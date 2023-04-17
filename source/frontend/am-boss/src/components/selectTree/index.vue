<template>
  <el-select ref="selectInput" :value="valueTitle" :clearable="clearable" @clear="clearHandle">
    <el-option :value="valueId" :label="valueTitle" class="options">
      <el-tree
        id="tree-option"
        ref="selectTree"
        :highlight-current="true"
        :check-strictly="true"
        :check-on-click-node="true"
        :accordion="accordion"
        :data="options"
        :props="props"
        :node-key="props.value"
        :show-checkbox="multiple"
        :default-expanded-keys="defaultKey"
        :default-checked-keys="defaultKey"
        @check-change="checkChange"
        @node-click="nodeClick"
      />
    </el-option>
  </el-select>
</template>

<script>
export default {
  name: 'SelectTree',
  props: {
    /* 配置项 */
    props: {
      type: Object,
      default: () => {
        return {
          value: 'id', // ID字段名
          label: 'title', // 显示名称
          children: 'children' // 子级字段名
        };
      }
    },
    /* 选项列表数据(树形结构的对象数组) */
    options: {
      type: Array,
      default: () => { return []; }
    },
    /* 初始值 */
    value: {
      type: String,
      default: () => { return null; }
    },
    /* 可清空选项 */
    clearable: {
      type: Boolean,
      default: () => { return true; }
    },
    /* 自动收起 */
    accordion: {
      type: Boolean,
      default: () => { return false; }
    },
    multiple: {
      type: Boolean,
      default: () => { return false; }
    }
  },
  data() {
    return {
      valueId: this.value, // 初始值
      valueTitle: '',
      defaultKey: []
    };
  },
  watch: {
    value() {
      this.valueId = this.value;
      this.initHandle();
    }
  },
  mounted() {
    this.initHandle();
  },
  methods: {
    // 初始化值
    initHandle() {
      this.valueTitle = '';
      this.defaultKey = [];
      this.$refs.selectTree.setCheckedNodes([]);
      for (let i = 0; i < this.$refs.selectTree.store._getAllNodes().length; i++) {
        this.$refs.selectTree.store._getAllNodes()[i].expanded = false;
      }
      if (this.valueId && this.valueId !== '0') {
        const valueList = this.valueId.split(',');
        for (const i in valueList) {
          this.valueTitle += this.$refs.selectTree.getNode(valueList[i]).data[this.props.label] + ' '; // 初始化显示
          if (this.multiple === false) {
            this.$refs.selectTree.setCurrentKey(valueList[i]); // 设置默认选中
          }
        }
        this.defaultKey = valueList; // 设置默认选中
      }
      this.initScroll();
    },
    // 初始化滚动条
    initScroll() {
      this.$nextTick(() => {
        const scrollWrap = document.querySelectorAll('.el-scrollbar .el-select-dropdown__wrap')[0];
        const scrollBar = document.querySelectorAll('.el-scrollbar .el-scrollbar__bar');
        scrollWrap.style.cssText = 'margin: 0px; max-height: none; overflow: hidden;';
        scrollBar.forEach(ele => ele.style.width = 0);
      });
    },
    // 清除选中
    clearHandle() {
      this.valueId = null;
      this.clearSelected();
      this.$emit('getValue', null);
    },
    /* 清空选中样式 */
    clearSelected() {
      const allNode = document.querySelectorAll('#tree-option .el-tree-node');
      allNode.forEach((element) => element.classList.remove('is-current'));
    },
    // 切换选项
    checkChange() {
      if (this.multiple === true) {
        const checkNodes = this.$refs.selectTree.getCheckedNodes();
        const valueList = [];
        const id = this.props.value;
        checkNodes.forEach(function(item) {
          valueList.push(item[id]);
        });
        this.valueId = valueList + '';
        this.$emit('getValue', this.valueId);
      }
    },
    // 点击选项
    nodeClick(node) {
      if (this.multiple === false) {
        this.valueId = node[this.props.value];
        this.$refs.selectInput.blur();
        this.$emit('getValue', this.valueId);
      }
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .el-scrollbar .el-scrollbar__view .el-select-dropdown__item{
    height: auto;
    max-height: 274px;
    padding: 0;
    overflow: hidden;
    overflow-y: auto;
  }
  .el-select-dropdown__item.selected{
    font-weight: normal;
  }
  ul li >>>.el-tree .el-tree-node__content{
    height:auto;
    padding: 0 20px;
  }
  .el-tree-node__label{
    font-weight: normal;
  }
  .el-tree >>>.is-current .el-tree-node__label{
    color: #409EFF;
    font-weight: 700;
  }
  .el-tree >>>.is-current .el-tree-node__children .el-tree-node__label{
    color:#606266;
    font-weight: normal;
  }
</style>
