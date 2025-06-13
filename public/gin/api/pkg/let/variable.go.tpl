package let

import (
	"github.com/rs/zerolog"
	"sync/atomic"
)

var (
	ConfigPath        string
	SQLitePath        string
	IsEnableEncrypted = false
	IsInitialized     atomic.Bool
	WebTitle          = "{{ .ProjectName }}"
)

var (
	DbType    = []string{"MySQL", "SQLite"}
	CacheType = []string{"Memory", "Redis"}
	Level     = []zerolog.Level{zerolog.TraceLevel, zerolog.DebugLevel, zerolog.InfoLevel, zerolog.WarnLevel, zerolog.ErrorLevel, zerolog.FatalLevel, zerolog.PanicLevel, zerolog.NoLevel, zerolog.Disabled}
)
