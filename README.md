# Flutter App Starter
Flutter / Dart / GetX / Dio，Android、iOS、Web 工程齐备。
按 feature 组织 MVC，包含登录、请求封装、路由守卫、任务分页和增删改查、中英文、系统浅深色主题。

## 启动
使用 Flutter stable（本地验证版本见 VALIDATION.md），先启动 Java 后端。
```bash
flutter pub get
# iOS 模拟器（localhost 指向 Mac）
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api
# Android 模拟器（使用后端 MySQL 配置或允许模拟器访问的本地测试服务）
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
# Web 调试：后端 CORS_ORIGIN 必须是这个 origin
flutter run -d chrome --web-port=5173 --dart-define=API_BASE_URL=http://localhost:8080/api
```
Flutter Web 与 Vue 不能同时占用 5173；使用其他端口时同步配置后端 CORS_ORIGIN。demo 默认仅监听 127.0.0.1；真实手机必须使用可达的开发服务地址，推荐 HTTPS，不使用现有业务数据库。
演示账号 `admin` / `DemoOnly-ChangeMe123!`。

## 结构
- `core/api_client.dart`：Dio 超时、Bearer 鉴权、401 处理；API_BASE_URL 为本项目服务地址。
- `core/translations.dart`：所有应用文字的中英文翻译。
- `features/auth`：登录 Controller / View。
- `features/tasks`：Model / Controller / View 完整示例。
- `main.dart`：主题、依赖注入、页面注册与路由守卫。

## 新增功能
参考 tasks 新建 feature，Controller 构造注入 ApiClient，Model 独立解析 JSON，View 只负责布局。通过 GetPage 注册 Binding 和路由；文本加入翻译字典；使用 Scaffold/AppBar/SafeArea/Row/Column/Flexible 响应式布局。

## 验证与发布
```bash
dart format lib test
flutter analyze
flutter test
flutter build apk --dart-define=API_BASE_URL=https://your-api.example/api
flutter build ios --no-codesign --dart-define=API_BASE_URL=https://your-api.example/api
flutter build web --dart-define=API_BASE_URL=https://your-api.example/api
```
发布模式请求强制 HTTPS。Android HTTP 仅 debug manifest 开启；iOS 本地 HTTP 如被 ATS 拦截，使用 HTTPS 开发域名。应用 id 为 `dev.starter.flutter_app_starter`，上线前替换包名、名称、图标并设置自己的签名。生成的 Android release 使用 debug 签名仅供开发，商店发布需配置正式签名；证书不要提交。iOS 开发者团队未保留。

没有接入相机、推送等原生业务能力，因此不申请额外权限；本地原生打包与真机验收状态见 VALIDATION.md。

## 配套仓库
- [Java API](https://github.com/Lpkiki/java-api-starter)
- [Vue 管理后台](https://github.com/Lpkiki/vue-admin-starter)
- [Flutter App](https://github.com/Lpkiki/flutter-app-starter)

## 约定与边界
这是从现有项目的分层、请求、路由和国际化约定中重新整理的精简底座，不是现有业务工程的副本。无聊天、支付、推送、医疗、学校等业务代码，无线上数据、密钥、证书或原项目资源。

统一接口：`/api`，返回 `{code:0,message:"OK",data:...}`，错误使用对应 HTTP 状态码。鉴权使用 `Authorization: Bearer <token>`。会话有效期 8 小时，退出后服务端立即撤销。客户端令牌仅保存在内存，刷新/重启需要重新登录。默认账号名 `admin`，正式数据库首次启动密码由后端初始化配置决定。

提供 ADMIN / USER 两种角色；ADMIN 可以管理账号，任务按账号隔离。暂未包含动态菜单、细粒度权限编辑、注册找回密码、短信、文件上传、审计中心、支付和推送；可按实际产品扩展。公网部署前需要配置 HTTPS、网关登录限流、监控和数据库备份。任务更新采用 version 乐观锁，重复删除幂等；新增 POST 不承诺重试幂等，调用方不可自动重试。

## 开发协作
不提交 `.env`、签名证书、私钥、真实账号和日志。数据库变更添加新的 Flyway 迁移，不修改已执行版本。API 字段、路径和分页约定修改后同步三端。每次修改运行本仓库检查，再测试登录、过期会话和关键业务流程。
