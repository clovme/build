package initweb

import (
	"context"
	"{{ .ProjectName }}/pkg/config"
	"{{ .ProjectName }}/pkg/let"
	"github.com/gin-gonic/gin"
	"net/http"
	"sync"
	"time"
)

var (
	cfg    *config.Config
	server *http.Server
	wg     sync.WaitGroup
)

func Initialization(c *config.Config) {
	cfg = c
	wg.Add(1) // +1 表示有个协程要等

	go initWebServer()

	// 阻塞，等上面那个协程跑完再继续
	wg.Wait()

	gin.SetMode(gin.ReleaseMode)
}

func stopInitialization() {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if server != nil {
		server.Shutdown(ctx)
	}
	let.IsInitialized.Store(true)
}
