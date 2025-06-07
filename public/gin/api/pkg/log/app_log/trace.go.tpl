package app_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Trace() *zerolog.Event {
	_log := log.NewLoggers(log.AppTrace)
	return _log.Trace()
}

func TraceM(format string) {
	Trace().Msg(format)
}

func TraceF(format string, args ...any) {
	Trace().Msgf(format, args...)
}
