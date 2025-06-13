package initdata

import (
	"{{ .ProjectName }}/internal/domain/do_config"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/enums/em_bool"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/logger/log"
	"{{ .ProjectName }}/public"
)

// Config 初始化配置
func (d *InitData) Config() {
	modelList := []do_config.Config{
		{Name: constants.ContextIsEncrypted, Value: em_bool.True.Key(), Default: em_bool.False.Key(), Show: em_bool.True, Description: "是否开启加密模式"},
		{Name: let.WebTitle, Value: "知识库", Default: "知识库", Show: em_bool.True, Description: "站点标题"},
		{Name: constants.PublicPEM, Value: string(public.PublicPEM), Default: string(public.PublicPEM), Show: em_bool.True, Description: "加密公钥"},
		{Name: constants.PrivatePEM, Value: string(public.PrivatePEM), Default: string(public.PrivatePEM), Show: em_bool.True, Description: "加密私钥"},
	}

	newModelList := insertIfNotExist[do_config.Config](modelList, func(model do_config.Config) (*do_config.Config, error) {
		return d.Q.Config.Where(d.Q.Config.Name.Eq(model.Name)).Take()
	})

	if len(newModelList) <= 0 {
		return
	}

	if err := d.Q.Config.CreateInBatches(newModelList, 100); err != nil {
		log.Error().Err(err).Msgf("[%s]初始化失败:", "系统配置表")
	} else {
		log.Info().Msgf("[%s]初始化成功，共%d条数据！", "系统配置表", len(newModelList))
	}
}
