package initdata

import (
	"errors"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/log/app_log"
	"gorm.io/gorm"
)

type InitData struct {
	Db *gorm.DB
	Q  *query.Query
}

// insertIfNotExist 插入数据
func insertIfNotExist[T any](msg string, db *gorm.DB, modelList []T, exists func(model T) (*T, error)) {
	tempModelList := make([]T, 0)

	for _, model := range modelList {
		if _, err := exists(model); err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				tempModelList = append(tempModelList, model)
				continue
			}
		}
	}

	if len(tempModelList) <= 0 {
		return
	}

	if err := db.CreateInBatches(&tempModelList, 100).Error; err != nil {
		app_log.Error().Err(err).Msgf("[%s]初始化失败:", msg)
	} else {
		app_log.Info().Msgf("[%s]初始化成功，共%d条数据！", msg, len(tempModelList))
	}
}
