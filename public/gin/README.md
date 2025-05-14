# {{ .ProjectName }} API

## 编译工具
```shell
go install github.com/clovme/build@latest
build
```

```markdown
* `config` 👉 配置加载（viper / env / yaml）
* `constant` 👉 常量枚举
* `controller` 👉 控制器，HTTP 接口入口
* `database` 👉 数据库连接、初始化
* `libs` 👉 自己封装的工具库、第三方二次封装
* `middleware` 👉 gin 中间件
* `models` 👉 数据库模型、struct 定义
* `main.go` 👉 入口文件
* `README.md` 👉 项目说明，面子工程+规范
```