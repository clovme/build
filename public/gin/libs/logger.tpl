package libs

import (
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/libs/exists"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm/logger"
	"io"
	"log"
	"os"
	"path/filepath"
	"time"
)

// 私有变量
var (
	gormLogger logger.Interface
	logFile    = make(map[string]*os.File)
)

// InitAllLogger 初始化所有日志，统一管理
func InitAllLogger() (err error) {
	if !exists.IsExists(constant.LogsPath) {
		_ = os.Mkdir(constant.LogsPath, os.ModePerm)
	}

	// Gin 访问日志/错误日志/Gorm 日志/自定义应用日志
	for _, name := range []string{"access.log", "error.log", "gorm.log", "app.log"} {
		file, err := os.OpenFile(filepath.Join(constant.LogsPath, name), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			return err
		}
		logFile[name] = file
	}

	// Gin 日志配置
	gin.DefaultWriter = io.MultiWriter(logFile["access.log"], os.Stdout)
	gin.DefaultErrorWriter = io.MultiWriter(logFile["error.log"], os.Stderr)

	// 标准库 log 配置
	log.SetOutput(io.MultiWriter(logFile["app.log"], os.Stdout))

	// Gorm 日志配置
	gormLogger = logger.New(
		log.New(io.MultiWriter(logFile["gorm.log"], os.Stdout), "\r\n", log.LstdFlags),
		logger.Config{
			SlowThreshold:             time.Second, // 超过 1s 算慢查询
			LogLevel:                  logger.Info, // 打开所有日志
			IgnoreRecordNotFoundError: false,       // 不忽略 ErrRecordNotFound 错误
			Colorful:                  false,       // 彩色输出
		},
	)

	return nil
}

// GetGormLogger 获取 Gorm Logger 实例
func GetGormLogger() logger.Interface {
	return gormLogger
}

// CloseAllLogger 关闭所有日志文件
func CloseAllLogger() {
	for _, file := range logFile {
		if file != nil {
			_ = file.Close()
		}
	}
}
