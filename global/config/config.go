package config

// Env 环境变量配置
type Env struct {
	GOOS   string `ini:"GOOS" comment:"GO 编译平台"`
	GOARCH string `ini:"GOARCH" comment:"GO 编译架构"`
}

// FileName 编译生成的文件名配置
type FileName struct {
	Name   string `ini:"name" comment:"文件名，不包含扩展名"`
	IsPlat bool   `ini:"isPlat" comment:" 文件名是否台添加编译平台名称"`
	IsArch bool   `ini:"isArch" comment:"文件名是否台添加架构名称"`
	IsVer  bool   `ini:"isVer" comment:"文件名是否添加版本号"`
}

// Build 编译配置
type Build struct {
	IsGen   bool     `ini:"isGen" comment:"是否执行go generate命令"`
	IsGUI   bool     `ini:"isGui" comment:"是否编译GUI程序"`
	IsAll   bool     `ini:"isAll" comment:"编译三大平台(linux、windows、darwin)"`
	IsUPX   bool     `ini:"isUpx" comment:"是否启用UPX压缩"`
	IsMode  bool     `ini:"isMode" comment:"是否编译为动态链接库"`
	Plat    []string `ini:"plat" comment:"编译平台"`
	Arch    []string `ini:"arch" comment:"编译架构"`
	Version []int    `ini:"version" comment:"程序编译版本"`
}

// Other 其他配置
type Other struct {
	UPX       string `ini:"-" comment:"UPX 文件路径"`
	Temp      string `ini:"-" comment:"临时路径"`
	Version   string `ini:"-" comment:"临时保存版本号"`
	IsComment bool   `ini:"isComment" comment:"是否开启配置文件注释"`
	GoVersion string `ini:"goVersion" comment:"当前项目Go版本"`
}

type Config struct {
	Env      Env      `ini:"env" comment:"配置编译环境变量"`
	FileName FileName `ini:"filename" comment:"编译文件名配置"`
	Build    Build    `ini:"build" comment:"编译配置"`
	Other    Other    `ini:"other" comment:"编译其他配置"`
}
