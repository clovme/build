<script lang="ts" setup>
import PageView from '@/views/layout/PageView.vue'
import { ref, watch } from 'vue'
import VxeUI, { VxeFormListeners, VxeFormProps } from 'vxe-pc-ui'
import { getFormConfig, postFormConfig } from '@/api/initiate.ts'

interface FormDataVO {
  OtherDbType: string,
  OtherCacheType: string,
  OtherDataPath: string,
  SQLiteDbName: string,
  MySQLHost: string,
  MySQLPort: number,
  MySQLUsername: string,
  MySQLPassword: string,
  MySQLDbName: string,
  WebHost: string,
  WebPor: number,
  RedisHost: string,
  RedisPort: number,
  RedisPassword: string,
  LoggerLevel: string,
  LoggerLogs: string,
  LoggerFormatJson: boolean,
  LoggerCompress: boolean,
  LoggerMaxSize: number,
  LoggerMaxAge: number,
  LoggerMaxBackups: number
}

let configData = {}
const watchType = {}
const formOptions = ref<VxeFormProps<FormDataVO>>()

function filterVisibleItems (items, data) {
  return items.filter(group => {
    if (group.showWhen) {
      const { field, value } = group.showWhen
      watchType[field] = value
      return data[field] === value
    }
    return true
  })
}

getFormConfig().then((config) => {
  configData = JSON.parse(JSON.stringify(config.data.items))
  formOptions.value = config.data as VxeFormProps<FormDataVO>

  // 初始过滤
  formOptions.value.items = filterVisibleItems(formOptions.value.items, formOptions.value.data)

  for (const watchTypeKey in watchType) {
    // @ts-ignore
    watch(() => formOptions.value?.data[watchTypeKey], () => {
      if (formOptions.value) {
        formOptions.value.items = filterVisibleItems(configData, formOptions.value.data)
      }
    })
  }
})

const formEvents: VxeFormListeners<FormDataVO> = {
  submit () {
    // @ts-ignore
    formOptions.value.loading = true
    postFormConfig(formOptions.value?.data).then(result => {
      if (result.code === 10000) {
        VxeUI.modal.message({ content: '系统初始化完成，请查看日志信息', status: 'success' })
        setTimeout(() => {
          window.location.href = result.message
        }, 2000)
      } else {
        // @ts-ignore
        formOptions.value.loading = false
        VxeUI.modal.message({ content: '系统初始化失败，请检查', status: 'error' })
      }
    })
  }
}
</script>

<template>
  <PageView class="initialize-page" :padding="true" :background="true">
    <div>
      <vxe-form class-name="initialize-page-form" v-bind="formOptions" v-on="formEvents" />
    </div>
  </PageView>
</template>

<style lang="scss" scoped>
.initialize-page {
  display: flex;
  justify-content: center;

  .initialize-page-form {
    width: 800px;
  }
}
</style>
