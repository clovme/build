package main

// VBuildIsAll 是否编译所有平台
func (c *ArgsCommand) VBuildIsAll(isDefault bool) {
	if isDefault {
		if len(conf.Build.Arch) == 0 || len(conf.Build.Plat) == 0 {
			conf.Build.Arch = []string{"amd64", "arm64"}
			conf.Build.Plat = []string{"windows", "linux", "darwin"}
		}
	} else {
		conf.Build.Arch = []string{conf.Env.GOARCH}
		conf.Build.Plat = []string{conf.Env.GOOS}
	}
}

// VBuildIsGen 是否执行go generate命令
func (c *ArgsCommand) VBuildIsGen(isDefault bool) {
	if isDefault {
		Command("go", "generate", "./...")
	}
}
