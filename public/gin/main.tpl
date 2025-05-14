package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"{{ .ProjectName }}/config"
	"{{ .ProjectName }}/routers"
)

func main() {
	cfg := config.GetConfig()
	ipPost := fmt.Sprintf("%s:%d", cfg.Server.Host, cfg.Server.Port)

	log.Println(fmt.Sprintf("地址端口：http://%s", ipPost))

	engine := gin.Default()

	routers.Initialization(engine)
	if err := engine.Run(ipPost); err != nil {
		log.Fatalf("WEB 服务器启动失败: %v", err)
	}
}
