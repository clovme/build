package gin

import (
	"buildx/global"
	"buildx/libs"
	"buildx/public"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

func genNewGinTemp() {
	tmpl, _ := template.New("newGinTemp").Parse(`⚙️ 帮助：
$ {{ .Name }} gin new project	# 创建 Gin 框架项目`)
	var buf bytes.Buffer
	_ = tmpl.Execute(&buf, map[string]string{"Name": global.ExeFileName})
	fmt.Println(buf.String())
}

var newCmd = &cobra.Command{
	Use:   "new",
	Short: "创建 Gin 框架项目",
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			genNewGinTemp()
			return
		}
		if strings.Contains(args[0], "/") || strings.Contains(args[0], "\\") {
			fmt.Printf("项目名称不能包含 / 或 \\ 字符，请重试...\n")
			return
		}
		if libs.IsDirExist(args[0]) {
			fmt.Printf("项目 %s 已存在，请重试...\n", args[0])
			return
		}

		_ = fs.WalkDir(public.GinTpl, "gin", func(path string, d fs.DirEntry, err error) error {
			tempPath := filepath.Join(args[0], strings.Replace(path, "gin/", "", 1))

			// 判断是否是文件夹
			if !d.IsDir() {
				if !libs.IsDirExist(filepath.Dir(tempPath)) {
					_ = os.MkdirAll(filepath.Dir(tempPath), os.ModePerm)
				}
				newFile := strings.Replace(tempPath, ".tpl", "", 1)
				if !libs.IsFileExist(newFile) {
					// 读取模板文件
					tmpl, _ := public.GinTpl.ReadFile(path)

					// 创建一个新的模板，解析并执行模板
					t, _ := template.New("constant").Parse(string(tmpl))

					// 输出解析结果，可以写入文件
					file, _ := os.Create(newFile)
					defer file.Close()

					// 执行模板，填充数据，并写入文件
					_ = t.Execute(file, map[string]string{"ProjectName": args[0]})

					fmt.Printf("创建文件：%s\n", newFile)
				} else {
					fmt.Printf("文件已存在：%s\n", newFile)
				}
			}
			return nil
		})

		libs.CommandDir(fmt.Sprintf("%s/api", args[0]), "go", "mod", "tidy")
		fmt.Printf("%s 项目创建完毕...\n\n", args[0])
		fmt.Printf("cd %s/api\n", args[0])
		fmt.Printf("%s gin context\n", global.ExeFileName)
		fmt.Printf("%s gin router\n", global.ExeFileName)
		fmt.Printf("%s run 启动项目\n", global.ExeFileName)
	},
}

func init() {
	newCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin new [porject]\t创建 Gin 框架项目\n\nGlobal Flags:\n{{.Flags.FlagUsages}}\n", global.ExeFileName))
}
