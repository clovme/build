package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
)

type ConfigEnv struct {
	GOROOT string `ini:"GOROOT"`
	GOOS   string `ini:"GOOS"`
	GOARCH string `ini:"GOARCH"`
}

type ConfigBuild struct {
	IsGUI    bool   `ini:"gui"`
	IsUPX    bool   `ini:"upx"`
	Filename string `ini:"filename"`
}

type Config struct {
	Env   ConfigEnv   `ini:"env"`
	Build ConfigBuild `ini:"build"`
}

type ArgsCommand struct {
	Init     *bool   `type:"func" func:"InitEnv"`
	Help     *bool   `type:"func" func:"Help"`
	GUI      *bool   `type:"field" field:"Build.IsGUI"`
	UPX      *bool   `type:"field" field:"Build.IsUPX"`
	Filename *string `type:"field" field:"Build.Filename"`
	GOROOT   *string `type:"field" field:"Env.GOROOT"`
	GOOS     *string `type:"field" field:"Env.GOOS"`
	GOARCH   *string `type:"field" field:"Env.GOARCH"`
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
