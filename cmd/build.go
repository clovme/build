package cmd

import (
	"buildx/global"
	"buildx/global/config"
	"buildx/libs"
	"buildx/public"
	"bytes"
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"strings"
	"text/template"
)

// 构建编译参数
func buildParams(IsMode bool, flags, output string) []string {
	ldflags := fmt.Sprintf("-ldflags=%s", flags)
	if IsMode {
		return []string{"build", "-buildmode=c-shared", ldflags, "-trimpath", "-v", "-x", "-o", output, "."}
	}
	return []string{"build", ldflags, "-trimpath", "-v", "-x", "-o", output, "."}
}

// 执行编译命令
func buildSource(output string) {
	var params = buildParams(cfg.Build.IsMode, `-s -w`, output)
	if cfg.Build.IsGUI && cfg.Env.GOOS == "windows" {
		params = buildParams(cfg.Build.IsMode, `-s -w -H windowsgui`, output)
	}
	libs.Command("go", params...)

	if !cfg.Build.IsUPX || cfg.Env.GOOS != "windows" || (cfg.Env.GOARCH != "amd64" && cfg.Env.GOARCH != "386") {
		// 不支持 UPX 或者不是 Windows 或者架构不对，跳过压缩
		return
	}

	libs.Command(cfg.Other.UPX, "--ultra-brute", "--best", "--lzma", "--brute", "--compress-exports=1", "--no-mode", "--no-owner", "--no-time", "--force", output)
}

// 递增版本号，逢十进一
func incrementVersion() {
	var version []string
	num := len(cfg.Build.Version) - 1
	for i := num; i >= 0; i-- {
		// 递增当前位
		cfg.Build.Version[i]++

		// 如果当前位为 10，重置为 0，并继续向前一位进位
		if cfg.Build.Version[i] == 10 {
			// 如果已经到了最左边的数字，不需要继续进位，直接结束
			if i == 0 {
				break
			}
			cfg.Build.Version[i] = 0
		} else {
			// 如果没有进位，直接结束
			break
		}
	}

	// 将版本号转换为字符串
	for _, v := range cfg.Build.Version {
		version = append(version, strconv.Itoa(v))
	}

	cfg.Other.Version = fmt.Sprintf("v%s", strings.Join(version, "."))
}

// 是否编译所有平台
func buildIsAllOrFilename(isDefault bool) {
	if isDefault {
		cfg.Build.Arch = []string{"amd64", "arm64"}
		cfg.Build.Plat = []string{"windows", "linux", "darwin"}
	} else {
		cfg.Build.Arch = []string{cfg.Env.GOARCH}
		cfg.Build.Plat = []string{cfg.Env.GOOS}
	}

	// 如果没有文件名，使用当前go.mod的模块名，其次使用目录名
	if cfg.FileName.Name == "" {
		file, err := os.ReadFile("go.mod")
		if err != nil {
			dir, _ := os.Getwd()
			cfg.FileName.Name = filepath.Base(dir)
		} else {
			module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
			cfg.FileName.Name = strings.TrimSpace(module[len(module)-1])
		}
	}

	// 配置文件名
	ext := filepath.Ext(cfg.FileName.Name)
	cfg.FileName.Name = cfg.FileName.Name[:len(cfg.FileName.Name)-len(ext)]
}

// 获取平台后缀名
func platformExt(plat string) string {
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

	if _ext, ok := ext[cfg.Build.IsMode][plat]; ok {
		return _ext
	} else {
		if cfg.Build.IsMode {
			return ".so"
		}
		return ""
	}
}

// 生成文件名
func getFilename(ext string) string {
	filename := []string{cfg.FileName.Name}
	if cfg.FileName.IsPlat {
		filename = append(filename, cfg.Env.GOOS)
	}
	if cfg.FileName.IsArch {
		filename = append(filename, cfg.Env.GOARCH)
	}
	if cfg.FileName.IsVer {
		filename = append(filename, cfg.Other.Version)
	}

	_filename := strings.Join(filename, "-")
	return fmt.Sprintf("%s%s", _filename, ext)
}

// 解压临时文件
func unEmbedTempFile() {
	cfg.Other.Temp = filepath.Join(os.TempDir(), "~go-build-tmp")
	if !libs.IsDirExist(cfg.Other.Temp) {
		_ = os.MkdirAll(cfg.Other.Temp, os.ModePerm)
	}
	cfg.Other.UPX = filepath.Join(cfg.Other.Temp, "upx.exe")
	ePath := fmt.Sprintf("public/%s", strings.ToLower(runtime.GOOS))
	fileInfos, _ := public.Build.ReadDir(ePath)
	for _, fileInfo := range fileInfos {
		file, _ := public.Build.ReadFile(fmt.Sprintf("%s/%s", ePath, fileInfo.Name()))
		filePath := filepath.Join(cfg.Other.Temp, fileInfo.Name())
		if !libs.IsFileExist(filePath) {
			_ = os.WriteFile(filePath, file, os.ModePerm)
		}
	}
}

