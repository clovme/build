package gin

import (
	"buildx/global"
	"fmt"
	"github.com/spf13/cobra"
)

var gormCmd = &cobra.Command{
	Use:   "gen",
	Short: "生成query,router,migrate,context",
	Run: func(cmd *cobra.Command, args []string) {
		regContext()
		regRouter()
		regMigrate()
		regQuery()
	},
}

func init() {
	gormCmd.SetUsageTemplate(fmt.Sprintf("Usage:\n  %s gin gen\t生成infrastructure/query,bootstrap的router,migrate,app_context\n\nGlobal Flags:\n{{.Flags.FlagUsages}}", global.ExeFileName))
}
