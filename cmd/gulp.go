package cmd

import (
	"buildx/libs"
	"buildx/public"
	"fmt"
	"github.com/spf13/cobra"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

func newGulpTemp(name string) {
	_ = fs.WalkDir(public.Gulp, "gulp", func(path string, d fs.DirEntry, err error) error {
		// 判断是否是文件夹
		if !d.IsDir() {
			pathArr := strings.Split(path, "/")
			pathArr[0] = name
			if strings.HasPrefix(d.Name(), ".gitignore") {
				pathArr[len(pathArr)-1] = ".gitignore"
			}
			tempPath := strings.Join(pathArr, "/")

			if !libs.IsDirExist(filepath.Dir(tempPath)) {
				_ = os.MkdirAll(filepath.Dir(tempPath), os.ModePerm)
			}

			// 读取模板文件
			tmpl, _ := public.GinTpl.ReadFile(path)

			// 创建一个新的模板，解析并执行模板
			t, _ := template.New("constant").Delims("[//{", "}//]").Parse(string(tmpl))

			// 输出解析结果，可以写入文件
			file, _ := os.Create(tempPath)
			defer file.Close()

			// 执行模板，填充数据，并写入文件
			_ = t.Execute(file, map[string]string{"ProjectName": name})

			fmt.Printf("创建文件：%s\n", tempPath)
		}
		return nil
	})
}

var gulpCmd = &cobra.Command{
	Use:   "gulp",
	Short: "创建一个gulp5 WEB开发自动化项目",
	Long:  "创建一个gulp5 WEB开发自动化项目，支持NodeJS 20+",
}

var newGulpCmd = &cobra.Command{
	Use:   "new",
	Short: "创建一个gulp5 WEB开发自动化项目",
	Long:  "创建一个gulp5 WEB开发自动化项目，支持NodeJS 20+",
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		if strings.Contains(args[0], "/") || strings.Contains(args[0], "\\") {
			fmt.Printf("项目名称不能包含 / 或 \\ 字符，请重试...\n")
			return
		}
		if libs.IsDirExist(args[0]) {
			fmt.Printf("项目 %s 已存在，请重试...\n", args[0])
			return
		}
		newGulpTemp(args[0])

		fmt.Printf("%s 项目创建完毕...\n\n", args[0])
		fmt.Printf("cd %s\n", args[0])
		fmt.Println("npm install")
		fmt.Println("npm run start 启动项目")
	},
}

func init() {
	gulpCmd.AddCommand(newGulpCmd)
}
