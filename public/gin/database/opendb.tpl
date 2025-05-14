package database

import (
	"{{ .ProjectName }}/config"
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"log"
)

// OpenMySQLDB MySQL数据库初始化 和 打开数据库
func OpenMySQLDB() gorm.Dialector {
	var err error
	cfg := config.GetConfig().MySQL

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/", cfg.Username, cfg.Password, cfg.Host, cfg.Port)
	conn, err := gorm.Open(mysql.Open(fmt.Sprintf(dsn)), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		log.Fatal("[初始化][创建数据库]无法连接到 MySQL 服务器: ", err)
	}
	// 检查数据库是否存在
	var result int
	conn.Raw("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = ?", cfg.Database).Scan(&result)
	if result == 0 {
		// 数据库不存在，创建数据库
		if err = conn.Exec(fmt.Sprintf("create schema `%s` collate utf8mb4_general_ci;", cfg.Database)).Error; err != nil {
			log.Fatal("[初始化]无法创建数据库: ", err)
		}
	}
	return mysql.Open(fmt.Sprintf("%s%s?charset=utf8mb4&parseTime=True&loc=Local", dsn, cfg.Database))
}
