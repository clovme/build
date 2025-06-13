package em_type

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type ValueT int

const Name = "value_type"

const (
	Int ValueT = iota + 1
	Int64
	Float64
	String
	Bool
	Time
)

var (
	initiate = map[ValueT]enums.Enums{
		Int:     {Key: "int", Name: "int", Desc: "整数类型"},
		Int64:   {Key: "bigint", Name: "int64", Desc: "长整型"},
		Float64: {Key: "double", Name: "float64", Desc: "浮点型"},
		String:  {Key: "varchar", Name: "string", Desc: "字符串类型"},
		Bool:    {Key: "tinyint(1)", Name: "bool", Desc: "布尔值"},
		Time:    {Key: "datetime", Name: "time.Time", Desc: "时间类型"},
	}

	enumToValue = make(map[string]ValueT)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c ValueT) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Key
	}
	return "Int"
}

// Name 获取枚举名称
func (c ValueT) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "Int"
}

// Desc 获取枚举描述
func (c ValueT) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "Int"
}

// Int 获取枚举值
func (c ValueT) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c ValueT) Is(v ValueT) bool {
	return v == c
}

// Code 获取ValueT
func Code(key string) ValueT {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Int
}

// Values 获取所有枚举
func Values() []ValueT {
	values := make([]ValueT, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
