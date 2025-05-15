package controller

import (
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/libs"
	"{{ .ProjectName }}/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

// IndexView		godoc
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/ [get]
// @Group 			views
func IndexView(c *gin.Context) {
	ct := libs.Context(c)

	var users []models.Users

	ct.Find(&users)

	c.HTML(http.StatusOK, "index.html", gin.H{
		"ProjectName": constant.ProjectName,
		"Users":       users,
	})
}

// DocsView			godoc
// @Summary			API文档
// @Description 	API文档
// @Tags        	API文档
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200 text/html text/html
// @Router			/docs [get]
// @Group 			views
func DocsView(c *gin.Context) {
	c.HTML(http.StatusOK, "docs.html", gin.H{
		"ProjectName": constant.ProjectName,
	})
}
