package main

import (
	"bytes"
	"flag"
	"fmt"
	"github.com/go-ini/ini"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
	"unicode"
)

// ANSI 彩色代码
const (
	colorReset  = "\033[0m"
	colorCyan   = "\033[36m"
	colorYellow = "\033[33m"
	colorGreen  = "\033[32m"
	colorBold   = "\033[1m"
)

// CmdValue 执行命令并获取输出
func CmdValue(exe string, arg ...string) string {
	cmd := exec.Command(exe, arg...)

	// 获取命令的输出
	output, _ := cmd.Output()

	return strings.TrimSpace(string(output))
}

// CmdParams 构建命令参数
func CmdParams(flags, output string) []string {
	ldflags := fmt.Sprintf("-ldflags=%s", flags)
	if conf.Build.IsMode {
		return []string{"build", "-buildmode=c-shared", ldflags, "-trimpath", "-v", "-x", "-o", output, "."}
	}
	return []string{"build", ldflags, "-trimpath", "-v", "-x", "-o", output, "."}
}

// Command 执行控制台输出命令
func Command(exe string, arg ...string) {
	cmd := exec.Command(exe, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic("命令执行失败！")
	}
}

// ExecCmd 执行编译命令
func ExecCmd(output string) {
	var params = CmdParams(`-s -w`, output)
	if conf.Build.IsGUI && conf.Env.GOOS == "windows" {
		params = CmdParams(`-s -w -H windowsgui`, output)
	}
	Command("go", params...)

	if !conf.Build.IsUPX || runtime.GOOS != "windows" {
		return
	}

	Command(conf.Other.UPX, "--ultra-brute", "--best", "--lzma", "--brute", "--compress-exports=1", "--no-mode", "--no-owner", "--no-time", "--force", output)
}

// PlatformExt 获取平台后缀名
func PlatformExt(plat string) string {
	ext := map[bool]map[string]string{
		true: {
			"windows": ".dll",
			"darwin":  ".dylib",
		},
		false: {
			"js":      ".wasm",
			"windows": ".exe",
			"android": ".apk",
		},
	}

	if _ext, ok := ext[conf.Build.IsMode][plat]; ok {
		return _ext
	} else {
		if conf.Build.IsMode {
			return ".so"
		}
		return ""
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

	conf.Other.Version = fmt.Sprintf("v%s", strings.Join(version, "."))
}

// GenFilename 生成文件名
func GenFilename(ext string) string {
	filename := []string{conf.FileName.Name}
	if conf.FileName.IsPlat || *ac.IsAll {
		filename = append(filename, conf.Env.GOOS)
	}
	if conf.FileName.IsArch || *ac.IsAll {
		filename = append(filename, conf.Env.GOARCH)
	}
	if conf.FileName.IsVer {
		filename = append(filename, conf.Other.Version)
	}

	_filename := strings.Join(filename, "-")
	return fmt.Sprintf("%s%s", _filename, ext)
}

// flagUsage 自定义帮助文档
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

// SaveConfig 保存配置文件
func SaveConfig() {
	// true 配置文件改变
	if !conf.Other.Change && CheckDirExist(buildCfg) {
		return
	}
	f := ini.Empty()
	if err := f.ReflectFrom(conf); err != nil {
		panic("配置文件解析失败！")
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

	if err := f.SaveTo(buildCfg); err != nil {
		panic("配置文件保存失败！")
	}

	var buf bytes.Buffer
	buf.WriteString("; go install github.com/clovme/build@latest\n\n")

	_, _ = f.WriteTo(&buf) // 把 ini 配置写进去

	_ = os.WriteFile(buildCfg, buf.Bytes(), 0644)
}

// ExecSourceBuild 执行源码编译
func ExecSourceBuild() {
	oldArch := conf.Env.GOARCH
	oldPlatform := conf.Env.GOOS
	for _, plat := range conf.Build.Plat {
		conf.Env.GOOS = plat
		_ = os.Setenv("GOOS", plat)
		// 平台后缀
		fileExt := PlatformExt(plat)
		fmt.Printf("开始编译 %s 平台\n", plat)
		fmt.Printf("Go版本: %s\n", conf.Other.GoVersion)

		for _, arch := range conf.Build.Arch {
			conf.Env.GOARCH = arch
			_ = os.Setenv("GOARCH", arch)
			fmt.Printf("编译架构 %s\n", conf.Env.GOARCH)
			// 生成文件名
			filename := GenFilename(fileExt)
			fmt.Printf("输出文件 %s\n", filename)

			// 执行命令
			ExecCmd(filename)
		}
	}
	conf.Env.GOARCH = oldArch
	conf.Env.GOOS = oldPlatform
}

// CheckDirExist 判断文件夹是否存在
func CheckDirExist(folderPath string) bool {
	if _, err := os.Stat(folderPath); os.IsNotExist(err) {
		// 文件夹不存在
		return false
	}
	// 文件夹存在
	return true
}

// UnEmbedTempFile 解压临时文件
func UnEmbedTempFile() {
	conf.Other.Temp = filepath.Join(os.TempDir(), "~gobuild-tmp")
	if !CheckDirExist(conf.Other.Temp) {
		_ = os.MkdirAll(conf.Other.Temp, os.ModePerm)
	}
	conf.Other.UPX = filepath.Join(conf.Other.Temp, "upx.exe")
	ePath := fmt.Sprintf("public/%s", strings.ToLower(runtime.GOOS))
	fileInfos, _ := ePublic.ReadDir(ePath)
	for _, fileInfo := range fileInfos {
		file, _ := ePublic.ReadFile(fmt.Sprintf("%s/%s", ePath, fileInfo.Name()))
		_ = os.WriteFile(filepath.Join(conf.Other.Temp, fileInfo.Name()), file, os.ModePerm)
	}
}

// GenConfigFileName 生成配置文件名
func GenConfigFileName() {
	path := os.Args[0]
	ext := filepath.Ext(path)
	buildCfg = filepath.Base(path[:len(path)-len(ext)])
}

// FirstUpper 首字母大写
func FirstUpper(s string) string {
	if len(s) == 0 {
		return ""
	}
	runes := []rune(s)
	runes[0] = unicode.ToUpper(runes[0])
	return string(runes)
}
