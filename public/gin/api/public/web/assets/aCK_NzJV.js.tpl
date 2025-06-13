import{_ as T}from"./XnZ52jX-.js";import{b as $,E as k,d as j,t as V,v as N,e as E}from"./Dp2quOww.js";import{e as w,p as q,n as F,c as g,g as x,o as v,a as t,h as M,x as S,y as _,i as d,w as s,b as e,O as C,K as z,P as L,F as P,r as G,Q as D,d as f,f as Q,m as A,B as H}from"./D5WYelTe.js";import{b as K,_ as O,w as R}from"./gSGeHy51.js";import{c as J,u as U}from"./DF7d02V2.js";import{M as W,_ as X,a as Y}from"./BAbSPbuL.js";import{_ as I}from"./DlAUqK2U.js";import{E as Z}from"./C3ki9-3U.js";import{E as tt}from"./C_2j8Isb.js";import{_ as et}from"./ii-bcQZC.js";const it=K({type:{type:String,values:["primary","success","info","warning","danger"],default:"primary"},closable:Boolean,disableTransitions:Boolean,hit:Boolean,color:String,size:{type:String,values:J},effect:{type:String,values:["dark","light","plain"],default:"light"},round:Boolean}),at={close:c=>c instanceof MouseEvent,click:c=>c instanceof MouseEvent},st=w({name:"ElTag"}),ot=w({...st,props:it,emits:at,setup(c,{emit:m}){const i=c,n=U(),l=q("tag"),p=F(()=>{const{type:o,hit:h,effect:y,closable:b,round:B}=i;return[l.b(),l.is("closable",b),l.m(o||"primary"),l.m(n.value),l.m(y),l.is("hit",h),l.is("round",B)]}),a=o=>{m("close",o)},r=o=>{m("click",o)},u=o=>{var h,y,b;(b=(y=(h=o==null?void 0:o.component)==null?void 0:h.subTree)==null?void 0:y.component)!=null&&b.bum&&(o.component.subTree.component.bum=null)};return(o,h)=>o.disableTransitions?(v(),g("span",{key:0,class:_(d(p)),style:z({backgroundColor:o.color}),onClick:r},[t("span",{class:_(d(l).e("content"))},[S(o.$slots,"default")],2),o.closable?(v(),x(d(k),{key:0,class:_(d(l).e("close")),onClick:C(a,["stop"])},{default:s(()=>[e(d($))]),_:1},8,["class","onClick"])):M("v-if",!0)],6)):(v(),x(L,{key:1,name:`${d(l).namespace.value}-zoom-in-center`,appear:"",onVnodeMounted:u},{default:s(()=>[t("span",{class:_(d(p)),style:z({backgroundColor:o.color}),onClick:r},[t("span",{class:_(d(l).e("content"))},[S(o.$slots,"default")],2),o.closable?(v(),x(d(k),{key:0,class:_(d(l).e("close")),onClick:C(a,["stop"])},{default:s(()=>[e(d($))]),_:1},8,["class","onClick"])):M("v-if",!0)],6)]),_:3},8,["name"]))}});var dt=O(ot,[["__file","tag.vue"]]);const lt=R(dt),nt={class:"details-aside"},rt={class:"details-aside-items"},mt=w({__name:"AsideRight",setup(c){let m;return m=document.documentElement,(i,n)=>(v(),g("div",nt,[t("div",rt,[e(d(W),{editorId:"details-preview-only",scrollElement:d(m)},null,8,["scrollElement"])])]))}}),ct=I(mt,[["__scopeId","data-v-e23438e7"]]),ut={class:"details-aside"},vt={class:"details-aside-user"},pt={class:"details-aside-name"},ft={class:"details-aside-item"},_t={class:"details-aside-item-child"},ht={class:"details-aside-item"},gt=w({__name:"AsideLeft",setup(c){return(m,i)=>{const n=T,l=X,p=k,a=Z,r=tt;return v(),g("div",ut,[(v(),g(P,null,G(2,u=>t("div",{class:"details-aside-items",key:u},[t("div",vt,[e(l,null,{default:s(()=>[e(n,{to:"/details"},{default:s(()=>i[0]||(i[0]=[t("div",{class:"details-aside-avatar zoom-1"},[t("img",{src:et,alt:"发表用户"})],-1)])),_:1,__:[0]})]),_:1}),t("div",pt,[e(n,{to:"/details"},{default:s(()=>i[1]||(i[1]=[f("用户昵称")])),_:1,__:[1]}),i[2]||(i[2]=t("div",{class:"details-aside-description"},[t("span",{class:"text-color-light"},"加入时间：10年")],-1))])]),t("div",ft,[e(n,{class:"details-aside-item-child",to:"/details"},{default:s(()=>i[3]||(i[3]=[t("div",{class:"count"},"170",-1),t("div",null,"原创",-1)])),_:1,__:[3]}),e(n,{class:"details-aside-item-child",to:"/details"},{default:s(()=>i[4]||(i[4]=[t("div",{class:"count"},"1万+",-1),t("div",null,"周排名",-1)])),_:1,__:[4]}),e(n,{class:"details-aside-item-child",to:"/details"},{default:s(()=>i[5]||(i[5]=[t("div",{class:"count"},"8930",-1),t("div",null,"总排名",-1)])),_:1,__:[5]}),i[7]||(i[7]=t("div",{class:"details-aside-item-child"},[t("div",{class:"count"},"15万+"),t("div",{class:"text-color-light"},"访问")],-1)),t("div",_t,[e(n,{to:"/details"},{default:s(()=>[e(p,null,{default:s(()=>[e(d(j))]),_:1})]),_:1}),i[6]||(i[6]=t("div",{class:"text-color-light"},"等级",-1))])]),e(a),i[10]||(i[10]=D('<div class="details-aside-item" data-v-ce74bf03><div class="details-aside-item-child" data-v-ce74bf03><div class="count" data-v-ce74bf03>3859</div><div class="text-color-light" data-v-ce74bf03>积分</div></div><div class="details-aside-item-child" data-v-ce74bf03><div class="count" data-v-ce74bf03>870</div><div class="text-color-light" data-v-ce74bf03>粉丝</div></div><div class="details-aside-item-child" data-v-ce74bf03><div class="count" data-v-ce74bf03>1550</div><div class="text-color-light" data-v-ce74bf03>获赞</div></div><div class="details-aside-item-child" data-v-ce74bf03><div class="count" data-v-ce74bf03>52</div><div class="text-color-light" data-v-ce74bf03>评论</div></div><div class="details-aside-item-child" data-v-ce74bf03><div class="count" data-v-ce74bf03>1950</div><div class="text-color-light" data-v-ce74bf03>收藏</div></div></div>',1)),t("div",ht,[e(r,{round:""},{default:s(()=>i[8]||(i[8]=[f("私信")])),_:1,__:[8]}),e(r,{round:""},{default:s(()=>i[9]||(i[9]=[f("关注")])),_:1,__:[9]})])])),64))])}}}),wt=I(gt,[["__scopeId","data-v-ce74bf03"]]),yt={class:"details-box"},bt={class:"details-content"},kt={class:"details-content-title-box"},xt={class:"details-content-title-info"},It={class:"details-content-title-description-box"},$t={class:"details-content-title-description"},Et={class:"details-content-title-description-item"},Mt={class:"details-content-title-description-item"},St={class:"details-content-title-description-item"},Ct={class:"details-content-title-description-o"},zt={class:"details-content-title-tag"},At=w({__name:"[id]",setup(c){Q({description:"详情",titleTemplate:"%s - 详情"});let m;const i=A("light"),n=A(`## 🐶 标题

\`\`\`markdown
## 标题
\`\`\`

---

## 🐱 加粗

**I have a dream that one day this nation will rise up.**

\`\`\`markdown
**I have a dream that one day this nation will rise up.**
\`\`\`

---

## 🐭 斜体

_It is a dream deeply rooted in the American dream._

\`\`\`markdown
_It is a dream deeply rooted in the American dream._
\`\`\`

---

## 🐹 删除线

~~It is a dream deeply rooted in the American dream.~~

\`\`\`markdown
~~It is a dream deeply rooted in the American dream.~~
\`\`\`

---

## 🐻 超链接

[md-editor-v3](https://imzbf.github.io/md-editor-v3/)

\`\`\`markdown
[md-editor-v3](https://imzbf.github.io/md-editor-v3/)
\`\`\`

---

## 🐼 图片

![描述文字](/imgs/mark_emoji.gif 'title')

\`\`\`markdown
![描述文字](/imgs/mark_emoji.gif 'title')
\`\`\`

---

## 🙉 下划线

<u>So even though we face the difficulties of today and tomorrow, I still have a dream.</u>

\`\`\`markdown
<u>So even though we face the difficulties of today and tomorrow, I still have a dream.</u>
\`\`\`

---

## 🙊 上标

I have a dream that one day this nation will rise up.^[1]^

\`\`\`markdown
I have a dream that one day this nation will rise up.^[1]^
\`\`\`

---

## 🐒 下标

I have a dream that one day this nation will rise up.~[2]~

\`\`\`markdown
I have a dream that one day this nation will rise up.~[2]~
\`\`\`

---

## 🐰 行内代码

\`md-editor-v3\`

\`\`\`markdown
\`md-editor-v3\`
\`\`\`

---

## 🦊 块级代码

\`\`\`\`markdown
\`\`\`js
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
\`\`\`
\`\`\`\`

### 🗄 代码组合

\`\`\`shell [id:yarn]
yarn add md-editor-v3
\`\`\`

\`\`\`shell [id:npm]
npm install md-editor-v3
\`\`\`

\`\`\`shell [id:pnpm]
pnpm install md-editor-v3
\`\`\`

\`\`\`\`markdown
\`\`\`shell [id:yarn]
yarn add md-editor-v3
\`\`\`

\`\`\`shell [id:npm]
npm install md-editor-v3
\`\`\`

\`\`\`shell [id:pnpm]
pnpm install md-editor-v3
\`\`\`
\`\`\`\`

### 🤌🏻 强制折叠

\`\`\`js ::close
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
\`\`\`

\`\`\`\`markdown
\`\`\`js ::close
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
\`\`\`
\`\`\`\`

### 👐 强制展开

\`\`\`js ::open
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
\`\`\`

\`\`\`\`markdown
\`\`\`js ::open
import MdEditor from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
\`\`\`
\`\`\`\`

据其他编辑器的了解，目前没有其他编辑器使用类似的语法，如果需要拷贝你的内容到其他编辑器展示时，请谨慎使用该语法。

---

## 🐻‍❄️ 引用

> 引用：《I Have a Dream》

\`\`\`markdown
> 引用：《I Have a Dream》
\`\`\`

---

## 🐨 有序列表

1. So even though we face the difficulties of today and tomorrow, I still have a dream.
2. It is a dream deeply rooted in the American dream.
3. I have a dream that one day this nation will rise up.

\`\`\`markdown
1. So even though we face the difficulties of today and tomorrow, I still have a dream.
2. It is a dream deeply rooted in the American dream.
3. I have a dream that one day this nation will rise up.
\`\`\`

---

## 🐯 无序列表

- So even though we face the difficulties of today and tomorrow, I still have a dream.
- It is a dream deeply rooted in the American dream.
- I have a dream that one day this nation will rise up.

\`\`\`markdown
- So even though we face the difficulties of today and tomorrow, I still have a dream.
- It is a dream deeply rooted in the American dream.
- I have a dream that one day this nation will rise up.
\`\`\`

---

## 🦁 任务列表

- [ ] 周五
- [ ] 周六
- [x] 周天

\`\`\`markdown
- [ ] 周五
- [ ] 周六
- [x] 周天
\`\`\`

支持在预览模块切换任务状态的[示例](https://imzbf.github.io/md-editor-v3/zh-CN/demo#☑%EF%B8%8F%20可切换状态的任务列表)

---

## 🐮 表格

| 表头1  |  表头2   |  表头3 | 表头4 |
| :----- | :------: | -----: | ----- |
| 左对齐 | 中间对齐 | 右对齐 | 默认  |

\`\`\`markdown
| 表头1  |  表头2   |  表头3 | 表头4 |
| :----- | :------: | -----: | ----- |
| 左对齐 | 中间对齐 | 右对齐 | 默认  |
\`\`\`

---

## 🐷 数学公式

有两种模式

### 🐽 行内

$x+y^{2x}$ \\(\\xrightarrow[under]{over}\\)

\`\`\`markdown
$x+y^{2x}$

<!-- or -->

\\(\\xrightarrow[under]{over}\\)
\`\`\`

---

### 🐸 块级

$$\\sqrt[3]{x}$$

\\[\\xrightarrow[under]{over}\\]

\`\`\`markdown
$$
\\sqrt[3]{x}
$$

<!-- or -->

\\[\\xrightarrow[under]{over}\\]
\`\`\`

更多公式示例参考：[https://katex.org/docs/supported.html](https://katex.org/docs/supported.html)

---

## 🐵 图表

\`\`\`mermaid
---
title: Example Git diagram
---
gitGraph
   commit
   commit
   branch develop
   checkout develop
   commit
   commit
   checkout main
   merge develop
   commit
   commit
\`\`\`

\`\`\`\`markdown
\`\`\`
---
title: Example Git diagram
---
gitGraph
   commit
   commit
   branch develop
   checkout develop
   commit
   commit
   checkout main
   merge develop
   commit
   commit
\`\`\`
\`\`\`\`

更多图形示例参考：[https://mermaid.js.org/syntax/flowchart.html](https://mermaid.js.org/syntax/flowchart.html)

---

## 🙈 提示

!!! note 支持的类型

note、abstract、info、tip、success、question、warning、failure、danger、bug、example、quote、hint、caution、error、attention

!!!

\`\`\`markdown
!!! note 支持的类型

note、abstract、info、tip、success、question、warning

failure、danger、bug、example、quote、hint、caution、error、attention

!!!
\`\`\``);function l(p){p.matches?i.value="dark":i.value="light"}return m=window.matchMedia("(prefers-color-scheme: dark)"),H(()=>{window.matchMedia&&window.matchMedia("(prefers-color-scheme: dark)").matches?i.value="dark":i.value="light",m.addEventListener("change",l)}),(p,a)=>{const r=T,u=k,o=lt;return v(),g("div",yt,[e(wt),t("div",bt,[t("div",kt,[a[10]||(a[10]=t("h1",null,"从零开始构建完整的知识体系",-1)),t("div",xt,[t("div",It,[t("div",$t,[e(r,{to:"/details"},{default:s(()=>a[0]||(a[0]=[f("发表用户")])),_:1,__:[0]}),t("div",Et,[e(u,null,{default:s(()=>[e(d(V))]),_:1}),a[1]||(a[1]=t("span",{class:"count"},"于2025-03-29 23:08:12发布",-1))]),t("div",Mt,[e(u,null,{default:s(()=>[e(d(N))]),_:1}),a[2]||(a[2]=t("span",{class:"count"},"阅读量605",-1))]),e(r,{class:"details-content-title-description-item",to:"/details"},{default:s(()=>[e(u,null,{default:s(()=>[e(d(E))]),_:1}),a[3]||(a[3]=t("span",{class:"count"},"收藏",-1)),a[4]||(a[4]=t("span",{class:"count"},"12",-1))]),_:1,__:[3,4]}),t("div",St,[e(u,null,{default:s(()=>[e(d(E))]),_:1}),a[5]||(a[5]=t("span",{class:"count"},"点赞数 13",-1))])]),t("div",Ct,[e(r,{class:"count",to:"/meself/article/edit/985211"},{default:s(()=>a[6]||(a[6]=[f("编辑")])),_:1,__:[6]})])]),t("div",zt,[a[9]||(a[9]=t("div",null,"文章标签：",-1)),e(r,{to:"/details"},{default:s(()=>[e(o,{size:"small",type:"primary",effect:"plain"},{default:s(()=>a[7]||(a[7]=[f("数据库")])),_:1,__:[7]})]),_:1}),e(r,{to:"/details"},{default:s(()=>[e(o,{size:"small",type:"primary",effect:"plain"},{default:s(()=>a[8]||(a[8]=[f("MySQL")])),_:1,__:[8]})]),_:1})])])]),e(d(Y),{theme:i.value,codeTheme:"github",codeFoldable:!1,noPrettier:!0,id:"details-preview-only",modelValue:n.value},null,8,["theme","modelValue"])]),e(ct)])}}}),Dt=I(At,[["__scopeId","data-v-1333db25"]]);export{Dt as default};
