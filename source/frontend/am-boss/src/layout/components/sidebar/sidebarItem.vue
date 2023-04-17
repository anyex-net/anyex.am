<template>
  <div class="menu-wrapper">
    <el-submenu v-if="hasChild(item.children)" ref="subMenu" popper-append-to-body :index="item.text">
      <template slot="title">
        <svg-icon icon-class="example"></svg-icon>
        <span>{{ item.text }}</span>
      </template>
      <sidebar-item
        v-for="list in item.children"
        :key="list.id"
        :item="list"
        :base-path="list.path"
        class="nest-menu"
      />
    </el-submenu>
    <template v-else>
      <router-link :to="item.attributes">
        <el-menu-item :index="item.attributes">
          <i class="el-icon-menu"></i>
          <span slot="title">{{ item.text }}</span>
        </el-menu-item>
      </router-link>
    </template>
  </div>
</template>

<script>
import fixBugIOS from './fixBugIOS';

export default {
  name: 'SidebarItem',
  mixins: [fixBugIOS],
  props: {
    // route object
    item: {
      type: Object,
      required: true
    },
    basePath: {
      type: String,
      default: ''
    }
  },
  data() {
    return {};
  },
  methods: {
    hasChild(list) {
      return list && list.length > 0;
    }
  }
};
</script>
