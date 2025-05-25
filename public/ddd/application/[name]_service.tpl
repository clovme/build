package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
)

type {{ .StructName }}Service struct {
	Repo {{ .DomainName }}.Repository
}

func (s *{{ .StructName }}Service) GetAll{{ .StructName }}s() ([]{{ .DomainName }}.{{ .EntityName }}, error) {
	return s.Repo.FindAll()
}
