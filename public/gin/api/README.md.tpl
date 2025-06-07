# {{ .ProjectName }} API

## 编译工具
```shell
go install github.com/clovme/build@latest
build
```

## 🌿 项目目录结构（前后端解耦 + 基础设施独立 + 业务归一）

```
/global/
    global.go            # 全局变量和项目状态管理
    /config/             # 配置管理（ini/json/env）
/initialize/
/internal/
    /infrastructure/        # 基础设施层（第三方依赖、底层实现、配置）
        /database/           # 数据库驱动初始化和迁移
        /libs/               # 工具方法库，独立无副作用
        /models/             # 数据库表映射结构体
    /domain/                # 业务领域核心层（逻辑、数据交互）
        /controller/         # 控制器
            /account/        # 业务子域控制器
        /middleware/         # 中间件（鉴权、CORS、异常等）
    
    /application/           # 应用层（路由分发、程序启动）
        /routers/            # 路由注册
main.go                     # 程序入口
```

---

## 📌 依赖方向

```
infrastructure → domain → application
```

绝不允许反过来
比如：

* middleware 不能调用 database/initdata
* controller 不能直接用 global 中未暴露的内容
* config 不能引用 application 或 domain 中的结构

**谁耦合，谁超度。**

---


```markdown
/myapp
├── internal
│   ├── application
│   │   └── user_service.go
│   │      
│   ├── domain
│   │   ├── shared
│   │   │   └── model
│   │   │       └── base_model.go
│   │   ├── article
│   │   │   ├── entity.go
│   │   │   ├── repository.go
│   │   │   └── service.go
│   │   └── user
│   │       ├── entity.go
│   │       ├── repository.go
│   │       └── service.go
│   │          
│   ├── infrastructure
│   │   └── persistence
│   │       └── user_repository.go
│   │          
│   └── interfaces
│      └── web
│          └── handler
│              └── user_handler.go
│                  
├── pkg
│   └── config
│       └── config.go
│          
├── public
│   │  public.go
│   │  
│   ├── assets
│   │   └── css
│   │       └── style.css
│   │          
│   └── templates
│       ├── layout
│       │   └── base.html
│       │      
│       └── user
│           └── list.html
├── go.mod
├── go.sum
├── main.go
├── README.md
```

```
本来因该：infrastructure → domain → application
现在：infrastructure → domain ← application
然后：interfaces → application
     interfaces → domain
main.go 调用了他们全部
```