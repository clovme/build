//go:generate go run internal/gen/gen_xxx.go

package main

import (
	"embed"
	"flag"
	"fmt"
	"github.com/go-ini/ini"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"strings"
)

//go:embed public/*
var ePublic embed.FS

//go:embed public/env
var env []byte

//go:embed public/pip.ini
var pip []byte

var conf = &Config{
	Build: BuildConfig{
		Version: []int{0, 0, 0},
	},
	Other: OtherConfig{
		Change: false,
	},
}
var ac = &ArgsCommand{}
var buildCfg = "build"

func init() {
	flagUsage()
	// 解压临时文件
	UnEmbedTempFile()
	// 生成配置文件名
	GenConfigFileName()
	// 设置GO环境变量
	SetGoEnv()

	file, err := ini.Load(buildCfg)
	if err == nil {
		_ = file.MapTo(conf)
	}

	ct := reflect.TypeOf(&conf.Env).Elem()
	cv := reflect.ValueOf(&conf.Env).Elem()

	for i := 0; i < ct.NumField(); i++ {
		field := ct.Field(i)
		cvField := cv.FieldByName(field.Name)
		value, _ := cvField.Interface().(string)
		if len(strings.TrimSpace(value)) == 0 {
			cv.FieldByName(field.Name).SetString(CmdValue("go", "env", field.Tag.Get("ini")))
		}
	}

	if len(strings.TrimSpace(conf.Other.GoVersion)) == 0 {
		conf.Other.GoVersion = runtime.Version()
	}
	// 如果没有文件名，使用当前go.mod的模块名，其次使用目录名
	if conf.FileName.Name == "" {
		file, err := os.ReadFile("go.mod")
		if err != nil {
			dir, _ := os.Getwd()
			conf.FileName.Name = filepath.Base(dir)
		} else {
			module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
			conf.FileName.Name = strings.TrimSpace(module[len(module)-1])
		}
	}

	ac = &ArgsCommand{
		IsGen:   flag.Bool("gen", false, "执行go generate命令(建议:internal/gen)"),
		Air:     flag.Bool("air", false, "go项目热更新工具Air"),
		Gin:     flag.Bool("gin", false, "在文件夹中生成Gin框架项目"),
		Router:  flag.Bool("router", false, "生成Gin路由文件"),
		Help:    flag.Bool("help", false, "帮助"),
		Init:    flag.Bool("init", false, "初始化Go环境"),
		IsGUI:   flag.Bool("gui", conf.Build.IsGUI, "是否是GUI编译"),
		IsUPX:   flag.Bool("upx", conf.Build.IsUPX, "是否开启UPX压缩"),
		IsArch:  flag.Bool("arch", conf.FileName.IsArch, "文件名中是否添加架构名称"),
		IsVer:   flag.Bool("ver", conf.FileName.IsVer, "文件名中是否添加版本号"),
		IsMode:  flag.Bool("mode", conf.Build.IsMode, "是否编译为动态链接库，例如 .dll、.so、.dylib"),
		IsPlat:  flag.Bool("plat", conf.FileName.IsPlat, "文件名中是否添加平台名称"),
		Name:    flag.String("name", conf.FileName.Name, "可执行文件名称"),
		GOOS:    flag.String("GOOS", conf.Env.GOOS, "编译目标平台，例如 linux、windows、darwin"),
		GOARCH:  flag.String("GOARCH", conf.Env.GOARCH, "编译目标系统架构，例如 amd64、arm64"),
		Check:   flag.Bool("check", false, "快速检测此项目那些文件是可构建的命令"),
		Comment: flag.Bool("note", false, "配置文件中是否写入注释"),
		IsAll:   flag.Bool("all", conf.Build.IsAll, "编译(amd64、arm64)三大平台(linux、windows、darwin)"),
		List:    flag.Bool("list", false, "查看当前环境可交叉编译的所有系统+架构"),
		Default: flag.Bool("default", false, fmt.Sprintf("使用默认(本机)编译环境(%s/%s)", runtime.GOOS, runtime.GOARCH)),
	}
	flag.Parse()
	// 递增版本号
	IncrementVersion()
}

func main() {
	defer func() {
		// 保存配置文件
		SaveConfig()
		if IsDirExist(conf.Other.Temp) {
			_ = os.RemoveAll(conf.Other.Temp)
		}
	}()

	cmdType := reflect.TypeOf(ac)
	cmdValue := reflect.ValueOf(ac).Elem()
	confValue := reflect.ValueOf(conf).Elem()

	for i := 0; i < cmdType.Elem().NumField(); i++ {
		field := cmdType.Elem().Field(i)
		value, ok := cmdValue.Field(i).Interface().(*bool)
		method, _ := cmdType.MethodByName(fmt.Sprintf("T%s", field.Tag.Get("type")))
		method.Func.Call([]reflect.Value{
			reflect.ValueOf(ac),
			reflect.ValueOf(ArgsCommandContext{
				Value:     value,
				ValueOk:   ok,
				Field:     field,
				CmdType:   cmdType,
				CmdValue:  cmdValue,
				ConfValue: confValue,
				TagField:  "field",
			}),
		})
	}

	// 配置文件名
	ext := filepath.Ext(conf.FileName.Name)
	conf.FileName.Name = conf.FileName.Name[:len(conf.FileName.Name)-len(ext)]

	// 设置编译环境变量
	envt := reflect.TypeOf(&conf.Env).Elem()
	envv := reflect.ValueOf(&conf.Env).Elem()
	for i := 0; i < envt.NumField(); i++ {
		field := envt.Field(i)
		value, ok := envv.FieldByName(field.Name).Interface().(string)
		if value != "" && ok {
			_ = os.Setenv(field.Tag.Get("ini"), value)
		}
	}
	// 执行编译命令
	ExecSourceBuild()
}
