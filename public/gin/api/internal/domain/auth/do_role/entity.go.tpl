package do_role

import (
	"{{ .ProjectName }}/pkg/enums/em_role"
	"{{ .ProjectName }}/pkg/enums/em_status"
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

/*
| 字段名           | 类型                      | 说明                                      |
| :------------ | :----------------------- | :-------------------------------------- |
| `ID`          | `bigint`                 | 主键，自增ID                                 |
| `Name`        | `varchar(100)`           | 角色名称，唯一，不可为空（例：系统管理员、VIP用户）             |
| `Type`        | `int`(`enums_role.Role`) | 角色类型枚举值（如 system、admin、custom），便于固定逻辑判定 |
| `Type`        | `string`                 | 角色编码（英文唯一） |
| `CreatedBy`   | `bigint`                 | 创建人ID，记录是谁创建的                           |
| `Description` | `varchar(255)`           | 角色说明，文字描述角色用途、权限范围等                     |
| `CreatedAt`   | `time.Time`              | 创建时间，自动填充                               |
| `UpdatedAt`   | `time.Time`              | 更新时间，自动更新时间戳                            |
| `DeletedAt`   | `*time.Time`             | 软删除字段，GORM自带功能，索引加速软删查找                 |
*/

type Role struct {
	ID          int64            `gorm:"primaryKey;type:bigint" json:"id"`
	Name        string           `gorm:"type:varchar(100);uniqueIndex;not null" json:"name"` // 角色名称
	Type        em_role.Role     `gorm:"type:int" json:"type"`                               // 类型 system/admin/custom
	Code        string           `gorm:"type:varchar(64)" json:"code"`                       // 角色编码（英文唯一）
	CreatedBy   int64            `gorm:"not null" json:"createdBy"`                          // 创建人ID
	Description string           `gorm:"type:varchar(255)" json:"description,omitempty"`     // 角色说明
	Status      em_status.Status `gorm:"type:int;default:1" json:"status"`                   // 状态：Enable启用，Disable禁用，其他扩展(如审核中，待发布等)
	RoleGroupID int64            `gorm:"type:bigint;not null" json:"roleGroupId"`
	CreatedAt   time.Time        `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt   time.Time        `gorm:"autoUpdateTime:nano" json:"updatedAt"`
	DeletedAt   *time.Time       `gorm:"index" json:"-"`
}

func (role *Role) BeforeCreate(tx *gorm.DB) (err error) {
	if role.ID == 0 {
		role.ID = utils.GenerateID()
	}
	return
}

func (role *Role) TableName() string {
	return "sys_role"
}
