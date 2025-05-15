package config

import (
	"fmt"
	"{{ .ProjectName }}/constant"
	"{{ .ProjectName }}/libs/exists"
	"gopkg.in/ini.v1"
	"log"
	"sync"
)

// 这俩私有化 ↓↓↓
var (
	cfg  *Config
	once sync.Once
)

// GetConfig 单例获取配置
func GetConfig() *Config {
	cfgPath := fmt.Sprintf("%v.ini", constant.ProjectName)
	once.Do(func() {
		cfg = &Config{
			SQLite: SQLite{
				Database: fmt.Sprintf("%v.db", constant.ProjectName),
			},
			MySQL: MySQL{
				Host:     "localhost",
				Port:     3306,
				Username: "root",
				Password: "",
				Database: constant.ProjectName,
			},
			Redis: Redis{
				Host:     "localhost",
				Port:     6379,
				Password: "",
			},
			Server: Server{
				Host: "localhost",
				Port: 8080,
				Mode: "release",
			},
			Other: Other{
				Db:   "SQLite",
				Node: "node",
				Data: "data",
				Logs: "logs",
			},
		}

		// ini 覆盖
		file, err := ini.Load(cfgPath)
		if err == nil {
			_ = file.MapTo(cfg)
		}
	})
	return cfg
}

// SaveConfig 保存配置到 config.ini
func SaveConfig() error {
	if exists.IsExists(constant.ConfigFile) {
		return nil
	}

	file := ini.Empty()

	_ = file.Section("SQLite").ReflectFrom(&cfg.SQLite)
	_ = file.Section("MySQL").ReflectFrom(&cfg.MySQL)
	_ = file.Section("Redis").ReflectFrom(&cfg.Redis)
	_ = file.Section("Server").ReflectFrom(&cfg.Server)
	_ = file.Section("Other").ReflectFrom(&cfg.Other)

	err := file.SaveTo(constant.ConfigFile)
	if err != nil {
		log.Println("保存配置失败:", err)
		return err
	}
	return nil
}
