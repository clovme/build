package do_config

type Repository interface {
	FindAll() ([]*Config, error)
	Save(config *Config) error
}
