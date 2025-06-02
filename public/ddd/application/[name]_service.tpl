package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
)

type {{ .StructName }}Service struct {
	Repo {{ .DomainPath }}.Repository
}

func (s *{{ .StructName }}Service) GetAll{{ .StructName }}s() ([]{{ .DomainPath }}.{{ .DomainName }}, error) {
	return s.Repo.FindAll()
}
