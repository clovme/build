package gin

import (
	"buildx/global"
	"buildx/libs"
	"buildx/public"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

const app = "app"

type dddData struct {
	Package          string
	StructName       string
	EntityName       string
	DomainPath       string
	DomainName       string
	DomainStructName string
	ProjectName      string
	AppPath          string
	AppName          string
}

func getAppPath(args string) (string, string) {
	appPrefix, _ := libs.NamePrefix(args, app)
	if strings.Contains(appPrefix, "/") {
		return fmt.Sprintf("/%s", appPrefix), filepath.Base(appPrefix)
	}
	return "", "application"
}

// 创建 DDD 模块目录结构
func createDDD(flag string, path string, toPath, domainPath, domainStructName, args string) bool {
	prefix, name := libs.NamePrefix(args, flag)

	appPath, appName := getAppPath(args)

	data := dddData{
		Package:          libs.GetPackageName(toPath, prefix),
		StructName:       libs.Capitalize(name),
		EntityName:       "",
		DomainPath:       domainPath,
		DomainName:       filepath.Base(domainPath),
		DomainStructName: domainStructName,
		ProjectName:      libs.GetModuleName(),
		AppPath:          appPath,
		AppName:          appName,
	}

	bContent, _ := public.DDD.ReadFile(fmt.Sprintf("ddd/%s", path))
	tmpl, _ := template.New("ddd").Parse(string(bContent))

	filePath := libs.GetFilePath(toPath, prefix, name, path, flag)

	if libs.IsFileExist(filePath) {
		return false
	}
	if !libs.IsDirExist(filepath.Dir(filePath)) {
		_ = os.MkdirAll(filepath.Dir(filePath), os.ModePerm)
	}

	// 输出解析结果，可以写入文件
	file, _ := os.Create(filePath)
	defer file.Close()
	_ = tmpl.Execute(file, data)

	return true
}

var dddCmd = &cobra.Command{
	Use:   "ddd",
	Short: "创建 DDD(application/infrastructure/interfaces) 层",
	Args:  cobra.ExactArgs(3),
	Run: func(cmd *cobra.Command, args []string) {
		domain, _ := libs.NamePrefix(args[1], "do")
		entityPath, domainStructName, err := libs.DomainStructOrPath(domain)

		if err != nil {
			fmt.Println(fmt.Sprintf("%s 可能不存在！请先创建domain层\n　　%s gin domain -h", entityPath, global.ExeFileName))
			return
		}
		var flag []bool
		for _, path := range []string{"internal/application", "internal/domain", "internal/infrastructure", "internal/interfaces"} {
			flag = append(flag, !libs.IsDirExist(path))
		}
		if libs.IsBoolArrayContains(true, flag) {
			fmt.Println(genGinTemp())
			return
		}

		datas := []bool{
			createDDD(app, "application/[name]_service.go.tpl", "internal/application", domain, domainStructName, args[2]),
			createDDD("pre", "infrastructure/persistence/[name]_repository.go.tpl", "internal/infrastructure/persistence", domain, domainStructName, args[2]),
			createDDD(fmt.Sprintf("%s", args[0]), "handler/[name]_handler.go.tpl", fmt.Sprintf("internal/interfaces/%s", args[0]), domain, domainStructName, args[2]),
		}
		if libs.IsBoolArrayContains(true, datas) {
			fmt.Printf("[%s] %s 模块创建并注册完毕...\n", args[0], args[1])
			regContext()
			regRouter()
		} else {
			fmt.Printf("[%s] %s 模块创建已存在...\n", args[0], args[1])
		}
	},
}

func init() {
	dddCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin ddd [web/api] [domain] [module]\t创建 DDD(application/infrastructure/interfaces) 层\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
