package libs

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"
	"path/filepath"
	"strings"
	"unicode"
)

// GenExeFileName 生成配置文件名
func GenExeFileName() string {
	path := os.Args[0]
	ext := filepath.Ext(path)
	return filepath.Base(path[:len(path)-len(ext)])
}

func GetModuleName() string {
	file, err := os.ReadFile("go.mod")
	if err != nil {
		fmt.Println("获取模块名称失败:", err)
		os.Exit(-1)
	}
	module := strings.Split(strings.Split(string(file), "\n")[0][7:], "/")
	return module[len(module)-1]
}

// IsDirExist 判断文件夹是否存在
func IsDirExist(folderPath string) bool {
	info, err := os.Stat(folderPath)
	if os.IsNotExist(err) {
		return false
	}
	return info.IsDir()
}

// IsFileExist 判断文件是否存在
func IsFileExist(filePath string) bool {
	info, err := os.Stat(filePath)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func GetString(cmd *cobra.Command, name string) string {
	value, _ := cmd.Flags().GetString(name)
	return value
}

func GetBool(cmd *cobra.Command, name string) bool {
	value, _ := cmd.Flags().GetBool(name)
	return value
}

// SetGoEnv 设置GO环境变量
func SetGoEnv() {
	GOBIN := filepath.Join(os.Getenv("GOPATH"), "bin")
	if temp := CmdValue("go", "env", "get", "GOBIN"); temp != "" {
		GOBIN = temp
	}

	PATH := os.Getenv("PATH")
	if !strings.Contains(PATH, GOBIN) {
		_ = os.Setenv("PATH", fmt.Sprintf("%s;%s", GOBIN, PATH))
	}
}

// Capitalize 首字符大写
func Capitalize(s string) string {
	if s == "" {
		return ""
	}
	// 转成 rune 切片，防止中文/多字节字符乱码
	runes := []rune(s)
	runes[0] = unicode.ToUpper(runes[0])
	return string(runes)
}

// IsBoolArrayContains 判断bool数组是否包含true/false
func IsBoolArrayContains(target bool, arr []bool) bool {
	for _, item := range arr {
		if item == target {
			return true
		}
	}
	return false
}

// IsStringArrayContains 判断string数组是否包含true/false
func IsStringArrayContains(target string, arr []string) bool {
	for _, item := range arr {
		if item == target {
			return true
		}
	}
	return false
}
