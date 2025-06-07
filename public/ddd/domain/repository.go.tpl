package {{ .Package }}

type Repository interface {
	FindAll() ([]*{{ .StructName }}, error)
	Save({{ .DomainName }} *{{ .StructName }}) error
}
