package main

import (
	"errors"
	"fmt"
	"{{ .ProjectName }}/internal/bootstrap/database"
	"{{ .ProjectName }}/internal/bootstrap/routers"
	"{{ .ProjectName }}/internal/domain/auth/do_permission"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/crypto"
	"{{ .ProjectName }}/pkg/log"
	"{{ .ProjectName }}/pkg/log/app_log"
	"{{ .ProjectName }}/pkg/utils"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"path/filepath"
	"strings"
	"time"
)

var cfg *config.Config

func init() {
	time.Local = time.UTC
	cfg = config.GetConfig()

	// 初始化一次
	log.InitLogger(log.LoggerConfig{
		Dir:        cfg.Logger.Logs,
		MaxSize:    cfg.Logger.MaxSize,
		MaxBackups: cfg.Logger.MaxBackups,
		MaxAge:     cfg.Logger.MaxAge,
		Compress:   cfg.Logger.Compress,
		Level:      cfg.Logger.Level,
		FormatJSON: cfg.Logger.FormatJSON, // true=结构化；false=文本
	})

	gin.SetMode(cfg.Web.Mode)

	utils.InitSnowflake(1)
	if err := crypto.ParseRsaKeys(public.PublicPEM, public.PrivatePEM); err != nil {
		fmt.Println("密钥初始化失败：", err)
		return
	}
	constants.SQLitePath = filepath.Join(cfg.Other.Data, fmt.Sprintf("%s.db", constants.ProjectName))
}

func main() {
	config.SaveConfig()

	db := database.OpenConnectDB(*cfg)

	r := gin.New()
	routers.Initialization(r, db)

	if err := database.AutoMigrate(db, query.Q); err != nil {
		app_log.Error().Err(err).Msg("[初始化]数据库迁移失败！")
		return
	}

	database.InitializeConfig(query.Q)

	p := query.Q.Permission
	var tempModelList []do_permission.Permission

	// 遍历收集所有 URI
	for i, route := range r.Routes() {
		if strings.HasPrefix(route.Handler, "github.com") {
			continue
		}
		if _, err := p.Where(p.Method.Eq(route.Method), p.Uri.Eq(route.Path)).Take(); err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				fmt.Println(i, route.Method, route.Path, route.Handler)
				tempModelList = append(tempModelList, do_permission.Permission{Name: route.Path, Code: route.Path, PID: 0, Type: "api", Uri: route.Path, Method: route.Method, Sort: i + 1, Description: route.Path})
			}
		}
	}
	if len(tempModelList) > 0 {
		db.Create(tempModelList)
	}

	ipPort := fmt.Sprintf("%s:%d", cfg.Web.Host, cfg.Web.Port)
	app_log.InfoF("http://%s", ipPort)
	r.Run(ipPort)
}
