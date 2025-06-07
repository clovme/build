package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Warn(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpWarn)
	return _log.Warn().
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func WarnM(c *gin.Context, format string) {
	Warn(c).Msg(format)
}

func WarnF(c *gin.Context, format string, args ...any) {
	Warn(c).Msgf(format, args...)
}
