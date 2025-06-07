package app_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Debug() *zerolog.Event {
	_log := log.NewLoggers(log.AppDebug)
	return _log.Debug()
}

func DebugM(format string) {
	Debug().Msg(format)
}

func DebugF(format string, args ...any) {
	Debug().Msgf(format, args...)
}
