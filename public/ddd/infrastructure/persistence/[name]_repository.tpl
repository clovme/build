package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
	"gorm.io/gorm"
)

type {{ .StructName }}Repository struct {
	DB *gorm.DB
}

func (r *{{ .StructName }}Repository) FindAll() ([]{{ .DomainPath }}.{{ .DomainName }}, error) {
	var {{ .DomainPath }}s []{{ .DomainPath }}.{{ .DomainName }}
	err := r.DB.Find(&{{ .DomainPath }}s).Error
	return {{ .DomainPath }}s, err
}

func (r *{{ .StructName }}Repository) Save(u *{{ .DomainPath }}.{{ .DomainName }}) error {
	return r.DB.Create(u).Error
}
