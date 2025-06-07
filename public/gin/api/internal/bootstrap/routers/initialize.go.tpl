package routers

import (
	"{{ .ProjectName }}/internal/bootstrap/middleware"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"io/fs"
	"net/http"
	"time"
)

func Initialization(engine *gin.Engine, db *gorm.DB) {
	engine.Use(
		middleware.RecoveryMiddleware(),
		middleware.LogMiddleware(2*time.Second),
		//middleware.DecryptRequest(),
		//middleware.DBMiddleware(db),
		middleware.CorsMiddleware([]string{"127.0.0.1:8080", "localhost:8080"}),
		//middleware.RecoveryMiddleware(),
		middleware.FaviconMiddleware(),
		middleware.EncryptResponse(),
	)

	// 加载嵌入的模板文件
	//tmpl := template.Must(template.New("template").Funcs(sprig.FuncMap()).ParseFS(public.TemplateFS, "ui/templates/*.html"))
	//engine.SetHTMLTemplate(tmpl)

	// 提供嵌入的静态文件
	staticFS, _ := fs.Sub(public.StaticFS, "ui/assets")
	engine.StaticFS("/assets", http.FS(staticFS))

	routers := routeGroup{
		public: engine.Group("/api"),
		noAuth: engine.Group("/api", middleware.NoAuthMiddleware()),
	}

	routers.register(db)

	// 注册404处理
	middleware.RegisterNoRoute(engine)
}
