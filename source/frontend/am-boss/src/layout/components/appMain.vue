<template>
  <section class="app-main">
    <!--<transition name="fade-transform" mode="out-in">-->
    <!--<keep-alive :include="cachedViews">-->
    <!--<router-view :key="key" />-->
    <!--</keep-alive>-->
    <!--</transition>-->
    <router-view :key="key" />
  </section>
</template>

<script>
export default {
  name: 'AppMain',
  computed: {
    cachedViews() {
      return this.$store.state.tagsView.cachedViews;
    },
    key() {
      return this.$route.fullPath;
    }
  }
};
</script>

<style scoped>
  .app-main {
    /* 84 = navbar */
    height: calc(100vh - 84px);
    width: 100%;
    position: relative;
    overflow-y: auto;
  }
  .fixed-header+.app-main {
    padding-top: 50px;
  }
  </style>

  <style lang="scss">
  // fix css style bug in open el-dialog
  .el-popup-parent--hidden {
    .fixed-header {
      padding-right: 15px;
    }
  }
</style>