func genBuildTemp() string {
	tmpl, _ := template.New("buildTemp").Parse(`🛠️ Go 编译命令行工具

⚙️ 快速上手：
$ {{ .Name }} build	# 执行 Go 编译`)
	var buf bytes.Buffer
	_ = tmpl.Execute(&buf, map[string]string{"Name": global.ExeFileName})
	return buf.String()
}

var buildCmd = &cobra.Command{
	Use:   "build",
	Short: "Go 编译命令行工具",
	Long:  genBuildTemp(),
	Run: func(cmd *cobra.Command, args []string) {
		unEmbedTempFile()
		// 解压临时文件
		incrementVersion()
		// --all
		buildIsAllOrFilename(libs.GetBool(cmd, "all"))

		if !libs.IsDirExist(cmd.Use) {
			_ = os.Mkdir(cmd.Use, os.ModePerm)
		}

		// 配置编译环境，文件名
		oldArch := cfg.Env.GOARCH
		oldPlatform := cfg.Env.GOOS
		for _, plat := range cfg.Build.Plat {
			cfg.Env.GOOS = plat
			_ = os.Setenv("GOOS", plat)
			// 平台后缀
			fileExt := platformExt(plat)
			fmt.Printf("开始编译 %s 平台\n", plat)
			fmt.Printf("Go版本: %s\n", cfg.Other.GoVersion)

			for _, arch := range cfg.Build.Arch {
				cfg.Env.GOARCH = arch
				_ = os.Setenv("GOARCH", arch)
				fmt.Printf("编译架构 %s\n", cfg.Env.GOARCH)
				// 生成文件名
				filename := getFilename(fileExt)
				if !strings.Contains(cfg.FileName.Name, "/") || !strings.Contains(cfg.FileName.Name, "\\") {
					filename = filepath.Join(cmd.Use, getFilename(fileExt))
				}
				fmt.Printf("输出文件 %s\n", filename)

				// 执行命令
				buildSource(filename)
			}
		}
		cfg.Env.GOARCH = oldArch
		cfg.Env.GOOS = oldPlatform

		config.SaveConfig()
	},
}

func init() {
	// Go 编译环境变量
	buildCmd.Flags().StringP("GOOS", "o", cfg.Env.GOOS, "Go编译平台")
	buildCmd.Flags().StringP("GOARCH", "r", cfg.Env.GOARCH, "Go编译架构")

	// 文件名配置
	buildCmd.Flags().StringP("filename", "f", cfg.FileName.Name, "文件名，不包含扩展名")
	buildCmd.Flags().BoolP("plat", "p", cfg.FileName.IsPlat, "文件名是否台添加编译平台名称")
	buildCmd.Flags().BoolP("arch", "d", cfg.FileName.IsArch, "文件名是否台添加架构名称")
	buildCmd.Flags().BoolP("version", "v", cfg.FileName.IsVer, "文件名是否添加版本号")

	// build 编译配置
	buildCmd.Flags().BoolP("generate", "e", cfg.Build.IsGen, "编译前是否执行go generate命令")
	buildCmd.Flags().BoolP("gui", "g", cfg.Build.IsGUI, "是否编译GUI程序")
	buildCmd.Flags().BoolP("all", "a", cfg.Build.IsAll, "编译三大平台(linux、windows、darwin)")
	buildCmd.Flags().BoolP("upx", "u", cfg.Build.IsUPX, "是否启用UPX压缩")
	buildCmd.Flags().BoolP("mode", "m", cfg.Build.IsMode, "是否编译为动态链接库")

	buildCmd.Flags().BoolP("comment", "c", false, "是否开启配置文件注释")

	buildCmd.PreRun = func(cmd *cobra.Command, args []string) {
		// Go 编译环境变量
		cfg.Env.GOOS = libs.GetString(cmd, "GOOS")
		cfg.Env.GOARCH = libs.GetString(cmd, "GOARCH")

		// 文件名配置
		cfg.FileName.Name = libs.GetString(cmd, "filename")
		cfg.FileName.IsPlat = libs.GetBool(cmd, "plat")
		cfg.FileName.IsArch = libs.GetBool(cmd, "arch")
		cfg.FileName.IsVer = libs.GetBool(cmd, "version")

		// generate 编译配置
		cfg.Build.IsGen = libs.GetBool(cmd, "generate")
		cfg.Build.IsGUI = libs.GetBool(cmd, "gui")
		cfg.Build.IsAll = libs.GetBool(cmd, "all")
		cfg.Build.IsUPX = libs.GetBool(cmd, "upx")
		cfg.Build.IsMode = libs.GetBool(cmd, "mode")

		cfg.Other.IsComment = libs.GetBool(cmd, "comment")
	}
}
