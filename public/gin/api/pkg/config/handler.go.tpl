package config

import (
	"fmt"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/constants/vt"
	"{{ .ProjectName }}/pkg/let"
	"github.com/rs/zerolog"
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
				DB:       0,
			},
			Web: Web{
				Host: "localhost",
				Port: 9527,
			},
			Logger: Logger{
				Level:      zerolog.InfoLevel.String(),
				MaxSize:    50,
				Logs:       "logs",
				FormatJSON: false,
				Compress:   true,
				MaxAge:     7,
				MaxBackups: 5,
			},
			Other: Other{
				DbType:    vt.Redis,
				CacheType: vt.Memory,
				DataPath:  "data",
			},
		}

		// ini 覆盖
		if let.ConfigPath == "" {
			let.ConfigPath = fmt.Sprintf("%s.ini", constants.ProjectName)
		}
		file, err := ini.Load(let.ConfigPath)
		if err == nil {
			_ = file.MapTo(cfg)
		}
		if cfg.Logger.Level == "no" {
			cfg.Logger.Level = ""
		}
		cfg.Logger.Level = strings.ToLower(cfg.Logger.Level)
		cfg.Other.DbType = vt.GetDbName(cfg.Other.DbType)
		cfg.Other.CacheType = vt.GetCacheName(cfg.Other.CacheType)
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

	if cfg.Other.CacheType == "Memory" {
		for _, name := range []string{"Redis"} {
			file.DeleteSection(name)
		}
	}

	if file.SaveTo(let.ConfigPath) != nil {
		log.Fatal().Err(err).Msg("配置文件保存失败")
	}
}
