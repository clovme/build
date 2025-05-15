package main

import (
	"embed"
	"fmt"
	"{{ .ProjectName }}/config"
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/database"
	"{{ .ProjectName }}/libs"
	"{{ .ProjectName }}/routers"
	"github.com/gin-gonic/gin"
	"gopkg.in/ini.v1"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
	"path/filepath"
)

//go:embed public/*
var fSys embed.FS
var cfg *config.Config

func init() {
	cfg = config.GetConfig()
	libs.CreateDir(cfg.Other.Data)

	constant.LogsPath = cfg.Other.Logs
	constant.DataLockFile = filepath.Join(cfg.Other.Data, ".lock")
	constant.SQLiteFile = filepath.Join(cfg.Other.Data, cfg.SQLite.Database)
	constant.ConfigFile = fmt.Sprintf("%s.ini", constant.ProjectName)

	_ = config.SaveConfig()
}

func main() {
	var dsn gorm.Dialector

	if file, err := ini.Load(constant.ConfigFile); err == nil {
		if file.HasSection("SQLite") && cfg.Other.Db == "SQLite" {
			dsn = sqlite.Open(constant.SQLiteFile)
		} else if file.HasSection("MySQL") && cfg.Other.Db == "MySQL" {
			dsn = database.OpenMySQLDB(cfg.MySQL)
		}
	}

	// 初始化所有日志
	if err := libs.InitAllLogger(); err != nil {
		panic(err)
	}
	defer libs.CloseAllLogger()

	// 初始化数据库
	db := database.AutoMigrate(dsn)

	ipPost := fmt.Sprintf("%s:%d", cfg.Server.Host, cfg.Server.Port)
	gin.SetMode(gin.DebugMode)

	engine := gin.Default()

	routers.Initialization(engine, db, fSys)

	log.Println(fmt.Sprintf("地址端口：http://%s", ipPost))
	if err := engine.Run(ipPost); err != nil {
		log.Fatalf("WEB 服务器启动失败: %v", err)
	}
}
