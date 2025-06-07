package application

import (
	"{{ .ProjectName }}/internal/domain/do_user"
)

type LoginService struct {
	Repo do_user.Repository
}

func (s *LoginService) GetLogin() ([]*do_user.User, error) {
	return s.Repo.FindAll()
}
