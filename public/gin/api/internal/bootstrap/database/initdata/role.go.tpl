package initdata

import (
	"{{ .ProjectName }}/internal/domain/auth/do_role"
	"{{ .ProjectName }}/pkg/enums/enum_role"
)

func (d *InitData) Role() {
	var modelList []do_role.Role

	for _, enum := range enum_role.Values() {
		modelList = append(modelList, do_role.Role{Name: enum.Name(), Type: enum, Code: enum.Key(), CreatedBy: int64(enum_role.System), Description: enum.Desc()})
	}

	insertIfNotExist[do_role.Role]("角色表", d.Db, modelList, func(model do_role.Role) (*do_role.Role, error) {
		return d.Q.Role.Where(d.Q.Role.Type.Eq(int(model.Type)), d.Q.Role.CreatedBy.Eq(int64(enum_role.System))).Take()
	})
}
