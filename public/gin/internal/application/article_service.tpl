package application

import (
	"{{ .ProjectName }}/internal/domain/article"
)

type ArticleService struct {
	Repo article.Repository
}

func (s *ArticleService) GetAllArticles() ([]article.Article, error) {
	return s.Repo.FindAll()
}
