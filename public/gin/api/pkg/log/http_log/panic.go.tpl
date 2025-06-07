package http_log

import (
	"{{ .ProjectName }}/pkg/log"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
)

func Panic(c *gin.Context) *zerolog.Event {
	_log := log.NewLoggers(log.HttpPanic)
	return _log.Panic().
		Str("Method", c.Request.Method).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path)
}

func PanicM(c *gin.Context, format string) {
	Panic(c).Msg(format)
}

func PanicF(c *gin.Context, format string, args ...any) {
	Panic(c).Msgf(format, args...)
}
