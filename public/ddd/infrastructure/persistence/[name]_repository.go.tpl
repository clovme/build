package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"gorm.io/gorm"
)

type {{ .StructName }}Repository struct {
	DB *gorm.DB
    Q  *query.Query
}

func (r *{{ .StructName }}Repository) FindAll() ([]*{{ .DomainName }}.{{ .DomainStructName }}, error) {
	data, err := r.Q.{{ .DomainStructName }}.Find()
    if err != nil {
        return nil, err
    }
    return data, err
}

func (r *{{ .StructName }}Repository) Save(u *{{ .DomainName }}.{{ .DomainStructName }}) error {
	return r.DB.Create(u).Error
}
