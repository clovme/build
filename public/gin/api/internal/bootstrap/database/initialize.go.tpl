package database

import (
	"{{ .ProjectName }}/internal/infrastructure/query"
	"{{ .ProjectName }}/pkg/constants"
	"{{ .ProjectName }}/pkg/utils"
	"{{ .ProjectName }}/public"
)

func InitializeConfig(query *query.Query) {
	configs, err := query.Config.Find()
	if err != nil {
		return
	}

	for _, cfg := range configs {
		switch cfg.Name {
		case constants.ContextIsEncryptedResponse:
			utils.SetConfig[bool](&constants.IsEnableEncrypted, cfg.Value == constants.True, cfg.Default == constants.True, cfg.Enable)
		case constants.WebTitle:
			utils.SetConfig[string](&constants.WebTitle, cfg.Value, cfg.Default, cfg.Enable)
		case constants.PublicPEM:
			utils.SetByteConfig(&public.PublicPEM, []byte(cfg.Value), []byte(cfg.Default), cfg.Enable)
		case constants.PrivatePEM:
			utils.SetByteConfig(&public.PrivatePEM, []byte(cfg.Value), []byte(cfg.Default), cfg.Enable)
		}
	}
}
