package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
)

type {{ .StructName }}Service struct {
	Repo {{ .DomainName }}.Repository
}

func (s *{{ .StructName }}Service) Get{{ .StructName }}() ([]*{{ .DomainName }}.{{ .DomainStructName }}, error) {
	return s.Repo.FindAll()
}
