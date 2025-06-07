package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Info(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpInfo)
	return _log.Info().
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func InfoM(c *gin.Context, format string) {
	Info(c).Msg(format)
}

func InfoF(c *gin.Context, format string, args ...any) {
	Info(c).Msgf(format, args...)
}
