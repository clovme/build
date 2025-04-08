package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

func returnCMD(exe string, arg ...string) string {
	cmd := exec.Command(exe, arg...)

	// 获取命令的输出
	output, _ := cmd.Output()

	return strings.TrimSpace(string(output))
}

func ExecCmd() {
	goPath := filepath.Join(conf.Env.GOROOT, "bin", "go.exe")
	var cmdParams = []string{"build", "-ldflags", "-s -w", "-trimpath", "-v", "-x", "-o", conf.Other.File, "."}
	if conf.Build.IsGUI {
		cmdParams[2] = "-s -w -H windowsgui"
	}

	cmd := exec.Command(goPath, cmdParams...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic(err)
	}

	if !conf.Build.IsUPX {
		return
	}
	cmd = exec.Command(conf.Other.UPX, "--ultra-brute", "--best", "--lzma", "--brute", "--compress-exports=1", "--no-mode", "--no-owner", "--no-time", "--force", conf.Other.File)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic(err)
	}
}

// IncrementVersion 递增版本号，逢十进一
func IncrementVersion() {
	var version []string
	num := len(conf.Other.Version) - 1
	for i := num; i >= 0; i-- {
		// 递增当前位
		conf.Other.Version[i]++

		// 如果当前位为 10，重置为 0，并继续向前一位进位
		if conf.Other.Version[i] == 10 {
			// 如果已经到了最左边的数字，不需要继续进位，直接结束
			if i == 0 {
				break
			}
			conf.Other.Version[i] = 0
		} else {
			// 如果没有进位，直接结束
			break
		}
	}

	// 将版本号转换为字符串
	for _, v := range conf.Other.Version {
		version = append(version, strconv.Itoa(v))
	}

	_version := fmt.Sprintf("v%s", strings.Join(version, "."))
	filename := []string{conf.Build.Filename}
	if conf.Build.IsPlatform {
		filename = append(filename, conf.Env.GOOS)
	}
	if conf.Build.IsArch {
		filename = append(filename, conf.Env.GOARCH)
	}
	if conf.Build.IsVersion {
		filename = append(filename, _version)
	}

	_filename := strings.Join(filename, "-")
	switch conf.Env.GOOS {
	case "windows":
		conf.Other.File = fmt.Sprintf("%s.exe", _filename)
	case "android":
		conf.Other.File = fmt.Sprintf("%s.apk", _filename)
	default:
		conf.Other.File = fmt.Sprintf("%s", _filename)
	}
}

func flagUsage() {
	flag.Usage = func() {
		_, _ = fmt.Fprintf(os.Stderr, "程序使用帮助文档 🛠️：\n")
		_, _ = fmt.Fprintf(os.Stderr, "用法: %s [选项]\n", filepath.Base(os.Args[0]))
		_, _ = fmt.Fprintf(os.Stderr, "选项说明：\n")
		flag.VisitAll(func(f *flag.Flag) {
			if len(f.Name) <= 3 {
				_, _ = fmt.Fprintf(os.Stderr, "   -%s\t\t%s (当前值: %q)\n", f.Name, f.Usage, f.DefValue)
			} else {
				_, _ = fmt.Fprintf(os.Stderr, "   -%s\t%s (当前值: %q)\n", f.Name, f.Usage, f.DefValue)
			}
		})
	}
}
