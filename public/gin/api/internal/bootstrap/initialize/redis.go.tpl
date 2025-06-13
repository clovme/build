package initialize

import (
	"context"
	"fmt"
	"{{ .ProjectName }}/pkg/cache"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/constants/vt"
	"{{ .ProjectName }}/pkg/logger/log"
	"github.com/redis/go-redis/v9"
	"strings"
)

func CacheRedis(cfg config.Redis) (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", cfg.Host, cfg.Port),
		Password: cfg.Password,
		DB:       cfg.DB,
	})
	_, err := rdb.Ping(context.Background()).Result()
	return rdb, err
}

func InitCache(cfg config.Config) {
	if strings.EqualFold(vt.Redis, cfg.Other.CacheType) {
		// 初始化 Redis 客户端
		rdb, err := CacheRedis(cfg.Redis)
		if err != nil {
			log.Fatal().Err(err).Msg("Redis 初始化链接失败...")
		}
		cache.Cache = cache.NewRedisCache(rdb)
	} else {
		cache.Cache = cache.NewMemoryCache()
	}
}
