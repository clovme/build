package persistence

import (
	"{{ .ProjectName }}/internal/domain/article"
	"gorm.io/gorm"
)

type ArticleRepository struct {
	DB *gorm.DB
}

func (r *ArticleRepository) FindAll() ([]article.Article, error) {
	var articles []article.Article
	err := r.DB.Find(&articles).Error
	return articles, err
}

func (r *ArticleRepository) Save(u *article.Article) error {
	return r.DB.Create(u).Error
}
