package main

import (
	"flag"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"text/template"
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

// EAir 启动Air热加载服务
func (c *ArgsCommand) EAir() {
	CreateAirToml()
	if !IsCommandExists("air") {
		Command("go", "install", "github.com/air-verse/air@latest")
	}
	Command("air")
}

// EGenGinRouter 生成Gin路由文件
func (c *ArgsCommand) EGenGinRouter() {
	routes := make(map[string][]Route)
	fset := token.NewFileSet()

	// 递归遍历 controller 目录下所有 go 文件
	err := filepath.WalkDir("controller", func(path string, d os.DirEntry, err error) error {
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
							route.Path = re.ReplaceAllString(strings.TrimSpace(routeMatches[1]), `:$1`)
							route.HTTPMethod = strings.ToUpper(strings.TrimSpace(routeMatches[2]))
						}
						// 匹配 @Group
						if groupMatches := groupRegex.FindStringSubmatch(comment.Text); groupMatches != nil {
							group = strings.TrimSpace(groupMatches[1])
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
	if writeRouters(routes) != nil {
		fmt.Println("❌ 出错啦：", err)
	}
}

// EGin 生成Gin框架项目
func (c *ArgsCommand) EGin() {
	if files, _ := os.ReadDir("."); len(files) > 0 {
		fmt.Print("❌ 此目录下已有文件，是否强制执行？(y/n)：")
		var input string
		_, _ = fmt.Scanln(&input)
		if strings.ToLower(input) != "y" {
			return
		}
	}

	// 要填充的数据
	data := GinTemplateData{
		ProjectName: conf.FileName.Name,
	}

	isFirst := true
	_ = fs.WalkDir(ePublic, "public/gin", func(path string, d fs.DirEntry, err error) error {
		tempPath := strings.Replace(path, "public/gin/", "", 1)

		// 判断是否是文件夹
		if d.IsDir() {
			if tempPath != "public/gin" {
				if !IsDirExist(tempPath) {
					_ = os.MkdirAll(tempPath, os.ModePerm)
				}
			}
		} else {
			newFile := strings.Replace(tempPath, ".tpl", ".go", 1)
			if !IsFileExist(newFile) {
				// 读取模板文件
				tmpl, _ := ePublic.ReadFile(path)
				if strings.HasPrefix(newFile, "public") {
					// 复制文件
					_ = os.WriteFile(newFile, tmpl, os.ModePerm)
					return nil
				}
				// 创建一个新的模板，解析并执行模板
				t, _ := template.New("constant").Parse(string(tmpl))

				// 输出解析结果，可以写入文件
				file, _ := os.Create(newFile)
				defer file.Close()

				// 执行模板，填充数据，并写入文件
				_ = t.Execute(file, data)

				fmt.Printf("✅ 创建文件：%s\n", newFile)
			} else {
				isFirst = false
				fmt.Printf("❌ 文件已存在：%s\n", newFile)
			}
		}
		return nil
	})
	if !isFirst {
		fmt.Printf("✅ 项目已存在，可以执行:\n　 %s -router\n　 %s -air\n", buildCfg, buildCfg)
		return
	}
	if !IsFileExist(".gitignore") {
		_ = os.WriteFile(".gitignore", []byte(gitignore), os.ModePerm)
	}
	c.EGenGinRouter()

	Command("go", "mod", "init", conf.FileName.Name)
	Command("go", "mod", "tidy")

	c.EAir()
}
