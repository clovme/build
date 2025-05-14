package config

import (
	"{{ .ProjectName }}/constant"
	"fmt"
	"gopkg.in/ini.v1"
	"log"
	"sync"
)

// 这俩私有化 ↓↓↓
var (
	cfg  *config
	once sync.Once
)

// GetConfig 单例获取配置
func GetConfig() *config {
	once.Do(func() {
		fmt.Println("初始化配置")
		cfg = &config{
			SQLite: sQLite{
				Database: fmt.Sprintf("%v.db", constant.ProjectName),
			},
			MySQL: mySQL{
				Host:     "localhost",
				Port:     3306,
				Username: "root",
				Password: "",
				Database: constant.ProjectName,
			},
			Redis: redis{
				Host:     "localhost",
				Port:     6379,
				Password: "",
			},
			Server: server{
				Host: "localhost",
				Port: 8080,
				Mode: "release",
			},
			Other: other{
				Node: "node",
			},
		}

		// ini 覆盖
		file, err := ini.Load(fmt.Sprintf("%v.ini", constant.ProjectName))
		if err == nil {
			file.MapTo(cfg)
		}
	})
	return cfg
}

// SaveConfig 保存配置到 config.ini
func SaveConfig() error {
	if cfg == nil {
		GetConfig()
	}

	file := ini.Empty()

	if cfg.SQLite.Database != "" {
		file.Section("SQLite").ReflectFrom(&cfg.SQLite)
	} else {
		file.Section("MySQL").ReflectFrom(&cfg.MySQL)
	}

	file.Section("Redis").ReflectFrom(&cfg.Redis)
	file.Section("Server").ReflectFrom(&cfg.Server)
	file.Section("Other").ReflectFrom(&cfg.Other)

	err := file.SaveTo(fmt.Sprintf("%v.ini", constant.ProjectName))
	if err != nil {
		log.Println("保存配置失败:", err)
		return err
	}

	log.Println("配置保存成功")
	return nil
}
