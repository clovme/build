package config

import (
	"buildx/global"
	"bytes"
	"github.com/go-ini/ini"
	"os"
	"runtime"
	"sync"
)

var (
	cfg  *Config
	once sync.Once
)

func GetConfig() *Config {
	once.Do(func() {
		cfg = &Config{
			Env: Env{
				GOOS:   runtime.GOOS,
				GOARCH: runtime.GOARCH,
			},
			Build: Build{
				Plat:    []string{runtime.GOOS},
				Arch:    []string{runtime.GOARCH},
				Version: []int{0, 0, 0},
			},
			Other: Other{
				GoVersion: runtime.Version(),
			},
		}

		// ini 覆盖
		file, err := ini.Load(global.ExeFileName)
		if err == nil {
			_ = file.MapTo(cfg)
		}
	})
	return cfg
}

// SaveConfig 保存配置文件
func SaveConfig() {
	f := ini.Empty()
	if err := f.ReflectFrom(cfg); err != nil {
		panic("配置文件解析失败！")
	}

	if !cfg.Other.IsComment {
		// 清除掉所有注释
		for _, section := range f.Sections() {
			section.Comment = "" // 删除注释
			for _, key := range section.Keys() {
				key.Comment = "" // 删除注释
			}
		}
	}

	var buf bytes.Buffer
	buf.WriteString("; go install github.com/clovme/buildx@latest\n\n")

	_, _ = f.WriteTo(&buf) // 把 ini 配置写进去

	_ = os.WriteFile(global.ExeFileName, buf.Bytes(), 0644)
}
