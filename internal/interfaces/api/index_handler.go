package api

import (
	"buildx/internal/application"
	"buildx/internal/domain/user"
	"github.com/gin-gonic/gin"
	"net/http"
)

type IndexHandler struct {
	IndexService *application.IndexService
}

// ListIndexs 列表
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/list/users [get]
// @Group 			public
func (h *IndexHandler) ListIndexs(c *gin.Context) {
	users, err := h.IndexService.GetAllIndexs()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get users")
		return
	}

	c.HTML(http.StatusOK, "userList.html", gin.H{
		"Title": "Index列表",
		"Users": users,
	})
}

// DisableAllIndexs 禁用所有Index
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/disable_all/user [get]
// @Group 			public
func (h *IndexHandler) DisableAllIndexs(c *gin.Context) {
	users, err := h.IndexService.GetAllIndexs()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get users")
		return
	}

	// 新建领域服务
	svc := user.NewService()
	svc.DisableUsers(users)

	// 保存到数据库
	for i := range users {
		_ = h.IndexService.Repo.Save(&users[i])
	}

	c.Redirect(http.StatusFound, "/list/users")
}
