package app_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Panic() *zerolog.Event {
	_log := log.NewLoggers(log.AppPanic)
	return _log.Panic()
}

func PanicM(format string) {
	Panic().Msg(format)
}

func PanicF(format string, args ...any) {
	Panic().Msgf(format, args...)
}
