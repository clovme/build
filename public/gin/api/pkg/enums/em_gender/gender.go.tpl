package em_gender

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Gender int

const Name = "gender"

const (
	Male Gender = iota
	Female
	Unknown
)

var (
	initiate = map[Gender]enums.Enums{
		Male:    {Key: "Male", Name: "男", Desc: "性别男"},
		Female:  {Key: "Female", Name: "女", Desc: "性别女"},
		Unknown: {Key: "Unknown", Name: "未知", Desc: "未知性别"},
	}

	enumToValue = make(map[string]Gender)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c Gender) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Key
	}
	return "Unknown"
}

// Name 获取枚举名称
func (c Gender) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "Unknown"
}

// Desc 获取枚举描述
func (c Gender) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "Unknown"
}

// Int 获取枚举值
func (c Gender) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c Gender) Is(v Gender) bool {
	return v == c
}

// Code 获取Gender
func Code(key string) Gender {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return Unknown
}

// Values 获取所有枚举
func Values() []Gender {
	values := make([]Gender, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
