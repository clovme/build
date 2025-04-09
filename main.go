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
	Build: BuildConfig{
		Version: []int{0, 0, 0},
	},
}
var ac = &ArgsCommand{}

var buildIni = "build.cfg"

func init() {
	flagUsage()
	conf.Other.UPX = filepath.Join(os.TempDir(), "upx.exe")
	_ = os.WriteFile(conf.Other.UPX, upx, os.ModePerm)

	file, err := ini.Load(buildIni)
	if err == nil {
		_ = file.MapTo(conf)
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
	conf.Other.GoVersion = returnCMD("go", "version")
	// 如果没有文件名，使用当前go.mod的模块名，其次使用目录名
	if conf.Build.Name == "" {
		file, err := os.ReadFile("go.mod")
		if err != nil {
			dir, _ := os.Getwd()
			conf.Build.Name = filepath.Base(dir)
		} else {
			module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
			conf.Build.Name = strings.TrimSpace(module[len(module)-1])
		}
	}

	ac = &ArgsCommand{
		Help:    flag.Bool("help", false, "帮助"),
		Init:    flag.Bool("init", false, "初始化Go环境"),
		GUI:     flag.Bool("gui", conf.Build.IsGUI, "是否是GUI编译"),
		UPX:     flag.Bool("upx", conf.Build.IsUPX, "是否开启UPX压缩"),
		Arch:    flag.Bool("arch", conf.Build.IsArch, "文件名中是否添加架构名称"),
		Ver:     flag.Bool("ver", conf.Build.IsVer, "文件名中是否添加版本号"),
		Mode:    flag.Bool("mode", conf.Build.IsMode, "是否编译为动态链接库，例如 .dll、.so、.dylib"),
		Plat:    flag.Bool("plat", conf.Build.IsPlat, "文件名中是否添加平台名称"),
		Name:    flag.String("name", conf.Build.Name, "可执行文件名称"),
		GOOS:    flag.String("GOOS", conf.Env.GOOS, "编译目标平台，例如 linux、windows、darwin"),
		GOARCH:  flag.String("GOARCH", conf.Env.GOARCH, "编译目标系统架构，例如 amd64、arm64"),
		Check:   flag.Bool("check", false, "快速检测此项目那些文件是可构建的命令"),
		Comment: flag.Bool("note", false, "配置文件中是否写入注释"),
	}

	flag.Parse()
}

func main() {
	cmdType := reflect.TypeOf(ac).Elem()
	cmdValue := reflect.ValueOf(ac).Elem()
	confValue := reflect.ValueOf(conf).Elem()

	for i := 0; i < cmdType.NumField(); i++ {
		field := cmdType.Field(i)

		value, ok := cmdValue.FieldByName(field.Name).Interface().(*bool)
		method := cmdValue.MethodByName(fmt.Sprintf("T%s", field.Tag.Get("type")))
		method.Call([]reflect.Value{
			reflect.ValueOf(value),
			reflect.ValueOf(ok),
			reflect.ValueOf(field),
			reflect.ValueOf(cmdValue),
			reflect.ValueOf(confValue),
		})
	}

	ext := filepath.Ext(conf.Build.Name)
	conf.Build.Name = conf.Build.Name[:len(conf.Build.Name)-len(ext)]

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
	platformExt()
	IncrementVersion()

	// 执行命令
	ExecCmd()

	f := ini.Empty()
	if err := f.ReflectFrom(conf); err != nil {
		panic(err)
	}

	if !conf.Other.Comment {
		// 清除掉所有注释
		for _, section := range f.Sections() {
			section.Comment = "" // 删除注释
			for _, key := range section.Keys() {
				key.Comment = "" // 删除注释
			}
		}
	}

	if err := f.SaveTo(buildIni); err != nil {
		panic(err)
	}
}
