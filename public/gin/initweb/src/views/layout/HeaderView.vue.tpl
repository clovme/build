
<script lang="ts" setup>
import { ref, computed } from 'vue'
import { VxeGlobalI18nLocale, VxePulldownEvents } from 'vxe-pc-ui'
import { useAppStore } from '@/store/app'

const appStore = useAppStore()

const title = ref(document.title)

const langPullList = ref([
  { label: '简体中文', value: 'zh-CN' },
  { label: 'English', value: 'en-US' }
])

const langLabel = computed(() => {
  const item = langPullList.value.find(item => item.value === appStore.language)
  return item ? item.label : appStore.language
})

const currTheme = computed({
  get () {
    return appStore.theme
  },
  set (name) {
    appStore.setTheme(name)
  }
})

const currPrimaryColor = computed({
  get () {
    return appStore.primaryColor
  },
  set (color) {
    appStore.setPrimaryColor(color || '')
  }
})

const currCompSize = computed({
  get () {
    return appStore.componentsSize
  },
  set (size) {
    appStore.setComponentsSize(size)
  }
})

const colorList = ref([
  '#409eff', '#29D2F8', '#31FC49', '#3FF2B3', '#B52DFE', '#FC3243', '#FA3077', '#D1FC44', '#FEE529', '#FA9A2C'
])

const sizeOptions = ref([
  { label: '默认', value: '' },
  { label: '中', value: 'medium' },
  { label: '小', value: 'small' },
  { label: '迷你', value: 'mini' }
])

const langOptionClickEvent: VxePulldownEvents.OptionClick = ({ option }) => {
  appStore.setLanguage(option.value as VxeGlobalI18nLocale)
}
</script>

<template>
  <div class="page-header">
    <div class="header-left"><h2 v-text="title"></h2></div>
    <div class="header-right">
      <span class="right-item">
        <vxe-switch
          class="right-item-comp"
          v-model="currTheme"
          size="mini"
          open-value="light"
          open-label="白天"
          close-value="dark"
          close-label="夜间">
        </vxe-switch>
      </span>

      <span class="right-item">
        <vxe-color-picker class="switch-primary-color" v-model="currPrimaryColor" :colors="colorList" size="mini"></vxe-color-picker>
      </span>

      <span class="right-item">
        <vxe-radio-group class="switch-size" v-model="currCompSize" :options="sizeOptions" type="button" size="mini"></vxe-radio-group>
      </span>

      <span class="right-item">
        <vxe-pulldown :options="langPullList" trigger="click" class="right-item-comp" show-popup-shadow transfer  @option-click="langOptionClickEvent">
          <vxe-button mode="text" icon="vxe-icon-language-switch" :content="langLabel"></vxe-button>
        </vxe-pulldown>
      </span>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.page-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 50px;
  padding: 0 16px;
  border-bottom: 1px solid var(--page-layout-border-color);

  .header-left {
    flex-grow: 1;
  }

  .header-right {
    display: flex;
    flex-direction: row;
    flex-shrink: 0;
    align-items: center;
  }

  .right-item {
    cursor: pointer;
    margin-left: 24px;
  }
  .right-item-title {
    vertical-align: middle;
  }

  .right-item-comp {
    vertical-align: middle;
  }

  .user-avatar {
    display: inline-flex;
    flex-direction: row;
    align-items: center;
    cursor: pointer;
  }

  .user-picture {
    width: 24px;
    height: 24px;
    margin: 0 2px;
  }

  .collapseBtn {
    font-size: 18px;
  }
}
</style>
