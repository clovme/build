package libs

import (
	"{{ .ProjectName }}/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

type Response struct {
	*gorm.DB     `json:"-"`
	*gin.Context `json:"-"`
	User         models.Users   `json:"-"`
	Code         int            `json:"code"`
	Message      string         `json:"message"`
	Data         interface{}    `json:"data,omitempty"`
}

func (s *Response) Msg(code int, message string) {
	s.Code = code
	s.Message = message
	s.Context.JSON(http.StatusOK, s)
}

func (s *Response) Json(code int, message string, data interface{}) {
	s.Code = code
	s.Message = message
	s.Data = data
	s.Context.JSON(http.StatusOK, s)
}

func Context(c *gin.Context) Response {
	return c.MustGet("$").(Response)
}
