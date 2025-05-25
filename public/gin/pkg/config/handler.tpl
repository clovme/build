package config

import (
	"fmt"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/global"
	"gopkg.in/ini.v1"
	"log"
	"strings"
	"sync"
)

// 这俩私有化 ↓↓↓
var (
	cfg  *Config
	once sync.Once
)

// GetConfig 单例获取配置
func GetConfig() *Config {
	once.Do(func() {
		cfg = &Config{
			SQLite: SQLite{
				DbName: fmt.Sprintf("%s.db", global.ProjectName),
			},
			MySQL: MySQL{
				Host:     "localhost",
				Port:     3306,
				Username: "root",
				Password: "",
				DbName:   global.ProjectName,
			},
			Redis: Redis{
				Host:     "localhost",
				Port:     6379,
				Password: "",
			},
			WebServer: WebServer{
				Host: "localhost",
				Port: 8080,
				Mode: "debug",
			},
			Other: Other{
				DbType: "SQLite",
				Data:   "data",
				Logs:   "logs",
			},
		}

		// ini 覆盖
		file, err := ini.Load(constants.ConfigPath)
		if err == nil {
			_ = file.MapTo(cfg)
		}
	})
	return cfg
}

// SaveConfig 保存配置到 config.ini
func SaveConfig() {
	file := ini.Empty()
	err := file.ReflectFrom(cfg)
	if err != nil {
		log.Fatal(err)
	}

	for _, name := range []string{"SQLite", "MySQL"} {
		if strings.ToLower(cfg.Other.DbType) == strings.ToLower(name) {
			continue
		}
		file.DeleteSection(name)
	}

	err = file.SaveTo(constants.ConfigPath)
	if err != nil {
		log.Fatal(err)
	}
}
