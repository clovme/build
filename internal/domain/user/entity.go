package user

import "buildx/internal/shared/model"

type Userxxxx struct {
	model.BaseModel `gorm:"embedded"`
	// 在这里添加其他字段
	//Name            string `gorm:"not null" json:"name"`
	//Content         string `gorm:"not null;index" json:"content"`
}
