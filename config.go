package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"strings"
)

type EnvConfig struct {
	GOOS   string `ini:"GOOS" comment:"GO 编译平台"`
	GOARCH string `ini:"GOARCH" comment:"GO 编译架构"`
}

type BuildConfig struct {
	IsGUI   bool   `ini:"gui" comment:"是否是GUI程序"`
	IsUPX   bool   `ini:"upx" comment:"是否启用UPX压缩"`
	IsArch  bool   `ini:"arch" comment:"文件名是否台添加架构名称"`
	IsMode  bool   `ini:"mode" comment:"是否编译为动态链接库"`
	IsVer   bool   `ini:"ver" comment:"文件名是否添加版本号"`
	IsPlat  bool   `ini:"plat" comment:"编译平台"`
	Name    string `ini:"name" comment:"文件名"`
	Version []int  `ini:"version" comment:"程序编译版本"`
}

type OtherConfig struct {
	File      string `ini:"-" comment:"临时文件名"`
	UPX       string `ini:"-" comment:"UPX 文件路径"`
	Ext       string `ini:"-" comment:"文件扩展名"`
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
	GUI     *bool   `type:"Field" field:"Build.IsGUI" comment:"是否是GUI编译"`
	UPX     *bool   `type:"Field" field:"Build.IsUPX" comment:"是否开启UPX压缩"`
	Arch    *bool   `type:"Field" field:"Build.IsArch" comment:"文件名中是否添加架构名称"`
	Ver     *bool   `type:"Field" field:"Build.IsVer" comment:"文件名中是否添加版本号"`
	Mode    *bool   `type:"Field" field:"Build.IsMode" comment:"是否编译为动态链接库"`
	Plat    *bool   `type:"Field" field:"Build.IsPlat" comment:"文件名中是否添加平台名称"`
	Name    *string `type:"Field" field:"Build.Name" comment:"可执行文件名称"`
	Comment *bool   `type:"Field" field:"Other.Comment" comment:"是否开启配置文件注释"`
	GOOS    *string `type:"Field" field:"Env.GOOS" comment:"编译目标系统"`
	GOARCH  *string `type:"Field" field:"Env.GOARCH" comment:"编译目标平台"`
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

func (c ArgsCommand) TFunc(value *bool, valueOk bool, field reflect.StructField, cmdValue, confValue reflect.Value) {
	if !(*value && valueOk) {
		return
	}
	method := cmdValue.MethodByName(fmt.Sprintf("E%s", field.Tag.Get("func")))
	method.Call([]reflect.Value{})
	os.Exit(0)
}

func (c ArgsCommand) TField(value *bool, valueOk bool, field reflect.StructField, cmdValue, confValue reflect.Value) {
	tf := strings.Split(field.Tag.Get("field"), ".")
	getField := confValue.FieldByName(tf[0]).FieldByName(tf[1])
	// 处理字段
	if valueOk {
		getField.SetBool(*value)
	} else {
		value, _ := cmdValue.FieldByName(field.Name).Interface().(*string)
		getField.SetString(*value)
	}
}
