package api

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/internal/domain/article"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ArticleHandler struct {
	ArticleService *application.ArticleService
}

// ListArticles 列表
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/list/articles [get]
// @Group 			views
func (h *ArticleHandler) ListArticles(c *gin.Context) {
	articles, err := h.ArticleService.GetAllArticles()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get articles")
		return
	}

	c.HTML(http.StatusOK, "articleList.html", gin.H{
		"Title": "Article列表",
		"articles": articles,
	})
}

// DisableAllArticles 禁用所有Article
// ListArticles 列表
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/disable_all/article [get]
// @Group 			views
func (h *ArticleHandler) DisableAllArticles(c *gin.Context) {
	articles, err := h.ArticleService.GetAllArticles()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get articles")
		return
	}

	// 新建领域服务
	svc := article.NewService()
	svc.DisableArticles(articles)

	// 保存到数据库
	for i := range articles {
		_ = h.ArticleService.Repo.Save(&articles[i])
	}

	c.Redirect(http.StatusFound, "/list/articles")
}
