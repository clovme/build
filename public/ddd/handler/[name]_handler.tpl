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
// @Router			/list/{{ .DomainName }}s [get]
// @Group 			views
func (h *{{ .StructName }}Handler) List{{ .StructName }}s(c *gin.Context) {
	{{ .DomainName }}s, err := h.{{ .StructName }}Service.GetAll{{ .StructName }}s()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainName }}s")
		return
	}

	c.HTML(http.StatusOK, "{{ .DomainName }}List.html", gin.H{
		"Title": "{{ .StructName }}列表",
		"{{ .DomainName }}s": {{ .DomainName }}s,
	})
}

// DisableAll{{ .StructName }}s 禁用所有{{ .StructName }}
// @Summary			HTML首页
// @Description 	HTML首页
// @Tags        	HTML首页
// @Accept       	text/html
// @Produce      	text/html
// @Success      	200  text/html  text/html
// @Router			/disable_all/{{ .DomainName }} [get]
// @Group 			views
func (h *{{ .StructName }}Handler) DisableAll{{ .StructName }}s(c *gin.Context) {
	{{ .DomainName }}s, err := h.{{ .StructName }}Service.GetAll{{ .StructName }}s()
	if err != nil {
		c.String(http.StatusInternalServerError, "Failed to get {{ .DomainName }}s")
		return
	}

	// 新建领域服务
	svc := {{ .DomainName }}.NewService()
	svc.Disable{{ .EntityName }}s({{ .DomainName }}s)

	// 保存到数据库
	for i := range {{ .DomainName }}s {
		_ = h.{{ .StructName }}Service.Repo.Save(&{{ .DomainName }}s[i])
	}

	c.Redirect(http.StatusFound, "/list/{{ .DomainName }}s")
}
