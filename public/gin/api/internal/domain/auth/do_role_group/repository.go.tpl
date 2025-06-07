package do_role_group

type Repository interface {
	FindAll() ([]*RoleGroup, error)
	Save(roleGroup *RoleGroup) error
}
