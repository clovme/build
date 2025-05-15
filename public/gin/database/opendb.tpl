package database

import (
	"fmt"
	"{{ .ProjectName }}/config"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"log"
)

// OpenMySQLDB MySQL数据库初始化 和 打开数据库
func OpenMySQLDB(cfg config.MySQL) gorm.Dialector {
	dsnPrefix := fmt.Sprintf("%s:%s@tcp(%s:%s)/", cfg.Username, cfg.Password, cfg.Host, cfg.Port)

	conn, err := gorm.Open(mysql.Open(dsnPrefix), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Silent),
	})
	if err != nil {
		log.Fatal("[初始化][创建数据库]无法连接到 MySQL 服务器: ", err)
	}

	// 检查数据库是否存在
	var result int
	conn.Raw("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = ?", cfg.Database).Scan(&result)
	if result == 0 {
		createSQL := fmt.Sprintf("CREATE DATABASE IF NOT EXISTS `%s` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;", cfg.Database)
		if err = conn.Exec(createSQL).Error; err != nil {
			log.Fatal("[初始化]无法创建数据库: ", err)
		}
	}

	dsn := fmt.Sprintf("%s%s?charset=utf8mb4&parseTime=True&loc=Asia%%2FShanghai", dsnPrefix, cfg.Database)
	return mysql.Open(dsn)
}
