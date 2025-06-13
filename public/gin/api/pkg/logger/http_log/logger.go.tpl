package http_log

import (
	"bytes"
	"{{ .ProjectName }}/pkg/logger"
	"github.com/gin-gonic/gin"
	"github.com/rs/zerolog"
	"io/ioutil"
)

// 核心字段统一封装
func _field(_log *zerolog.Event, c *gin.Context) *zerolog.Event {
	return _log.Str("Method", c.Request.Method).
		Str("TraceID", c.GetHeader("X-Trace-Id")).
		Int("Status", c.Writer.Status()).
		Str("ClientIP", c.ClientIP()).
		Str("UserAgent", c.Request.UserAgent()).
		Str("Path", c.Request.URL.Path).
		Str("RequestURI", c.Request.RequestURI).
		Str("Referer", c.Request.Referer()).
		Int("ContentLength", c.Writer.Size())
}

// debug 专用扩展字段
func _addDebugFields(_log *zerolog.Event, c *gin.Context) *zerolog.Event {
	// Safe 读取 body
	var bodyBytes []byte
	if c.Request.Body != nil {
		bodyBytes, _ = ioutil.ReadAll(c.Request.Body)
		// 读取后要重置 body，防止后续读不到
		c.Request.Body = ioutil.NopCloser(bytes.NewBuffer(bodyBytes))
	}

	return _log.
		Bytes("Body", bodyBytes).
		Interface("Header", c.Request.Header).
		Interface("Query", c.Request.URL.Query()).
		Interface("Form", c.Request.PostForm).
		Interface("MultipartForm", c.Request.MultipartForm).
		Str("RemoteAddr", c.Request.RemoteAddr).
		Interface("TLS", c.Request.TLS).
		Interface("Response", c.Writer)
}

// Debug 不同 level 封装
func Debug(c *gin.Context) *zerolog.Event {
	_log := logger.GetLogger(logger.HttpDebug)
	return _addDebugFields(_field(_log.Debug(), c), c)
}

func Info(c *gin.Context) *zerolog.Event {
	_log := logger.GetLogger(logger.HttpInfo)
	return _field(_log.Info(), c)
}

func Warn(c *gin.Context) *zerolog.Event {
	_log := logger.GetLogger(logger.HttpWarn)
	return _field(_log.Warn(), c)
}

func Error(c *gin.Context) *zerolog.Event {
	_log := logger.GetLogger(logger.HttpError)
	return _field(_log.Error(), c).Interface("Errors", c.Errors)
}

func Trace(c *gin.Context) *zerolog.Event {
	_log := logger.GetLogger(logger.HttpTrace)
	return _field(_log.Trace(), c)
}

// Log 仅用于正常请求日志，异常和慢请求请显式调用 Error / Warn
func Log(c *gin.Context) *zerolog.Event {
	switch logger.CurrentCfg.Lvl {
	case zerolog.DebugLevel:
		return Debug(c)
	default:
		return Info(c)
	}
}
