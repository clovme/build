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
}
`

const initialize = `package routers

import "github.com/gin-gonic/gin"

func Initialization(engine *gin.Engine) {
	routers := routeGroup{
		// 这里添加路由组和中间件
	}

	routers.register()
}
`

const controller = `// @Router	/users [get] (重要参数，路由配置)
// @Group	public (重要参数，路由分组和权限控制)

package controllers

import "github.com/gin-gonic/gin"

// GetUsers			godoc
// @Summary			获取用户信息
// @Description 	根据ID获取用户详细信息
// @Tags        	用户模块
// @Accept       	json
// @Produce      	json
// @Success      	200  {object}  UserResponse
// @Router			/users [get]
// @Group 			public
func GetUsers(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "GET Users",
	})
}


// PutUsers			godoc
// @Summary			获取用户信息
// @Description 	根据ID获取用户详细信息
// @Tags        	用户模块
// @Accept       	json
// @Produce      	json
// @Param        	id   path      int  true  "用户ID"
// @Success      	200  {object}  UserResponse
// @Router			/users/{id} [put]
// @Group 			admin
func PutUsers(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "PUT Users",
	})
}
`

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
	if !IsDirExist(initializePath) {
		os.WriteFile(initializePath, []byte(initialize), os.ModePerm)
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
