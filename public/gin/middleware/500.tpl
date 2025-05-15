package middleware

import (
	"{{ .ProjectName }}/constant"
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

// RecoveryMiddleware 自定义 Panic 恢复中间件
func RecoveryMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				// 此处可按需要修改
				if strings.HasPrefix(c.Request.URL.Path, "/api/") {
					// 记录日志也行，或者发钉钉告警啥的
					c.JSON(http.StatusInternalServerError, gin.H{
						"code":    500,
						"message": "服务器开小差了，请稍后再试！",
						"error":   err,
					})
				} else {
					c.HTML(http.StatusOK, "error.html", gin.H{
						"Code":        "500!",
						"ProjectName": constant.ProjectName,
						"Content":     "服务器开小差了，请稍后再试！",
					})
				}
				c.Abort()
			}
		}()
		c.Next()
	}
}
