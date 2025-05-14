package account

import "github.com/gin-gonic/gin"

// Login			用户登录
// @Summary			用户登录
// @Description 	用户登录
// @Tags        	账户
// @Accept       	json
// @Produce      	json
// @Param        	id   body      int  true  "用户ID"
// @Success      	200  {object}  Response
// @Router			/login [post]
// @Group 			noAuth
func Login(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Login",
	})
}
