package do_permission

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

/*
| 字段          | 说明                       | 示例                            |
| ----------- | ------------------------ | ----------------------------- |
| ID          | 主键                       | 1                             |
| Name        | 权限名称                     | `用户新增` / `删除角色`               |
| Code        | 权限编码（唯一英文）               | `user_create` / `role_delete` |
| PID         | 父级权限 ID                  | 0（顶级）或父权限ID                   |
| Type        | 权限类型：menu / button / api | api、menu、button               |
| Path        | API地址或前端路由               | `/api/user`、`/role`           |
| Method      | 请求方法                     | `GET` / `POST`                |
| Sort        | 排序值                      | 数字，越大越靠前                      |
| Description | 描述                       | `用户新增接口权限`                    |
*/

type Permission struct {
	ID          int64      `gorm:"primaryKey;type:bigint" json:"id"`                   // 权限ID，主键，自增
	Name        string     `gorm:"type:varchar(100);uniqueIndex;not null" json:"name"` // 权限名称，必填，唯一
	Code        string     `gorm:"type:varchar(100);uniqueIndex;not null" json:"code"` // 权限标识（唯一英文编码，建议全小写下划线）
	PID         int64      `gorm:"type:bigint;default:0" json:"pid"`                   // 父级权限ID，0表示顶级节点
	Type        string     `gorm:"type:varchar(20);default:'api'" json:"type"`         // 权限类型：menu（菜单）/ button（按钮）/ api（接口）
	Uri         string     `gorm:"type:varchar(255)" json:"uri"`                       // 路由路径或接口地址，菜单或接口必填
	Method      string     `gorm:"type:varchar(20)" json:"method,omitempty"`           // HTTP请求方式（GET/POST/PUT/DELETE），仅api类型使用
	Sort        int        `gorm:"type:int;default:0" json:"sort"`                     // 排序值，值越大越靠前，默认0
	Status      bool       `gorm:"type:tinyint;default:true" json:"status"`            // 状态：true启用，false禁用
	Description string     `gorm:"type:varchar(255)" json:"description,omitempty"`     // 权限描述，便于备注说明
	CreatedAt   time.Time  `gorm:"autoCreateTime:nano" json:"createdAt"`               // 创建时间，自动生成
	UpdatedAt   time.Time  `gorm:"autoUpdateTime:nano" json:"updatedAt"`               // 更新时间，自动更新
	DeletedAt   *time.Time `gorm:"index" json:"-"`                                     // 软删除标记，空值表示未删除
}

func (permission *Permission) BeforeCreate(tx *gorm.DB) (err error) {
	if permission.ID == 0 {
		permission.ID = utils.GenerateID()
	}
	return
}

func (permission *Permission) TableName() string {
	return "sys_permission"
}
