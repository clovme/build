package main

import (
	_ "embed"
	"flag"
	"fmt"
	"github.com/go-ini/ini"
	"os"
	"path/filepath"
	"reflect"
	"strings"
)

//go:embed public/upx.exe
var upx []byte

//go:embed public/env
var env []byte

//go:embed public/pip.ini
var pip []byte

var conf = &Config{
	Other: OtherConfig{
		Version: []int{0, 0, 0},
	},
}
var ac = &ArgsCommand{}

var buildIni = "build.cfg"
var errIni error = nil

func init() {
	flagUsage()
	conf.Other.UPX = filepath.Join(os.TempDir(), "upx.exe")
	_ = os.WriteFile(conf.Other.UPX, upx, os.ModePerm)

	file, err := ini.Load(buildIni)
	if err == nil {
		_ = file.MapTo(conf)
	} else {
		errIni = err
	}

	ct := reflect.TypeOf(&conf.Env).Elem()
	cv := reflect.ValueOf(&conf.Env).Elem()

	for i := 0; i < ct.NumField(); i++ {
		field := ct.Field(i)
		cvField := cv.FieldByName(field.Name)
		value, _ := cvField.Interface().(string)
		if value == "" {
			cv.FieldByName(field.Name).SetString(returnCMD("go", "env", field.Tag.Get("ini")))
		}
	}

	ac = &ArgsCommand{
		Init:     flag.Bool("init", false, "初始化Go环境"),
		Help:     flag.Bool("help", false, "帮助"),
		GUI:      flag.Bool("gui", conf.Build.IsGUI, "是否是GUI编译"),
		UPX:      flag.Bool("upx", conf.Build.IsUPX, "是否开启UPX压缩"),
		Arch:     flag.Bool("arch", conf.Build.IsArch, "文件名中是否添加架构名称"),
		Version:  flag.Bool("version", conf.Build.IsVersion, "文件名中是否添加版本号"),
		Platform: flag.Bool("platform", conf.Build.IsPlatform, "文件名中是否添加平台名称"),
		Filename: flag.String("filename", conf.Build.Filename, "可执行文件名称"),
		GOROOT:   flag.String("GOROOT", conf.Env.GOROOT, "GOROOT路径"),
		GOOS:     flag.String("GOOS", conf.Env.GOOS, "编译目标系统"),
		GOARCH:   flag.String("GOARCH", conf.Env.GOARCH, "编译目标平台"),
	}

	flag.Parse()
}

func main() {
	t := reflect.TypeOf(ac).Elem()
	v := reflect.ValueOf(ac).Elem()
	cv := reflect.ValueOf(conf).Elem()

	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)

		tagFunc := fmt.Sprintf("E%s", field.Tag.Get("func"))
		value, ok := v.FieldByName(field.Name).Interface().(*bool)

		// 处理方法
		if field.Tag.Get("type") == "func" {
			if *value && ok {
				exec := v.MethodByName(tagFunc)
				exec.Call([]reflect.Value{})
				break
			}
			continue
		}

		tf := strings.Split(field.Tag.Get("field"), ".")
		// 处理字段
		if ok {
			(cv.FieldByName(tf[0]).FieldByName(tf[1])).SetBool(*value)
		} else {
			value, _ := v.FieldByName(field.Name).Interface().(*string)
			(cv.FieldByName(tf[0]).FieldByName(tf[1])).SetString(*value)
		}
	}

	ext := filepath.Ext(conf.Build.Filename)
	conf.Build.Filename = conf.Build.Filename[:len(conf.Build.Filename)-len(ext)]

	// 设置环境变量
	envt := reflect.TypeOf(&conf.Env).Elem()
	envv := reflect.ValueOf(&conf.Env).Elem()
	for i := 0; i < envt.NumField(); i++ {
		field := envt.Field(i)
		value, ok := envv.FieldByName(field.Name).Interface().(string)
		if value != "" && ok {
			_ = os.Setenv(field.Tag.Get("ini"), value)
		}
	}

	// 如果没有文件名，使用当前go.mod的模块名，其次使用目录名
	if conf.Build.Filename == "" {
		file, err := os.ReadFile("go.mod")
		if err != nil {
			dir, _ := os.Getwd()
			conf.Build.Filename = filepath.Base(dir)
		} else {
			module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
			conf.Build.Filename = strings.TrimSpace(module[len(module)-1])
		}
	}

	IncrementVersion()

	// 执行命令
	ExecCmd()

	f := ini.Empty()
	if err := f.ReflectFrom(conf); err != nil {
		panic(err)
	}
	if err := f.SaveTo(buildIni); err != nil {
		panic(err)
	}
}
