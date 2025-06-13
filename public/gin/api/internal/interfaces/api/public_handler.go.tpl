package api

import (
	"encoding/base64"
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/resp"
	"{{ .ProjectName }}/public"
	"github.com/gin-gonic/gin"
)

type PublicHandler struct {
	PublicService *application.PublicService
}

// PublicKey 公钥
// @Router			/public/key [get]
// @Group 			public
func (h *PublicHandler) PublicKey(c *gin.Context) {
	data := base64.StdEncoding.EncodeToString(public.PublicPEM)
	for i := 0; i < 10; i++ {
		data = base64.StdEncoding.EncodeToString([]byte(data))
	}
	resp.StringSafe(c, data)
}

// HttpCode 自定义Http状态码
// @Router			/public/code [get]
// @Group 			public
func (h *PublicHandler) HttpCode(c *gin.Context) {
	enums, err := h.PublicService.GetEnums()
	if err != nil {
		return
	}
	resp.JsonSafe(c, em_http.Success.Desc(), enums)
}

// Ping 自定义Http状态码
// @Router			/public/ping [get]
// @Group 			public
func (h *PublicHandler) Ping(c *gin.Context) {
	resp.JsonUnSafe(c, em_http.Success.Desc(), nil)
}
