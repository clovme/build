@echo off

set filepath="build.exe"

go build -ldflags "-s -w" -trimpath -v -x -o %filepath%
upx --ultra-brute --best --lzma --brute --compress-exports=1 --no-mode --no-owner --no-time --force %filepath%
