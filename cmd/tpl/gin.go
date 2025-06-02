package tpl

import (
	"buildx/global"
	"bytes"
	"github.com/spf13/cobra"
	"text/template"
)

func genGinTemp() string {
	tmpl, _ := template.New("ginTemp").Parse(`Gin 框架项目助手，集成了一套高效实用的命令行工具，快速上手：
$ {{ .Name }} gin new [project]			# 创建 Gin 框架项目
$ {{ .Name }} gin router					# 提取并生成 Gin 路由
$ {{ .Name }} gin ddd [web/api] [name]	# 创建 DDD(application/infrastructure/interfaces) 层
$ {{ .Name }} gin domain [name]			# 创建 domain(model) 层
$ {{ .Name }} gin context				# 注册 Module
`)
	var buf bytes.Buffer
	_ = tmpl.Execute(&buf, map[string]string{"Name": global.ExeFileName})
	return buf.String()
}

var GinCmd = &cobra.Command{
	Use:   "gin",
	Short: "Gin 框架项目助手，集成了一套高效实用的命令行工具",
	Long:  "🛠️ Gin 框架项目助手，集成了一套高效实用的命令行工具",
}

func init() {
	// 必须放在 init 里注册子命令
	GinCmd.AddCommand(newCmd)
	GinCmd.AddCommand(dddCmd)
	GinCmd.AddCommand(domainCmd)
	GinCmd.AddCommand(routerCmd)
	GinCmd.AddCommand(contextCmd)
}
