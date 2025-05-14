package config

type sQLite struct {
	Database string `ini:"database"`
}

type server struct {
	Host string `ini:"host"`
	Port int    `ini:"port"`
	Mode string `ini:"mode"`
}

type mySQL struct {
	Host     string `ini:"host"`
	Port     int    `ini:"port"`
	Username string `ini:"username"`
	Password string `ini:"password"`
	Database string `ini:"database"`
}

type redis struct {
	Host     string `ini:"host"`
	Port     int    `ini:"port"`
	Password string `ini:"password"`
}

type other struct {
	Node string `ini:"node"`
}

type config struct {
	SQLite sQLite `ini:"SQLite"`
	MySQL  mySQL  `ini:"MySQL"`
	Redis  redis  `ini:"Redis"`
	Server server `ini:"Server"`
	Other  other  `ini:"Other"`
}
