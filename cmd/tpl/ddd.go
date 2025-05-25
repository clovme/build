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

// 判断bool数组是否包含true/false
func isBoolArrayContains(target bool, arr []bool) bool {
	for _, item := range arr {
		if item == target {
			return true
		}
	}
	return false
}

// 返回上一层目录，并把反斜杠替换为正斜杠
func dir(path string) string {
	return strings.Replace(filepath.Dir(path), "\\", "/", -1)
}

// domain 层的包后缀路径
func domainPath(toPath, name string) string {
	if strings.Contains(toPath, "domain") || !strings.Contains(name, "/") {
		return name
	}
	return dir(name)
}

// domain 层的包调用名称
func domainName(name string) string {
	if strings.Contains(name, "/") {
		return filepath.Base(dir(name))
	}
	return name
}

// app 层的包后缀路径
func appPath(name string) string {
	if strings.Contains(name, "/") {
		var temp []string
		for _, s := range strings.Split(dir(name), "/") {
			temp = append(temp, fmt.Sprintf("app_%s", s))
		}
		return fmt.Sprintf("/%s", strings.Join(temp, "/"))
	}
	return ""
}

// application 层的包调用名称
func appName(name string) string {
	if strings.Contains(name, "/") {
		return fmt.Sprintf("app_%s", filepath.Base(dir(name)))
	}
	return "application"
}

// structName 结构体名称
func structName(name string, flag bool) string {
	entityPath := goFilePath("domain/entity.tpl", "internal/domain", name, "")
	if !libs.IsFileExist(entityPath) || !flag {
		if strings.Contains(name, "/") {
			return libs.Capitalize(filepath.Base(dir(name)))
		}
		return libs.Capitalize(name)
	}
	entityName, err := parseFile(entityPath, "")
	if err != nil {
		fmt.Printf("❌ domain 层已存在，但没有解析出结构体名称,%s\n", entityName)
		os.Exit(-1)
	}
	return entityName
}

// getPackageAndName 包路径和名称
// flag: 前缀标识
// name: 包名称
//
// pkgPath: 包路径
// pkgName: 包名称
// filePrefix: 文件前缀
func getPackageAndName(toPath, name, flag string) (doPath, packName, filePrefix string) {
	if !strings.Contains(name, "/") {
		doPath, packName, filePrefix = "", filepath.Base(toPath), name
		if strings.Contains(toPath, "domain") {
			doPath, packName, filePrefix = "", name, name
		}
		return
	}

	var temp []string
	nameTemp := strings.Split(name, "/")
	for _, s := range nameTemp[:len(nameTemp)-1] {
		temp = append(temp, fmt.Sprintf("%s%s", flag, s))
	}

	filePrefix = filepath.Base(name)
	doPath = strings.Join(temp, "/")
	packName = filepath.Base(doPath)

	return
}

// 包名称
func packageName(toPath, name, flag string) string {
	_, packName, _ := getPackageAndName(toPath, name, flag)
	return packName
}

// goFilePath 写入文件路径
func goFilePath(path, toPath, name, flag string) string {
	tplName := filepath.Base(path)
	doPath, _, filePrefix := getPackageAndName(toPath, name, flag)
	if strings.Contains(name, "/") {
		doPath = fmt.Sprintf("/%s", doPath)
	}
	fileName := strings.Replace(tplName, ".tpl", ".go", -1)
	if strings.HasPrefix(fileName, "[name]") {
		fileName = strings.Replace(fileName, "[name]", filePrefix, 1)
		return fmt.Sprintf("%s%s/%s", toPath, doPath, fileName)
	}
	if doPath == "" {
		doPath = fmt.Sprintf("/%s", name)
	}
	return fmt.Sprintf("%s%s/%s", toPath, doPath, fileName)
}

func getModuleName() string {
	file, err := os.ReadFile("go.mod")
	if err != nil {
		fmt.Println("❌ 获取模块名称失败:", err)
		os.Exit(-1)
	}
	module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
	return module[len(module)-1]
}

// 创建 DDD 模块目录结构
func createModule(flag string, paths []string, toPath, name string) bool {
	name = strings.ToLower(strings.TrimPrefix(strings.Replace(strings.TrimSpace(name), "\\", "/", -1), "/"))

	data := map[string]string{
		"Package":     packageName(toPath, name, flag),
		"StructName":  structName(name, false),
		"EntityName":  structName(name, true),
		"AppPath":     appPath(name),
		"AppName":     appName(name),
		"DomainPath":  domainPath(toPath, name),
		"DomainName":  domainName(name),
		"ProjectName": strings.TrimSpace(getModuleName()),
	}

	isFlag := true
	for _, path := range paths {
		bContent, _ := public.DDD.ReadFile(fmt.Sprintf("ddd/%s", path))
		tmpl, _ := template.New("ddd").Parse(string(bContent))

		var buf bytes.Buffer
		_ = tmpl.Execute(&buf, data)

		filePath := goFilePath(path, toPath, name, flag)
		if libs.IsFileExist(filePath) {
			isFlag = false
			continue
		}
		if !libs.IsDirExist(filepath.Dir(filePath)) {
			_ = os.MkdirAll(filepath.Dir(filePath), os.ModePerm)
		}
		_ = os.WriteFile(filePath, buf.Bytes(), os.ModePerm)
	}
	return isFlag
}

var moduleCmd = &cobra.Command{
	Use:   "ddd",
	Short: "创建 DDD Module",
	Args:  cobra.MinimumNArgs(2),
	Run: func(cmd *cobra.Command, args []string) {
		var flag []bool
		for _, path := range []string{"internal/application", "internal/domain", "internal/infrastructure", "internal/interfaces"} {
			flag = append(flag, !libs.IsDirExist(path))
		}
		if isBoolArrayContains(true, flag) {
			fmt.Println(genGinTemp())
			return
		}
		datas := []bool{
			createModule("", []string{"domain/entity.tpl", "domain/repository.tpl", "domain/service.tpl"}, "internal/domain", args[1]),
			createModule("app_", []string{"application/[name]_service.tpl"}, "internal/application", args[1]),
			createModule(fmt.Sprintf("%s_", args[0]), []string{"handler/[name]_handler.tpl"}, fmt.Sprintf("internal/interfaces/%s", args[0]), args[1]),
			createModule("pre_", []string{"infrastructure/persistence/[name]_repository.tpl"}, "internal/infrastructure/persistence", args[1]),
		}
		if isBoolArrayContains(true, datas) {
			regContext()
			regRouter()
			fmt.Printf("✅ [%s] %s 模块创建并注册完毕...\n", args[0], args[1])
		} else {
			fmt.Printf("❌ [%s] %s 模块创建已存在...\n", args[0], args[1])
			fmt.Printf("❌ %s 模块创建已存在...\n", args[0])
		}
	},
}

func init() {
	moduleCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin ddd [web][api] [module]\t创建 DDD Module\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
