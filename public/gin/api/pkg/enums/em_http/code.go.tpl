package em_http

import (
	"{{ .ProjectName }}/pkg/enums"
	"sort"
)

type Http int

const Name = "http"

const (
	Success Http = iota + 10000
	ErrUnknown
	ErrBadRequest
	ErrUnauthorized
	ErrNotFound
	ErrInternal
)

var (
	initiate = map[Http]enums.Enums{
		Success:         {Key: "Success", Name: "成功", Desc: "请求成功"},
		ErrUnknown:      {Key: "ErrUnknown", Name: "未知错误", Desc: "未知错误"},
		ErrBadRequest:   {Key: "ErrBadRequest", Name: "参数错误", Desc: "请求参数不合法"},
		ErrUnauthorized: {Key: "ErrUnauthorized", Name: "未授权", Desc: "用户未授权"},
		ErrNotFound:     {Key: "ErrNotFound", Name: "资源不存在", Desc: "请求的资源不存在"},
		ErrInternal:     {Key: "ErrInternal", Name: "服务器错误", Desc: "服务器开小差了，请稍后再试"},
	}

	enumToValue = make(map[string]Http)
)

func init() {
	for code, meta := range initiate {
		enumToValue[meta.Key] = code
	}
}

// Key 获取enums.Key
func (c Http) Key() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "ErrUnknown"
}

// Name 获取枚举名称
func (c Http) Name() string {
	if meta, ok := initiate[c]; ok {
		return meta.Name
	}
	return "ErrUnknown"
}

// Desc 获取枚举描述
func (c Http) Desc() string {
	if meta, ok := initiate[c]; ok {
		return meta.Desc
	}
	return "ErrUnknown"
}

// Int 获取枚举值
func (c Http) Int() int {
	return int(c)
}

// Is 比较枚举值
func (c Http) Is(v Http) bool {
	return v == c
}

// Code 获取Code
func Code(key string) Http {
	if enum, ok := enumToValue[key]; ok {
		return enum
	}
	return ErrUnknown
}

// Values 获取所有枚举
func Values() []Http {
	values := make([]Http, 0, len(initiate))
	for k := range initiate {
		values = append(values, k)
	}
	sort.Slice(values, func(i, j int) bool {
		return values[i] < values[j]
	})
	return values
}
