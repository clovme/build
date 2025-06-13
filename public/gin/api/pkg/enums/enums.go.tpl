package enums

type Enums struct {
	Key  string
	Name string
	Desc string
}

type Enum interface {
	Key() string
	Name() string
	Desc() string
	Int() int
	String() string
}
