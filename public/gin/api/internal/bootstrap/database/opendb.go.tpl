package database

import (
	"database/sql"
	"fmt"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/log"
	"{{ .ProjectName }}/pkg/log/app_log"
	"{{ .ProjectName }}/pkg/log/db_log"
	"{{ .ProjectName }}/pkg/utils"
	_ "github.com/go-sql-driver/mysql"
	"gorm.io/driver/mysql"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// gorm配置
func gormConfig() *gorm.Config {
	return &gorm.Config{
		Logger: log.NewGormLogger(logger.Info),
	}
}

// MySQL建库
func checkAndCreateDatabase(cfg config.MySQL) {
	// 只连server，不带库名
	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%d)/", cfg.Username, cfg.Password, cfg.Host, cfg.Port))
	if err != nil {
		app_log.Error().Err(err).Msg("[数据库初始化] 数据库连接失败")
		os.Exit(-1)
	}
	defer db.Close()

	if err = db.Ping(); err != nil {
		app_log.Error().Err(err).Msg("[数据库初始化] 无法建立数据库连接")
		os.Exit(-1)
	}

	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = ?", cfg.DbName).Scan(&count); err != nil {
		app_log.Error().Err(err).Msg("[数据库初始化] 查询数据库失败")
		os.Exit(-1)
	}

	if count > 0 {
		return
	}
	createSQL := fmt.Sprintf("CREATE DATABASE `%s` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';", cfg.DbName)
	_, err = db.Exec(createSQL)
	if err != nil {
		app_log.Panic().Err(err).Msg("[数据库初始化] 创建数据库失败")
		os.Exit(-1)
	}
}

// OpenConnectDB 统一入口
func OpenConnectDB(cfg config.Config) *gorm.DB {
	var dsn gorm.Dialector
	dbType := strings.ToLower(cfg.Other.DbType)

	if dbType == "sqlite" {
		if !utils.IsDirExist(filepath.Dir(constants.SQLitePath)) {
			_ = os.MkdirAll(filepath.Dir(constants.SQLitePath), os.ModePerm)
		}
		dsn = sqlite.Open(constants.SQLitePath)
	} else {
		checkAndCreateDatabase(cfg.MySQL) // 先检查并建库
		dsn = mysql.Open(fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Asia%%2FShanghai", cfg.MySQL.Username, cfg.MySQL.Password, cfg.MySQL.Host, cfg.MySQL.Port, cfg.MySQL.DbName))
	}

	db, err := gorm.Open(dsn, gormConfig())
	if err != nil {
		db_log.Error().Err(err).Msg("数据库链接失败")
		os.Exit(-1)
	}

	sqlDB, err := db.DB()
	if err != nil {
		db_log.Error().Err(err).Msg("获取底层 sql.DB 失败")
		os.Exit(-1)
	}
	sqlDB.SetMaxOpenConns(50)
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetConnMaxLifetime(30 * time.Minute)

	query.SetDefault(db)
	return db
}
