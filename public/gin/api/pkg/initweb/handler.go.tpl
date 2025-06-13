package initweb

import (
	"fmt"
	"{{ .ProjectName }}/internal/bootstrap/initialize"
	"{{ .ProjectName }}/pkg/constants/vt"
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

func viewHandler(c *gin.Context) {
	c.HTML(http.StatusOK, "index.html", gin.H{
		"Title": let.WebTitle,
	})
}

func formHandler(c *gin.Context) {
	loggerLevel := &[]map[string]interface{}{
		{"value": "trace", "label": "trace", "desc": "细粒度最高，最大量日志"},
		{"value": "debug", "label": "debug", "desc": "调试日志"},
		{"value": "info", "label": "info", "desc": "常规运行状态日志"},
		{"value": "warn", "label": "warn", "desc": "警告，非致命异常"},
		{"value": "error", "label": "error", "desc": "错误日志，功能异常"},
		{"value": "fatal", "label": "fatal", "desc": "致命错误，程序即将终止"},
		{"value": "panic", "label": "panic", "desc": "更严重，触发 panic 行为"},
		{"value": "no", "label": "no", "desc": "没有级别，适合特殊用途"},
		{"value": "disabled", "label": "disabled", "desc": "禁止所有日志"},
	}
	Web := []Form{
		{Field: "WebHost", Title: "监听地址", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "WebPort", Title: "监听端口", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
	}
	Redis := []Form{
		{Field: "RedisHost", Title: "主机地址", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "RedisPort", Title: "端口号", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "RedisPassword", Title: "密码", Span: 24, ItemRender: ItemRender{Name: "VxeInput", Props: &Props{Type: password}}},
		{Field: "RedisDB", Title: "选择数据库", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}},
	}
	SQLite := []Form{
		{Field: "SQLiteDbName", Title: "数据库名称", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}},
	}
	MySQL := []Form{
		{Field: "MySQLHost", Title: "主机地址", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "MySQLPort", Title: "端口号", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "MySQLUsername", Title: "用户名", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "MySQLPassword", Title: "密码", Span: 24, ItemRender: ItemRender{Name: "VxeInput", Props: &Props{Type: password}}},
		{Field: "MySQLDbName", Title: "数据库名称", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}},
	}
	Logger := []Form{
		{Field: "LoggerLevel", Title: "日志级别", Span: 12, ItemRender: ItemRender{Name: "VxeTableSelect", Props: &Props{Columns: &[]Columns{{Field: "label", Title: "日志级别"}, {Field: "desc", Title: "日志描述"}}}, Options: loggerLevel}},
		{Field: "LoggerMaxSize", Title: "分割大小(MB)", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "LoggerLogs", Title: "日志路径", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "LoggerFormatJson", Title: "JSON/文本", Span: 8, ItemRender: ItemRender{Name: vxeSelect, Options: &[]map[string]interface{}{{"label": "JSON", "content": true, "value": true}, {"label": "文本", "content": false, "value": false}}}},
		{Field: "LoggerCompress", Title: "启用压缩", Span: 16, ItemRender: ItemRender{Name: vxeSelect, Options: &[]map[string]interface{}{{"label": "启用", "content": true, "value": true}, {"label": "禁用", "content": false, "value": false}}}},
		{Field: "LoggerMaxAge", Title: "保存天数(天)", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
		{Field: "LoggerMaxBackups", Title: "保留数量(个)", Span: 12, ItemRender: ItemRender{Name: "VxeInput"}},
	}
	OtherDbType := &[]map[string]interface{}{
		{"label": vt.SQLite, "content": vt.SQLite, "value": vt.SQLite},
		{"label": vt.MySQL, "content": vt.MySQL, "value": vt.MySQL},
	}
	OtherCacheType := &[]map[string]interface{}{
		{"label": vt.Memory, "content": vt.Memory, "value": vt.Memory},
		{"label": vt.Redis, "content": vt.Redis, "value": vt.Redis},
	}

	rules := map[string][]Rules{
		"OtherDataPath":    {{Required: true, Message: "请选择数据存放位置"}},
		"SQLiteDbName":     {{Required: true, Message: "SQLite 数据库名称"}},
		"MySQLHost":        {{Required: true, Message: "请输入主机地址"}},
		"MySQLPort":        {{Required: true, Type: numberType, Min: 1024, Max: 65535, Message: "请输入(1024~65535)范围内的端口号"}},
		"MySQLUsername":    {{Required: true, Message: "请输入用户名"}},
		"MySQLDbName":      {{Required: true, Message: "请输入数据库名称"}},
		"WebHost":          {{Required: true, Message: "请输入主机地址"}},
		"WebPort":          {{Required: true, Type: numberType, Min: 1024, Max: 65535, Message: "请输入(1024~65535)范围内的端口号"}},
		"RedisHost":        {{Required: true, Message: "请输入主机地址"}},
		"RedisPort":        {{Required: true, Type: numberType, Min: 1024, Max: 65535, Message: "请输入(1024~65535)范围内的端口号"}},
		"RedisDB":          {{Required: true, Type: numberType, Min: 0, Max: 15, Message: "请输入(0~15)范围内的端口号"}},
		"LoggerLogs":       {{Required: true, Message: "请输入日志存放路径"}},
		"LoggerMaxSize":    {{Required: true, Type: numberType, Min: 0, Message: "分割大小(>MB)"}},
		"LoggerMaxAge":     {{Required: true, Type: numberType, Min: 1, Message: "保存天数(天) > 1"}},
		"LoggerMaxBackups": {{Required: true, Type: numberType, Min: 0, Message: "旧日志数量 > 0"}},
	}

	form := FormOptions{
		Border:          true,
		TitleColon:      false,
		TitleWidth:      120,
		TitleAlign:      "right",
		TitleBackground: true,
		ValidConfig: &ValidConfig{
			Theme: normalTheme,
		},
		FormData: &FormData{
			OtherDbType:      cfg.Other.DbType,
			OtherCacheType:   cfg.Other.CacheType,
			OtherDataPath:    cfg.Other.DataPath,
			SQLiteDbName:     cfg.SQLite.DbName,
			MySQLHost:        cfg.MySQL.Host,
			MySQLPort:        cfg.MySQL.Port,
			MySQLUsername:    cfg.MySQL.Username,
			MySQLPassword:    cfg.MySQL.Password,
			MySQLDbName:      cfg.MySQL.DbName,
			WebHost:          cfg.Web.Host,
			WebPort:          cfg.Web.Port,
			RedisHost:        cfg.Redis.Host,
			RedisPort:        cfg.Redis.Port,
			RedisPassword:    cfg.Redis.Password,
			RedisDB:          cfg.Redis.DB,
			LoggerLevel:      cfg.Logger.Level,
			LoggerLogs:       cfg.Logger.Logs,
			LoggerFormatJson: cfg.Logger.FormatJSON,
			LoggerCompress:   cfg.Logger.Compress,
			LoggerMaxSize:    cfg.Logger.MaxSize,
			LoggerMaxAge:     cfg.Logger.MaxAge,
			LoggerMaxBackups: cfg.Logger.MaxBackups,
		},
		Rules: &rules,
		FormItems: []FormItems{
			{Span: 24, Vertical: true, TitleBold: true, Title: "数据库选择", Children: &[]Form{
				{Field: "OtherDbType", Title: "数据库类型", Span: 12, ItemRender: ItemRender{Name: vxeSelect, Options: OtherDbType}},
				{Field: "OtherCacheType", Title: "缓存数据库", Span: 12, ItemRender: ItemRender{Name: vxeSelect, Options: OtherCacheType}},
			}},
			{Span: 24, Vertical: true, TitleBold: true, Title: "SQLite 配置", Children: &SQLite, ShowWhen: &ShowWhen{Field: "OtherDbType", Value: vt.SQLite}},
			{Span: 24, Vertical: true, TitleBold: true, Title: "MySQL 配置", Children: &MySQL, ShowWhen: &ShowWhen{Field: "OtherDbType", Value: vt.MySQL}},
			{Span: 24, Vertical: true, TitleBold: true, Title: "Redis 配置", Children: &Redis, ShowWhen: &ShowWhen{Field: "OtherCacheType", Value: vt.Redis}},
			{Span: 24, Vertical: true, TitleBold: true, Title: "Web 配置", Children: &Web},
			{Span: 24, Vertical: true, TitleBold: true, Title: "系统日志配置", Children: &Logger},
			{Span: 24, Vertical: true, TitleBold: true, Title: "其他配置", Children: &[]Form{{Field: "OtherDataPath", Title: "数据存放路径", Span: 24, ItemRender: ItemRender{Name: "VxeInput"}}}},
			{Span: 24, Children: &[]Form{
				{Align: "center", Span: 24, ItemRender: ItemRender{Name: "VxeButtonGroup", Options: &[]map[string]interface{}{{"type": "submit", "content": "保存配置", "status": "primary"}}}},
			}},
		},
	}
	resp.JsonUnSafe(c, em_http.Success.Desc(), form)
}

