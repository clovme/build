package libs

import (
	"crypto/md5"
	"encoding/hex"
	"log"
	"os"
)

// CreateDir 创建多级文件夹的函数
func CreateDir(folderPath string) {
	// 检查文件夹是否存在
	if _, err := os.Stat(folderPath); os.IsNotExist(err) {
		// 文件夹不存在，创建多级文件夹
		err = os.MkdirAll(folderPath, os.ModePerm)
		if err != nil {
			log.Fatalf("创建文件夹失败: %v\n", err)
		} else {
			log.Printf("文件夹 '%s' 创建成功。", folderPath)
		}
	} else if err != nil {
		// 处理其他可能的错误
		log.Fatalf("检查文件夹失败: %v\n", err)
	}
}

func MD5(str string) string {
	// 计算MD5哈希值
	hash := md5.Sum([]byte(str))

	// 将哈希值转换为十六进制字符串
	return hex.EncodeToString(hash[:])
}

func ArrContains(target string, arr []string) bool {
	for _, item := range arr {
		if item == target {
			return true
		}
	}
	return false
}
