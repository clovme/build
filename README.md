# go-build
go 项目编译工具，极限压缩工具

## 安装

```shell
go install github.com/clovme/build@latest
```

```markdown
Usage of build.exe:
  -GOARCH string
        编译目标平台 (default "amd64")
  -GOOS string
        编译目标系统 (default "windows")
  -GOROOT string
        GOROOT路径 (default "C:\\Go")
  -filename string
        可执行文件名称 (default "项目名称[.exe]")
  -gui
        是否是GUI编译 (default "false")
  -help
        帮助
  -init
        初始化Go环境 (default "false")
  -upx
        是否开启UPX压缩 (default "false")
```