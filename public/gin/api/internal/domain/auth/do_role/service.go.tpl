package do_role

type Service struct{}

func NewService() *Service {
	return &Service{}
}

// DisableRole 禁用Role
func (s *Service) DisableRole(u *Role) error {
	// 这里本来应该有状态属性，比如 u.IsActive = false
	// 假设我们现在只打印一下
	// u.Name = u.Name + "【已禁用】"
	return nil
}
