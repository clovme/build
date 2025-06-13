package public

import (
	"embed"
)

//go:embed all:web/templates
var TemplateFS embed.FS

//go:embed all:initweb
var InitiateFS embed.FS

//go:embed all:web/assets
var StaticFS embed.FS

//go:embed all:web/images
var ImagesFS embed.FS

//go:embed favicon.ico
var Favicon embed.FS

//go:embed rsa/public.pem
var PublicPEM []byte

//go:embed rsa/private.pem
var PrivatePEM []byte
