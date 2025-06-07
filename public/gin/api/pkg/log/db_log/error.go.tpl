package db_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Error() *zerolog.Event {
	_log := log.NewLoggers(log.DbError)
	return _log.Error()
}

func ErrorM(format string) {
	Error().Msg(format)
}

func ErrorF(format string, args ...any) {
	Error().Msgf(format, args...)
}
