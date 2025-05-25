package model

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
	"strings"
	"time"
)

type BaseModel struct {
	ID        string    `gorm:"primaryKey;type:char(32)" json:"id"`
	CreatedAt time.Time `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt time.Time `gorm:"autoUpdateTime:nano" json:"updatedAt"`
}

func (base *BaseModel) BeforeCreate(tx *gorm.DB) (err error) {
	if base.ID == "" {
		base.ID = strings.ReplaceAll(uuid.NewString(), "-", "")
	}
	return
}
