// @Router	/users [get] (重要参数，路由配置)
// @Group	public (重要参数，路由分组和权限控制)

package controller

import (
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/libs"
	"github.com/gin-gonic/gin"
)

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
	ct := libs.Context(c)
	ct.Msg(10000, "GET Users")
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
	ct := libs.Context(c)
	ct.Msg(10000, "PUT Users")
}

// Var				godoc
// @Summary			打印变量
// @Description 	打印变量
// @Tags        	打印变量
// @Accept       	json
// @Produce      	json
// @Param        	id   path      int  true  "用户ID"
// @Success      	200  {object}  UserResponse
// @Router			/var [get]
// @Group 			public
func Var(c *gin.Context) {
	ct := libs.Context(c)
	ct.Json(10000, "Print Var", map[string]interface{}{
		"LogsPath":     constant.LogsPath,
		"ConfigFile":   constant.ConfigFile,
		"DataLockFile": constant.DataLockFile,
		"SQLiteFile":   constant.SQLiteFile,
	})
}
