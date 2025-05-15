package config

type SQLite struct {
	Database string `ini:"database"`
}

type Server struct {
	Host string `ini:"host"`
	Port int    `ini:"port"`
	Mode string `ini:"mode"`
}

type MySQL struct {
	Host     string `ini:"host"`
	Port     int    `ini:"port"`
	Username string `ini:"username"`
	Password string `ini:"password"`
	Database string `ini:"database"`
}

type Redis struct {
	Host     string `ini:"host"`
	Port     int    `ini:"port"`
	Password string `ini:"password"`
}

type Other struct {
	Db   string `ini:"db"`
	Node string `ini:"node"`
	Data string `ini:"data"`
	Logs string `ini:"logs"`
}

type Config struct {
	SQLite SQLite `ini:"SQLite"`
	MySQL  MySQL  `ini:"MySQL"`
	Redis  Redis  `ini:"Redis"`
	Server Server `ini:"Server"`
	Other  Other  `ini:"Other"`
}
