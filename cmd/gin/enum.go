package gin

import (
	"buildx/global"
	"buildx/libs"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"text/template"
)

const enumTpl = `package em_{{ .Name }}

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type {{ .EnumName }} int

const Name = "{{ .Name }}"

const (
	Unknown {{ .EnumName }} = iota + 1
)

var (
	initiate = map[{{ .EnumName }}]enums.Enums{
		Unknown: {Key: "Unknown", Name: "未知", Desc: "未知值"},
	}

	enumToValue = make(map[string]{{ .EnumName }})
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c {{ .EnumName }}) Key() string {
	return initiate[c].Key
}

// Name 获取枚举名称
func (c {{ .EnumName }}) Name() string {
	return initiate[c].Name
}

// Desc 获取枚举描述
func (c {{ .EnumName }}) Desc() string {
	return initiate[c].Desc
}

// String 获取枚举名称
func (c {{ .EnumName }}) String() string {
	return initiate[c].Key
}

// Int 获取枚举值
func (c {{ .EnumName }}) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c {{ .EnumName }}) Is(v {{ .EnumName }}) bool {
	return v == c
}

// Code 获取{{ .EnumName }}
func Code(key string) {{ .EnumName }} {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Unknown
}

// Values 获取所有枚举
func Values() []{{ .EnumName }} {
	values := make([]{{ .EnumName }}, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}`

type enums struct {
	Name        string
	EnumName    string
	ProjectName string
}

var enumCmd = &cobra.Command{
	Use:   "enums",
	Short: "创建枚举模块",
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		prefix, _ := libs.NamePrefix(args[0], "enum")
		path := fmt.Sprintf("pkg/enums/%s", prefix)
		if libs.IsDirExist(path) {
			fmt.Println(fmt.Sprintf("%s 可已存在，请检查！", path))
			return
		}

		_ = os.MkdirAll(path, os.ModePerm)
		data := enums{
			Name:        libs.CamelToSnake(args[0]),
			EnumName:    libs.Capitalize(args[0]),
			ProjectName: libs.GetModuleName(),
		}

		tmpl, _ := template.New("enums").Parse(enumTpl)

		path = fmt.Sprintf("%s/%s.go", path, data.Name)
		// 输出解析结果，可以写入文件
		file, _ := os.Create(path)
		defer file.Close()

		_ = tmpl.Execute(file, data)

		fmt.Printf("枚举%s已生成，%s\n", args[0], path)
	},
}

func init() {
	enumCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin enum [name]\t创建枚举模块\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
