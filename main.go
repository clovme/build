package main

import (
	"buildx/cmd"
	"buildx/global"
	"buildx/libs"
)

func init() {
	libs.SetGoEnv()
	global.ExeFileName = libs.GenExeFileName()
}

func main() {
	cmd.Execute()
}
