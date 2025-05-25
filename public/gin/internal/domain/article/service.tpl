package article

import "errors"

type Service struct{}

func NewService() *Service {
	return &Service{}
}

// DisableArticle 禁用Article
func (s *Service) DisableArticle(u *Article) error {
	if u.ID == "id" {
		return errors.New("invalid article id")
	}
	// 这里本来应该有状态属性，比如 u.IsActive = false
	// 假设我们现在只打印一下
	// u.Name = u.Name + "【已禁用】"
	return nil
}

// DisableArticles 批量禁用
func (s *Service) DisableArticles(articles []Article) []error {
	var errs []error
	for i := range articles {
		if err := s.DisableArticle(&articles[i]); err != nil {
			errs = append(errs, err)
		}
	}
	return errs
}
