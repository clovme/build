package config

type SQLite struct {
	DbName string `ini:"db_name" json:"db_name" comment:"数据库名称，用于指定 SQLite 数据库文件名"`
}

type MySQL struct {
	Host     string `ini:"host" json:"host" comment:"MySQL 服务器地址，支持域名或 IP"`
	Port     int    `ini:"port" json:"port" comment:"MySQL 服务器端口号"`
	Username string `ini:"username" json:"username" comment:"连接 MySQL 的用户名"`
	Password string `ini:"password" json:"password" comment:"连接 MySQL 的密码"`
	DbName   string `ini:"db_name" json:"db_name" comment:"MySQL 数据库名称"`
}

type Web struct {
	Host string `ini:"host" json:"host" comment:"Web 服务器监听地址，通常为 IP 或域名"`
	Port int    `ini:"port" json:"port" comment:"Web 服务器监听端口"`
}

type Redis struct {
	Host     string `ini:"host" json:"host" comment:"Redis 服务器地址，支持域名或 IP"`
	Port     int    `ini:"port" json:"port" comment:"Redis 服务器端口"`
	Password string `ini:"password" json:"password" comment:"Redis 连接密码，若无密码则为空"`
	DB       int    `ini:"db" json:"db" comment:"Redis 数据库索引，默认为 0"`
}

type Logger struct {
	Level      string `ini:"level" json:"level" comment:"数据库日志级别 info > warn > error > silent  silent 不记录任何日志，相当于disabled\n; 系统日志级别   trace > debug > info > warn > error > fatal > panic > no > disabled\n; trace 细粒度最高，最大量日志\n; debug 调试日志\n; info  常规运行状态日志\n; warn  警告，非致命异常\n; error 错误日志，功能异常\n; fatal 致命错误，程序即将终止\n; panic 更严重，触发 panic 行为\n; no    没有级别，适合特殊用途\n; disabled   禁止所有日志"`
	MaxSize    int    `ini:"max_size" json:"max_size" comment:"单个日志文件最大尺寸，单位为 MB，超过该大小将触发日志切割"`
	Logs       string `ini:"logs" json:"logs" comment:"日志文件存放路径"`
	FormatJSON bool   `ini:"format_json" json:"format_json" comment:"文件日志输出格式，true 表示结构化 JSON，false 表示纯文本"`
	Compress   bool   `ini:"compress" json:"compress" comment:"是否压缩旧日志文件，开启后使用 gzip 格式压缩"`
	MaxAge     int    `ini:"max_age" json:"max_age" comment:"日志文件最大保存天数，超过该天数的日志文件将被删除"`
	MaxBackups int    `ini:"max_backups" json:"max_backups" comment:"保留旧日志文件的最大数量，超过时自动删除最早的日志"`
}

type Other struct {
	DbType    string `ini:"db_type" json:"db_type" comment:"所使用的数据库类型，支持 SQLite 或 MySQL"`
	CacheType string `ini:"cache_type" json:"cache_type" comment:"所使用的数据库类型，支持 Memory 或 Redis"`
	DataPath  string `ini:"data_path" json:"data_path" comment:"数据存储路径"`
}

type Config struct {
	SQLite SQLite `ini:"SQLite" json:"SQLite"`
	MySQL  MySQL  `ini:"MySQL" json:"MySQL"`
	Redis  Redis  `ini:"Redis" json:"Redis"`
	Web    Web    `ini:"Web" json:"Web"`
	Logger Logger `ini:"Logger" json:"Logger"`
	Other  Other  `ini:"Other" json:"Other"`
}
