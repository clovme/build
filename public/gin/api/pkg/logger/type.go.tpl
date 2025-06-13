package logger

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
	HttpTrace = "http_trace"

	DbInfo  = "db_info"
	DbWarn  = "db_warn"
	DbError = "db_error"
)

// CallerWithSkipFrameCount 调用者跳过的帧数
var callerSkipFrames = map[string]int{
	"db":  8,
	"app": 2,
}
