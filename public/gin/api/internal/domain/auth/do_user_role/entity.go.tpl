package do_user_role

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

/*
| 字段         | 说明       |
| ----------- | ---------- |
| ID          | 主键   |
| UserID      | 用户ID |
| RoleID      | 角色ID |
| ExpireAt    | 角色到期时间 |
| IsActive    | 是否启用 |
| Description | 描述 |
| CreatedAt   | 备注 |
*/

type UserRole struct {
	ID          int64      `gorm:"primaryKey;type:bigint" json:"id"`
	UserID      int64      `gorm:"type:bigint;not null;index" json:"userId"` // 用户ID
	RoleID      int64      `gorm:"type:bigint;not null;index" json:"roleId"` // 角色ID
	ExpireAt    *time.Time `gorm:"" json:"expireAt,omitempty"`               // 角色到期时间
	IsActive    bool       `gorm:"default:true" json:"isActive"`             // 是否启用
	Description string     `gorm:"type:varchar(255)" json:"description,omitempty"`
	CreatedAt   time.Time  `gorm:"autoCreateTime:nano" json:"createdAt"`
	DeletedAt   *time.Time `gorm:"index" json:"-"`
}

func (userRole *UserRole) BeforeCreate(tx *gorm.DB) (err error) {
	if userRole.ID == 0 {
		userRole.ID = utils.GenerateID()
	}
	return
}

func (userRole *UserRole) TableName() string {
	return "sys_user_role"
}
