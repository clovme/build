package account

import (
	"{{ .ProjectName }}/libs"
	"github.com/gin-gonic/gin"
)

// Login			用户登录
// @Summary			用户登录
// @Description 	用户登录
// @Tags        	账户
// @Accept       	json
// @Produce      	json
// @Param        	id   body      int  true  "用户ID"
// @Success      	200  {object}  Response
// @Router			/login [get]
// @Group 			noAuth
func Login(c *gin.Context) {
	ct := libs.Context(c)
	ct.Msg(10000, "Login")
}
