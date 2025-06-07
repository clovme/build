package app_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Info() *zerolog.Event {
	_log := log.NewLoggers(log.AppInfo)
	return _log.Info()
}

func InfoM(format string) {
	Info().Msg(format)
}

func InfoF(format string, args ...any) {
	Info().Msgf(format, args...)
}
