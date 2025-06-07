package do_permission

type Repository interface {
	FindAll() ([]*Permission, error)
	Save(Permission *Permission) error
}
