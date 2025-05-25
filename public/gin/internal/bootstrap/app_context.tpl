package bootstrap

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/internal/infrastructure/persistence"
	"{{ .ProjectName }}/internal/interfaces/api"
	"{{ .ProjectName }}/internal/interfaces/web"
	"gorm.io/gorm"
)

type AppContext struct {
	ArticleHandler *web.ArticleHandler
}

func NewAppContext(db *gorm.DB) *AppContext {
	articleRepo := &persistence.ArticleRepository{DB: db}
	articleService := &application.ArticleService{Repo: articleRepo}
	articleHandler := &web.ArticleHandler{ArticleService: articleService}

	return &AppContext{
		ArticleHandler: articleHandler,
	}
}