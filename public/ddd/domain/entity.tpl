package {{ .Package }}

import "{{ .ProjectName }}/internal/shared/model"

type {{ .StructName }} struct {
	model.BaseModel `gorm:"embedded"`
	// 在这里添加其他字段
	//Name            string `gorm:"not null" json:"name"`
	//Content         string `gorm:"not null;index" json:"content"`
}
