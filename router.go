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

// GinTemplateData 定义一个结构体，用来填充模板
type GinTemplateData struct {
	ProjectName string
}

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

type GroupedRouters struct {
	GroupName string
	Routers   []TemplateRoute
}

type TemplateData struct {
	Imports []string
	Groups  []string
	Grouped []GroupedRouters
}

const routeTemplate = `package routers

import (
{{- range .Imports }}
	"{{ . }}"
{{- end }}
	"github.com/gin-gonic/gin"
)

type routeGroup struct {
{{- range .Groups }}
	{{ . }} *gin.RouterGroup
{{- end }}
}

func (r *routeGroup) register() {
{{- range $gIndex, $group := .Grouped }}
{{- range $group.Routers }}
	r.{{ .Group }}.{{ .Method }}("{{ .Path }}", {{ .Handler }})
{{- end }}
{{- if lt $gIndex (sub1 (len $.Grouped)) }}
{{ end }}
{{- end }}
}`

const initialize = `package routers

import (
	"{{ .ProjectName }}/middleware"
	"github.com/gin-gonic/gin"
	"net/http"
)

// registerNoRoute 注册404处理
func registerNoRoute(engine *gin.Engine) {
	engine.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{
			"message": "请输入正确的请求地址!",
		})
	})
}

func Initialization(engine *gin.Engine) {
	engine.Use(
		middleware.CorsMiddleware([]string{"127.0.0.1:8080", "localhost:8080"}),
		middleware.RecoveryMiddleware(),
	)

	routers := routeGroup{
		public: engine.Group("/api"),
		admin:  engine.Group("/api"),
		noAuth: engine.Group("/api", middleware.NoAuth()),
	}

	routers.register()

	// 注册404处理
	registerNoRoute(engine)
}`

func writeRouters(routers map[string][]Route) error {
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

	for groupName, routeList := range routers {
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

	var grouped []GroupedRouters
	for _, g := range groups {
		grouped = append(grouped, GroupedRouters{
			GroupName: g,
			Routers:   groupMap[g],
		})
	}

	data := TemplateData{
		Imports: imports,
		Groups:  groups,
		Grouped: grouped,
	}

	routerPath := "routers/router.go"
	initializePath := "routers/initialize.go"
	// 判断 routers 文件夹是否存在，不存在则创建
	if !IsDirExist("routers") {
		if err = os.Mkdir("routers", os.ModePerm); err != nil {
			return fmt.Errorf("创建 routers 文件夹失败: %w", err)
		}
	}

	// 判断文件 routers/initialize.go 是否存在，不存在则创建
	if !IsFileExist(initializePath) {
		// 创建一个新的模板，解析并执行模板
		t, _ := template.New("initialize").Parse(initialize)

		// 输出解析结果，可以写入文件
		file, _ := os.Create(initializePath)
		defer file.Close()

		// 要填充的数据
		_data := GinTemplateData{
			ProjectName: conf.FileName.Name,
		}
		// 执行模板，填充数据，并写入文件
		_ = t.Execute(file, _data)
	}

	// 输出
	f, err := os.Create(routerPath)
	if err != nil {
		return fmt.Errorf("创建文件失败: %w", err)
	}
	defer f.Close()

	if err := tmpl.Execute(f, data); err != nil {
		return fmt.Errorf("执行模板失败: %w", err)
	}

	fmt.Println("✅ 路由文件生成成功:", routerPath)
	return nil
}
