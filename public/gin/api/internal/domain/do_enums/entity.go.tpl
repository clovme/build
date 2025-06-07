package do_enums

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

/*
| 字段名           | 类型             | 说明                           |
| :------------ | :------------- | :--------------------------- |
| `ID`          | `bigint`       | 主键，自增                        |
| `Category`    | `varchar(50)`  | 枚举分类（比如 role_type / gender） |
| `Key`         | `varchar(100)` | 枚举键名（代码里用的值）                 |
| `Name`        | `varchar(100)` | 枚举名称（显示用）                 |
| `Value`       | `int`          | 枚举展示值（给前端、后台看的文字）            |
| `Sort`        | `int`          | 排序值，越小排越前                    |
| `Enable`      | `bool`         | 是否启用，false 表示逻辑禁用            |
| `Description` | `varchar(255)` | 描述，方便维护说明                    |
| `CreatedAt`   | `time.Time`    | 创建时间                         |
| `UpdatedAt`   | `time.Time`    | 更新时间                         |
*/

type Enums struct {
	ID          int64     `gorm:"primaryKey;type:bigint" json:"id"`
	Category    string    `gorm:"type:varchar(50);index;not null" json:"category"` // 枚举分类
	Key         string    `gorm:"type:varchar(100);not null" json:"key"`           // 枚举键（唯一标识）
	Name        string    `gorm:"type:varchar(100);not null" json:"name"`          // 枚举名称（显示用）
	Value       int       `gorm:"type:int;not null" json:"value"`                  // 枚举值（数字）
	Sort        int       `gorm:"default:0" json:"sort"`                           // 排序
	Enable      bool      `gorm:"not null;default:true" json:"enable"`             // 是否启用
	Description string    `gorm:"type:varchar(255)" json:"description,omitempty"`  // 描述
	CreatedAt   time.Time `gorm:"autoCreateTime:nano" json:"createdAt"`
	UpdatedAt   time.Time `gorm:"autoUpdateTime:nano" json:"updatedAt"`
}

func (enums *Enums) BeforeCreate(tx *gorm.DB) (err error) {
	if enums.ID == 0 {
		enums.ID = utils.GenerateID()
	}
	return
}

func (enums *Enums) TableName() string {
	return "sys_enums"
}
