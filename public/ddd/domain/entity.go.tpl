package {{ .Package }}

import (
	"{{ .ProjectName }}/pkg/utils"
	"gorm.io/gorm"
	"time"
)

type {{ .StructName }} struct {
    ID        int64     `gorm:"primaryKey;type:bigint" json:"id"`
	// 在这里添加其他字段
	
    CreatedAt time.Time `gorm:"autoCreateTime:nano" json:"createdAt"`
    UpdatedAt time.Time `gorm:"autoUpdateTime:nano" json:"updatedAt"`
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