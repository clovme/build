package utils

import "{{ .ProjectName }}/pkg/enums/em_status"

// SetConfig 设置配置
func SetConfig[T comparable](key *T, value, defaultValue T, s em_status.Status) {
	*key = value
	if !s.Is(em_status.Enable) {
		*key = defaultValue
	}
}

// SetByteConfig 设置配置
func SetByteConfig(key *[]byte, value, defaultValue []byte, s em_status.Status) {
	*key = value
	if !s.Is(em_status.Enable) {
		*key = defaultValue
	}
}
