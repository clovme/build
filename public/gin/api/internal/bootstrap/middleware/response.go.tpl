package middleware

import (
	"bytes"
	"crypto/rand"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/crypto"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/logger/http_log"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"strings"
	"time"
)

type bodyWriter struct {
	gin.ResponseWriter
	body *bytes.Buffer
}

func (w *bodyWriter) Write(b []byte) (int, error) {
	// 拦截响应内容，写入缓存
	return w.body.Write(b)
}

func EncryptResponse() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 替换Writer
		buf := new(bytes.Buffer)
		writer := &bodyWriter{
			ResponseWriter: c.Writer,
			body:           buf,
		}
		c.Writer = writer
		// 写入加密后的响应
		origin := writer.ResponseWriter

		// 执行业务
		c.Next()

		// 那些请求直接返原路返回
		encrypt, exists := c.Get(constants.ContextIsEncrypted)
		if !exists || !encrypt.(bool) || !let.IsEnableEncrypted {
			// 不加密，直接返回原始
			origin.Write(buf.Bytes())
			return
		}

		// 生成16字节 AES 密钥
		aesKey := make([]byte, 16)
		if _, err := rand.Read(aesKey); err != nil {
			http_log.Error(c).Err(err).Msg("随机密钥生成失败")
			// 生成密钥失败，返回错误信息
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "服务器异常"})
			return
		}

		// AES 加密正文
		encrypted, err := crypto.AesEncrypt(buf.Bytes(), aesKey)
		if err != nil {
			http_log.Error(c).Err(err).Msg("AES 加密失败")
			// 加密失败，返回错误信息
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "服务器异常"})
			return
		}

		// RSA 加密 AES 密钥
		encKey, err := crypto.RsaEncryptKey(aesKey, crypto.PublicKey)
		if err != nil {
			http_log.Error(c).Err(err).Msg("RSA 加密失败")
			// 加密失败，返回错误信息
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "服务器异常"})
			return
		}

		// 签名
		timestamp := time.Now().Unix()
		signContent := strings.TrimSpace(encrypted) + "|" + strconv.FormatInt(timestamp, 10)

		signature, err := crypto.SignWithPrivateKey([]byte(signContent))
		if err != nil {
			http_log.Error(c).Err(err).Msg("签名失败")
			// 加密失败，返回错误信息
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "签名失败"})
			return
		}

		// 写入Header
		c.Header("X-Timestamp", strconv.FormatInt(timestamp, 10))
		c.Header("X-Signature", signature)
		c.Header("X-Encipher", encKey)
		c.Header("Content-Type", "text/plain; charset=utf-8")

		if !writer.Written() {
			origin.WriteHeader(http.StatusOK)
		}

		origin.Write([]byte(encrypted))
	}
}
