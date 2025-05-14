package main

import (
	"bytes"
	"fmt"
	"os"
	"text/template"
)

// AirTemplateData 定义模板需要的结构体
type AirTemplateData struct {
	Name string
}

const airTemplate = `root = "."
tmp_dir = "tmp"

[build]
  cmd = "go build -o tmp/{{ .Name }}.exe ."
  bin = "tmp/{{ .Name }}.exe"
  include_ext = ["go"]
  exclude_dir = [".idea", "tmp", "vendor"]
  delay = 1000

[log]
  time = true`

func CreateAirToml() {
	if !IsFileExist(".air.toml") {
		// 创建模板数据
		data := AirTemplateData{
			Name: conf.FileName.Name, // 你可以在这里修改 Name 的值
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
