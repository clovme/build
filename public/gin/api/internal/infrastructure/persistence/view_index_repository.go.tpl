package persistence

import (
	"{{ .ProjectName }}/internal/domain/do_user"
	"{{ .ProjectName }}/internal/infrastructure/query"
	"gorm.io/gorm"
)

type ViewIndexRepository struct {
	DB *gorm.DB
    Q  *query.Query
}

func (r *ViewIndexRepository) FindAll() ([]*do_user.User, error) {
	data, err := r.Q.User.Find()
    if err != nil {
        return nil, err
    }
    return data, err
}

func (r *ViewIndexRepository) Save(u *do_user.User) error {
	return r.DB.Create(u).Error
}
