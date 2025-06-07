package persistence

import (
	"{{ .ProjectName }}/internal/domain/do_enums"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"gorm.io/gorm"
)

type PublicRepository struct {
	DB *gorm.DB
	Q  *query.Query
}

func (r *PublicRepository) FindAll() ([]*do_enums.Enums, error) {
	enums, err := r.Q.Enums.Order(r.Q.Enums.ID.Asc(), r.Q.Enums.Category).Order(r.Q.Enums.Sort.Asc(), r.Q.Enums.Sort).Find()
	if err != nil {
		return nil, err
	}
	return enums, err
}

func (r *PublicRepository) Save(u *do_enums.Enums) error {
	return r.DB.Create(u).Error
}
