package middleware

import (
	"github.com/gin-gonic/gin"
)

// NoAuthMiddleware 无权限中间件(登录后不允许访问)
func NoAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next() // Process request

		//c.JSON(http.StatusNotFound, gin.H{
		//	"message": "你!",
		//})
		//c.Abort()
	}
}
