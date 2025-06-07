package public

import (
	"embed"
)

//go:embed all:ui/templates
var TemplateFS embed.FS

//go:embed all:ui/assets
var StaticFS embed.FS

//go:embed favicon.ico
var Favicon embed.FS

//go:embed rsa/public.pem
var PublicPEM []byte

//go:embed rsa/private.pem
var PrivatePEM []byte
