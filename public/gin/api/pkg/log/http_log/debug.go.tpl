package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Debug(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpDebug)
	return _log.Debug().
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func DebugM(c *gin.Context, format string) {
	Debug(c).Msg(format)
}

func DebugF(c *gin.Context, format string, args ...any) {
	Debug(c).Msgf(format, args...)
}
