package account

import "github.com/gin-gonic/gin"

// Register			用户注册
// @Summary			用户注册
// @Description 	用户注册
// @Tags        	账户
// @Accept       	json
// @Produce      	json
// @Param        	id   body      int  true  "用户ID"
// @Success      	200  {object}  Response
// @Router			/signup [post]
// @Group 			noAuth
func Register(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "Register",
	})
}
