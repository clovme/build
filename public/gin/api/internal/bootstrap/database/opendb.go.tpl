package database

import (
	"fmt"
	"{{ .ProjectName }}/internal/bootstrap/initialize"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/logger"
	"{{ .ProjectName }}/pkg/logger/log"
	"{{ .ProjectName }}/pkg/utils"
	_ "github.com/go-sql-driver/mysql"
	"gorm.io/driver/mysql"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"os"
	"path/filepath"
	"strings"
	"time"
)

// MySQL建库
func checkAndCreateDatabase(cfg config.MySQL) bool {
	// 只连server，不带库名
	db, err := initialize.CheckDbConnect(cfg)
	if err != nil {
		return false
	}
	defer db.Close()

	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = ?", cfg.DbName).Scan(&count); err != nil {
		log.Error().Err(err).Msgf("[数据库初始化] 数据库[%s]查询失败...", cfg.DbName)
		return false
	}

	if count > 0 {
		return true
	}

	_, err = db.Exec(fmt.Sprintf("CREATE DATABASE `%s` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';", cfg.DbName))
	if err != nil {
		log.Panic().Err(err).Msgf("[数据库初始化] 创建数据库[%s]失败", cfg.DbName)
		return false
	}
	log.Info().Msgf("[数据库初始化] 数据库[%s]初始化完成...", cfg.DbName)
	return true
}

// OpenConnectDB 统一入口
func OpenConnectDB(cfg config.Config) *gorm.DB {
	var dsn gorm.Dialector
	dbType := strings.ToLower(cfg.Other.DbType)

	if dbType == "sqlite" {
		if !utils.IsDirExist(filepath.Dir(let.SQLitePath)) {
			_ = os.MkdirAll(filepath.Dir(let.SQLitePath), os.ModePerm)
		}
		dsn = sqlite.Open(let.SQLitePath)
	} else {
		if !checkAndCreateDatabase(cfg.MySQL) { // 先检查并建库
			log.Error().Msg("[数据库初始化] 数据库初始化失败")
			os.Exit(-1)
		}
		dsn = mysql.Open(fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Asia%%2FShanghai", cfg.MySQL.Username, cfg.MySQL.Password, cfg.MySQL.Host, cfg.MySQL.Port, cfg.MySQL.DbName))
	}

	db, err := gorm.Open(dsn, logger.GetGormLogger())
	if err != nil {
		os.Exit(-1)
	}

	sqlDB, err := db.DB()
	if err != nil {
		log.Error().Err(err).Msg("获取底层 sql.DB 失败")
		os.Exit(-1)
	}
	sqlDB.SetMaxOpenConns(50)
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetConnMaxLifetime(30 * time.Minute)

	query.SetDefault(db)
	return db
}
