<script lang="ts" setup>
import HeaderView from './HeaderView.vue'
import FooterView from './FooterView.vue'
import { useAppStore } from '@/store/app'
import Initialize from '@/views/Initialize/Initialize.vue'

const appStore = useAppStore()
</script>

<style lang="scss" scoped>
.page-aside {
  padding: 8px 0;
  border-right: 1px solid var(--page-layout-border-color);
}

.page-body {
  padding: 16px 16px 0 16px;
  background-color: var(--page-layout-background-color);
}

:deep(.vxe-layout-body) {
  overflow: auto !important;
}
</style>

<template>
  <vxe-layout-container :size="appStore.componentsSize">
    <vxe-layout-container vertical>
      <vxe-layout-header>
        <HeaderView />
      </vxe-layout-header>
      <vxe-layout-body :key="appStore.pageKey" class="page-body">
        <Initialize />
      </vxe-layout-body>
      <vxe-layout-footer>
        <FooterView />
      </vxe-layout-footer>
    </vxe-layout-container>
  </vxe-layout-container>
</template>
