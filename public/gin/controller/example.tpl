// @Router	/users [get] (重要参数，路由配置)
// @Group	public (重要参数，路由分组和权限控制)

package controller

import "github.com/gin-gonic/gin"

// GetUsers			godoc
// @Summary			获取用户信息
// @Description 	根据ID获取用户详细信息
// @Tags        	用户模块
// @Accept       	json
// @Produce      	json
// @Success      	200  {object}  UserResponse
// @Router			/users [get]
// @Group 			public
func GetUsers(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "GET Users",
	})
}


// PutUsers			godoc
// @Summary			获取用户信息
// @Description 	根据ID获取用户详细信息
// @Tags        	用户模块
// @Accept       	json
// @Produce      	json
// @Param        	id   path      int  true  "用户ID"
// @Success      	200  {object}  UserResponse
// @Router			/users/{id} [put]
// @Group 			admin
func PutUsers(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "PUT Users",
	})
}