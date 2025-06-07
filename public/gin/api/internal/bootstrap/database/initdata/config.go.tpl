package initdata

import (
	"{{ .ProjectName }}/internal/domain/do_config"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/public"
)

// Config 初始化配置
func (d *InitData) Config() {
	modelList := []do_config.Config{
		{Name: constants.ContextIsEncryptedResponse, Value: constants.True, Default: constants.False, Description: "是否开启加密模式"},
		{Name: constants.WebTitle, Value: "知识库", Default: "知识库", Description: "网络标题"},
		{Name: constants.PublicPEM, Value: string(public.PublicPEM), Default: string(public.PublicPEM), Description: "加密公钥"},
		{Name: constants.PrivatePEM, Value: string(public.PrivatePEM), Default: string(public.PrivatePEM), Description: "加密私钥"},
	}

	insertIfNotExist[do_config.Config]("系统配置", d.Db, modelList, func(model do_config.Config) (*do_config.Config, error) {
		return d.Q.Config.Where(d.Q.Config.Name.Eq(model.Name)).Take()
	})
}
