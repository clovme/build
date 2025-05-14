package libs

import (
	"crypto/md5"
	"encoding/hex"
	"os"
)

func MD5(str string) string {
	// 计算MD5哈希值
	hash := md5.Sum([]byte(str))

	// 将哈希值转换为十六进制字符串
	return hex.EncodeToString(hash[:])
}

func Exists(path string) bool {
	_, err := os.Stat(path)
	return !os.IsNotExist(err)
}