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

type BuildConfig struct {
	IsGUI    bool     `ini:"gui" comment:"是否是GUI程序"`
	IsAll    bool     `ini:"all" comment:"编译三大平台(linux、windows、darwin)"`
	IsUPX    bool     `ini:"upx" comment:"是否启用UPX压缩"`
	IsArch   bool     `ini:"arch" comment:"文件名是否台添加架构名称"`
	IsMode   bool     `ini:"mode" comment:"是否编译为动态链接库"`
	IsVer    bool     `ini:"ver" comment:"文件名是否添加版本号"`
	IsPlat   bool     `ini:"plat" comment:"编译平台"`
	Name     string   `ini:"name" comment:"文件名"`
	Version  []int    `ini:"version" comment:"程序编译版本"`
	Platform []string `ini:"platform" comment:"编译平台"`
	Arch     []string `ini:"arch" comment:"编译架构"`
}

type OtherConfig struct {
	UPX       string `ini:"-" comment:"UPX 文件路径"`
	Temp      string `ini:"-" comment:"临时路径"`
	Version   string `ini:"-" comment:"临时保存版本号"`
	Comment   bool   `ini:"comment" comment:"是否开启配置文件注释"`
	GoVersion string `ini:"go_version" comment:"当前项目Go版本"`
}

type Config struct {
	Env   EnvConfig   `ini:"env" comment:"环境变量配置"`
	Build BuildConfig `ini:"build" comment:"编译配置"`
	Other OtherConfig `ini:"other" comment:"其他配置"`
}

type ArgsCommand struct {
	Init    *bool   `type:"Func" func:"InitEnv" comment:"初始化Go环境"`
	Help    *bool   `type:"Func" func:"Help" comment:"帮助"`
	Check   *bool   `type:"Func" func:"Check" comment:"构建器快速诊断命令"`
	Default *bool   `type:"Func" func:"Default" comment:"使用默认(本机)编译环境(GOOS/GOARCH)"`
	List    *bool   `type:"Func" func:"List" comment:"查看当前环境可交叉编译的所有系统+架构"`
	IsGUI   *bool   `type:"Field" field:"Build.IsGUI" comment:"是否是GUI编译"`
	IsUPX   *bool   `type:"Field" field:"Build.IsUPX" comment:"是否开启UPX压缩"`
	IsArch  *bool   `type:"Field" field:"Build.IsArch" comment:"文件名中是否添加架构名称"`
	IsVer   *bool   `type:"Field" field:"Build.IsVer" comment:"文件名中是否添加版本号"`
	IsMode  *bool   `type:"Field" field:"Build.IsMode" comment:"是否编译为动态链接库"`
	IsPlat  *bool   `type:"Field" field:"Build.IsPlat" comment:"文件名中是否添加平台名称"`
	Name    *string `type:"Field" field:"Build.Name" comment:"可执行文件名称"`
	Comment *bool   `type:"Field" field:"Other.Comment" comment:"是否开启配置文件注释"`
	GOOS    *string `type:"Field" field:"Env.GOOS" comment:"编译目标系统"`
	GOARCH  *string `type:"Field" field:"Env.GOARCH" comment:"编译目标平台"`
	IsAll   *bool   `type:"Value" func:"Build.IsAll" comment:"编译三大平台(linux、windows、darwin)"`
}

func (c ArgsCommand) EInitEnv() {
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

func (c ArgsCommand) EHelp() {
	flag.Usage()
}

func (c ArgsCommand) ECheck() {
	Command("go", "list", "-f", "'{{.GoFiles}}'", ".")
}

func (c ArgsCommand) EList() {
	Command("go", "tool", "dist", "list")
}

func (c ArgsCommand) EDefault() {
	conf.Env.GOOS = runtime.GOOS
	conf.Env.GOARCH = runtime.GOARCH
	SaveConfig()
}

func (c ArgsCommand) EBuildIsAll(isDefault bool) {
	if isDefault {
		if len(conf.Build.Arch) == 0 || len(conf.Build.Platform) == 0 {
			conf.Build.Arch = []string{"amd64", "arm64"}
			conf.Build.Platform = []string{"windows", "linux", "darwin"}
		}
	} else {
		conf.Build.Arch = []string{conf.Env.GOARCH}
		conf.Build.Platform = []string{conf.Env.GOOS}
	}
}

// TValue 处理值类型函数
func (c ArgsCommand) TValue(value *bool, valueOk bool, field reflect.StructField, cmdValue, confValue reflect.Value, tagField string) {
	if !valueOk {
		return
	}
	funcName := strings.Replace(field.Tag.Get("func"), ".", "", -1)
	method := cmdValue.MethodByName(fmt.Sprintf("E%s", funcName))
	method.Call([]reflect.Value{
		reflect.ValueOf(*value),
	})

	c.TField(value, valueOk, field, cmdValue, confValue, "func")
}

// TFunc 执行函数类型函数，执行完函数就结束程序
func (c ArgsCommand) TFunc(value *bool, valueOk bool, field reflect.StructField, cmdValue, confValue reflect.Value, tagField string) {
	if !(*value && valueOk) {
		return
	}
	method := cmdValue.MethodByName(fmt.Sprintf("E%s", field.Tag.Get("func")))
	method.Call([]reflect.Value{})
	os.Exit(0)
}

// TField 处理字段类型函数，从命令行赋值给配置文件
func (c ArgsCommand) TField(value *bool, valueOk bool, field reflect.StructField, cmdValue, confValue reflect.Value, tagField string) {
	tf := strings.Split(field.Tag.Get(tagField), ".")
	getField := confValue.FieldByName(tf[0]).FieldByName(tf[1])
	// 处理字段
	if valueOk {
		getField.SetBool(*value)
	} else {
		value, _ := cmdValue.FieldByName(field.Name).Interface().(*string)
		getField.SetString(*value)
	}
}
