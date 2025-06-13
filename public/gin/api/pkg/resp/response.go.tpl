package resp

import (
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/let"
	"github.com/gin-gonic/gin"
	"net/http"
)

type response struct {
	Code    em_http.Http `json:"code"`
	Message string       `json:"message"`
	Data    interface{}  `json:"data"`
}

func setResponse(c *gin.Context, flag bool) {
	c.Set(constants.ContextIsEncrypted, flag)
	if !flag || !let.IsEnableEncrypted {
		c.Header(constants.HeaderEncrypted, "no")
	} else {
		c.Header(constants.HeaderEncrypted, "safe")
	}
}

func JsonSafeCode(c *gin.Context, code em_http.Http, message string, obj interface{}) {
	setResponse(c, true)
	c.JSON(http.StatusOK, response{Code: code, Message: message, Data: obj})
}

func JsonSafe(c *gin.Context, message string, obj interface{}) {
	JsonSafeCode(c, em_http.Success, message, obj)
}

func JsonUnSafeCode(c *gin.Context, code em_http.Http, message string, obj interface{}) {
	setResponse(c, false)
	c.JSON(http.StatusOK, response{Code: code, Message: message, Data: obj})
}

func JsonUnSafe(c *gin.Context, message string, obj interface{}) {
	JsonUnSafeCode(c, em_http.Success, message, obj)
}

func StringSafeCode(c *gin.Context, code int, obj string) {
	setResponse(c, true)
	c.String(code, obj)
}

func StringSafe(c *gin.Context, obj string) {
	StringSafeCode(c, http.StatusOK, obj)
}

func StringUnSafeCode(c *gin.Context, code int, obj string) {
	setResponse(c, false)
	c.String(code, obj)
}

func StringUnSafe(c *gin.Context, obj string) {
	StringUnSafeCode(c, http.StatusOK, obj)
}

func HtmlSafeCode(c *gin.Context, code int, tpl string, resp interface{}) {
	setResponse(c, true)
	c.HTML(code, tpl, resp)
}

func HtmlSafe(c *gin.Context, tpl string, resp interface{}) {
	HtmlSafeCode(c, http.StatusOK, tpl, resp)
}

func HtmlUnSafeCode(c *gin.Context, code int, tpl string, resp interface{}) {
	setResponse(c, false)
	c.HTML(code, tpl, resp)
}

func HtmlUnSafe(c *gin.Context, tpl string, resp interface{}) {
	HtmlUnSafeCode(c, http.StatusOK, tpl, resp)
}
