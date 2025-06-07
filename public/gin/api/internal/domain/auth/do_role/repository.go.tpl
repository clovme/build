package do_role

type Repository interface {
	FindAll() ([]*Role, error)
	Save(Role *Role) error
}
