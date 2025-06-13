package middleware

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

// CorsMiddleware 创建一个 CORS（跨域资源共享）中间件处理器。
// 该中间件允许来自指定源的请求访问服务器资源。
//
// 参数:
// allowedOrigins - 字符串切片，代表允许的源地址列表。
//
//	支持通配符模式，如 "*.example.com"。
//
// 返回值:
// 一个 Gin 处理函数，可作为中间件使用。
func CorsMiddleware(allowedOrigins []string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// 从请求头中获取请求的源地址
		origin := c.Request.Header.Get("Origin")

		// 标记请求源地址是否被允许
		isAllowed := false
		// 遍历允许的源地址列表
		for _, o := range allowedOrigins {
			// 检查请求源地址是否与允许的源地址完全匹配
			// 或者是否匹配通配符模式（例如 "*.example.com"）
			if o == origin || (strings.HasPrefix(o, "*.") && strings.HasSuffix(origin, o[1:])) || o == "*" {
				isAllowed = true
				break
			}
		}

		// 如果请求源地址被允许，则设置相应的 CORS 响应头
		if isAllowed {
			// 设置允许访问的源地址为请求的源地址
			c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
			// 设置允许的 HTTP 请求方法
			c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
			// 设置允许的 HTTP 请求头
			c.Writer.Header().Set("Access-Control-Allow-Headers", "Authorization, Browser-Type, Origin, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Accept, X-Requested-With")
			// 允许请求携带凭证（如 Cookie、HTTP 认证信息等）
			c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
			// 设置浏览器可以缓存预检请求响应的最长时间（秒）
			c.Writer.Header().Set("Access-Control-Max-Age", "3600")
		}

		// 如果请求方法为 OPTIONS（预检请求）
		// 则返回 204 No Content 状态码，并终止后续的请求处理链
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
			return
		}

		// 继续执行后续的处理函数
		c.Next()
	}
}
