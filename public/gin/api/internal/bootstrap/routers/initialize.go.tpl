package routers

import (
	"{{ .ProjectName }}/internal/bootstrap/middleware"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"html/template"
	"io/fs"
	"net/http"
	"time"
)

func Initialization(db *gorm.DB) *gin.Engine {
	engine := gin.New()
	engine.Use(
		middleware.RecoveryMiddleware(),                                         // 抓捕 panic，防止服务崩溃
		middleware.LogMiddleware(2*time.Second),                                 // 请求日志，记录全流程
		middleware.CorsMiddleware([]string{"127.0.0.1:8080", "localhost:8080"}), // 跨域，处理请求头
		middleware.FaviconMiddleware(),                                          // 小图标资源，最靠后
		middleware.EncryptResponse(),                                            // 响应加密，最后处理输出
	)

	// 加载嵌入的模板文件
	tmpl := template.Must(template.New("template").Delims("[{", "}]").ParseFS(public.TemplateFS, "web/templates/*.html"))
	engine.SetHTMLTemplate(tmpl)

	// 提供嵌入的静态文件
	staticFS, _ := fs.Sub(public.StaticFS, "web/assets")
	engine.StaticFS("/assets", http.FS(staticFS))
	imagesFS, _ := fs.Sub(public.ImagesFS, "web/images")
	engine.StaticFS("/imgs", http.FS(imagesFS))

	routers := routeGroup{
		public:     engine.Group("/api"),
		noAuth:     engine.Group("/api", middleware.NoAuthMiddleware()),
		noAuthView: engine.Group("/", middleware.NoAuthMiddleware()),
	}

	routers.register(db)

	// 注册404处理
	middleware.RegisterNoRoute(engine)

	return engine
}
