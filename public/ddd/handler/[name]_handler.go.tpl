package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/application{{ .AppPath }}"
	"gen_gin_tpl/pkg/enums/enum_code"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
	"net/http"
)

type {{ .StructName }}Handler struct {
	{{ .StructName }}Service *{{ .AppName }}.{{ .StructName }}Service
}

// {{ .StructName }} 列表
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/{{ .DomainPath }} [get]
// @Group 			public
func (h *{{ .StructName }}Handler) {{ .StructName }}(c *gin.Context) {
	data, err := h.{{ .StructName }}Service.Get{{ .StructName }}()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainPath }}")
		return
	}

    resp.JsonSafe(c, enum_code.Success.Desc(), data)
}