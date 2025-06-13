package initdata

import (
	"{{ .ProjectName }}/internal/domain/auth/do_permission"
	"{{ .ProjectName }}/pkg/enums/em_perm"
	"{{ .ProjectName }}/pkg/logger/log"
	"path/filepath"
	"strings"
)

func (d *InitData) Permission() {
	modelList := make([]do_permission.Permission, 0)

	// 遍历收集所有 URI
	for i, route := range d.Router {
		if strings.HasSuffix(route.Path, "*filepath") {
			continue
		}
		name := filepath.Base(strings.Split(route.Handler, ".(*")[0])
		if name == "web" {
			name = em_perm.Page.Key()
		}
		modelList = append(modelList, do_permission.Permission{Name: route.Path, Code: route.Path, PID: 0, Type: em_perm.Code(name), Uri: route.Path, Method: route.Method, Sort: i + 1, Description: route.Path})
	}

	newModelList := insertIfNotExist[do_permission.Permission](modelList, func(model do_permission.Permission) (*do_permission.Permission, error) {
		return d.Q.Permission.Where(d.Q.Permission.Method.Eq(model.Method), d.Q.Permission.Uri.Eq(model.Uri)).Take()
	})

	if len(newModelList) <= 0 {
		return
	}

	if err := d.Q.Permission.CreateInBatches(newModelList, 100); err != nil {
		log.Error().Err(err).Msgf("[%s]初始化失败:", "权限表")
	} else {
		log.Info().Msgf("[%s]初始化成功，共%d条数据！", "权限表", len(newModelList))
	}
}
