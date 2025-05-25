package public

import "embed"

//go:embed all:build
var Build embed.FS

//go:embed all:gin
var GinTpl embed.FS

//go:embed all:ddd
var DDD embed.FS

//go:embed env
var Env []byte

//go:embed pip.ini
var Pip []byte
