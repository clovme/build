import { createApp } from 'vue'
import App from './App.vue'
import i18n from './i18n'
import pinia from './store'

import VxeTable from 'vxe-table'
import 'vxe-table/lib/style.css'

import VxeUI from 'vxe-pc-ui'
import 'vxe-pc-ui/lib/style.css'

import './style/style.scss'

const app = createApp(App)

app.use(i18n).use(pinia).use(VxeUI).use(VxeTable).mount('#app')
