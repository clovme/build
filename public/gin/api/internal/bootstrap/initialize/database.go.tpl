package initialize

import (
	"database/sql"
	"fmt"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/logger/log"
)

func CheckDbConnect(cfg config.MySQL) (*sql.DB, error) {
	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%d)/", cfg.Username, cfg.Password, cfg.Host, cfg.Port))
	if err != nil {
		log.Error().Err(err).Msg("[数据库初始化] 数据库连接失败")
		return nil, err
	}

	if err = db.Ping(); err != nil {
		log.Error().Err(err).Msg("[数据库初始化] 无法建立数据库连接")
		return nil, err
	}
	return db, nil
}
