package initialize

import (
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/logger"
)

func InitLogger(cfg config.Logger) {
	// 初始化一次
	logger.InitLogger(logger.LoggerConfig{
		Dir:        cfg.Logs,
		MaxSize:    cfg.MaxSize,
		MaxBackups: cfg.MaxBackups,
		MaxAge:     cfg.MaxAge,
		Compress:   cfg.Compress,
		Level:      cfg.Level,
		FormatJSON: cfg.FormatJSON, // true=结构化；false=文本
	})
}
