package enum_permission

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Permission int

const Category = "permission"

const (
	Menu Permission = iota
	Api
	Page
	Unknown
)

var (
	initiate = map[Permission]enums.Enums{
		Menu:    {Key: "menu", Name: "菜单", Desc: "菜单权限"},
		Api:     {Key: "api", Name: "接口", Desc: "接口权限"},
		Page:    {Key: "page", Name: "页面", Desc: "页面权限"},
		Unknown: {Key: "unknown", Name: "未知", Desc: "未知权限"},
	}

	enumToValue = make(map[string]Permission)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c Permission) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Key
	}
	return "Unknown"
}

// Name 获取枚举名称
func (c Permission) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "Unknown"
}

// Desc 获取枚举描述
func (c Permission) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "Unknown"
}

// Int 获取枚举值
func (c Permission) Int() int {
	return int(c)
}

// GetPermission 获取Permission
func GetPermission(key string) Permission {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Unknown
}

// Values 获取所有枚举
func Values() []Permission {
	values := make([]Permission, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
