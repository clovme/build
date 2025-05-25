package public

import (
	"embed"
)

//go:embed all:templates
var TemplateFS embed.FS

//go:embed all:assets
var StaticFS embed.FS
