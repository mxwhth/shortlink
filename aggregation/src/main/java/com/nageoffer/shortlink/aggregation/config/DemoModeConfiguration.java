/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.nageoffer.shortlink.aggregation.config;

import com.alibaba.fastjson.JSON;
import com.nageoffer.shortlink.admin.common.convention.result.Result;
import com.nageoffer.shortlink.admin.common.convention.result.Results;
import jakarta.annotation.Nullable;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.PrintWriter;
import java.util.Objects;

/**
 * 部署公网环境演示模式配置
 */
@Configuration
@RequiredArgsConstructor
public class DemoModeConfiguration implements WebMvcConfigurer {

    private final DemoModeProperties demoModeProperties;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new DemoModeInterceptor())
                .addPathPatterns("/**");
    }

    public class DemoModeInterceptor implements HandlerInterceptor {

        @Override
        public boolean preHandle(@Nullable HttpServletRequest request, @Nullable HttpServletResponse response, @Nullable Object handler) throws Exception {
            if (demoModeProperties.getEnable()
                    && demoModeProperties.getBlacklist().contains(request.getRequestURI())
                    && !Objects.equals(request.getMethod(), "GET")) {
                response.setContentType("application/json;charset=UTF-8");
                PrintWriter out = response.getWriter();
                Result<Void> result = Results.failure("B000001", "演示环境部分功能受限，请访问短链接跳转、监控等功能");
                out.print(JSON.toJSONString(result)); // 返回指定的 JSON 字符串
                out.flush();
                return false;
            }
            return true;
        }
    }
}
