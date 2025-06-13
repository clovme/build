package utils

import (
	"os"
	"unicode"
)

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
