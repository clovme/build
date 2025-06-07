package do_enums

type Repository interface {
	FindAll() ([]*Enums, error)
	Save(enums *Enums) error
}
