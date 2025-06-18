package libs

import (
	"fmt"
	"github.com/spf13/cobra"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path/filepath"
	"strings"
	"unicode"
)

// GenExeFileName 生成配置文件名
func GenExeFileName() string {
	path := os.Args[0]
	ext := filepath.Ext(path)
	return filepath.Base(path[:len(path)-len(ext)])
}

func GetModuleName() string {
	file, err := os.ReadFile("go.mod")
	if err != nil {
		fmt.Println("获取模块名称失败:", err)
		os.Exit(-1)
	}
	module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
	return strings.TrimSpace(module[len(module)-1])
}

// IsDirExist 判断文件夹是否存在
func IsDirExist(folderPath string) bool {
	info, err := os.Stat(folderPath)
	if os.IsNotExist(err) {
		return false
	}
	return info.IsDir()
}

// IsFileExist 判断文件是否存在
func IsFileExist(filePath string) bool {
	info, err := os.Stat(filePath)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func GetString(cmd *cobra.Command, name string) string {
	value, _ := cmd.Flags().GetString(name)
	return value
}

func GetBool(cmd *cobra.Command, name string) bool {
	value, _ := cmd.Flags().GetBool(name)
	return value
}

// SetGoEnv 设置GO环境变量
func SetGoEnv() {
	GOBIN := filepath.Join(os.Getenv("GOPATH"), "bin")
	if temp := CmdValue("go", "env", "get", "GOBIN"); temp != "" {
		GOBIN = temp
	}

	PATH := os.Getenv("PATH")
	if !strings.Contains(PATH, GOBIN) {
		_ = os.Setenv("PATH", fmt.Sprintf("%s;%s", GOBIN, PATH))
	}
}

// Capitalize 首字符大写
func Capitalize(s string) string {
	if s == "" {
		return ""
	}
	// 转成 rune 切片，防止中文/多字节字符乱码
	runes := []rune(s)
	runes[0] = unicode.ToUpper(runes[0])
	return string(runes)
}

// IsArrayContains 判断数组是否包含某元素
func IsArrayContains[T comparable](target T, arr []T) bool {
	for _, item := range arr {
		if item == target {
			return true
		}
	}
	return false
}

func NamePrefix(path, flag string) (prefix, name string) {
	for _, item := range []string{"/", "\\", "."} {
		path = strings.Replace(path, item, "/", -1)
	}
	path = strings.TrimSpace(path)

	name = filepath.Base(path)
	if !strings.Contains(path, "/") {
		prefix = fmt.Sprintf("%s_%s", flag, CamelToSnake(path))
		return
	}

	data := strings.Split(path, "/")
	data[len(data)-1] = fmt.Sprintf("%s_%s", flag, CamelToSnake(data[len(data)-1]))
	prefix = strings.Join(data, "/")
	return
}

// GetFilePath 拼接路径
// toPath internal/domain、internal/application等
// name 控制台传来的参数，user、auth/role等
// ddd embed 路径
// flag "", app, api/web等
func GetFilePath(toPath, prefix, name, ddd, flag string) string {
	ddd = filepath.Base(ddd)
	ddd = strings.Replace(ddd, ".tpl", "", -1)

	if flag != "do" {
		ddd = strings.Replace(ddd, "[name]", CamelToSnake(name), -1)
		if strings.Contains(prefix, "/") {
			name = filepath.Base(prefix)
			prefix, _ = NamePrefix(filepath.Dir(prefix), flag)
			return fmt.Sprintf("%s/%s/%s", toPath, strings.ToLower(prefix), ddd)
		}
	}

	if !strings.Contains(prefix, "/") {
		return fmt.Sprintf("%s/%s", toPath, ddd)
	}
	return fmt.Sprintf("%s/%s/%s", toPath, strings.ToLower(prefix), ddd)
}

func GetPackageName(toPath, args, flag string) string {
	if strings.Contains(args, "/") {
		prefix, _ := NamePrefix(filepath.Dir(args), flag)
		return filepath.Base(prefix)
	}
	return filepath.Base(toPath)
}

func CamelToSnake(s string) string {
	var result []rune
	runes := []rune(s)

	for i := 0; i < len(runes); i++ {
		if i > 0 {
			// 当前是大写，前面是小写，或者当前是大写，前面是大写，后面是小写
			if unicode.IsUpper(runes[i]) && ((i+1 < len(runes) && unicode.IsLower(runes[i+1])) || unicode.IsLower(runes[i-1])) {
				result = append(result, '_')
			}
		}
		result = append(result, unicode.ToLower(runes[i]))
	}
	return strings.ToLower(string(result))
}

// SnakeToCamel 智能将 PascalCase → lowerCamelCase，保留开头缩写正确形式
func SnakeToCamel(s string) string {
	if s == "" {
		return s
	}

	if strings.Contains(s, "_") {
		parts := strings.Split(s, "_")
		for i := 1; i < len(parts); i++ {
			if parts[i] == "" {
				continue
			}
			runes := []rune(parts[i])
			runes[0] = unicode.ToUpper(runes[0])
			parts[i] = string(runes)
		}
		s = strings.Join(parts, "")
	}

	runes := []rune(s)
	var result []rune

	// 把开头连续的大写字母全变小写，直到遇到第一个后跟小写字母
	for i := 0; i < len(runes); i++ {
		if i == 0 {
			result = append(result, unicode.ToLower(runes[i]))
			continue
		}
		if i+1 >= len(runes) {
			result = append(result, unicode.ToLower(runes[i]))
			break
		}
		if unicode.IsUpper(runes[i]) && unicode.IsLower(runes[i+1]) || unicode.IsLower(runes[i-1]) && unicode.IsUpper(runes[i]) {
			result = append(result, runes[i])
		} else {
			result = append(result, unicode.ToLower(runes[i]))
		}
	}

	return string(result)
}

func DomainStructOrPath(domain string) (entityPath, structName string, err error) {
	entityPath = fmt.Sprintf("internal/domain/%s/entity.go", domain)

	// 解析文件
	node, err := parser.ParseFile(token.NewFileSet(), entityPath, nil, parser.AllErrors)
	if err != nil {
		return
	}

	ast.Inspect(node, func(n ast.Node) bool {
		genDecl, ok := n.(*ast.GenDecl)
		if !ok || genDecl.Tok != token.TYPE {
			return true
		}
		for _, spec := range genDecl.Specs {
			typeSpec, ok := spec.(*ast.TypeSpec)
			if !ok {
				continue
			}

			// 判断是否是 struct 类型
			if _, ok := typeSpec.Type.(*ast.StructType); ok {
				structName = typeSpec.Name.Name
			}
		}
		return true
	})
	return
}
