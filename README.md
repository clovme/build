# go-build
go 项目编译工具，极限压缩工具

## 安装

```shell
go install github.com/clovme/build@latest
```

## 使用
```shell
build -help
````

## 程序使用帮助文档

```markdown
🧱 程序使用帮助文档 🛠️：
用法: build [选项]
选项说明：
    -GOARCH   编译目标系统架构，例如 amd64、arm64 (默认值: "amd64")
    -GOOS     编译目标平台，例如 linux、windows、darwin (默认值: "windows")
    -GOROOT   GOROOT 路径 (默认值: "C:\\Go")
    -arch     文件名中是否添加架构名称 (默认值: "false")
    -filename 可执行文件名称 (默认值: "")
    -gui      是否是GUI编译 (默认值: "false")
    -help     帮助 (默认值: "false")
    -init     初始化Go环境 (默认值: "false")
    -mode     是否编译为动态链接库，例如 .dll、.so、.dylib (默认值: "false")
    -platform 文件名中是否添加平台名称 (默认值: "false")
    -upx      是否开启UPX压缩 (默认值: "false")
    -version  文件名中是否添加版本号 (默认值: "false")

Tips：使用 -help 查看帮助，或直接运行以使用默认参数。
```

## 配置文件
```ini
; 环境变量配置
[env]
; GO ROOT路径
GOROOT = C:/go
; GO 编译平台
GOOS   = windows
; GO 编译架构
GOARCH = amd64

; 编译配置
[build]
; 是否是GUI程序
gui      = false
; 是否启用UPX压缩
upx      = false
; 文件名是否台添加架构名称
arch     = false
; 是否编译为动态链接库
mode     = false
; 文件名是否添加版本号
version  = false
; 编译平台
platform = false
; 文件名
filename = 程序名称

; 其他配置
[other]
; 程序编译版本
version = 0,0,1
```

> 生成的文件名: `程序名称-windows-amd64-v0.0.1.exe`