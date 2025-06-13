package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/application{{ .AppPath }}"
	"gen_gin_tpl/pkg/enums/em_code"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
	"net/http"
)

type {{ .StructName }}Handler struct {
	{{ .StructName }}Service *{{ .AppName }}.{{ .StructName }}Service
}

// {{ .StructName }}
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/{{ .Router }} [get]
// @Group 			public
func (h *{{ .StructName }}Handler) {{ .StructName }}(c *gin.Context) {
	data, err := h.{{ .StructName }}Service.Get{{ .StructName }}()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainPath }}")
		return
	}

    resp.JsonSafe(c, em_code.Success.Desc(), data)
}