func postHandler(c *gin.Context) {
	var data FormData

	if err := c.ShouldBindJSON(&data); err != nil {
		resp.JsonUnSafeCode(c, em_http.ErrUnknown, "参数格式错误", nil)
		return
	}

	cfg.SQLite.DbName = data.SQLiteDbName

	cfg.MySQL.Host = data.MySQLHost
	cfg.MySQL.Port = data.MySQLPort
	cfg.MySQL.Username = data.MySQLUsername
	cfg.MySQL.Password = data.MySQLPassword
	cfg.MySQL.DbName = data.MySQLDbName

	cfg.Web.Host = data.WebHost
	cfg.Web.Port = data.WebPort

	cfg.Redis.Host = data.RedisHost
	cfg.Redis.Port = data.RedisPort
	cfg.Redis.Password = data.RedisPassword
	cfg.Redis.DB = data.RedisDB

	cfg.Logger.Level = data.LoggerLevel
	cfg.Logger.MaxSize = data.LoggerMaxSize
	cfg.Logger.Logs = data.LoggerLogs
	cfg.Logger.FormatJSON = data.LoggerFormatJson
	cfg.Logger.Compress = data.LoggerCompress
	cfg.Logger.MaxAge = data.LoggerMaxAge
	cfg.Logger.MaxBackups = data.LoggerMaxBackups

	cfg.Other.DbType = data.OtherDbType
	cfg.Other.CacheType = data.OtherCacheType
	cfg.Other.DataPath = data.OtherDataPath

	initialize.InitLogger(cfg.Logger)

	if strings.EqualFold(cfg.Other.DbType, vt.MySQL) {
		db, err := initialize.CheckDbConnect(cfg.MySQL)
		if err != nil {
			resp.JsonUnSafeCode(c, em_http.ErrUnknown, fmt.Sprintf("MySQL参数错误，%s", err), nil)
			return
		}
		defer db.Close()
	}

	if strings.EqualFold(cfg.Other.CacheType, vt.Redis) {
		_, err := initialize.CacheRedis(cfg.Redis)
		if err != nil {
			resp.JsonUnSafeCode(c, em_http.ErrUnknown, fmt.Sprintf("Redis 连接失败: %v", err), nil)
			return
		}
	}

	stopInitialization()
	resp.JsonUnSafe(c, fmt.Sprintf("http://%s:%d", cfg.Web.Host, cfg.Web.Port), nil)
}
