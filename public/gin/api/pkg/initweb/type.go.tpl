package initweb

const (
	vxeSelect = "VxeRadioGroup"
	//vxeRadioGroup = "VxeRadioGroup"
	password      = "password"
	arrayType     = "array"
	numberType    = "number"
	normalTheme   = "normal"
	beautifyTheme = "beautify"
)

type Columns struct {
	Field string `json:"field,omitempty"`
	Title string `json:"title,omitempty"`
}

type Props struct {
	Type    string     `json:"type,omitempty"`
	Columns *[]Columns `json:"columns,omitempty"`
}

type Options struct {
	Type    string `json:"type,omitempty"`
	Content string `json:"content,omitempty"`
	Status  string `json:"status,omitempty"`
	Label   string `json:"label,omitempty"`
	Value   string `json:"value,omitempty"`
}

type ItemRender struct {
	Name    string                    `json:"name,omitempty"`
	Props   *Props                    `json:"props,omitempty"`
	Options *[]map[string]interface{} `json:"options,omitempty"`
}

type Form struct {
	Align      string     `json:"align,omitempty"`
	Field      string     `json:"field,omitempty"`
	Title      string     `json:"title,omitempty"`
	Span       int        `json:"span,omitempty"`
	ItemRender ItemRender `json:"itemRender,omitempty"`
}

// ShowWhen 显示条件,页面中出现单选框时,根据单选框的值显示或隐藏其他元素
type ShowWhen struct {
	Field string `json:"field,omitempty"`
	Value string `json:"value,omitempty"`
}

type FormItems struct {
	Span      int       `json:"span,omitempty"`
	Vertical  bool      `json:"vertical,omitempty"`
	TitleBold bool      `json:"titleBold,omitempty"`
	Title     string    `json:"title,omitempty"`
	ShowWhen  *ShowWhen `json:"showWhen,omitempty"`
	Children  *[]Form   `json:"children,omitempty"`
}

type FormData struct {
	OtherDbType      string `json:"OtherDbType"`
	OtherCacheType   string `json:"OtherCacheType"`
	OtherDataPath    string `json:"OtherDataPath"`
	SQLiteDbName     string `json:"SQLiteDbName"`
	MySQLHost        string `json:"MySQLHost"`
	MySQLPort        int    `json:"MySQLPort"`
	MySQLUsername    string `json:"MySQLUsername"`
	MySQLPassword    string `json:"MySQLPassword"`
	MySQLDbName      string `json:"MySQLDbName"`
	WebHost          string `json:"WebHost"`
	WebPort          int    `json:"WebPort"`
	RedisHost        string `json:"RedisHost"`
	RedisPort        int    `json:"RedisPort"`
	RedisPassword    string `json:"RedisPassword"`
	RedisDB          int    `json:"RedisDB"`
	LoggerLevel      string `json:"LoggerLevel"`
	LoggerLogs       string `json:"LoggerLogs"`
	LoggerFormatJson bool   `json:"LoggerFormatJson"`
	LoggerCompress   bool   `json:"LoggerCompress"`
	LoggerMaxSize    int    `json:"LoggerMaxSize"`
	LoggerMaxAge     int    `json:"LoggerMaxAge"`
	LoggerMaxBackups int    `json:"LoggerMaxBackups"`
}

// Rules 规则校验
type Rules struct {
	Type     string `json:"type,omitempty"`
	Min      int    `json:"min,omitempty"`
	Max      int    `json:"max,omitempty"`
	Required bool   `json:"required,omitempty"`
	Pattern  string `json:"pattern,omitempty"`
	Message  string `json:"message,omitempty"`
}

type ValidConfig struct {
	Theme string `json:"theme,omitempty"`
}

type FormOptions struct {
	Border          bool                `json:"border,omitempty"`
	TitleColon      bool                `json:"titleColon,omitempty"`
	TitleAlign      string              `json:"titleAlign,omitempty"`
	TitleWidth      int                 `json:"titleWidth,omitempty"`
	TitleBackground bool                `json:"titleBackground,omitempty"`
	ValidConfig     *ValidConfig        `json:"validConfig,omitempty"`
	FormData        *FormData           `json:"data,omitempty"`
	Rules           *map[string][]Rules `json:"rules,omitempty"`
	FormItems       []FormItems         `json:"items,omitempty"`
}
