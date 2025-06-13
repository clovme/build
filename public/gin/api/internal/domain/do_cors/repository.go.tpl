package do_cors

type Repository interface {
	FindAll() ([]*CorsWhitelist, error)
	Save(cors *CorsWhitelist) error
}
