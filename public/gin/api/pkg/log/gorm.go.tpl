package log

import (
	"context"
	"gorm.io/gorm/logger"
	"time"
)

type GormLogger struct {
	level logger.LogLevel
}

func NewGormLogger(level logger.LogLevel) *GormLogger {
	return &GormLogger{
		level: level,
	}
}

func (l *GormLogger) LogMode(level logger.LogLevel) logger.Interface {
	newlogger := *l
	newlogger.level = level
	return &newlogger
}

func (l *GormLogger) Info(ctx context.Context, s string, args ...interface{}) {
	if l.level >= logger.Info {
		_log := loggers[DbInfo]
		_log.Info().Msgf(s, args...)
	}
}

func (l *GormLogger) Warn(ctx context.Context, s string, args ...interface{}) {
	if l.level >= logger.Warn {
		_log := loggers[DbWarn]
		_log.Warn().Msgf(s, args...)
	}
}

func (l *GormLogger) Error(ctx context.Context, s string, args ...interface{}) {
	if l.level >= logger.Error {
		_log := loggers[DbError]
		_log.Error().Msgf(s, args...)
	}
}

func (l *GormLogger) Trace(ctx context.Context, begin time.Time, fc func() (string, int64), err error) {
	elapsed := time.Since(begin)
	sql, rows := fc()

	switch {
	case err != nil && l.level >= logger.Error:
		_log := loggers[DbError]
		_log.Error().Err(err).Msgf("[%.3fms] [rows:%v] %s", float64(elapsed.Milliseconds()), rows, sql)

	case elapsed > 200*time.Millisecond && l.level >= logger.Warn: // 慢查询阈值可以调
		_log := loggers[DbWarn]
		_log.Warn().Msgf("[SLOW SQL >=200ms] [%.3fms] [rows:%v] %s", float64(elapsed.Milliseconds()), rows, sql)

	case l.level >= logger.Info:
		_log := loggers[DbInfo]
		_log.Info().Msgf("[%.3fms] [rows:%v] %s", float64(elapsed.Milliseconds()), rows, sql)
	}
}
