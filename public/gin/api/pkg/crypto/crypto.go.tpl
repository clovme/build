package crypto

import (
	"crypto"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"errors"
	"io"
)

var (
	PublicKey  *rsa.PublicKey
	PrivateKey *rsa.PrivateKey
)

func ParseRsaKeys(pubPEM, priPEM []byte) error {
	// 公钥
	block, _ := pem.Decode(pubPEM)
	if block == nil {
		return errors.New("invalid public key")
	}
	pub, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		return err
	}
	PublicKey = pub.(*rsa.PublicKey)

	// 私钥
	block, _ = pem.Decode(priPEM)
	if block == nil {
		return errors.New("invalid private key")
	}
	//pri, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	pri, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		return err
	}
	PrivateKey = pri.(*rsa.PrivateKey)
	return nil
}

// AesEncrypt 加密数据
func AesEncrypt(plainText, key []byte) (string, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return "", err
	}

	cipherText := make([]byte, aes.BlockSize+len(plainText))
	iv := cipherText[:aes.BlockSize]

	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return "", err
	}

	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(cipherText[aes.BlockSize:], plainText)

	return base64.StdEncoding.EncodeToString(cipherText), nil
}

// AesDecrypt 解密数据
func AesDecrypt(cipherTextBase64 string, key []byte) ([]byte, error) {
	cipherText, _ := base64.StdEncoding.DecodeString(cipherTextBase64)

	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	if len(cipherText) < aes.BlockSize {
		return nil, errors.New("cipherText too short")
	}

	iv := cipherText[:aes.BlockSize]
	cipherText = cipherText[aes.BlockSize:]

	stream := cipher.NewCFBDecrypter(block, iv)
	stream.XORKeyStream(cipherText, cipherText)

	return cipherText, nil
}

// RsaEncryptKey 用RSA公钥加密AES密钥
func RsaEncryptKey(aesKey []byte, pub *rsa.PublicKey) (string, error) {
	encryptedKey, err := rsa.EncryptPKCS1v15(rand.Reader, pub, aesKey)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(encryptedKey), nil
}

// RsaDecryptKey 用RSA私钥解密AES密钥
func RsaDecryptKey(encryptedKeyBase64 string, pri *rsa.PrivateKey) ([]byte, error) {
	encryptedKey, _ := base64.StdEncoding.DecodeString(encryptedKeyBase64)
	return rsa.DecryptPKCS1v15(rand.Reader, pri, encryptedKey)
}

// SignWithPrivateKey 签名
func SignWithPrivateKey(data []byte) (string, error) {
	hash := sha256.Sum256(data)
	signature, err := rsa.SignPKCS1v15(rand.Reader, PrivateKey, crypto.SHA256, hash[:])
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(signature), nil
}

// VerifyWithPublicKey 验签
func VerifyWithPublicKey(data []byte, signature string) error {
	sig, err := base64.StdEncoding.DecodeString(signature)
	if err != nil {
		return err
	}
	hash := sha256.Sum256(data)
	return rsa.VerifyPKCS1v15(PublicKey, crypto.SHA256, hash[:], sig)
}
