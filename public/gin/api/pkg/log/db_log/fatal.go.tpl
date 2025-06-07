package db_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/rs/zerolog"
)

func Fatal() *zerolog.Event {
	_log := log.NewLoggers(log.DbFatal)
	return _log.Fatal()
}

func FatalM(format string) {
	Fatal().Msg(format)
}

func FatalF(format string, args ...any) {
	Fatal().Msgf(format, args...)
}
