// Code generated by gorm.io/gen. DO NOT EDIT.
// Code generated by gorm.io/gen. DO NOT EDIT.
// Code generated by gorm.io/gen. DO NOT EDIT.

package query

import (
	"context"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
	"gorm.io/gorm/schema"

	"gorm.io/gen"
	"gorm.io/gen/field"

	"gorm.io/plugin/dbresolver"

	"{{ .ProjectName }}/internal/domain/do_cors"
)

func newCorsWhitelist(db *gorm.DB, opts ...gen.DOOption) corsWhitelist {
	_corsWhitelist := corsWhitelist{}

	_corsWhitelist.corsWhitelistDo.UseDB(db, opts...)
	_corsWhitelist.corsWhitelistDo.UseModel(&do_cors.CorsWhitelist{})

	tableName := _corsWhitelist.corsWhitelistDo.TableName()
	_corsWhitelist.ALL = field.NewAsterisk(tableName)
	_corsWhitelist.ID = field.NewInt64(tableName, "id")
	_corsWhitelist.Origin = field.NewString(tableName, "origin")
	_corsWhitelist.Description = field.NewString(tableName, "description")
	_corsWhitelist.Status = field.NewInt(tableName, "status")
	_corsWhitelist.CreatedAt = field.NewTime(tableName, "created_at")
	_corsWhitelist.UpdatedAt = field.NewTime(tableName, "updated_at")
	_corsWhitelist.DeletedAt = field.NewField(tableName, "deleted_at")

	_corsWhitelist.fillFieldMap()

	return _corsWhitelist
}

type corsWhitelist struct {
	corsWhitelistDo

	ALL         field.Asterisk
	ID          field.Int64
	Origin      field.String
	Description field.String
	Status      field.Int
	CreatedAt   field.Time
	UpdatedAt   field.Time
	DeletedAt   field.Field

	fieldMap map[string]field.Expr
}

func (c corsWhitelist) Table(newTableName string) *corsWhitelist {
	c.corsWhitelistDo.UseTable(newTableName)
	return c.updateTableName(newTableName)
}

func (c corsWhitelist) As(alias string) *corsWhitelist {
	c.corsWhitelistDo.DO = *(c.corsWhitelistDo.As(alias).(*gen.DO))
	return c.updateTableName(alias)
}

func (c *corsWhitelist) updateTableName(table string) *corsWhitelist {
	c.ALL = field.NewAsterisk(table)
	c.ID = field.NewInt64(table, "id")
	c.Origin = field.NewString(table, "origin")
	c.Description = field.NewString(table, "description")
	c.Status = field.NewInt(table, "status")
	c.CreatedAt = field.NewTime(table, "created_at")
	c.UpdatedAt = field.NewTime(table, "updated_at")
	c.DeletedAt = field.NewField(table, "deleted_at")

	c.fillFieldMap()

	return c
}

func (c *corsWhitelist) GetFieldByName(fieldName string) (field.OrderExpr, bool) {
	_f, ok := c.fieldMap[fieldName]
	if !ok || _f == nil {
		return nil, false
	}
	_oe, ok := _f.(field.OrderExpr)
	return _oe, ok
}

func (c *corsWhitelist) fillFieldMap() {
	c.fieldMap = make(map[string]field.Expr, 7)
	c.fieldMap["id"] = c.ID
	c.fieldMap["origin"] = c.Origin
	c.fieldMap["description"] = c.Description
	c.fieldMap["status"] = c.Status
	c.fieldMap["created_at"] = c.CreatedAt
	c.fieldMap["updated_at"] = c.UpdatedAt
	c.fieldMap["deleted_at"] = c.DeletedAt
}

func (c corsWhitelist) clone(db *gorm.DB) corsWhitelist {
	c.corsWhitelistDo.ReplaceConnPool(db.Statement.ConnPool)
	return c
}

func (c corsWhitelist) replaceDB(db *gorm.DB) corsWhitelist {
	c.corsWhitelistDo.ReplaceDB(db)
	return c
}

