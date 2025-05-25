package config

type SQLite struct {
	DbName string `ini:"db_name" comment:"数据库名称"`
}

type MySQL struct {
	Host     string `ini:"host" comment:"数据库主机名或 IP"`
	Port     int    `ini:"port" comment:"数据库端口号"`
	Username string `ini:"username" comment:"用户名"`
	Password string `ini:"password" comment:"密码"`
	DbName   string `ini:"db_name" comment:"数据库名称"`
}

type WebServer struct {
	Host string `ini:"host" comment:"服务器主机名或 IP"`
	Port int    `ini:"port" comment:"服务器端口号"`
	Mode string `ini:"mode" comment:"服务器运行模式，如 debug、release、test"`
}

type Redis struct {
	Host     string `ini:"host" comment:"主机名或 IP"`
	Port     int    `ini:"port" comment:"端口号"`
	Password string `ini:"password" comment:"密码"`
}

type Other struct {
	DbType string `ini:"db_type" comment:"使用的数据库类型，SQLite、MySQL"`
	Data   string `ini:"data" comment:"数据路径"`
	Logs   string `ini:"logs" comment:"日志路径"`
}

type Config struct {
	SQLite    SQLite    `ini:"SQLite"`
	MySQL     MySQL     `ini:"MySQL"`
	Redis     Redis     `ini:"Redis"`
	WebServer WebServer `ini:"WebServer"`
	Other     Other     `ini:"Other"`
}
