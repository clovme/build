package main

import (
	"fmt"
	"{{ .ProjectName }}/internal/bootstrap/database"
	"{{ .ProjectName }}/internal/bootstrap/initialize"
	"{{ .ProjectName }}/internal/bootstrap/routers"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/crypto"
	"{{ .ProjectName }}/pkg/initweb"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/logger/log"
	"{{ .ProjectName }}/pkg/utils"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
	"path/filepath"
	"strings"
	"time"
)

var cfg *config.Config

func init() {
	time.Local = time.UTC
	cfg = config.GetConfig()
	gin.SetMode(gin.ReleaseMode)

	let.IsInitialized.Store(utils.IsFileExist(let.ConfigPath))

	utils.InitSnowflake(1)
	if err := crypto.ParseRsaKeys(public.PublicPEM, public.PrivatePEM); err != nil {
		fmt.Println("密钥初始化失败：", err)
		return
	}
	let.SQLitePath = filepath.Join(cfg.Other.DataPath, fmt.Sprintf("%s.db", constants.ProjectName))
}

func main() {
	// 初始化配置文件
	if !let.IsInitialized.Load() {
		initweb.Initialization(cfg)
		for {
			if let.IsInitialized.Load() {
				break
			}
		}
		config.SaveConfig()
	}

	initialize.InitLogger(cfg.Logger)
	initialize.InitCache(*cfg)
	db := database.OpenConnectDB(*cfg)
	engine := routers.Initialization(db)

	if err := database.AutoMigrate(db, query.Q, engine.Routes()); err != nil {
		log.Error().Err(err).Msg("[初始化]数据库迁移失败！")
		return
	}
	initialize.InitSystemConfig(query.Q)

	ipPort := fmt.Sprintf("%s:%d", cfg.Web.Host, cfg.Web.Port)
	for i, route := range engine.Routes() {
		if strings.HasSuffix(route.Path, "*filepath") {
			continue
		}
		log.Info().Msgf("%03d [%s] http://%s%-30s%-10s%s", i+1, route.Method, ipPort, route.Path, "->", route.Handler)
	}
	engine.Run(fmt.Sprintf("%s:%d", cfg.Web.Host, cfg.Web.Port))
}
