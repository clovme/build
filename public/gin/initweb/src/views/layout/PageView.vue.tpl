<script lang="ts" setup>
defineProps({
  loading: Boolean,
  loadingText: String,
  padding: {
    type: Boolean,
    default: true
  },
  background: {
    type: Boolean,
    default: true
  }
})
</script>

<template>
  <div :class="['page-view', {'is-pg': padding, 'is-bg': background}]">
    <slot></slot>
  </div>
</template>

<style lang="scss" scoped>
.page-view {
  position: relative;
  height: 100%;
  min-width: 800px;
  overflow: auto;
  border-radius: 6px;

  &.is-pg {
    padding: 10px;
  }

  &.is-bg {
    background-color: var(--page-layout-body-background-color);
  }
}
</style>
