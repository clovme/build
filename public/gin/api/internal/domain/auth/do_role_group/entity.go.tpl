package do_role_group

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

type RoleGroup struct {
	ID          int64     `gorm:"primaryKey;type:bigint" json:"id"`
	Name        string    `gorm:"type:varchar(64);not null;unique" json:"name"`
	Description string    `gorm:"type:varchar(255)" json:"description"`
	CreatedAt   time.Time `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt   time.Time `gorm:"autoUpdateTime:nano" json:"updatedAt"`
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
