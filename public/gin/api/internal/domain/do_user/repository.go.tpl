package do_user

type Repository interface {
	FindAll() ([]*User, error)
	Save(user *User) error
}
