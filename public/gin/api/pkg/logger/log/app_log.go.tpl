package log

import (
	"{{ .ProjectName }}/pkg/logger"
	"github.com/rs/zerolog"
)

func Debug() *zerolog.Event {
	_log := logger.GetLogger(logger.AppDebug)
	return _log.Debug()
}

func Error() *zerolog.Event {
	_log := logger.GetLogger(logger.AppError)
	return _log.Error()
}

func Fatal() *zerolog.Event {
	_log := logger.GetLogger(logger.AppFatal)
	return _log.Fatal()
}

func Info() *zerolog.Event {
	_log := logger.GetLogger(logger.AppInfo)
	return _log.Info()
}

func Panic() *zerolog.Event {
	_log := logger.GetLogger(logger.AppPanic)
	return _log.Panic()
}

func Trace() *zerolog.Event {
	_log := logger.GetLogger(logger.AppTrace)
	return _log.Trace()
}

func Warn() *zerolog.Event {
	_log := logger.GetLogger(logger.AppWarn)
	return _log.Warn()
}
