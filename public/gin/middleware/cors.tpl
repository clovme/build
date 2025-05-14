package middleware

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

// CorsMiddleware CORS 中间件
func CorsMiddleware(allowedOrigins []string) gin.HandlerFunc {
	return func(c *gin.Context) {
		origin := c.Request.Header.Get("Origin")

		// 判断当前请求的 Origin 是否在允许的白名单内
		isAllowed := false
		for _, o := range allowedOrigins {
			if o == origin {
				isAllowed = true
				break
			}
		}

		// 如果在白名单内，设置 CORS 响应头
		if isAllowed {
			c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
			c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
			c.Writer.Header().Set("Access-Control-Allow-Headers", "Authorization, Origin, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token")
			c.Writer.Header().Set("Access-Control-Allow-Credentials", "true") // 如果需要带 cookie 或 token，就打开这行
		}

		// 预检请求，直接 200 返回
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusOK)
			return
		}

		c.Next()
	}
}
