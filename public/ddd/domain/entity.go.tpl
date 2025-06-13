package {{ .Package }}

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

type {{ .StructName }} struct {
    ID        int64     `gorm:"primaryKey;type:bigint" json:"id"`
	// 在这里添加其他字段
	
    Sort        int                `gorm:"type:int;default:0" json:"sort"`                     // 排序值，值越大越靠前，默认0
	Status      enum_status.Status `gorm:"type:int;default:1" json:"status"`                   // 状态：Enable启用，Disable禁用，其他扩展(如审核中，待发布等)
	Description string             `gorm:"type:varchar(255)" json:"description,omitempty"`     // 权限描述，便于备注说明
	CreatedAt   time.Time          `gorm:"autoCreateTime:nano" json:"createdAt"`               // 创建时间，自动生成
	UpdatedAt   time.Time          `gorm:"autoUpdateTime:nano" json:"updatedAt"`               // 更新时间，自动更新
	DeletedAt   *time.Time         `gorm:"index" json:"-"`                                     // 软删除标记，空值表示未删除
}

func ({{ .DomainName }} *{{ .StructName }}) BeforeCreate(tx *gorm.DB) (err error) {
	if {{ .DomainName }}.ID == 0 {
		{{ .DomainName }}.ID = utils.GenerateID()
	}
	return
}

func ({{ .DomainName }} *{{ .StructName }}) TableName() string {
	return "{{ .TableName }}"
}