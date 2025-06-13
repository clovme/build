package cache

import (
	"context"
	"sync"
	"time"
)

type memoryItem struct {
	value      string
	expiration int64
}

type memoryCache struct {
	data sync.Map
}

func NewMemoryCache() *memoryCache {
	cache := &memoryCache{}
	go cache.cleaner()
	return cache
}

func (m *memoryCache) Get(ctx context.Context, key string) (string, error) {
	v, ok := m.data.Load(key)
	if !ok {
		return "", nil
	}
	item := v.(memoryItem)
	if item.expiration > 0 && time.Now().UnixNano() > item.expiration {
		m.data.Delete(key)
		return "", nil
	}
	return item.value, nil
}

func (m *memoryCache) Set(ctx context.Context, key string, value string, expiration time.Duration) error {
	var exp int64
	if expiration > 0 {
		exp = time.Now().Add(expiration).UnixNano()
	}
	m.data.Store(key, memoryItem{
		value:      value,
		expiration: exp,
	})
	return nil
}

func (m *memoryCache) Del(ctx context.Context, key string) error {
	m.data.Delete(key)
	return nil
}

func (m *memoryCache) cleaner() {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		now := time.Now().UnixNano()
		m.data.Range(func(key, value any) bool {
			item := value.(memoryItem)
			if item.expiration > 0 && now > item.expiration {
				m.data.Delete(key)
			}
			return true
		})
	}
}
