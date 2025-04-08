package main

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func returnCMD(exe string, arg ...string) string {
	cmd := exec.Command(exe, arg...)

	// 获取命令的输出
	output, _ := cmd.Output()

	return strings.TrimSpace(string(output))
}

func ExecCmd() {
	goPath := filepath.Join(conf.Env.GOROOT, "bin", "go.exe")
	var cmdParams = []string{"build", "-ldflags", "-s -w", "-trimpath", "-v", "-x", "-o", conf.Build.Filename, "."}
	if conf.Build.IsGUI {
		cmdParams[2] = "-s -w -H windowsgui"
	}

	cmd := exec.Command(goPath, cmdParams...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic(err)
	}

	if !conf.Build.IsUPX {
		return
	}
	cmd = exec.Command(filepath.Join(os.TempDir(), "upx.exe"), "--ultra-brute", "--best", "--lzma", "--brute", "--compress-exports=1", "--no-mode", "--no-owner", "--no-time", "--force", conf.Build.Filename)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		panic(err)
	}
}
