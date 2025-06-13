<!DOCTYPE html><html  lang="zh"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>我的知识库 - 登录</title>
<style>:root{--sky-blue:#00aeec;--blue:#007bff;--indigo:#6610f2;--purple:#6f42c1;--pink:#e83e8c;--red:#dc3545;--orange:#fd7e14;--flame-orange:#fc5531;--yellow:#ffc107;--green:#28a745;--teal:#20c997;--cyan:#17a2b8;--white:#fff;--gray:#6c757d;--cool-gray:#040507;--gray-dark:#343a40;--primary:#007bff;--secondary:#6c757d;--success:#28a745;--info:#17a2b8;--warning:#ffc107;--danger:#dc3545;--silver-gray:#e3e5e7;--light:#f8f9fa;--dark:#343a40;--breakpoint-xs:0;--breakpoint-sm:576px;--breakpoint-md:768px;--breakpoint-lg:992px;--breakpoint-xl:1200px;--font-family-sans-serif:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji"}:root{--gap:10px;--padding:var(--gap);--radius:5px;--border:1px solid rgba(0,0,0,.125)}::-webkit-scrollbar{width:0}*{font-family:var(--font-family-sans-serif),serif;margin:0;padding:0}:focus{outline:none}body{background-color:var(--silver-gray);font-size:14px}#app,body,html{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;-webkit-box-orient:vertical;-webkit-box-direction:normal;-webkit-flex-direction:column;-moz-box-orient:vertical;-moz-box-direction:normal;-ms-flex-direction:column;flex-direction:column;height:100%}.ul-none{list-style:none;margin:0;padding:0}a{color:var(--Ga10);text-decoration:none;-webkit-transition:color var(--el-transition-duration);transition:color var(--el-transition-duration)}a:hover{color:var(--flame-orange)}.count{color:#4a4d52}.text-color-light{color:var(--cool-gray)}.zoom-1{opacity:1;-webkit-transition:all .2s;transition:all .2s}.zoom-1:hover{opacity:.9;-webkit-transform:scale(1.1);-ms-transform:scale(1.1);transform:scale(1.1)}.zoom-2{opacity:1;-webkit-transition:all .2s;transition:all .2s}.zoom-2:hover{opacity:.9;-webkit-transform:scale(1.2);-ms-transform:scale(1.2);transform:scale(1.2)}.zoom-3{opacity:1;-webkit-transition:all .2s;transition:all .2s}.zoom-3:hover{opacity:.9;-webkit-transform:scale(1.3);-ms-transform:scale(1.3);transform:scale(1.3)}.zoom-4{opacity:1;-webkit-transition:all .2s;transition:all .2s}.zoom-4:hover{opacity:.9;-webkit-transform:scale(1.4);-ms-transform:scale(1.4);transform:scale(1.4)}.zoom-5{opacity:1;-webkit-transition:all .2s;transition:all .2s}.zoom-5:hover{opacity:.9;-webkit-transform:scale(1.5);-ms-transform:scale(1.5);transform:scale(1.5)}.page-enter-active,.page-leave-active{-webkit-transition:all .4s ease;transition:all .4s ease}.page-enter-from{opacity:0;-webkit-transform:translateX(30vw);-ms-transform:translateX(30vw);transform:translate(30vw)}.page-enter-to,.page-leave-from{opacity:1;-webkit-transform:translateX(0);-ms-transform:translateX(0);transform:translate(0)}.page-leave-to{opacity:0;-webkit-transform:translateX(-30vw);-ms-transform:translateX(-30vw);transform:translate(-30vw)}.login-box{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;height:100vh;width:600px}.login-box .login-container{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;gap:20px;width:100%}.login-box .login-container .login-tip{text-align:center;width:200px}.login-box .login-container .login-tip h1{font-size:24px;font-weight:700;margin-bottom:10px}.login-box .login-container .login-split{background-color:#747675ba;width:1px}.login-box .login-container .el-form{-webkit-box-flex:1;-webkit-flex:1;-moz-box-flex:1;-ms-flex:1;flex:1}.login-box .login-container .el-form .el-form-item:last-child{margin-bottom:0}.login-box .login-container .el-form .el-form-item:last-child :deep(.el-form-item__content){-webkit-box-pack:end;-webkit-justify-content:flex-end;-moz-box-pack:end;-ms-flex-pack:end;justify-content:flex-end}.login-box .login-container{background-color:var(--white);border-radius:var(--radius);color:var(--dark);padding:80px 20px}@media (prefers-color-scheme:dark){.login-box .login-container{background-color:var(--dark)!important;color:var(--white)!important}}@media (prefers-color-scheme:dark){.el-checkbox:not(.is-checked) .el-checkbox__label,.el-form-item__label,.el-input__count-inner,.el-input__wrapper,.el-radio:not(.is-checked) .el-radio__label,.el-select-dropdown__wrap,.el-select__wrapper,.el-tag,button,textarea{background-color:var(--dark)!important;color:var(--white)!important}.is-hovering{background-color:#2f2f2f!important}}.link-button{border-radius:20px!important}.link-button:hover{background-color:#0000001a!important}</style>
<style>.app-box{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;height:100%;margin:0;padding:0}.app-box .el-main{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;background-position:50%;background-repeat:no-repeat;background-size:cover;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;-webkit-box-flex:1;-webkit-flex:1;-moz-box-flex:1;-ms-flex:1;flex:1;-webkit-box-orient:vertical;-webkit-box-direction:normal;-webkit-flex-direction:column;-moz-box-orient:vertical;-moz-box-direction:normal;-ms-flex-direction:column;flex-direction:column;margin-top:55px;min-width:1130px;padding:var(--padding)}.app-box .el-header{-webkit-box-shadow:0 0 5px 1px #bfc6cd;box-shadow:0 0 5px 1px #bfc6cd;height:unset;position:fixed;top:0;width:100%;z-index:999}.app-box .el-header .header-wrap{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;gap:15px;-webkit-box-pack:justify;-webkit-justify-content:space-between;-moz-box-pack:justify;-ms-flex-pack:justify;justify-content:space-between;padding:5px 0}.app-box .el-header .header-wrap .header-search{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;-webkit-box-flex:1;-webkit-flex:1;-moz-box-flex:1;-ms-flex:1;flex:1;-webkit-box-pack:center;-webkit-justify-content:center;-moz-box-pack:center;-ms-flex-pack:center;justify-content:center}.app-box .el-header .header-wrap .header-search .el-input{max-width:480px}.app-box .el-header .header-wrap ul{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;gap:15px}.app-box .el-header .header-wrap ul.header-wrap-left{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;font-size:14px}.app-box .el-header .header-wrap ul.header-wrap-left li .router-link-active{color:var(--sky-blue)}.app-box .el-header .header-wrap ul.header-wrap-left a.header-logo-wrap{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;gap:10px;height:45px;overflow:hidden}.app-box .el-header .header-wrap ul.header-wrap-left a.header-logo-wrap .header-logo-wrap-logo{background-color:var(--white);color:var(--dark)}@media (prefers-color-scheme:dark){.app-box .el-header .header-wrap ul.header-wrap-left a.header-logo-wrap .header-logo-wrap-logo{background-color:var(--dark)!important;color:var(--white)!important}}.app-box .el-header .header-wrap ul.header-wrap-right{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center}.app-box .el-header .header-wrap ul.header-wrap-right li a{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;-webkit-box-orient:vertical;-webkit-box-direction:normal;-webkit-flex-direction:column;-moz-box-orient:vertical;-moz-box-direction:normal;-ms-flex-direction:column;flex-direction:column}.app-box .el-header .header-wrap ul.header-wrap-right li a .el-icon,.app-box .el-header .header-wrap ul.header-wrap-right li a .el-icon svg{font-size:18px}.app-box .el-header .header-wrap ul.header-wrap-right li a:hover .el-icon{color:var(--Ga10)}.app-box .el-header .header-wrap ul li.header-avatar-wrap{border-radius:100%;-webkit-box-shadow:inset 0 -1px 0 var(--line-regular)!important;box-shadow:inset 0 -1px 0 var(--line-regular)!important;-webkit-box-sizing:content-box;-moz-box-sizing:content-box;box-sizing:content-box;cursor:pointer;height:30px;overflow:hidden;position:relative;width:30px}.app-box .el-header .header-wrap ul li.header-avatar-wrap img{height:100%;-o-object-fit:cover;object-fit:cover;width:100%}.app-box .el-header{background-color:var(--white);color:var(--dark)}@media (prefers-color-scheme:dark){.app-box .el-header{background-color:var(--dark)!important;color:var(--white)!important}}</style>
<style>.me-input-box{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;background-color:var(--el-bg-color,#fff);border-radius:var(--el-input-border-radius,var(--el-border-radius-base));-webkit-box-shadow:inset 0 0 0 1px #737674;box-shadow:inset 0 0 0 1px #737674;cursor:text;display:-webkit-inline-box;display:-webkit-inline-flex;display:-moz-inline-box;display:-ms-inline-flexbox;display:inline-flex;font-size:var(--font-size);padding:1px 11px;position:relative;-webkit-transition:-webkit-box-shadow .2s ease;transition:-webkit-box-shadow .2s ease;transition:box-shadow .2s ease;transition:box-shadow .2s ease,-webkit-box-shadow .2s ease;width:100%}.me-input-box .me-input-placeholder{background-color:var(--el-bg-color,#fff);color:#737674;font-size:14px;height:14px;left:11px;line-height:14px;padding:0 4px;pointer-events:none;position:absolute;top:50%;-webkit-transform:translateY(-50%);-ms-transform:translateY(-50%);transform:translateY(-50%);-webkit-transition:all .2s ease;transition:all .2s ease;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.me-input-box .me-input{-webkit-appearance:none;-moz-appearance:none;appearance:none;background:none;border:none;color:var(--el-input-text-color,var(--el-text-color-regular));-webkit-box-flex:1;-webkit-flex-grow:1;-moz-box-flex:1;-ms-flex-positive:1;flex-grow:1;font-size:inherit;height:var(--el-input-inner-height);line-height:var(--el-input-inner-height);outline:none;padding:0;width:100%}.me-input-box .me-clear-icon{-webkit-box-align:center;-webkit-align-items:center;-moz-box-align:center;-ms-flex-align:center;align-items:center;cursor:pointer;display:none;font-size:14px;height:100%;-webkit-box-pack:start;-webkit-justify-content:flex-start;-moz-box-pack:start;-ms-flex-pack:start;justify-content:flex-start;position:absolute;right:0;-webkit-transition:color .2s;transition:color .2s;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;width:25px}.me-input-box .me-clear-icon i{color:#909399;-webkit-transition:color .2s;transition:color .2s}.me-input-box .me-clear-icon i:hover{color:#c1c4ca}.me-input-box:hover .me-clear-icon{display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex}.me-input-box:focus-within{-webkit-box-shadow:inset 0 0 0 1px #409eff;box-shadow:inset 0 0 0 1px #409eff}.me-input-box:focus-within .me-input-placeholder{color:#409eff}.me-input-box.has-value .me-input-placeholder,.me-input-box:focus-within .me-input-placeholder{font-size:12px;height:12px;line-height:12px;top:0}@media (prefers-color-scheme:dark){.me-input-box,.me-input-box .me-input-placeholder{background-color:var(--dark,#121212)}.me-input-box .me-input-placeholder{color:#bbb}.me-input-box .me-input{color:#eee}.me-input-box .me-clear-icon{color:#666}.me-input-box .me-clear-icon:hover{color:#999}}</style>
<link rel="stylesheet" href="/assets/el-input.uw2Q-UTh.css" crossorigin>
<link rel="stylesheet" href="/assets/base.L8-VYUOd.css" crossorigin>
<link rel="stylesheet" href="/assets/el-button.HFX6wX62.css" crossorigin>
<link rel="stylesheet" href="/assets/el-form.3oBk8E0o.css" crossorigin>
<meta name="description" content="登录">
</head>
<body>
<div id="app" lang="zh">
    <div class="app-box">
        <header class="el-header">
            <div class="header-wrap">
                <ul class="header-wrap-left ul-none">
                    <li><a href="/" class="header-logo-wrap">
                        <h1 class="header-logo-wrap-logo">知识库</h1>
                        <span class="zoom-1">首页</span></a>
                    </li>
                </ul>
                <div class="header-search">
                    <div class="el-input el-input--large el-input--suffix">
                        <div class="el-input__wrapper">
                            <input class="el-input__inner" type="text" autocomplete="off" tabindex="0" placeholder="设置 Window 环境变量">
                            <span class="el-input__suffix">
                                <span class="el-input__suffix-inner">
                                    <i class="el-icon el-input__icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path fill="currentColor" d="m795.904 750.72 124.992 124.928a32 32 0 0 1-45.248 45.248L750.656 795.904a416 416 0 1 1 45.248-45.248zM480 832a352 352 0 1 0 0-704 352 352 0 0 0 0 704"></path></svg>
                                    </i>
                                </span>
                            </span>
                        </div>
                    </div>
                </div>
                <ul class="header-wrap-right ul-none">
                    <li class="header-avatar-wrap zoom-4"><a href="/meself"><img src="/imgs/web-avatar-nav.png" alt="Avatar"></a></li>
                    <li><a href="/meself/message">消息</a></li>
                    <li><a href="/">历史</a></li>
                    <li><a href="/admin">系统管理</a></li>
                    <li><a href="/meself/article/add">
                        <button type="button" class="el-button el-button--danger">
                            <i class="el-icon">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
                                    <path fill="currentColor" d="M480 480V128a32 32 0 0 1 64 0v352h352a32 32 0 1 1 0 64H544v352a32 32 0 1 1-64 0V544H128a32 32 0 0 1 0-64z"></path>
                                </svg>
                            </i>
                            <span>写作</span>
                        </button>
                    </a></li>
                    <li style="display:flex;gap:5px;"><a href="/signup">
                        <button type="button" class="el-button el-button--primary el-button--small is-plain is-round"><span>注册</span></button></a>
                    </li>
                </ul>
            </div>
        </header>
        <main class="el-main" style="background-image:url(/imgs/bg.jpg);">
            <div class="login-box">
                <div class="login-container">
                    <div class="login-tip"><h1>登录</h1>
                        <p> 欢迎使用我的知识库，这里是我的学习笔记和知识总结。 </p></div>
                    <div class="login-split"></div>
                    <form class="el-form el-form--default el-form--label-right" style="max-width:600px;">
                        <div class="el-form-item asterisk-left el-form-item--label-right" >
                            <div class="el-form-item__label-wrap"></div>
                            <div class="el-form-item__content" style="margin-left:auto;">
                                <div class="me-input-box" >
                                    <div class="me-input-placeholder" >请输入用户名</div>
                                    <input class="me-input" type="text" value >
                                </div>
                            </div>
                        </div>
                        <div class="el-form-item asterisk-left el-form-item--label-right" >
                            <div class="el-form-item__label-wrap"></div>
                            <div class="el-form-item__content" style="margin-left:auto;">
                                <div class="me-input-box" >
                                    <div class="me-input-placeholder" >请输入密码</div>
                                    <input class="me-input" type="text" value >
                                </div>
                            </div>
                        </div>
                        <div class="el-form-item asterisk-left el-form-item--label-right">
                            <div class="el-form-item__label-wrap"></div>
                            <div class="el-form-item__content" style="margin-left:auto;"><a href="/signup" class="link-button el-button el-button--primary is-text" link>创建账号</a><button type="button" class="el-button el-button--primary is-round"><span>登录　</span></button></div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>