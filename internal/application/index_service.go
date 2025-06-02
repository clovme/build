package application

import (
	"buildx/internal/domain/user"
)

type IndexService struct {
	Repo user.Repository
}

func (s *IndexService) GetAllIndexs() ([]user.User, error) {
	return s.Repo.FindAll()
}
