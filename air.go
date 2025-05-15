package main

import (
	"bytes"
	"fmt"
	"os"
	"runtime"
	"text/template"
)

const airTemplate = `root = "."
tmp_dir = "tmp"

[build]
  cmd = "go build -o tmp/{{ .ProjectName }} ."
  bin = "tmp/{{ .ProjectName }}"
  include_ext = ["go", "html", "js", "css"]
  exclude_dir = [".idea", "temp", "tmp", "vendor"]
  delay = 1000

[log]
  time = true`

func CreateAirToml() {
	if !IsFileExist(".air.toml") {
		fileExt := PlatformExt(runtime.GOOS)
		filename := GenFilename(fileExt)
		// 创建模板数据
		data := GinTemplateData{
			ProjectName: filename, // 你可以在这里修改 Name 的值
		}

		// 解析模板
		tmpl, err := template.New("airConfig").Parse(airTemplate)
		if err != nil {
			fmt.Println("Error parsing template:", err)
			return
		}

		// 使用模板填充数据
		var result bytes.Buffer
		err = tmpl.Execute(&result, data)
		if err != nil {
			fmt.Println("Error executing template:", err)
			return
		}

		// 输出生成的结果 写入文件
		_ = os.WriteFile(".air.toml", result.Bytes(), os.ModePerm)
	}
}
