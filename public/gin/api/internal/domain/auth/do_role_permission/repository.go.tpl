package do_role_permission

type Repository interface {
	FindAll() ([]*RolePermission, error)
	Save(rolePermission *RolePermission) error
}
