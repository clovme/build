package tpl

import (
	"buildx/global"
	"buildx/libs"
	"buildx/public"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

func createDomain(name string) {
	_domainName := name
	_structName := name
	toPath := "internal/domain"

	if len(strings.Split(name, "/")) > 2 {
		fmt.Println(fmt.Sprintf("你当前执行的命令是:\n　　%s gin domain %s", global.ExeFileName, name))
		fmt.Println(fmt.Sprintf("此命令应该是:\n　　%s gin domain [package]/[Struct]\n　　或者:\n　　%s gin domain [package]\n", global.ExeFileName, global.ExeFileName))
		fmt.Println("此命令[name]只定义了两级")
		return
	}
	if len(strings.Split(name, "\\")) > 2 {
		fmt.Println(fmt.Sprintf("你当前执行的命令是:\n　　%s gin domain %s", global.ExeFileName, name))
		fmt.Println(fmt.Sprintf("此命令应该是:\n　　%s gin domain [package]\\[Struct]\n　　或者:\n　　%s gin domain [package]\n", global.ExeFileName, global.ExeFileName))
		fmt.Println("此命令[name]只定义了两级")
		return
	}
	if len(strings.Split(name, ".")) > 2 {
		fmt.Println(fmt.Sprintf("你当前执行的命令是:\n　　%s gin domain %s\n", global.ExeFileName, name))
		fmt.Println(fmt.Sprintf("此命令应该是:\n　　%s gin domain [package].[Struct]\n　　或者:\n　　%s gin domain [package]\n", global.ExeFileName, global.ExeFileName))
		fmt.Println("此命令[name]只定义了两级")
		return
	}

	for _, item := range []string{"/", "\\", "."} {
		if strings.Contains(name, item) {
			temp := strings.SplitN(name, item, 2)
			_domainName = temp[0]
			_structName = temp[1]
			break
		}
	}

	domainNamePath := fmt.Sprintf("%s/%s", toPath, _domainName)

	if libs.IsDirExist(domainNamePath) {
		fmt.Printf("domain层(%s)已存在...\n", domainNamePath)
		return
	}

	data := map[string]string{
		"Package":     _domainName,
		"StructName":  Capitalize(_structName),
		"ProjectName": strings.TrimSpace(libs.GetModuleName()),
	}

	for _, path := range []string{"domain/entity.tpl", "domain/repository.tpl", "domain/service.tpl"} {
		filePath := goFilePath(path, toPath, _domainName, "")

		bContent, _ := public.DDD.ReadFile(fmt.Sprintf("ddd/%s", path))
		tmpl, _ := template.New("ddd").Parse(string(bContent))

		var buf bytes.Buffer
		_ = tmpl.Execute(&buf, data)

		_ = os.MkdirAll(filepath.Dir(filePath), os.ModePerm)
		_ = os.WriteFile(filePath, buf.Bytes(), os.ModePerm)
		fmt.Println(fmt.Sprintf("文件 %s 创建成功！", filePath))
	}
}

var domainCmd = &cobra.Command{
	Use:   "domain",
	Short: "创建 domain(model) 层",
	Run: func(cmd *cobra.Command, args []string) {
		if !libs.IsDirExist("internal/domain") {
			fmt.Println(fmt.Sprintf("项目可能不是 %s gin new [project] 创建的，internal/domain不存在！\n", global.ExeFileName))
			fmt.Println(genGinTemp())
			return
		}
		createDomain(args[0])
	},
}

func init() {
	domainCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin domain [name]\t创建 domain(model) 层\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
