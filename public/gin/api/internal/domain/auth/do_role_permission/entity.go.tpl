package do_role_permission

import (
	"{{ .ProjectName }}/pkg/enums/em_status"
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

/*
| ID | Name  | Code         | Type | Path           | Method |
| -- | ----- | ------------ | ---- | -------------- | ------ |
| 1  | 用户查询 | user_list   | api  | /api/user      | GET    |
| 2  | 新增用户 | user_create | api  | /api/user      | POST   |
| 3  | 删除用户 | user_delete | api  | /api/user/\:id | DELETE |
| 4  | 菜单管理 | menu_manage | menu | /menu          |        |
*/

type RolePermission struct {
	ID           int64            `gorm:"primaryKey;type:bigint" json:"id"`
	RoleID       int64            `gorm:"type:bigint;not null;index" json:"roleId"`
	PermissionID int64            `gorm:"type:bigint;not null;index" json:"permissionId"`
	CreatedAt    time.Time        `gorm:"autoCreateTime:nano" json:"createdAt"`
	Status       em_status.Status `gorm:"type:int;default:1" json:"status"` // 状态：Enable启用，Disable禁用，其他扩展(如审核中，待发布等)
	DeletedAt    *time.Time       `gorm:"index" json:"-"`
}

func (rolePermission *RolePermission) BeforeCreate(tx *gorm.DB) (err error) {
	if rolePermission.ID == 0 {
		rolePermission.ID = utils.GenerateID()
	}
	return
}

func (rolePermission *RolePermission) TableName() string {
	return "sys_role_permission"
}
