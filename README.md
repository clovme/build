# go-build
go 项目编译工具，极限压缩工具

## 安装

```shell
go install github.com/clovme/build
```

## 使用

> 使用`build`命令会使用当前项目的默认配置编译并在命令执行的目录生成配置文件`build`。

```shell
build -help
````

## 程序使用帮助文档

```markdown
🧱 程序使用帮助文档 🛠️：
用法: build [选项]
选项说明：
    -GOARCH   编译目标系统架构，例如 amd64、arm64 (当前值: "amd64")
    -GOOS     编译目标平台，例如 linux、windows、darwin (当前值: "windows")
    -all      编译(amd64、arm64)三大平台(linux、windows、darwin) (当前值: "false")
    -arch     文件名中是否添加架构名称 (当前值: "false")
    -check    快速检测此项目那些文件是可构建的命令 (当前值: "false")
    -default  使用默认(本机)编译环境(windows/amd64) (当前值: "false")
    -gui      是否是GUI编译 (当前值: "false")
    -help     帮助 (当前值: "false")
    -init     初始化Go环境 (当前值: "false")
    -list     查看当前环境可交叉编译的所有系统+架构 (当前值: "false")
    -mode     是否编译为动态链接库，例如 .dll、.so、.dylib (当前值: "false")
    -name     可执行文件名称 (当前值: "build")
    -note     配置文件中是否写入注释 (当前值: "false")
    -plat     文件名中是否添加平台名称 (当前值: "false")
    -upx      是否开启UPX压缩 (当前值: "false")
    -ver      文件名中是否添加版本号 (当前值: "false")

Tips：使用 -help 查看帮助，或直接运行以使用默认参数。
```

## 默认配置文件
```ini
; 环境变量配置
[env]
; GO 编译平台
GOOS   = windows
; GO 编译架构
GOARCH = amd64

; 编译配置
[build]
; 是否是GUI程序
gui      = false
; 编译三大平台(linux、windows、darwin)
all      = false
; 是否启用UPX压缩
upx      = false
; 文件名是否台添加架构名称
arch     = amd64
; 是否编译为动态链接库
mode     = false
; 文件名是否添加版本号
ver      = false
; 编译平台
plat     = false
; 文件名
name     = build
; 程序编译版本
version  = 0,0,1
; 编译平台
platform = windows

; 其他配置
[other]
; 是否开启配置文件注释
comment    = true
; 当前项目Go版本
go_version = go version go1.23.4 windows/amd64
```

> arch=true, plat=true, ver=true 时，生成的文件名:
> 
> 生成的文件名: `程序名称-windows-amd64-v0.0.1.exe`