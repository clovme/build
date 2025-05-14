package main

import (
	"flag"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// EInitEnv 初始化环境变量
func (c *ArgsCommand) EInitEnv() {
	// 获取用户配置目录
	dir, err := os.UserConfigDir()
	if err != nil {
		fmt.Println("获取用户配置目录时出错:", err)
		return
	}

	// 准备路径
	pipPath := filepath.Join(dir, "pip")
	goPath := filepath.Join(dir, "go")

	// 创建目录
	_ = os.MkdirAll(goPath, 0755)
	_ = os.MkdirAll(pipPath, 0755)

	// 写入文件
	_ = os.WriteFile(filepath.Join(goPath, "env"), env, 0644)
	_ = os.WriteFile(filepath.Join(pipPath, "pip.ini"), pip, 0644)
}

// EHelp 帮助文档
func (c *ArgsCommand) EHelp() {
	flag.Usage()
}

// ECheck 快速检测此项目那些文件是可构建的命令
func (c *ArgsCommand) ECheck() {
	Command("go", "list", "-f", "'{{.GoFiles}}'", ".")
}

// EList 查看当前环境可交叉编译的所有系统+架构
func (c *ArgsCommand) EList() {
	Command("go", "tool", "dist", "list")
}

// EDefault 使用默认(本机)编译环境
func (c *ArgsCommand) EDefault() {
	conf.Env.GOOS = runtime.GOOS
	conf.Env.GOARCH = runtime.GOARCH
	SaveConfig()
}

// EGenGinRouter 生成Gin路由文件
func (c *ArgsCommand) EGenGinRouter() {
	routes := make(map[string][]Route)
	fset := token.NewFileSet()

	// 判断./controllers是否存在
	if _, err := os.Stat("./controllers"); os.IsNotExist(err) {
		fmt.Println("❌ 错误：controllers 目录不存在，或者这不是Gin项目")
		return
	}
	// 递归遍历 controllers 目录下所有 go 文件
	err := filepath.WalkDir("./controllers", func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		// 只处理 .go 文件
		if !d.IsDir() && strings.HasSuffix(d.Name(), ".go") {
			// 获取包名（根据目录路径）
			dir := filepath.Dir(path)
			pkgPath := fmt.Sprintf("%s/%s", conf.FileName.Name, strings.Replace(dir, "\\", "/", -1))
			pkgName := filepath.Base(dir)

			// 解析文件
			node, err := parser.ParseFile(fset, path, nil, parser.ParseComments)
			if err != nil {
				return err
			}

			for _, decl := range node.Decls {
				if fn, ok := decl.(*ast.FuncDecl); ok && fn.Doc != nil {
					route := Route{
						Func:        fn.Name.Name,
						PackagePath: pkgPath,
						PackageName: pkgName,
					}
					group := "Public"
					for _, comment := range fn.Doc.List {
						// 匹配 @Route
						if routeMatches := routeRegex.FindStringSubmatch(comment.Text); routeMatches != nil {
							route.Path = re.ReplaceAllString(routeMatches[1], `:$1`)
							route.HTTPMethod = strings.ToUpper(routeMatches[2])
						}
						// 匹配 @Group
						if groupMatches := groupRegex.FindStringSubmatch(comment.Text); groupMatches != nil {
							group = FirstUpper(groupMatches[1])
						}
					}
					fmt.Printf("发现路由: %s %s %s -> %s.%s\n", group, route.HTTPMethod, route.Path, pkgName, fn.Name.Name)
					routes[group] = append(routes[group], route)
				}
			}
		}
		return nil
	})

	if err != nil {
		log.Fatal(err)
	}

	// 写入路由文件
	if writeRoutes(routes) != nil {
		fmt.Println("❌ 出错啦：", err)
	}
}
