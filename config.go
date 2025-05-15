package main

import (
	"fmt"
	"os"
	"reflect"
	"strings"
)

// EnvConfig 环境变量配置
type EnvConfig struct {
	GOOS   string `ini:"GOOS" comment:"GO 编译平台"`
	GOARCH string `ini:"GOARCH" comment:"GO 编译架构"`
}

// BuildFileName 编译生成的文件名配置
type BuildFileName struct {
	Name   string `ini:"name" comment:"文件名"`
	IsPlat bool   `ini:"plat" comment:"编译平台"`
	IsArch bool   `ini:"arch" comment:"文件名是否台添加架构名称"`
	IsVer  bool   `ini:"ver" comment:"文件名是否添加版本号"`
}

// BuildConfig 编译配置
type BuildConfig struct {
	IsGen   bool     `ini:"gen" comment:"是否执行go generate命令"`
	IsGUI   bool     `ini:"gui" comment:"是否是GUI程序"`
	IsAll   bool     `ini:"all" comment:"编译三大平台(linux、windows、darwin)"`
	IsUPX   bool     `ini:"upx" comment:"是否启用UPX压缩"`
	IsMode  bool     `ini:"mode" comment:"是否编译为动态链接库"`
	Plat    []string `ini:"plat" comment:"编译平台"`
	Arch    []string `ini:"arch" comment:"编译架构"`
	Version []int    `ini:"version" comment:"程序编译版本"`
}

// OtherConfig 其他配置
type OtherConfig struct {
	UPX       string `ini:"-" comment:"UPX 文件路径"`
	Temp      string `ini:"-" comment:"临时路径"`
	Version   string `ini:"-" comment:"临时保存版本号"`
	Change    bool   `ini:"-" comment:"配置文件改变"`
	Comment   bool   `ini:"comment" comment:"是否开启配置文件注释"`
	GoVersion string `ini:"go_version" comment:"当前项目Go版本"`
}

// Config 配置文件
type Config struct {
	Env      EnvConfig     `ini:"env" comment:"环境变量配置"`
	Build    BuildConfig   `ini:"build" comment:"编译配置"`
	FileName BuildFileName `ini:"filename" comment:"编译文件名配置"`
	Other    OtherConfig   `ini:"other" comment:"其他配置"`
}

// ArgsCommandContext 命令上下文参数传递
type ArgsCommandContext struct {
	Value     *bool
	ValueOk   bool
	Field     reflect.StructField
	CmdType   reflect.Type
	CmdValue  reflect.Value
	ConfValue reflect.Value
	TagField  string
}

// ArgsCommand 命令行参数
//
//	type: 类型，Value: 函数+值类型，Field: 值类型，Func: 函数类型，EValue: 执行函数+值类型+退出程序
//	func: 执行函数名称，field: 配置文件字段名称，comment: 注释内容
type ArgsCommand struct {
	IsGen   *bool   `type:"Value" func:"Build.IsGen" comment:"是否执行go generate命令"`
	Air     *bool   `type:"Func" func:"Air" comment:"go项目热更新工具Air"`
	Gin     *bool   `type:"Func" func:"Gin" comment:"在文件夹中生成Gin框架项目"`
	Router  *bool   `type:"Func" func:"GenGinRouter" comment:"生成Gin路由文件"`
	Init    *bool   `type:"Func" func:"InitEnv" comment:"初始化Go环境"`
	Help    *bool   `type:"Func" func:"Help" comment:"帮助"`
	Check   *bool   `type:"Func" func:"Check" comment:"构建器快速诊断命令"`
	Default *bool   `type:"Func" func:"Default" comment:"使用默认(本机)编译环境(GOOS/GOARCH)"`
	List    *bool   `type:"Func" func:"List" comment:"查看当前环境可交叉编译的所有系统+架构"`
	IsArch  *bool   `type:"Field" field:"FileName.IsArch" comment:"文件名中是否添加架构名称"`
	IsVer   *bool   `type:"Field" field:"FileName.IsVer" comment:"文件名中是否添加版本号"`
	IsPlat  *bool   `type:"Field" field:"FileName.IsPlat" comment:"文件名中是否添加平台名称"`
	Name    *string `type:"Field" field:"FileName.Name" comment:"可执行文件名称"`
	IsGUI   *bool   `type:"Field" field:"Build.IsGUI" comment:"是否是GUI编译"`
	IsUPX   *bool   `type:"Field" field:"Build.IsUPX" comment:"是否开启UPX压缩"`
	IsMode  *bool   `type:"Field" field:"Build.IsMode" comment:"是否编译为动态链接库"`
	Comment *bool   `type:"Field" field:"Other.Comment" comment:"是否开启配置文件注释"`
	GOOS    *string `type:"Field" field:"Env.GOOS" comment:"编译目标系统"`
	GOARCH  *string `type:"Field" field:"Env.GOARCH" comment:"编译目标平台"`
	IsAll   *bool   `type:"Value" func:"Build.IsAll" comment:"编译三大平台(linux、windows、darwin)"`
}

func (c *ArgsCommand) TValue(ctx ArgsCommandContext) {
	// 数据断言成功
	if !ctx.ValueOk {
		return
	}
	funcName := strings.Replace(ctx.Field.Tag.Get("func"), ".", "", -1)
	method, _ := ctx.CmdType.MethodByName(fmt.Sprintf("V%s", funcName))
	method.Func.Call([]reflect.Value{
		reflect.ValueOf(ac),
		reflect.ValueOf(*ctx.Value),
	})

	ctx.TagField = "func"

	c.TField(ctx)
}

// TFunc 执行函数类型函数，执行完函数就结束程序
func (c *ArgsCommand) TFunc(ctx ArgsCommandContext) {
	// 数据断言成功, 数据为true
	if !ctx.ValueOk || !*ctx.Value {
		return
	}
	defer func() {
		if IsDirExist(conf.Other.Temp) {
			_ = os.RemoveAll(conf.Other.Temp)
		}
		os.Exit(0)
	}()
	method, _ := ctx.CmdType.MethodByName(fmt.Sprintf("E%s", ctx.Field.Tag.Get("func")))
	method.Func.Call([]reflect.Value{reflect.ValueOf(ac)})
}

// TField 处理字段类型函数，从命令行赋值给配置文件
func (c *ArgsCommand) TField(ctx ArgsCommandContext) {
	tf := strings.Split(ctx.Field.Tag.Get(ctx.TagField), ".")
	getField := ctx.ConfValue.FieldByName(tf[0]).FieldByName(tf[1])
	// 处理字段
	if ctx.ValueOk {
		oldValue, _ := getField.Interface().(bool)
		if oldValue == *ctx.Value {
			return // 没有变化
		}
		conf.Other.Change = true // 配置文件改变
		getField.SetBool(*ctx.Value)
	} else {
		oldValue, _ := getField.Interface().(string)
		value, _ := ctx.CmdValue.FieldByName(ctx.Field.Name).Interface().(*string)
		if oldValue == *value {
			return // 没有变化
		}
		conf.Other.Change = true // 配置文件改变
		getField.SetString(*value)
	}
}
