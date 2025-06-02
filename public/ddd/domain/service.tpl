package {{ .Package }}

import "errors"

type Service struct{}

func NewService() *Service {
	return &Service{}
}

// Disable{{ .StructName }} 禁用{{ .StructName }}
func (s *Service) Disable{{ .StructName }}(u *{{ .StructName }}) error {
	if u.ID == "id" {
		return errors.New("invalid {{ .StructName }} id")
	}
	// 这里本来应该有状态属性，比如 u.IsActive = false
	// 假设我们现在只打印一下
	// u.Name = u.Name + "【已禁用】"
	return nil
}

// Disable{{ .StructName }}s 批量禁用
func (s *Service) Disable{{ .StructName }}s({{ .Package }}s []{{ .StructName }}) []error {
	var errs []error
	for i := range {{ .Package }}s {
		if err := s.Disable{{ .StructName }}(&{{ .Package }}s[i]); err != nil {
			errs = append(errs, err)
		}
	}
	return errs
}
