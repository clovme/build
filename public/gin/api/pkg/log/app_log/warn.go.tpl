package app_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Warn() *zerolog.Event {
	_log := log.NewLoggers(log.AppWarn)
	return _log.Warn()
}

func WarnM(format string) {
	Warn().Msg(format)
}

func WarnF(format string, args ...any) {
	Warn().Msgf(format, args...)
}
