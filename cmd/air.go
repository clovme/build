package cmd

import (
	"buildx/libs"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"runtime"
	"text/template"
)

const airTemplate = `root = "."
tmp_dir = "build"

[build]
  cmd = "go build -o build/{{ .Name }} ."
  bin = "build/{{ .Name }}"
  include_ext = ["go", "html", "js", "css"]
  exclude_dir = [".idea", "temp", "tmp", "vendor", "build", "logs", "data"]
  delay = 1000

[log]
  time = true`

var airCmd = &cobra.Command{
	Use:   "run",
	Short: "启动Air热加载服务",
	Run: func(cmd *cobra.Command, args []string) {
		if !libs.IsFileExist(".air.toml") {
			// 解析模板
			tmpl, _ := template.New("airConfig").Parse(airTemplate)

			// 使用模板填充数据
			var result bytes.Buffer
			_ = tmpl.Execute(&result, map[string]string{"Name": fmt.Sprintf("%s%s", libs.GetModuleName(), platformExt(runtime.GOOS))})

			// 输出生成的结果 写入文件
			_ = os.WriteFile(".air.toml", result.Bytes(), os.ModePerm)
		}

		if !libs.IsCommandExists("air") {
			libs.Command("go", "install", "github.com/air-verse/air@latest")
		}
		libs.Command("air")
	},
}
