package config

import (
	"fmt"
	"{{ .ProjectName }}/pkg/constants"
	"github.com/rs/zerolog/log"
	"gopkg.in/ini.v1"
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
				DbName: fmt.Sprintf("%s.db", constants.ProjectName),
			},
			MySQL: MySQL{
				Host:     "localhost",
				Port:     3306,
				Username: "root",
				Password: "",
				DbName:   constants.ProjectName,
			},
			Redis: Redis{
				Host:     "localhost",
				Port:     6379,
				Password: "",
			},
			Web: Web{
				Host: "localhost",
				Port: 8080,
				Mode: "debug",
			},
			Logger: Logger{
				Level:      "debug",
				MaxSize:    50,
				Logs:       "logs",
				FormatJSON: false,
				Compress:   true,
				MaxAge:     7,
				MaxBackups: 5,
			},
			Other: Other{
				DbType: "SQLite",
				Data:   "data",
			},
		}

		// ini 覆盖
		if constants.ConfigPath == "" {
			constants.ConfigPath = fmt.Sprintf("%s.ini", constants.ProjectName)
		}
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
		log.Fatal().Err(err).Msg("配置保存，序列化成ini失败")
	}

	for _, name := range []string{"SQLite", "MySQL"} {
		if strings.ToLower(cfg.Other.DbType) == strings.ToLower(name) {
			continue
		}
		file.DeleteSection(name)
	}

	if file.SaveTo(constants.ConfigPath) != nil {
		log.Fatal().Err(err).Msg("配置文件保存失败")
	}
}
