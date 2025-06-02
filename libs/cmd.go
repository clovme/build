package libs

import (
	"os"
	"os/exec"
	"runtime"
	"strings"
)

// IsCommandExists 判断命令是否存在
func IsCommandExists(command string) bool {
	var cmd *exec.Cmd

	// 判断操作系统
	if runtime.GOOS == "windows" {
		// 在 Windows 中使用 "where" 命令
		cmd = exec.Command("where", command)
	} else {
		// 在 Linux/macOS 中使用 "which" 命令
		cmd = exec.Command("which", command)
	}

	// 执行命令并判断返回值
	err := cmd.Run()
	return err == nil // 如果 err == nil，表示命令存在
}

// CmdValue 执行命令并获取输出
func CmdValue(exe string, arg ...string) string {
	cmd := exec.Command(exe, arg...)

	// 获取命令的输出
	output, _ := cmd.Output()

	return strings.TrimSpace(string(output))
}

// CommandDir 执行控制台输出命令
func CommandDir(dir, exe string, arg ...string) {
	cmd := exec.Command(exe, arg...)
	cmd.Dir = dir // 指定目录
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	
	if err := cmd.Run(); err != nil {
		panic("命令执行失败！")
	}
}

// Command 执行控制台输出命令
func Command(exe string, arg ...string) {
	CommandDir(".", exe, arg...)
}
