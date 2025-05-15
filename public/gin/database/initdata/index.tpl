package initdata

import (
	"crypto/md5"
	"encoding/hex"
	"errors"
	"fmt"
	"{{ .ProjectName }}/libs"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"log"
)

type InitData struct {
	Db *gorm.DB
}

// insertRecord 插入数据
func insertRecord[T libs.HasID](msg string, modelList []T, DbModel func(model T) (db *gorm.DB, where *gorm.DB)) bool {
	isSuccess := true
	for _, model := range modelList {
		db, Where := DbModel(model)
		if err := Where.First(model).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				// 这里手动生成 ID
				hash := md5.Sum([]byte(uuid.New().String()))
				model.SetID(hex.EncodeToString(hash[:]))

				if db.Create(model).Error != nil {
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
