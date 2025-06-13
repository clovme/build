package middleware

import (
	"{{ .ProjectName }}/pkg/logger/http_log"
	"time"

	"github.com/gin-gonic/gin"
)

// LogMiddleware 请求日志中间件
// LogMiddleware 请求日志中间件
func LogMiddleware(threshold time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now() // ⚠️ 注意：放在 c.Next() 之前

		c.Next() // 执行其他 handler

		duration := time.Since(start)
		status := c.Writer.Status()

		if len(c.Errors) > 0 {
			http_log.Error(c).Dur("latency", duration).Msg("请求异常")
		} else if status >= 500 {
			http_log.Error(c).Dur("latency", duration).Msg("服务器内部错误")
		} else if duration > threshold {
			http_log.Warn(c).Dur("latency", duration).Msg("慢请求")
		} else {
			http_log.Log(c).Dur("latency", duration).Msg("请求成功")
		}
	}
}
