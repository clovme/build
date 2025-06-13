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

func createDomain(prefix, name, structName string) bool {
	toPath := "internal/domain"

	domainNamePath := fmt.Sprintf("%s/%s", toPath, prefix)
	if libs.IsDirExist(domainNamePath) {
		fmt.Printf("domain层(%s)已存在...\n", domainNamePath)
		return false
	}

	data := domainData{
		ProjectName: libs.GetModuleName(),
		Package:     filepath.Base(prefix),
		DomainPath:  prefix,
		DomainName:  libs.SnakeToCamel(name),
		TableName:   structName,
		StructName:  libs.Capitalize(structName),
	}

	if structName != "" {
		data.TableName = libs.CamelToSnake(structName)
		data.StructName = libs.Capitalize(libs.SnakeToCamel(structName))
	}

	for _, path := range []string{"domain/entity.go.tpl", "domain/repository.go.tpl", "domain/service.go.tpl"} {
		filePath := libs.GetFilePath(toPath, prefix, name, path, "do")
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
	Args:  cobra.MinimumNArgs(1),
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

		isFlag := false
		if len(args) > 1 {
			isFlag = createDomain(prefix, name, libs.CamelToSnake(args[1]))
		} else {
			isFlag = createDomain(prefix, name, libs.CamelToSnake(args[0]))
		}
		if isFlag {
			regRouter()
			regQuery()
		}
	},
}

func init() {
	domainCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin domain [path/name] [StructName]\t创建 domain(model) 层，参数2不存在的时候，则使用参数1来做model名称\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
