package config

type SQLite struct {
	DbName string `ini:"db_name" comment:"数据库名称，用于指定 SQLite 数据库文件名"`
}

type MySQL struct {
	Host     string `ini:"host" comment:"MySQL 服务器地址，支持域名或 IP"`
	Port     int    `ini:"port" comment:"MySQL 服务器端口号"`
	Username string `ini:"username" comment:"连接 MySQL 的用户名"`
	Password string `ini:"password" comment:"连接 MySQL 的密码"`
	DbName   string `ini:"db_name" comment:"MySQL 数据库名称"`
}

type Web struct {
	Host string `ini:"host" comment:"Web 服务器监听地址，通常为 IP 或域名"`
	Port int    `ini:"port" comment:"Web 服务器监听端口"`
	Mode string `ini:"mode" comment:"运行模式，支持 debug、release、test 等环境配置"`
}

type Redis struct {
	Host     string `ini:"host" comment:"Redis 服务器地址，支持域名或 IP"`
	Port     int    `ini:"port" comment:"Redis 服务器端口"`
	Password string `ini:"password" comment:"Redis 连接密码，若无密码则为空"`
}

type Logger struct {
	Level      string `ini:"level" comment:"日志级别，debug、info、warn、error、fatal、panic、no、disabled、trace"`
	MaxSize    int    `ini:"max_size" comment:"单个日志文件最大尺寸，单位为 MB，超过该大小将触发日志切割"`
	Logs       string `ini:"logs" comment:"日志文件存放路径"`
	FormatJSON bool   `ini:"format_json" comment:"文件日志输出格式，true 表示结构化 JSON，false 表示纯文本"`
	Compress   bool   `ini:"compress" comment:"是否压缩旧日志文件，开启后使用 gzip 格式压缩"`
	MaxAge     int    `ini:"max_age" comment:"日志文件最大保存天数，超过该天数的日志文件将被删除"`
	MaxBackups int    `ini:"max_backups" comment:"保留旧日志文件的最大数量，超过时自动删除最早的日志"`
}

type Other struct {
	DbType string `ini:"db_type" comment:"所使用的数据库类型，支持 SQLite 或 MySQL"`
	Data   string `ini:"data" comment:"数据存储路径"`
}

type Config struct {
	SQLite SQLite `ini:"SQLite"`
	MySQL  MySQL  `ini:"MySQL"`
	Redis  Redis  `ini:"Redis"`
	Web    Web    `ini:"Web"`
	Logger Logger `ini:"Logger"`
	Other  Other  `ini:"Other"`
}
