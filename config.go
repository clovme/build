package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
)

type ConfigEnv struct {
	GOROOT string `ini:"GOROOT" comment:"GO ROOT路径"`
	GOOS   string `ini:"GOOS" comment:"GO 编译平台"`
	GOARCH string `ini:"GOARCH" comment:"GO 编译架构"`
}

type ConfigBuild struct {
	IsGUI      bool   `ini:"gui" comment:"是否是GUI程序"`
	IsUPX      bool   `ini:"upx" comment:"是否启用UPX压缩"`
	IsArch     bool   `ini:"arch" comment:"文件名是否台添加架构名称"`
	IsMode     bool   `ini:"mode" comment:"是否编译为动态链接库"`
	IsVersion  bool   `ini:"version" comment:"文件名是否添加版本号"`
	IsPlatform bool   `ini:"platform" comment:"编译平台"`
	Filename   string `ini:"filename" comment:"文件名"`
}

type OtherConfig struct {
	File    string `ini:"-" comment:"临时文件名"`
	UPX     string `ini:"-" comment:"UPX 文件路径"`
	Ext     string `ini:"-" comment:"文件扩展名"`
	Version []int  `ini:"version" comment:"程序编译版本"`
}

type Config struct {
	Env   ConfigEnv   `ini:"env" comment:"环境变量配置"`
	Build ConfigBuild `ini:"build" comment:"编译配置"`
	Other OtherConfig `ini:"other" comment:"其他配置"`
}

type ArgsCommand struct {
	Init     *bool   `type:"func" func:"InitEnv" comment:"初始化Go环境"`
	Help     *bool   `type:"func" func:"Help" comment:"帮助"`
	GUI      *bool   `type:"field" field:"Build.IsGUI" comment:"是否是GUI编译"`
	UPX      *bool   `type:"field" field:"Build.IsUPX" comment:"是否开启UPX压缩"`
	Arch     *bool   `type:"field" field:"Build.IsArch" comment:"文件名中是否添加架构名称"`
	Version  *bool   `type:"field" field:"Build.IsVersion" comment:"文件名中是否添加版本号"`
	Mode     *bool   `type:"field" field:"Build.IsMode" comment:"是否编译为动态链接库"`
	Platform *bool   `type:"field" field:"Build.IsPlatform" comment:"文件名中是否添加平台名称"`
	Filename *string `type:"field" field:"Build.Filename" comment:"可执行文件名称"`
	GOROOT   *string `type:"field" field:"Env.GOROOT" comment:"GOROOT路径"`
	GOOS     *string `type:"field" field:"Env.GOOS" comment:"编译目标系统"`
	GOARCH   *string `type:"field" field:"Env.GOARCH" comment:"编译目标平台"`
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
	os.Exit(0)
}
