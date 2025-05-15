package initdata

import (
	"{{ .ProjectName }}/models"
	"gorm.io/gorm"
)

// Users 初始化用户表
func (d *InitData) Users() bool {
	modelList := []*models.Users{
		{Nickname: "router0", Username: "路由器", Password: "123456", Token: "1"},
		{Nickname: "router1", Username: "路由器", Password: "123456", Token: "2"},
		{Nickname: "router2", Username: "路由器", Password: "123456", Token: "3"},
		{Nickname: "router3", Username: "路由器", Password: "123456", Token: "4"},
	}
	return insertRecord("用户表", modelList, func(u *models.Users) (db *gorm.DB, where *gorm.DB) {
		return d.Db, d.Db.Where("nickname = ?", u.Nickname)
	})
}
