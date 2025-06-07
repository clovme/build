package cmd

import (
	"buildx/cmd/gin"
	"buildx/global"
	"buildx/global/config"
	"buildx/libs"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"text/template"
)

var cfg = config.GetConfig()

func genRootLongTemp() string {
	tmpl, _ := template.New("rootLong").Parse(`🛠️ Go 编译工具 & Gin 框架项目助手，集成了一套高效实用的命令行工具`)
	var buf bytes.Buffer
	_ = tmpl.Execute(&buf, map[string]string{"Name": global.ExeFileName})
	return buf.String()
}

var rootCmd = &cobra.Command{
	Use:  global.ExeFileName,
	Long: genRootLongTemp(),
	CompletionOptions: cobra.CompletionOptions{
		DisableDefaultCmd: true,
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
	}
}

func init() {
	rootCmd.AddCommand(airCmd)
	rootCmd.AddCommand(buildCmd)
	rootCmd.AddCommand(gin.GinCmd)

	rootCmd.PersistentFlags().BoolP("help", "h", false, "查看命令帮助")

	rootCmd.PreRun = func(cmd *cobra.Command, args []string) {
		cfg.Other.IsComment = libs.GetBool(cmd, "comment")
	}
}
