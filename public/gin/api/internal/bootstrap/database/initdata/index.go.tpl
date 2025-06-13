package initdata

import (
	"errors"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type InitData struct {
	Router gin.RoutesInfo
	Q      *query.Query
}

// insertIfNotExist 插入数据
func insertIfNotExist[T any](modelList []T, exists func(model T) (*T, error)) []*T {
	newModelList := make([]*T, 0)

	for _, model := range modelList {
		if _, err := exists(model); err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				newModelList = append(newModelList, &model)
				continue
			}
		}
	}

	return newModelList
}
