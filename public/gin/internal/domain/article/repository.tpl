package article

type Repository interface {
	FindAll() ([]Article, error)
	Save(article *Article) error
}
