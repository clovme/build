package em_status

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Status int

const Name = "status"

const (
	Disable Status = iota
	Enable
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
	return initiate[c].Key
}

// Name 获取枚举名称
func (c Status) Name() string {
	return initiate[c].Name
}

// Desc 获取枚举描述
func (c Status) Desc() string {
	return initiate[c].Desc
}

// String 获取枚举名称
func (c Status) String() string {
	return initiate[c].Key
}

// Int 获取枚举值
func (c Status) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c Status) Is(v Status) bool {
	return v == c
}

// Code 获取Status
func Code(key string) Status {
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
