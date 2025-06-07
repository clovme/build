package do_user_role

type Repository interface {
	FindAll() ([]*UserRole, error)
	Save(userRole *UserRole) error
}
