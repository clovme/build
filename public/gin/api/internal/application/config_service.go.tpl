package application

import (
	"{{ .ProjectName }}/internal/domain/do_config"
)

type ConfigService struct {
	Repo do_config.Repository
}

func (s *ConfigService) GetConfig() ([]*do_config.Config, error) {
	return s.Repo.FindAll()
}