type corsWhitelistDo struct{ gen.DO }

func (c corsWhitelistDo) Debug() *corsWhitelistDo {
	return c.withDO(c.DO.Debug())
}

func (c corsWhitelistDo) WithContext(ctx context.Context) *corsWhitelistDo {
	return c.withDO(c.DO.WithContext(ctx))
}

func (c corsWhitelistDo) ReadDB() *corsWhitelistDo {
	return c.Clauses(dbresolver.Read)
}

func (c corsWhitelistDo) WriteDB() *corsWhitelistDo {
	return c.Clauses(dbresolver.Write)
}

func (c corsWhitelistDo) Session(config *gorm.Session) *corsWhitelistDo {
	return c.withDO(c.DO.Session(config))
}

func (c corsWhitelistDo) Clauses(conds ...clause.Expression) *corsWhitelistDo {
	return c.withDO(c.DO.Clauses(conds...))
}

func (c corsWhitelistDo) Returning(value interface{}, columns ...string) *corsWhitelistDo {
	return c.withDO(c.DO.Returning(value, columns...))
}

func (c corsWhitelistDo) Not(conds ...gen.Condition) *corsWhitelistDo {
	return c.withDO(c.DO.Not(conds...))
}

func (c corsWhitelistDo) Or(conds ...gen.Condition) *corsWhitelistDo {
	return c.withDO(c.DO.Or(conds...))
}

func (c corsWhitelistDo) Select(conds ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Select(conds...))
}

func (c corsWhitelistDo) Where(conds ...gen.Condition) *corsWhitelistDo {
	return c.withDO(c.DO.Where(conds...))
}

func (c corsWhitelistDo) Order(conds ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Order(conds...))
}

func (c corsWhitelistDo) Distinct(cols ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Distinct(cols...))
}

func (c corsWhitelistDo) Omit(cols ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Omit(cols...))
}

func (c corsWhitelistDo) Join(table schema.Tabler, on ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Join(table, on...))
}

func (c corsWhitelistDo) LeftJoin(table schema.Tabler, on ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.LeftJoin(table, on...))
}

func (c corsWhitelistDo) RightJoin(table schema.Tabler, on ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.RightJoin(table, on...))
}

func (c corsWhitelistDo) Group(cols ...field.Expr) *corsWhitelistDo {
	return c.withDO(c.DO.Group(cols...))
}

func (c corsWhitelistDo) Having(conds ...gen.Condition) *corsWhitelistDo {
	return c.withDO(c.DO.Having(conds...))
}

func (c corsWhitelistDo) Limit(limit int) *corsWhitelistDo {
	return c.withDO(c.DO.Limit(limit))
}

func (c corsWhitelistDo) Offset(offset int) *corsWhitelistDo {
	return c.withDO(c.DO.Offset(offset))
}

func (c corsWhitelistDo) Scopes(funcs ...func(gen.Dao) gen.Dao) *corsWhitelistDo {
	return c.withDO(c.DO.Scopes(funcs...))
}

func (c corsWhitelistDo) Unscoped() *corsWhitelistDo {
	return c.withDO(c.DO.Unscoped())
}

func (c corsWhitelistDo) Create(values ...*do_cors.CorsWhitelist) error {
	if len(values) == 0 {
		return nil
	}
	return c.DO.Create(values)
}

func (c corsWhitelistDo) CreateInBatches(values []*do_cors.CorsWhitelist, batchSize int) error {
	return c.DO.CreateInBatches(values, batchSize)
}

// Save : !!! underlying implementation is different with GORM
// The method is equivalent to executing the statement: db.Clauses(clause.OnConflict{UpdateAll: true}).Create(values)
func (c corsWhitelistDo) Save(values ...*do_cors.CorsWhitelist) error {
	if len(values) == 0 {
		return nil
	}
	return c.DO.Save(values)
}

