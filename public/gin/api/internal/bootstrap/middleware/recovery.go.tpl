package middleware

import (
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/logger/http_log"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
)

// RecoveryMiddleware panic 捕捉中间件
func RecoveryMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// 记录 panic 错误，附带 stack trace
				http_log.Error(c).Interface("panic", err).Msg("捕捉到 panic 异常")

				// 可扩展：钉钉/飞书/邮件/Prometheus 警报等
				// sendDingTalkAlert(err)

				// 返回统一 JSON 响应
				resp.JsonSafeCode(c, em_http.ErrInternal, "服务器开小差了，请稍后再试！", nil)

				// 强制中断后续
				c.AbortWithStatus(500)
			}
		}()
		c.Next()
	}
}
