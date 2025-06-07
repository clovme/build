package gin

import (
	"buildx/global"
	"buildx/libs"
	"buildx/public"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"text/template"
)

type domainData struct {
	ProjectName string
	Package     string
	DomainPath  string
	DomainName  string
	StructName  string
	TableName   string
}

func createDomain(prefix, name string) bool {
	toPath := "internal/domain"

	domainNamePath := fmt.Sprintf("%s/%s", toPath, prefix)
	if libs.IsDirExist(domainNamePath) {
		fmt.Printf("domain层(%s)已存在...\n", domainNamePath)
		return false
	}

	fmt.Println(prefix)
	data := domainData{
		ProjectName: libs.GetModuleName(),
		Package:     filepath.Base(prefix),
		DomainPath:  prefix,
		DomainName:  libs.SnakeToCamel(name),
		TableName:   libs.CamelToSnake(name),
		StructName:  libs.Capitalize(name),
	}

	for _, path := range []string{"domain/entity.go.tpl", "domain/repository.go.tpl", "domain/service.go.tpl"} {
		filePath := libs.GetFilePath(toPath, prefix, name, path, "")
		bContent, _ := public.DDD.ReadFile(fmt.Sprintf("ddd/%s", path))
		tmpl, _ := template.New("ddd").Parse(string(bContent))

		var buf bytes.Buffer
		_ = tmpl.Execute(&buf, data)

		_ = os.MkdirAll(filepath.Dir(filePath), os.ModePerm)
		_ = os.WriteFile(filePath, buf.Bytes(), os.ModePerm)
		fmt.Println(fmt.Sprintf("文件 %s 创建成功！", filePath))
	}
	return true
}

var domainCmd = &cobra.Command{
	Use:   "domain",
	Short: "创建 domain(model) 层",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		if !libs.IsDirExist("internal/domain") {
			fmt.Println(fmt.Sprintf("项目可能不是 %s gin new [project] 创建的，internal/domain不存在！\n", global.ExeFileName))
			fmt.Println(genGinTemp())
			return
		}

		prefix, name := libs.NamePrefix(args[0], "do")
		if libs.IsDirExist(fmt.Sprintf("internal/domain/%s", prefix)) {
			fmt.Println(fmt.Sprintf("模块 %s 已存在！", args[0]))
			return
		}
		if createDomain(prefix, name) {
			regRouter()
			regQuery()
		}
	},
}

func init() {
	domainCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin domain [name]\t创建 domain(model) 层\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
