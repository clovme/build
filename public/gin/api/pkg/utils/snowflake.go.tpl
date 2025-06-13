package utils

import (
	"{{ .ProjectName }}/pkg/logger/log"
	"{{ .ProjectName }}/pkg/snowflake"
)

var node *snowflake.Node

// InitSnowflake 初始化雪花算法节点
func InitSnowflake(nodeID int64) {
	var err error
	node, err = snowflake.NewNode(nodeID)
	if err != nil {
		log.Panic().Err(err).Msg("雪花算法节点初始化失败")
	}
}

// GenerateID 生成唯一ID
func GenerateID() int64 {
	return node.Generate().Int64()
}
