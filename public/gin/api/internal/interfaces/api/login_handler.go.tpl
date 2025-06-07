package api

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/pkg/enums/enum_code"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
	"net/http"
)

type LoginHandler struct {
	LoginService *application.LoginService
}

// Login 列表
// @Router			/login [get]
// @Group 			noAuth
func (h *LoginHandler) Login(c *gin.Context) {
	user, err := h.LoginService.GetLogin()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get user")
		return
	}

	resp.JsonSafe(c, enum_code.Success.Desc(), user)
}
