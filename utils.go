package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
)

// ANSI 彩色代码
const (
	colorReset  = "\033[0m"
	colorCyan   = "\033[36m"
	colorYellow = "\033[33m"
	colorGreen  = "\033[32m"
	colorBold   = "\033[1m"
)

func returnCMD(exe string, arg ...string) string {
	cmd := exec.Command(exe, arg...)

	// 获取命令的输出
	output, _ := cmd.Output()

	return strings.TrimSpace(string(output))
}

func CmdParams(flags string) []string {
	ldflags := fmt.Sprintf("-ldflags=%s", flags)
	if conf.Build.IsMode {
		return []string{"build", "-buildmode=c-shared", ldflags, "-trimpath", "-v", "-x", "-o", conf.Other.File, "."}
	}
	return []string{"build", ldflags, "-trimpath", "-v", "-x", "-o", conf.Other.File, "."}
}

func Command(exe string, arg ...string) {
	cmd := exec.Command(exe, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic(err.Error())
	}
}

func ExecCmd() {
	var params = CmdParams(`-s -w`)
	if conf.Build.IsGUI && conf.Env.GOOS == "windows" {
		params = CmdParams(`-s -w -H windowsgui`)
	}
	Command("go", params...)

	if !conf.Build.IsUPX || runtime.GOOS != "windows" {
		return
	}

	Command(conf.Other.UPX, "--ultra-brute", "--best", "--lzma", "--brute", "--compress-exports=1", "--no-mode", "--no-owner", "--no-time", "--force", conf.Other.File)
}

func platformExt() {
	ext := map[bool]map[string]string{
		true: {
			"windows": "dll",
			"darwin":  "dylib",
		},
		false: {
			"windows": "exe",
			"android": "apk",
		},
	}

	if _ext, ok := ext[conf.Build.IsMode][conf.Env.GOOS]; ok {
		conf.Other.Ext = _ext
	} else {
		if conf.Build.IsMode {
			conf.Other.Ext = "so"
		}
	}
}

// IncrementVersion 递增版本号，逢十进一
func IncrementVersion() {
	var version []string
	num := len(conf.Build.Version) - 1
	for i := num; i >= 0; i-- {
		// 递增当前位
		conf.Build.Version[i]++

		// 如果当前位为 10，重置为 0，并继续向前一位进位
		if conf.Build.Version[i] == 10 {
			// 如果已经到了最左边的数字，不需要继续进位，直接结束
			if i == 0 {
				break
			}
			conf.Build.Version[i] = 0
		} else {
			// 如果没有进位，直接结束
			break
		}
	}

	// 将版本号转换为字符串
	for _, v := range conf.Build.Version {
		version = append(version, strconv.Itoa(v))
	}

	_version := fmt.Sprintf("v%s", strings.Join(version, "."))
	filename := []string{conf.Build.Name}
	if conf.Build.IsPlat {
		filename = append(filename, conf.Env.GOOS)
	}
	if conf.Build.IsArch {
		filename = append(filename, conf.Env.GOARCH)
	}
	if conf.Build.IsVer {
		filename = append(filename, _version)
	}

	_filename := strings.Join(filename, "-")
	conf.Other.File = fmt.Sprintf("%s.%s", _filename, conf.Other.Ext)
}

func flagUsage() {
	flag.Usage = func() {
		_, _ = fmt.Fprintf(os.Stdout, "%s🧱 程序使用帮助文档 🛠️%s：\n", colorBold+colorGreen, colorReset)
		_, _ = fmt.Fprintf(os.Stdout, "%s用法: %s%s [选项]%s\n", colorCyan, colorReset, filepath.Base(os.Args[0]), colorReset)
		_, _ = fmt.Fprintf(os.Stdout, "%s选项说明：%s\n", colorYellow, colorReset)
		flag.VisitAll(func(f *flag.Flag) {
			_, _ = fmt.Fprintf(os.Stdout, "  %s-%-8s%s %s (当前值: %s%q%s)\n", colorCyan, f.Name, colorReset, f.Usage, colorGreen, f.DefValue, colorReset)
		})
		_, _ = fmt.Fprintf(os.Stdout, "\n%sTips：使用 -help 查看帮助，或直接运行以使用默认参数。%s\n", colorYellow, colorReset)
	}
}
