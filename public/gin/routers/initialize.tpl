package routers

import (
	"embed"
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/middleware"
	"github.com/Masterminds/sprig/v3"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"html/template"
	"io/fs"
	"net/http"
	"strings"
)

// registerNoRoute 注册404处理
func registerNoRoute(engine *gin.Engine) {

	engine.NoRoute(func(c *gin.Context) {
		// 此处可按需要修改
		if strings.HasPrefix(c.Request.URL.Path, "/api/") {
			c.JSON(http.StatusNotFound, gin.H{
				"message": "请输入正确的请求地址!",
			})
		} else {
			c.HTML(http.StatusOK, "error.html", gin.H{
				"Code":        "404!",
				"ProjectName": constant.ProjectName,
				"Content":     "请输入正确的请求地址!",
			})
		}
	})
}

func Initialization(engine *gin.Engine, db *gorm.DB, fsys embed.FS) {
	engine.Use(
		middleware.DBMiddleware(db),
		middleware.FaviconMiddleware(fsys),
		middleware.CorsMiddleware([]string{"127.0.0.1:8080", "localhost:8080"}),
		middleware.RecoveryMiddleware(),
	)

	// 加载嵌入的模板文件
	tmpl := template.Must(
		template.New("template").Funcs(sprig.FuncMap()).ParseFS(fsys, "public/template/*.html"))
	engine.SetHTMLTemplate(tmpl)

	// 提供嵌入的静态文件
	staticFS, _ := fs.Sub(fsys, "public/assets")
	engine.StaticFS("/assets", http.FS(staticFS))

	routers := routeGroup{
		admin:  engine.Group("/api"),
		noAuth: engine.Group("/api", middleware.NoAuthMiddleware()),
		public: engine.Group("/api"),
		views:  engine.Group(""),
	}

	routers.register()

	// 注册404处理
	registerNoRoute(engine)
}
