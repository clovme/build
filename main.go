package main

import (
	"buildx/cmd"
	"buildx/libs"
)

func init() {
	libs.SetGoEnv()
	//global.ExeFileName = libs.GenExeFileName()
}

func main() {
	cmd.Execute()
}
