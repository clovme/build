package utils

// SetConfig 设置配置
func SetConfig[T comparable](key *T, value, defaultValue T, enable bool) {
	*key = value
	if !enable {
		*key = defaultValue
	}
}

// SetByteConfig 设置配置
func SetByteConfig(key *[]byte, value, defaultValue []byte, enable bool) {
	*key = value
	if !enable {
		*key = defaultValue
	}
}
