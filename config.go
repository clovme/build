package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"strings"
)

type EnvConfig struct {
	GOOS   string `ini:"GOOS" comment:"GO 编译平台"`
	GOARCH string `ini:"GOARCH" comment:"GO 编译架构"`
}

type BuildFileName struct {
	Name   string `ini:"name" comment:"文件名"`
	IsPlat bool   `ini:"plat" comment:"编译平台"`
	IsArch bool   `ini:"arch" comment:"文件名是否台添加架构名称"`
	IsVer  bool   `ini:"ver" comment:"文件名是否添加版本号"`
}

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

type OtherConfig struct {
	UPX       string `ini:"-" comment:"UPX 文件路径"`
	Temp      string `ini:"-" comment:"临时路径"`
	Version   string `ini:"-" comment:"临时保存版本号"`
	Change    bool   `ini:"-" comment:"配置文件改变"`
	Comment   bool   `ini:"comment" comment:"是否开启配置文件注释"`
	GoVersion string `ini:"go_version" comment:"当前项目Go版本"`
}

type Config struct {
	Env      EnvConfig     `ini:"env" comment:"环境变量配置"`
	Build    BuildConfig   `ini:"build" comment:"编译配置"`
	FileName BuildFileName `ini:"filename" comment:"编译文件名配置"`
	Other    OtherConfig   `ini:"other" comment:"其他配置"`
}

type ArgsCommandContext struct {
	Value     *bool
	ValueOk   bool
	Field     reflect.StructField
	CmdType   reflect.Type
	CmdValue  reflect.Value
	ConfValue reflect.Value
	TagField  string
}

type ArgsCommand struct {
	IsGen   *bool   `type:"Value" func:"Build.IsGen" comment:"编译三大平台(linux、windows、darwin)"`
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

func (c *ArgsCommand) EInitEnv() {
	// 获取用户配置目录
	dir, err := os.UserConfigDir()
	if err != nil {
		fmt.Println("获取用户配置目录时出错:", err)
		return
	}

	// 准备路径
	pipPath := filepath.Join(dir, "pip")
	goPath := filepath.Join(dir, "go")

	// 创建目录
	_ = os.MkdirAll(goPath, 0755)
	_ = os.MkdirAll(pipPath, 0755)

	// 写入文件
	_ = os.WriteFile(filepath.Join(goPath, "env"), env, 0644)
	_ = os.WriteFile(filepath.Join(pipPath, "pip.ini"), pip, 0644)
}

func (c *ArgsCommand) EHelp() {
	flag.Usage()
}

func (c *ArgsCommand) ECheck() {
	Command("go", "list", "-f", "'{{.GoFiles}}'", ".")
}

func (c *ArgsCommand) EList() {
	Command("go", "tool", "dist", "list")
}

func (c *ArgsCommand) EDefault() {
	conf.Env.GOOS = runtime.GOOS
	conf.Env.GOARCH = runtime.GOARCH
	SaveConfig()
}

func (c *ArgsCommand) EBuildIsAll(isDefault bool) {
	if isDefault {
		if len(conf.Build.Arch) == 0 || len(conf.Build.Plat) == 0 {
			conf.Build.Arch = []string{"amd64", "arm64"}
			conf.Build.Plat = []string{"windows", "linux", "darwin"}
		}
	} else {
		conf.Build.Arch = []string{conf.Env.GOARCH}
		conf.Build.Plat = []string{conf.Env.GOOS}
	}
}

func (c *ArgsCommand) EBuildIsGen(isDefault bool) {
	if isDefault {
		Command("go", "generate", "./...")
	}
}

// TValue 处理值类型函数
func (c *ArgsCommand) TValue(ctx ArgsCommandContext) {
	// 数据断言成功
	if !ctx.ValueOk {
		return
	}
	funcName := strings.Replace(ctx.Field.Tag.Get("func"), ".", "", -1)
	method, _ := ctx.CmdType.MethodByName(fmt.Sprintf("E%s", funcName))
	method.Func.Call([]reflect.Value{
		reflect.ValueOf(ac),
		reflect.ValueOf(*ctx.Value),
	})

	ctx.TagField = "func"

	c.TField(ctx)
}

// TFunc 执行函数类型函数，执行完函数就结束程序
func (c *ArgsCommand) TFunc(ctx ArgsCommandContext) {
	// 数据断言成功
	if !ctx.ValueOk {
		return
	}
	// 数据为true
	if !*ctx.Value {
		return
	}
	method, _ := ctx.CmdType.MethodByName(fmt.Sprintf("E%s", ctx.Field.Tag.Get("func")))
	method.Func.Call([]reflect.Value{reflect.ValueOf(ac)})
	os.Exit(0)
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
