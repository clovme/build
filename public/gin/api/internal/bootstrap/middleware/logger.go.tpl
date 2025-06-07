package middleware

import (
	"{{ .ProjectName }}/pkg/log/http_log"
	"time"

	"github.com/gin-gonic/gin"
)

// LogMiddleware 请求日志中间件
func LogMiddleware(threshold time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
		if c.IsAborted() {
			c.Abort()
			return
		}
		start := time.Now()

		duration := time.Since(start)
		status := c.Writer.Status()

		if len(c.Errors) > 0 {
			http_log.Error(c).Msg("请求日志中间件")
		} else if status >= 500 {
			http_log.Error(c).Msg("请求日志中间件")
		} else if duration > threshold {
			http_log.Warn(c).Dur("latency", duration)
		} else {
			http_log.Info(c).Msg("请求日志中间件")
		}
	}
}
