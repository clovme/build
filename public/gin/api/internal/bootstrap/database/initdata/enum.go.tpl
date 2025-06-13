package initdata

import (
	"{{ .ProjectName }}/internal/domain/do_enums"
	"{{ .ProjectName }}/pkg/enums/em_bool"
	"{{ .ProjectName }}/pkg/enums/em_gender"
	"{{ .ProjectName }}/pkg/enums/em_http"
	"{{ .ProjectName }}/pkg/enums/em_perm"
	"{{ .ProjectName }}/pkg/enums/em_role"
	"{{ .ProjectName }}/pkg/enums/em_status"
	"{{ .ProjectName }}/pkg/enums/em_type"
	"{{ .ProjectName }}/pkg/logger/log"
)

func (d *InitData) Enum() {
	var modelList []do_enums.Enums

	for i, enum := range em_role.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_role.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_gender.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_gender.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_http.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_http.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_status.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_status.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_perm.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_perm.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_type.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_type.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range em_bool.Values() {
		modelList = append(modelList, do_enums.Enums{Category: em_bool.Name, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), ValueT: em_type.Int.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	newModelList := insertIfNotExist[do_enums.Enums](modelList, func(model do_enums.Enums) (*do_enums.Enums, error) {
		return d.Q.Enums.Where(d.Q.Enums.Category.Eq(model.Category), d.Q.Enums.Value.Eq(model.Value), d.Q.Enums.Key.Eq(model.Key)).Take()
	})

	if len(newModelList) <= 0 {
		return
	}

	if err := d.Q.Enums.CreateInBatches(newModelList, 100); err != nil {
		log.Error().Err(err).Msgf("[%s]初始化失败:", "系统枚举")
	} else {
		log.Info().Msgf("[%s]初始化成功，共%d条数据！", "系统枚举", len(newModelList))
	}
}
