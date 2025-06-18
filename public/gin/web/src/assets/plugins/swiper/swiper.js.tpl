/**
 * Swiper 背景轮播图
 * @param options url: 图片服务器请求地址，数据最好是数组 [imgurl1,imgurl2,...]
 * @param options speed: 图片切换时间(毫秒)
 * @param options duration: 淡入淡出时间(秒)，默认 speed - 2
 * @param options data: 外部传入的图片数组(优先执行)[imgurl1,imgurl2,...]
 * @param options success: url请求成功后的操作，如果url响应的是数组，则无需重写此方法
 * @param options{{
 *     url: "图片url请求地址",
 *     speed: 4000,
 *     duration: 2000,
 *     data: [],
 *     success: Function
 * }}
 */
const Swiper = (options = { url: "", speed: 6000, duration: 4, data: [], success: undefined }) => {
    let dataIndex = 0
    let swiperIndex = 0
    let cursorIndex = 0
    let isStart = false
    const bg = []
    shuffleArray(options.data)

    const { el = "body", id = "#swiper", speed = 6000, duration = _duration(), data = [] } = options;

    // 图片乱序
    function shuffleArray(array) {
        // URL GET请求
        if (!options.data || options.data.length === 0) {
            const xhr = new XMLHttpRequest()
            xhr.open('GET', options.url, false);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    try {
                        array = JSON.parse(xhr.responseText)
                    } catch (e) {
                        array = []
                        console.warn(
                            `\n%c 背景图片请求内URL: %c ${options.url} \n%c 背景图片请求内容为: %c\n${xhr.responseText}\n%c 背景图片错误信息为: %c\n${e}`,
                            "color: #fff; background: #5f5f5f", "",
                            "color: #fff; background: #5f5f5f", "",
                            "color: #fff; background: #5f5f5f", ""
                        )
                    }
                }
            };
            xhr.send();
        }
        if (options.success) {
            if (typeof options.success === "string") {
                array = eval(options.success)(array)
            } else {
                array = options.success(array)
            }
        }
        try {
            for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [array[i], array[j]] = [array[j], array[i]];
            }
            options.data = array;
        }  catch (e) {
            console.error(`图片数组为: ${array},请传入图片数组,错误信息为: ${e}`)
            options.data = [];
        }
    }

    // 计算淡入淡出时间，默认比循环时间少2秒
    function _duration() {
        let duration_ = speed / 1000 - 2
        if (duration_ <= 0) {
            duration_ = 2
        }
        return duration_
    }

    // 创建背景DOM
    function createDOM(container, index) {
        let swiperDiv = createElementDiv()
        changeBackground(swiperDiv, index)
        container.appendChild(swiperDiv)
        return swiperDiv
    }

    // 计算下一张图片所索引
    function nextIndex() {
        dataIndex = dataIndex >= data.length - 1 ? 0 : dataIndex + 1
        return dataIndex
    }

    // 创建轮播容器和轮播item
    function createElementDiv() {
        const el = document.createElement("div")
        el.style.setProperty("width", "100%")
        el.style.setProperty("height", "100%")
        el.style.setProperty("position", "fixed")
        el.style.setProperty("left", "0")
        el.style.setProperty("top", "0")
        return el
    }

    // 更新背景URL
    function changeBackground(el, index) {
        el.style.setProperty("background", `url("${data[index]}") center center / cover no-repeat`)
    }

    // 创建轮播容器
    function containerEl() {
        const container = createElementDiv()
        container.style.setProperty("z-index", "-999")
        document.body.appendChild(container)
        return container
    }

    // 获取下一个轮播的index
    function swiperNextIndex() {
        swiperIndex = swiperIndex >= bg.length - 1 ? 0 : swiperIndex + 1
        return swiperIndex
    }

    // 获取不在当前和下一个背景的索引
    function swiperBgIndex() {
        let indexes = new Set([cursorIndex, swiperIndex])
        return Array.from(new Set([...new Set([0, 1, 2])].filter(element => !indexes.has(element))))[0];
    }

    // 背景透明度，淡入淡出使用
    function changeTransition(el, opacity, transition) {
        el.style.setProperty("opacity", `${opacity}`)
        el.style.setProperty("transition", transition)
        return el
    }

    // 一个循环的开始
    function swiperBackground() {
        changeTransition(bg[cursorIndex], 1, `opacity ${duration}s ease-in`)
        const bg2 = changeTransition(bg[swiperNextIndex()], 0, "")
        changeTransition(bg[swiperBgIndex()], 0, `opacity ${duration}s ease-out`)

        if (isStart) {
            changeBackground(bg2, nextIndex())
        }
        cursorIndex = swiperIndex
        isStart = true
    }

    // 判断元素是否存在
    if (!document.getElementById("#body-swiper") && data.length > 0) {
        const container = containerEl()
        container.setAttribute("id", "#body-swiper")
        bg.push(createDOM(container, dataIndex))
        bg.push(createDOM(container, nextIndex()))
        bg.push(createDOM(container, nextIndex()))

        // 开启轮播
        swiperBackground()
        setInterval(swiperBackground, speed)
    }
}