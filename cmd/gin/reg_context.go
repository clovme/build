package gin

import (
	"buildx/global"
	"buildx/libs"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

const tmplStr = `// Code generated by [{ .ExeName }] tool. DO NOT EDIT.
// Code generated by [{ .ExeName }] tool. DO NOT EDIT.
// Code generated by [{ .ExeName }] tool. DO NOT EDIT.

package bootstrap

import (
[{- range $key, $value := .Imports }]
	"[{ $key }]"
[{- end }]
	"[{ .ProjectName }]/internal/infrastructure/query"
	"gorm.io/gorm"
)

type appContext struct {
[{- range $key, $value := .StructType }]
	[{ $value.Handler }] *[{ $value.HandlerPkgName }].[{ $value.Handler }]
[{- end }]
}

func NewAppContext(db *gorm.DB) *appContext {
[{- range $key, $value := .StructType }]
[{- if not $value.IsStandalone }]
	[{ $key }]Repo := &[{ $value.RepositoryPkgName }].[{ $value.Repository }]{DB: db, Q: query.Q}
	[{ $key }]Service := &[{ $value.ServicePkgName }].[{ $value.Service }]{Repo: [{ $key }]Repo}
	[{ $key }]Handler := &[{ $value.HandlerPkgName }].[{ $value.Handler }]{[{ $value.Service }]: [{ $key }]Service}
[{ else }]
	[{ $key }]Handler := &[{ $value.HandlerPkgName }].[{ $value.Handler }]{}
[{ end }]
[{- end }]
	return &appContext{
[{- range $key, $value := .StructType }]
		[{ $value.Handler }]: [{ $key }]Handler,
[{- end }]
	}
}`

type StructType struct {
	Repository        string
	Service           string
	Handler           string
	RepositoryPkgName string
	ServicePkgName    string
	HandlerPkgName    string
	IsStandalone      bool
}

type TemplateStruct struct {
	Imports     map[string]string
	StructType  map[string]*StructType
	ExeName     string
	ProjectName string
}

var imports = make(map[string]string)
var structType = make(map[string]*StructType)

func parseFile(goFile, suffix string) (structName string, err error) {
	// 解析文件
	node, err := parser.ParseFile(token.NewFileSet(), goFile, nil, parser.AllErrors)
	if err != nil {
		return "", err
	}

	for _, decl := range node.Decls {
		// 找 type 声明
		genDecl, ok := decl.(*ast.GenDecl)
		if !ok || genDecl.Tok != token.TYPE {
			continue
		}

		for _, spec := range genDecl.Specs {
			typeSpec, ok := spec.(*ast.TypeSpec)
			if !ok {
				continue
			}

			// 判断是否是 struct 类型
			if _, isStruct := typeSpec.Type.(*ast.StructType); !isStruct || !strings.HasSuffix(typeSpec.Name.Name, suffix) {
				continue
			}
			structName = typeSpec.Name.Name
			break
		}
		if len(structName) > 0 {
			break
		}
	}
	return structName, nil
}

func pkg(path string) (pkgPath, pkgName string) {
	_dir := filepath.Dir(path)
	pkgPath = fmt.Sprintf("%s/%s", libs.GetModuleName(), strings.Replace(_dir, "\\", "/", -1))
	pkgName = filepath.Base(_dir)
	return
}

func persistence() {
	_ = filepath.WalkDir("internal/infrastructure/persistence", func(path string, d fs.DirEntry, err error) error {
		if d.IsDir() {
			return nil
		}

		pkgPath, pkgName := pkg(path)
		imports[pkgPath] = ""

		name := libs.SnakeToCamel(strings.Replace(filepath.Base(path), "_repository.go", "", -1))
		repositoryName, err := parseFile(path, "Repository")
		if err != nil {
			return err
		}

		structType[name] = &StructType{
			Repository:        repositoryName,
			RepositoryPkgName: pkgName,
			IsStandalone:      false,
		}

		return nil
	})
}

func application() {
	_ = filepath.WalkDir("internal/application", func(path string, d fs.DirEntry, err error) error {
		if d.IsDir() {
			return nil
		}

		pkgPath, pkgName := pkg(path)
		imports[pkgPath] = ""

		name := libs.SnakeToCamel(strings.Replace(filepath.Base(path), "_service.go", "", -1))
		serviceName, err := parseFile(path, "Service")
		if err != nil {
			return err
		}

		structType[name].ServicePkgName = pkgName
		structType[name].Service = serviceName

		return nil
	})
}

func interfaces() {
	_ = filepath.WalkDir("internal/interfaces", func(path string, d fs.DirEntry, err error) error {
		if d.IsDir() {
			return nil
		}

		pkgPath, pkgName := pkg(path)

		imports[pkgPath] = ""

		name := libs.SnakeToCamel(strings.Replace(filepath.Base(path), "_handler.go", "", -1))
		handlerName, err := parseFile(path, "Handler")
		if err != nil {
			return err
		}

		if structType[name] == nil {
			structType[name] = &StructType{
				IsStandalone: true,
			}
		}
		structType[name].HandlerPkgName = pkgName
		structType[name].Handler = handlerName

		return nil
	})
}

func regContext() {
	persistence()
	application()
	interfaces()

	// 创建一个新的模板，解析并执行模板
	tmpl, _ := template.New("constant").Delims("[{", "}]").Parse(tmplStr)

	// 输出解析结果，可以写入文件
	file, _ := os.Create("internal/bootstrap/app_context.go")
	defer file.Close()

	tmplData := TemplateStruct{
		Imports:     imports,
		StructType:  structType,
		ProjectName: libs.GetModuleName(),
		ExeName:     global.ExeFileName,
	}

	// 执行模板，填充数据，并写入文件
	_ = tmpl.Execute(file, tmplData)

	fmt.Println("注册 DDD(application/infrastructure/interfaces) 层完成...")
}
