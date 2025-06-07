package enum_status

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Status int

const Category = "status"

const (
	Enable Status = iota
	Disable
)

var (
	initiate = map[Status]enums.Enums{
		Enable:  {Key: "enable", Name: "启用", Desc: "启用"},
		Disable: {Key: "disable", Name: "禁用", Desc: "禁用"},
	}

	enumToValue = make(map[string]Status)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c Status) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Key
	}
	return "Disable"
}

// Name 获取枚举名称
func (c Status) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "Disable"
}

// Desc 获取枚举描述
func (c Status) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "Disable"
}

// Int 获取枚举值
func (c Status) Int() int {
	return int(c)
}

// GetStatus 获取Status
func GetStatus(key string) Status {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Disable
}

// Values 获取所有枚举
func Values() []Status {
	values := make([]Status, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
