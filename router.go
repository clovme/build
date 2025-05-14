package main

import (
	"fmt"
	"os"
	"reflect"
	"regexp"
	"sort"
	"strings"
	"text/template"
)

var (
	re = regexp.MustCompile(`\{(\w+)}`)
	// 正则表达式
	routeRegex = regexp.MustCompile(`@Router\s+(\S+)\s+\[(\w+)\]`)
	//descRegex       = regexp.MustCompile(`@Desc\s+(.+)`)
	groupRegex = regexp.MustCompile(`@Group\s+(.+)`)
	//rolesRegex      = regexp.MustCompile(`@Roles\s+([^\s]+)`)
	//permissionRegex = regexp.MustCompile(`@Permission\s+([^\s]+)`)
)

type Route struct {
	HTTPMethod  string
	Path        string
	Func        string
	PackagePath string
	PackageName string
}

type TemplateRoute struct {
	Group   string
	Method  string
	Path    string
	Handler string
}

type GroupedRoutes struct {
	GroupName string
	Routes    []TemplateRoute
}

type TemplateData struct {
	Imports []string
	Groups  []string
	Grouped []GroupedRoutes
}

const routeTemplate = `package main

import (
{{- range .Imports }}
	"{{ . }}"
{{- end }}
	"github.com/gin-gonic/gin"
)

type Routes struct {
{{- range .Groups }}
	{{ . }} *gin.RouterGroup
{{- end }}
}

func (r *Routes) Register() {
{{- range $gIndex, $group := .Grouped }}
{{- range $group.Routes }}
	r.{{ .Group }}.{{ .Method }}("{{ .Path }}", {{ .Handler }})
{{- end }}
{{- if lt $gIndex (sub1 (len $.Grouped)) }}
{{ end }}
{{- end }}
}
`

func writeRoutes(routes map[string][]Route) error {
	funcMap := template.FuncMap{
		"len":  func(v interface{}) int { return reflect.ValueOf(v).Len() },
		"sub1": func(i int) int { return i - 1 },
	}

	tmpl, err := template.New("routers").Funcs(funcMap).Parse(routeTemplate)
	if err != nil {
		return fmt.Errorf("解析模板失败: %w", err)
	}

	// 收集 import、分组、组内路由
	importSet := make(map[string]struct{})
	var groups []string
	groupMap := make(map[string][]TemplateRoute)

	for groupName, routeList := range routes {
		groups = append(groups, groupName)
		for _, route := range routeList {
			importSet[route.PackagePath] = struct{}{}
			groupMap[groupName] = append(groupMap[groupName], TemplateRoute{
				Group:   groupName,
				Method:  strings.ToUpper(route.HTTPMethod),
				Path:    route.Path,
				Handler: fmt.Sprintf("%s.%s", route.PackageName, route.Func),
			})
		}
	}
	sort.Strings(groups)

	var imports []string
	for path := range importSet {
		imports = append(imports, path)
	}
	sort.Strings(imports)

	var grouped []GroupedRoutes
	for _, g := range groups {
		grouped = append(grouped, GroupedRoutes{
			GroupName: g,
			Routes:    groupMap[g],
		})
	}

	data := TemplateData{
		Imports: imports,
		Groups:  groups,
		Grouped: grouped,
	}

	outputPath := "routers/router.go"
	// 判断 routers 文件夹是否存在，不存在则创建
	if !CheckDirExist("routers") {
		if err = os.Mkdir("routers", os.ModePerm); err != nil {
			return fmt.Errorf("创建 routers 文件夹失败: %w", err)
		}
	}

	// 输出
	f, err := os.Create(outputPath)
	if err != nil {
		return fmt.Errorf("创建文件失败: %w", err)
	}
	defer f.Close()

	if err := tmpl.Execute(f, data); err != nil {
		return fmt.Errorf("执行模板失败: %w", err)
	}

	fmt.Println("✅ 路由文件生成成功:", outputPath)
	return nil
}
