package database

import (
	"fmt"
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/database/initdata"
	"{{ .ProjectName }}/libs"
	"{{ .ProjectName }}/libs/exists"
	"{{ .ProjectName }}/models"
	"gorm.io/gorm"
	"log"
	"os"
	"reflect"
	"unicode"
)

// AutoMigrate 自动迁移数据库表和初始化数据
func AutoMigrate(dbn gorm.Dialector) *gorm.DB {
	db, err := gorm.Open(dbn, &gorm.Config{
		Logger: libs.GetGormLogger(),
	})
	if err != nil {
		log.Panicln("[初始化] 数据库打开失败！")
	}

	err = db.AutoMigrate(
		&models.Users{},
	)
	if err != nil {
		log.Panicln("[初始化] 数据库迁移失败：", err)
	}

	if !exists.IsExists(constant.DataLockFile) {
		fmt.Println("[初始化] 开始初始化数据... ###################################################")

		isSuccess := true
		v := reflect.ValueOf(&initdata.InitData{Db: db})

		for i := 0; i < v.NumMethod(); i++ {
			method := v.Type().Method(i)
			// 跳过非大写字母开头的方法
			if !unicode.IsUpper(rune(method.Name[0])) {
				continue
			}
			result := v.Method(i).Call(nil)
			if !result[0].Interface().(bool) {
				isSuccess = false
			}
		}

		if isSuccess {
			file, err := os.Create(constant.DataLockFile)
			if err != nil {
				log.Panicln("[初始化] 创建 lock 文件失败：", err)
			}
			defer file.Close()
			fmt.Println("[初始化] 数据初始化完成 ✅ ###################################################")
		}
	}

	return db
}
