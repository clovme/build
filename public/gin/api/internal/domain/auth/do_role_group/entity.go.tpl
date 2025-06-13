package do_role_group

import (
	"{{ .ProjectName }}/pkg/enums/em_status"
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

type RoleGroup struct {
	ID          int64            `gorm:"primaryKey;type:bigint" json:"id"`
	Name        string           `gorm:"type:varchar(64);not null;unique" json:"name"`
	Description string           `gorm:"type:varchar(255)" json:"description"`
	Status      em_status.Status `gorm:"type:int;default:1" json:"status"` // 状态：Enable启用，Disable禁用，其他扩展(如审核中，待发布等)
	CreatedAt   time.Time        `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt   time.Time        `gorm:"autoUpdateTime:nano" json:"updatedAt"`
}

func (roleGroup *RoleGroup) BeforeCreate(tx *gorm.DB) (err error) {
	if roleGroup.ID == 0 {
		roleGroup.ID = utils.GenerateID()
	}
	return
}

func (roleGroup *RoleGroup) TableName() string {
	return "sys_role_group"
}