func (c corsWhitelistDo) First() (*do_cors.CorsWhitelist, error) {
	if result, err := c.DO.First(); err != nil {
		return nil, err
	} else {
		return result.(*do_cors.CorsWhitelist), nil
	}
}

func (c corsWhitelistDo) Take() (*do_cors.CorsWhitelist, error) {
	if result, err := c.DO.Take(); err != nil {
		return nil, err
	} else {
		return result.(*do_cors.CorsWhitelist), nil
	}
}

func (c corsWhitelistDo) Last() (*do_cors.CorsWhitelist, error) {
	if result, err := c.DO.Last(); err != nil {
		return nil, err
	} else {
		return result.(*do_cors.CorsWhitelist), nil
	}
}

func (c corsWhitelistDo) Find() ([]*do_cors.CorsWhitelist, error) {
	result, err := c.DO.Find()
	return result.([]*do_cors.CorsWhitelist), err
}

func (c corsWhitelistDo) FindInBatch(batchSize int, fc func(tx gen.Dao, batch int) error) (results []*do_cors.CorsWhitelist, err error) {
	buf := make([]*do_cors.CorsWhitelist, 0, batchSize)
	err = c.DO.FindInBatches(&buf, batchSize, func(tx gen.Dao, batch int) error {
		defer func() { results = append(results, buf...) }()
		return fc(tx, batch)
	})
	return results, err
}

func (c corsWhitelistDo) FindInBatches(result *[]*do_cors.CorsWhitelist, batchSize int, fc func(tx gen.Dao, batch int) error) error {
	return c.DO.FindInBatches(result, batchSize, fc)
}

func (c corsWhitelistDo) Attrs(attrs ...field.AssignExpr) *corsWhitelistDo {
	return c.withDO(c.DO.Attrs(attrs...))
}

func (c corsWhitelistDo) Assign(attrs ...field.AssignExpr) *corsWhitelistDo {
	return c.withDO(c.DO.Assign(attrs...))
}

func (c corsWhitelistDo) Joins(fields ...field.RelationField) *corsWhitelistDo {
	for _, _f := range fields {
		c = *c.withDO(c.DO.Joins(_f))
	}
	return &c
}

func (c corsWhitelistDo) Preload(fields ...field.RelationField) *corsWhitelistDo {
	for _, _f := range fields {
		c = *c.withDO(c.DO.Preload(_f))
	}
	return &c
}

func (c corsWhitelistDo) FirstOrInit() (*do_cors.CorsWhitelist, error) {
	if result, err := c.DO.FirstOrInit(); err != nil {
		return nil, err
	} else {
		return result.(*do_cors.CorsWhitelist), nil
	}
}

func (c corsWhitelistDo) FirstOrCreate() (*do_cors.CorsWhitelist, error) {
	if result, err := c.DO.FirstOrCreate(); err != nil {
		return nil, err
	} else {
		return result.(*do_cors.CorsWhitelist), nil
	}
}

func (c corsWhitelistDo) FindByPage(offset int, limit int) (result []*do_cors.CorsWhitelist, count int64, err error) {
	result, err = c.Offset(offset).Limit(limit).Find()
	if err != nil {
		return
	}

	if size := len(result); 0 < limit && 0 < size && size < limit {
		count = int64(size + offset)
		return
	}

	count, err = c.Offset(-1).Limit(-1).Count()
	return
}

func (c corsWhitelistDo) ScanByPage(result interface{}, offset int, limit int) (count int64, err error) {
	count, err = c.Count()
	if err != nil {
		return
	}

	err = c.Offset(offset).Limit(limit).Scan(result)
	return
}

func (c corsWhitelistDo) Scan(result interface{}) (err error) {
	return c.DO.Scan(result)
}

func (c corsWhitelistDo) Delete(models ...*do_cors.CorsWhitelist) (result gen.ResultInfo, err error) {
	return c.DO.Delete(models)
}

func (c *corsWhitelistDo) withDO(do gen.Dao) *corsWhitelistDo {
	c.DO = *do.(*gen.DO)
	return c
}
