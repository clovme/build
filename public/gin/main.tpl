package main

//
//import (
//	"fmt"
//	"{{ .ProjectName }}/internal/bootstrap"
//	"{{ .ProjectName }}/internal/domain/user"
//	"{{ .ProjectName }}/pkg/config"
//	"{{ .ProjectName }}/pkg/constants"
//	"{{ .ProjectName }}/pkg/global"
//	"{{ .ProjectName }}/public"
//	"github.com/gin-gonic/gin"
//	"gorm.io/driver/sqlite"
//	"gorm.io/gorm"
//	"html/template"
//	"io/fs"
//	"log"
//	"net/http"
//	"path/filepath"
//)
//
//var cfg = config.GetConfig()
//
//func init() {
//	constants.ConfigPath = fmt.Sprintf("%s.ini", global.ProjectName)
//	constants.SQLitePath = filepath.Join(cfg.Other.Data, fmt.Sprintf("%s.db", global.ProjectName))
//}
//
//func main() {
//	config.SaveConfig()
//	db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	// 自动建表
//	db.AutoMigrate(&user.User{})
//
//	// 初始化仓库和服务
//	ctx := bootstrap.NewAppContext(db)
//
//	// 插点数据
//	db.Create(&user.User{Name: "张三", Email: "zhangsan@example.com"})
//	db.Create(&user.User{Name: "李四", Email: "lisi@example.com"})
//
//	r := gin.Default()
//
//	// 配置 HTML 模板
//	tmpl := template.Must(template.New("").ParseFS(public.TemplateFS, "templates/*.html"))
//	r.LoadHTMLGlob("templates/**/*")
//	r.SetHTMLTemplate(tmpl)
//
//	// 配置静态文件
//	staticFS, _ := fs.Sub(public.StaticFS, "assets")
//	r.StaticFS("/assets", http.FS(staticFS))
//
//	// 路由
//	r.GET("/users", ctx.UserHandler.ListUsers)
//	r.GET("/users/disable", ctx.UserHandler.DisableAllUsers)
//
//	r.Run(":8080")
//}
