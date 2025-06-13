package web

import (
	"{{ .ProjectName }}/internal/application"
	"{{ .ProjectName }}/pkg/resp"
	"github.com/gin-gonic/gin"
)

type ViewIndexHandler struct {
	ViewIndexService *application.ViewIndexService
}

// IndexView
// @Router			/ [get]
// @Group 			noAuthView
func (h *ViewIndexHandler) IndexView(c *gin.Context) {
	resp.HtmlUnSafe(c, "index.html", nil)
}
