package database

import (
	"fmt"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"log"
	"os"
	"reflect"
	"{{ .ProjectName }}/database/initdata"
	"{{ .ProjectName }}/libs"
	"{{ .ProjectName }}/models"
	"time"
)

func AutoMigrate(dbn gorm.Dialector) *gorm.DB {
	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // 输出位置
		logger.Config{
			SlowThreshold:             time.Second, // 超过 1s 算慢查询
			LogLevel:                  logger.Info, // 打开所有日志
			IgnoreRecordNotFoundError: false,       // 忽略 ErrRecordNotFound 错误
			Colorful:                  true,        // 彩色输出
		},
	)

	db, err := gorm.Open(dbn, &gorm.Config{
		Logger: newLogger,
	})
	if err != nil {
		log.Fatalln("[初始化]数据库打开失败！")
	}

	err = db.AutoMigrate(
		&models.Users{},
	)

	if err != nil {
		log.Fatalln("[初始化]数据库迁移失败：", err)
	}

	lock := "data/.lock"
	if !libs.Exists(lock) {
		fmt.Println("[初始化]开始初始化数据... #####################################################################")
		isSuccess := true
		v := reflect.ValueOf(&initdata.InitData{Db: db})

		for i := 0; i < v.NumMethod(); i++ {
			result := v.Method(i).Call(nil)
			if !result[0].Interface().(bool) {
				isSuccess = false
			}
		}
		if isSuccess {
			file, _ := os.Create(lock)
			defer file.Close() // 最好关掉资源
		}
		fmt.Println("[初始化]数据初始化完成... #####################################################################")
	}

	return db
}
