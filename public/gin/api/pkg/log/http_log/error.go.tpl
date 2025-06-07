package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Error(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpError)
	return _log.Error().
		Interface("error", c.Errors.String()).
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func ErrorM(c *gin.Context, format string) {
	Error(c).Msg(format)
}

func ErrorF(c *gin.Context, format string, args ...any) {
	Error(c).Msgf(format, args...)
}
