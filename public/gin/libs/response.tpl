package libs

import (
	"{{ .ProjectName }}/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

type HttpResponse struct {
	*gorm.DB     `json:"-"`
	*gin.Context `json:"-"`
	User         models.Users `json:"-"`
	Code         int          `json:"code"`
	Message      string       `json:"message"`
	Data         interface{}  `json:"data,omitempty"`
}

func (s *HttpResponse) Msg(code int, message string) {
	s.Code = code
	s.Message = message
	s.Context.JSON(http.StatusOK, s)
}

func (s *HttpResponse) Json(code int, message string, data interface{}) {
	s.Code = code
	s.Message = message
	s.Data = data
	s.Context.JSON(http.StatusOK, s)
}

func Context(c *gin.Context) HttpResponse {
	return c.MustGet("$").(HttpResponse)
}
