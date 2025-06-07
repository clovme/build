package api

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/pkg/enums/enum_code"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
)

type ConfigHandler struct {
	ConfigService *application.ConfigService
}

// Config 列表
// @Router			/config [get]
// @Group 			public
func (h *ConfigHandler) Config(c *gin.Context) {
	config, err := h.ConfigService.GetConfig()
	if err != nil {
		resp.JsonSafeCode(c, enum_code.ErrInternal, "Failed to get config", nil)
		return
	}

	resp.JsonSafe(c, enum_code.Success.Desc(), config)
}
