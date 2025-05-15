package exists

import "os"

func IsExists(path string) bool {
	_, err := os.Stat(path)
	return !os.IsNotExist(err)
}
