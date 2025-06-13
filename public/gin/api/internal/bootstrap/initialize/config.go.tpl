package initialize

import (
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/enums/em_bool"
	"{{ .ProjectName }}/pkg/let"
	"{{ .ProjectName }}/pkg/utils"
	"{{ .ProjectName }}/public"
)

func InitSystemConfig(query *query.Query) {
	configs, err := query.Config.Find()
	if err != nil {
		return
	}

	for _, cfg := range configs {
		switch cfg.Name {
		case constants.ContextIsEncrypted:
			utils.SetConfig[bool](&let.IsEnableEncrypted, cfg.Value == em_bool.True.Key(), cfg.Default == em_bool.True.Key(), cfg.Status)
		case let.WebTitle:
			utils.SetConfig[string](&let.WebTitle, cfg.Value, cfg.Default, cfg.Status)
		case constants.PublicPEM:
			utils.SetByteConfig(&public.PublicPEM, []byte(cfg.Value), []byte(cfg.Default), cfg.Status)
		case constants.PrivatePEM:
			utils.SetByteConfig(&public.PrivatePEM, []byte(cfg.Value), []byte(cfg.Default), cfg.Status)
		case constants.ProjectName:
			let.WebTitle = cfg.Value
		}
	}
}
