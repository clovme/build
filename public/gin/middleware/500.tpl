package middleware

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

// RecoveryMiddleware 自定义 Panic 恢复中间件
func RecoveryMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// 记录日志也行，或者发钉钉告警啥的
				c.JSON(http.StatusInternalServerError, gin.H{
					"code":    500,
					"message": "服务器开小差了，请稍后再试！",
					"error":   err,
				})
				c.Abort()
			}
		}()
		c.Next()
	}
}
