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
程序使用帮助文档 🛠️：
用法: build [选项]
选项说明：
    -GOARCH      编译目标平台 (当前值: "amd64")
    -GOOS        编译目标系统 (当前值: "windows")
    -GOROOT      GOROOT路径 (当前值: "D:\\Application\\Go")
    -arch        文件名中是否添加架构名称 (当前值: "false")
    -filename    可执行文件名称 (当前值: "")
    -gui         是否是GUI编译 (当前值: "false")
    -help        帮助 (当前值: "false")
    -init        初始化Go环境 (当前值: "false")
    -platform    文件名中是否添加平台名称 (当前值: "false")
    -upx         是否开启UPX压缩 (当前值: "false")
    -version     文件名中是否添加版本号 (当前值: "false")
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
upx      = true
; 文件名是否台添加架构名称
arch     = true
; 文件名是否添加版本号
version  = true
; 编译平台
platform = true
; 文件名
filename = 程序名称

; 其他配置
[other]
; 程序编译版本
version = 0,0,2
```

> 生成的文件名: `程序名称-windows-amd64-v0.0.2.exe`