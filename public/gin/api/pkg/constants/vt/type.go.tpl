package vt

import (
	"strings"
)

const (
	MySQL  = "MySQL"
	SQLite = "SQLite"
	Memory = "Memory"
	Redis  = "Redis"
)

func getConstant(name string) string {
	switch true {
	case strings.EqualFold(name, MySQL):
		return MySQL
	case strings.EqualFold(name, SQLite):
		return SQLite
	case strings.EqualFold(name, Memory):
		return Memory
	case strings.EqualFold(name, Redis):
		return Redis
	default:
		return ""
	}
}

func GetDbName(name string) string {
	switch true {
	case strings.EqualFold(name, MySQL):
		return MySQL
	default:
		return SQLite
	}
}

func GetCacheName(name string) string {
	switch true {
	case strings.EqualFold(name, Redis):
		return Redis
	default:
		return Memory
	}
}

func GetValue(name string) string {
	return getConstant(name)
}
