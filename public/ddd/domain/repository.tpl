package {{ .Package }}

type Repository interface {
	FindAll() ([]{{ .StructName }}, error)
	Save({{ .Package }} *{{ .StructName }}) error
}
