package do_cors

import (
	"{{ .ProjectName }}/pkg/enums/em_status"
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

type CorsWhitelist struct {
	ID          int64            `gorm:"primaryKey;type:bigint" json:"id"`
	Origin      string           `gorm:"type:varchar(255);uniqueIndex;not null" json:"origin"` // 白名单域名或IP
	Description string           `gorm:"type:varchar(255)" json:"description"`                 // 描述备注
	Status      em_status.Status `gorm:"type:int;default:1" json:"status"`                     // 状态：Enable启用，Disable禁用，其他扩展(如审核中，待发布等)
	CreatedAt   time.Time        `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt   time.Time        `gorm:"autoUpdateTime:nano" json:"updatedAt"`
	DeletedAt   gorm.DeletedAt   `gorm:"index" json:"-"` // 软删除
}

func (cors *CorsWhitelist) BeforeCreate(tx *gorm.DB) (err error) {
	if cors.ID == 0 {
		cors.ID = utils.GenerateID()
	}
	return
}

func (cors *CorsWhitelist) TableName() string {
	return "sys_cors_whitelist"
}
