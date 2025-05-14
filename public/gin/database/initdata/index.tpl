package initdata

import (
	"errors"
	"fmt"
	"gorm.io/gorm"
	"log"
)

type InitData struct {
	Db *gorm.DB
}

// insertRecord 插入数据
func insertRecord[T any](msg string, modelList []T, DbModel func(model T) (db *gorm.DB, where *gorm.DB)) bool {
	isSuccess := true
	for _, model := range modelList {
		db, Where := DbModel(model)
		if err := Where.First(&model).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				// 数据不存在，插入新记录
				if err := db.Create(&model).Error; err != nil {
					isSuccess = false
					log.Println(fmt.Sprintf("[%s]初始化失败:", msg), err)
				}
			} else {
				isSuccess = false
				log.Println(fmt.Sprintf("[%s]查询失败:", msg), err)
			}
		}
	}
	if isSuccess {
		log.Println(fmt.Sprintf("[%s]初始化成功", msg))
	}
	return isSuccess
}
