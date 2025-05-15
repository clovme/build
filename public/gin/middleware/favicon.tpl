package middleware

import (
	"embed"
	"github.com/gin-gonic/gin"
	"io/fs"
)

// FaviconMiddleware 加载 favicon.ico
func FaviconMiddleware(fsys embed.FS) gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.Request.URL.Path == "/favicon.ico" {
			data, err := fs.ReadFile(fsys, "public/favicon.ico")
			if err != nil {
				c.Status(404)
				return
			}
			c.Data(200, "image/x-icon", data)
			c.Abort()
			return
		}
		c.Next()
	}
}
