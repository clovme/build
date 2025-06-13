package initdata

import (
	"{{ .ProjectName }}/internal/domain/auth/do_role"
	"{{ .ProjectName }}/pkg/enums/em_role"
	"{{ .ProjectName }}/pkg/logger/log"
)

func (d *InitData) Role() {
	var modelList []do_role.Role

	for _, enum := range em_role.Values() {
		modelList = append(modelList, do_role.Role{Name: enum.Name(), Type: enum, Code: enum.Key(), CreatedBy: int64(em_role.System), Description: enum.Desc()})
	}

	newModelList := insertIfNotExist[do_role.Role](modelList, func(model do_role.Role) (*do_role.Role, error) {
		return d.Q.Role.Where(d.Q.Role.Type.Eq(int(model.Type)), d.Q.Role.CreatedBy.Eq(int64(em_role.System))).Take()
	})

	if len(newModelList) <= 0 {
		return
	}

	if err := d.Q.Role.CreateInBatches(newModelList, 100); err != nil {
		log.Error().Err(err).Msgf("[%s]初始化失败:", "角色表")
	} else {
		log.Info().Msgf("[%s]初始化成功，共%d条数据！", "角色表", len(newModelList))
	}
}
