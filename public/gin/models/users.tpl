package models

import (
	"time"
)

// Users 用户表
type Users struct {
	BaseModel
	Nickname  string    `gorm:"not null" json:"nickname"`     // 昵称
	Username  string    `gorm:"not null" json:"username"`     // 用户名
	Password  string    `gorm:"not null" json:"-"`            // 密码
	Token     string    `gorm:"unique;not null" json:"token"` // Token
	ExpiresAt time.Time `json:"expiresAt"`                    // 过期时间
}
