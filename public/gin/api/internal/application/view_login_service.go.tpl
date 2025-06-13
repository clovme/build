package application

import (
	"{{ .ProjectName }}/internal/domain/do_user"
)

type ViewLoginService struct {
	Repo do_user.Repository
}

func (s *ViewLoginService) GetViewLogin() ([]*do_user.User, error) {
	return s.Repo.FindAll()
}
