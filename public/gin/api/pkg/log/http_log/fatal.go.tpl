package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Fatal(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpFatal)
	return _log.Fatal().
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func FatalM(c *gin.Context, format string) {
	Fatal(c).Msg(format)
}

func FatalF(c *gin.Context, format string, args ...any) {
	Fatal(c).Msgf(format, args...)
}
