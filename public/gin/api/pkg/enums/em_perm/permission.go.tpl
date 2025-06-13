package em_perm

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Perm int

const Name = "permission"

const (
	Api Perm = iota + 1
	Page
	Menu
	Unknown
)

var (
	initiate = map[Perm]enums.Enums{
		Menu:    {Key: "menu", Name: "菜单", Desc: "菜单权限"},
		Api:     {Key: "api", Name: "接口", Desc: "接口权限"},
		Page:    {Key: "page", Name: "页面", Desc: "页面权限"},
		Unknown: {Key: "unknown", Name: "未知", Desc: "未知权限"},
	}

	enumToValue = make(map[string]Perm)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c Perm) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Key
	}
	return "Unknown"
}

// Name 获取枚举名称
func (c Perm) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "Unknown"
}

// Desc 获取枚举描述
func (c Perm) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "Unknown"
}

// Int 获取枚举值
func (c Perm) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c Perm) Is(v Perm) bool {
	return v == c
}

// Code 获取Permission
func Code(key string) Perm {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Unknown
}

// Values 获取所有枚举
func Values() []Perm {
	values := make([]Perm, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
