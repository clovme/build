package middleware

import (
	"{{ .ProjectName }}/libs"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// DBMiddleware 将数据库连接添加到上下文中
func DBMiddleware(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set("$", libs.HttpResponse{DB: db, Context: c})
		c.Next()
	}
}
