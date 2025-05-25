package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
	"gorm.io/gorm"
)

type {{ .StructName }}Repository struct {
	DB *gorm.DB
}

func (r *{{ .StructName }}Repository) FindAll() ([]{{ .DomainName }}.{{ .EntityName }}, error) {
	var {{ .DomainName }}s []{{ .DomainName }}.{{ .EntityName }}
	err := r.DB.Find(&{{ .DomainName }}s).Error
	return {{ .DomainName }}s, err
}

func (r *{{ .StructName }}Repository) Save(u *{{ .DomainName }}.{{ .EntityName }}) error {
	return r.DB.Create(u).Error
}
