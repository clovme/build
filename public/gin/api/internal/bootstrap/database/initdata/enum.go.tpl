package initdata

import (
	"{{ .ProjectName }}/internal/domain/do_enums"
	"{{ .ProjectName }}/pkg/enums/enum_code"
	"{{ .ProjectName }}/pkg/enums/enum_gender"
	"{{ .ProjectName }}/pkg/enums/enum_permission"
	"{{ .ProjectName }}/pkg/enums/enum_role"
	"{{ .ProjectName }}/pkg/enums/enum_status"
)

func (d *InitData) Enum() {
	var modelList []do_enums.Enums

	for i, enum := range enum_role.Values() {
		modelList = append(modelList, do_enums.Enums{Category: enum_role.Category, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range enum_gender.Values() {
		modelList = append(modelList, do_enums.Enums{Category: enum_gender.Category, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range enum_code.Values() {
		modelList = append(modelList, do_enums.Enums{Category: enum_code.Category, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range enum_status.Values() {
		modelList = append(modelList, do_enums.Enums{Category: enum_status.Category, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	for i, enum := range enum_permission.Values() {
		modelList = append(modelList, do_enums.Enums{Category: enum_permission.Category, Key: enum.Key(), Name: enum.Name(), Value: enum.Int(), Sort: i + 1, Description: enum.Desc()})
	}

	insertIfNotExist[do_enums.Enums]("枚举表", d.Db, modelList, func(model do_enums.Enums) (*do_enums.Enums, error) {
		return d.Q.Enums.Where(d.Q.Enums.Category.Eq(model.Category), d.Q.Enums.Value.Eq(model.Value), d.Q.Enums.Key.Eq(model.Key)).Take()
	})
}
