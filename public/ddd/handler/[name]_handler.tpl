package {{ .Package }}

import (
	"{{ .ProjectName }}/internal/application{{ .AppPath }}"
	"{{ .ProjectName }}/internal/domain/{{ .DomainPath }}"
	"github.com/gin-gonic/gin"
	"net/http"
)

type {{ .StructName }}Handler struct {
	{{ .StructName }}Service *{{ .AppName }}.{{ .StructName }}Service
}

// List{{ .StructName }}s 列表
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/list/{{ .DomainPath }}s [get]
// @Group 			public
func (h *{{ .StructName }}Handler) List{{ .StructName }}s(c *gin.Context) {
	{{ .DomainPath }}s, err := h.{{ .StructName }}Service.GetAll{{ .StructName }}s()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainPath }}s")
		return
	}

	c.HTML(http.StatusOK, "{{ .DomainPath }}List.html", gin.H{
		"Title": "{{ .StructName }}列表",
		"{{ .DomainName }}s": {{ .DomainPath }}s,
	})
}

// DisableAll{{ .StructName }}s 禁用所有{{ .StructName }}
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/disable_all/{{ .DomainPath }} [get]
// @Group 			public
func (h *{{ .StructName }}Handler) DisableAll{{ .StructName }}s(c *gin.Context) {
	{{ .DomainPath }}s, err := h.{{ .StructName }}Service.GetAll{{ .StructName }}s()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainPath }}s")
		return
	}

	// 新建领域服务
	svc := {{ .DomainPath }}.NewService()
	svc.Disable{{ .DomainName }}s({{ .DomainPath }}s)

	// 保存到数据库
	for i := range {{ .DomainPath }}s {
		_ = h.{{ .StructName }}Service.Repo.Save(&{{ .DomainPath }}s[i])
	}

	c.Redirect(http.StatusFound, "/list/{{ .DomainPath }}s")
}
