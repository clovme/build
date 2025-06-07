package middleware

import (
	"{{ .ProjectName }}/pkg/enums/enum_code"
	"{{ .ProjectName }}/pkg/log/http_log"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
)

// RecoveryMiddleware panic 捕捉中间件
func RecoveryMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.IsAborted() {
			c.Abort()
			return
		}
		defer func() {
			if err := recover(); err != nil {
				// 此处可按需要修改
				// 记录日志也行，或者发钉钉告警啥的
				// log err
				resp.JsonSafeCode(c, enum_code.ErrInternal, "服务器开小差了，请稍后再试！", nil)
				http_log.Trace(c).Msg("捕捉到 panic")
				c.AbortWithStatus(500)
			}
		}()
		c.Next()
	}
}
