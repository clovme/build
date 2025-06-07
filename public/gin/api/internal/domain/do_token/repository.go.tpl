package do_token

type Repository interface {
	FindAll() ([]*Token, error)
	Save(token *Token) error
}
