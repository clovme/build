package initweb

import (
	"errors"
	"fmt"
	"{{ .ProjectName }}/internal/bootstrap/middleware"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
	"html/template"
	"io/fs"
	"net/http"
)

func initWebServer() {
	gin.SetMode(gin.DebugMode)

	engine := gin.Default()

	engine.Use(middleware.CorsMiddleware([]string{"*"}))
	engine.Use(middleware.FaviconMiddleware())

	// 加载嵌入模板
	tmpl := template.Must(template.New("template").Delims("[{", "}]").ParseFS(public.InitiateFS, "initweb/*.html"))
	engine.SetHTMLTemplate(tmpl)

	staticFS, _ := fs.Sub(public.InitiateFS, "initweb/assets")
	engine.StaticFS("/assets", http.FS(staticFS))

	engine.GET("/", viewHandler)
	engine.GET("/initialize", formHandler)
	engine.POST("/initialize", postHandler)

	engine.NoRoute(func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "/")
		c.Abort()
	})

	server = &http.Server{
		Addr:    ":8080",
		Handler: engine,
	}

	fmt.Println("初始化服务启动完成，访问 http://localhost:8080 初始化配置")
	defer wg.Done() // 协程结束时 -1

	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("初始化服务异常退出: %v\n", err)
	}
}
