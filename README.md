## 简介

![](https://oss.open8gu.com/image-20231115133642504.png)

短链接（Short Link）是指将一个原始的长 URL（Uniform Resource Locator）通过特定的算法或服务转化为一个更短、易于记忆的
URL。短链接通常只包含几个字符，而原始的长 URL 可能会非常长。

短链接的原理非常简单，通过一个原始链接生成个相对短的链接，然后通过访问短链接跳转到原始链接。

如果更细节一些的话，那就是：

1. **生成唯一标识符**：当用户输入或提交一个长 URL 时，短链接服务会生成一个唯一的标识符或者短码。
2. **将标识符与长 URL 关联**：短链接服务将这个唯一标识符与用户提供的长 URL 关联起来，并将其保存在数据库或者其他持久化存储中。
3. **创建短链接**：将生成的唯一标识符加上短链接服务的域名（例如：http://nurl.ink ）作为前缀，构成一个短链接。
4. **重定向**：当用户访问该短链接时，短链接服务接收到请求后会根据唯一标识符查找关联的长 URL，然后将用户重定向到这个长 URL。
5. **跟踪统计**：一些短链接服务还会提供访问统计和分析功能，记录访问量、来源、地理位置等信息。

短链接经常出现在咱们日常生活中，大家总是能在某些活动节日里收到各种营销短信，里边就会出现短链接。帮助企业在营销活动中，识别用户行为、点击率等关键信息监控。

![](https://oss.open8gu.com/IMG_9858-20231126.jpg)

主要作用包括但不限于以下几个方面：

- **提升用户体验**：用户更容易记忆和分享短链接，增强了用户的体验。
- **节省空间**：短链接相对于长 URL 更短，可以节省字符空间，特别是在一些限制字符数的场合，如微博、短信等。
- **美化**：短链接通常更美观、简洁，不会包含一大串字符。
- **统计和分析**：可以追踪短链接的访问情况，了解用户的行为和喜好。

## 技术架构

在系统设计中，采用最新 JDK17 + SpringBoot3&SpringCloud 微服务架构，构建高并发、大数据量下仍然能提供高效可靠的短链接生成服务。

通过学习短链接项目，不仅能了解其运作机制，还能接触最新技术体系带来的新特性，从而拓展技术视野并提升自身技术水平。

![](https://oss.open8gu.com/image-20231026132606180.png)

## 🔨 Run the Microservice

<b>Init Database</b>

*首次启动项目执行，后续启动不需要*

<b>1 )</b> 注释掉 `docker-compose.yml` 中的除mysql外的所有服务，然后执行 `docker compose up`启动数据库

<b>2 )</b> 连接数据库，执行`resources/database/link-data.sql`脚本，初始化数据

<b>Run Application Locally</b>

<b>1 )</b> Clone project `git clone https://github.com/mxwhth/shortlink.git`

<b>2 )</b> Go to the project's home directory :  `cd shortlink`

<b>3 )</b> Run startup script <b>`./startup.sh`</b></b> *Will start containers and services*

<b>4 )</b> Visit `http://localhost:5173/home/space` and explore it.</b>

### ❌ Stop the Microservice

<b>1 )</b> Go to the project's home directory :  `cd shortlink`

<b>2 )</b> Run shutdown script <b>`./shutdown.sh`</b></b> *Will kill services, shutdown containers and cleanup log files.*


## 项目质量怎么样？

短链接项目采用 SaaS 方式开发。"SaaS"代表“软件即服务”（Software as a Service），与传统的软件模型不同，SaaS
不需要用户在本地安装和维护软件，而是通过互联网直接访问在线应用程序。

既然是 SaaS 系统，那势必会带来 N 多个问题。在我看来，问题即项目亮点。一起来看下：

1. **海量并发**：可能会面对大量用户同时访问的情况，尤其在高峰期，这会对系统的性能和响应速度提出很高的要求。
2. **海量存储**：可能需要存储大量的用户数据，包括数据库、缓存等，需要足够的存储空间和高效的存储管理方案。
3. **多租户场景**：通常支持多个租户共享同一套系统，需要保证租户间的数据隔离、安全性和性能。
4. **数据安全性**：需要保证用户数据的安全性和隐私，防止未经授权的访问和数据泄露。
5. **扩展性&可伸缩性**：需要具备良好的扩展性，以应对用户数量和业务规模的增长。

项目实现过程中会充分考虑以上问题，最终实现高可用、可扩展、支持海并发以及存储的 SaaS 短链接系统。另外，会额外交付精美前端控制台页面，学生可用于校招、毕设等场景。

