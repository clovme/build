package api

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
	"net/http"
)

type LoginHandler struct {
	LoginService *application.LoginService
}

// Login
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/login [get]
// @Group 			noAuth
func (h *LoginHandler) Login(c *gin.Context) {
	data, err := h.LoginService.GetLogin()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get do_user")
		return
	}

	resp.JsonSafe(c, em_http.Success.Desc(), data)
}
