package log

import (
	"fmt"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gopkg.in/natefinch/lumberjack.v2"
	"io"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

const (
	AppDebug = "app_debug"
	AppInfo  = "app_info"
	AppWarn  = "app_warn"
	AppError = "app_error"
	AppFatal = "app_fatal"
	AppPanic = "app_panic"
	AppTrace = "app_trace"

	HttpDebug = "http_debug"
	HttpInfo  = "http_info"
	HttpWarn  = "http_warn"
	HttpError = "http_error"
	HttpFatal = "http_fatal"
	HttpPanic = "http_panic"
	HttpTrace = "http_trace"

	DbDebug = "db_debug"
	DbInfo  = "db_info"
	DbWarn  = "db_warn"
	DbError = "db_error"
	DbFatal = "db_fatal"
	DbPanic = "db_panic"
	DbTrace = "db_trace"
)

type LoggerConfig struct {
	Dir        string // 日志目录，如 ./logs
	MaxSize    int    // MB
	MaxBackups int    // 个数
	MaxAge     int    // 天
	Compress   bool
	FormatJSON bool   // 是否 JSON 格式
	Level      string // 最低输出级别，如 debug、info、error
}

var (
	consoleWriter io.Writer
	loggers       map[string]zerolog.Logger
	mu            sync.RWMutex
	initialized   bool
	CurrentCfg    LoggerConfig
)

var loc, _ = time.LoadLocation("Asia/Shanghai")

func formatTimestamp(i interface{}) string {
	return time.Now().In(loc).Format("[2006-01-02 15:04:05]")
}

func formatLevel(i interface{}) string {
	return strings.ToUpper(fmt.Sprintf("[%s]", i))
}

func InitLogger(cfg LoggerConfig) {
	CurrentCfg = cfg
	mu.Lock()
	defer mu.Unlock()

	if initialized {
		return
	}

	zerolog.TimeFieldFormat = "[2006-01-02 15:04:05]"

	zerolog.TimestampFunc = func() time.Time {
		return time.Now().In(loc)
	}

	// 控制台输出
	consoleWriter = zerolog.ConsoleWriter{
		Out:             os.Stdout,
		NoColor:         false,
		FormatTimestamp: formatTimestamp,
		FormatLevel:     formatLevel,
	}

	loggers = make(map[string]zerolog.Logger)

	levels := []zerolog.Level{
		zerolog.DebugLevel,
		zerolog.InfoLevel,
		zerolog.WarnLevel,
		zerolog.ErrorLevel,
		zerolog.FatalLevel,
		zerolog.PanicLevel,
	}

	for _, level := range levels {
		for _, t := range []string{"app", "http", "db"} {
			fileName := filepath.Join(cfg.Dir, level.String(), fmt.Sprintf("%s.log", t))
			fileWriter := &lumberjack.Logger{
				Filename:   fileName,
				MaxSize:    cfg.MaxSize,
				MaxBackups: cfg.MaxBackups,
				MaxAge:     cfg.MaxAge,
				Compress:   cfg.Compress,
			}

			var writer io.Writer
			if cfg.FormatJSON {
				writer = io.MultiWriter(consoleWriter, fileWriter)
			} else {
				textWriter := zerolog.ConsoleWriter{
					Out:             fileWriter,
					NoColor:         true,
					FormatTimestamp: formatTimestamp,
					FormatLevel:     formatLevel,
				}
				writer = io.MultiWriter(consoleWriter, textWriter)
			}

			if t == "db" {
				loggers[fmt.Sprintf("%s_%s", t, level.String())] = zerolog.New(writer).Level(level).With().Timestamp().Logger()
			} else {
				loggers[fmt.Sprintf("%s_%s", t, level.String())] = zerolog.New(writer).Level(level).With().Caller().Timestamp().Logger()
			}
		}
	}

	// 替换默认 log
	lvl, err := zerolog.ParseLevel(strings.ToLower(cfg.Level))
	if err != nil {
		lvl = zerolog.InfoLevel
	}
	log.Logger = loggers[lvl.String()]
	initialized = true
}

func NewLoggers(filename string) zerolog.Logger {
	return loggers[filename]
}
