; go install github.com/clovme/buildx@latest

[env]
GOOS   = windows
GOARCH = amd64

[filename]
name   = {{ .ProjectName }}
isPlat = false
isArch = false
isVer  = false

[build]
isGen   = false
isGui   = false
isAll   = false
isUpx   = false
isMode  = false
plat    = windows
arch    = amd64
version = 0,0,4

[other]
isComment = false
goVersion = go1.24.3
