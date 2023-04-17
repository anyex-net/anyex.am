<template>
  <div class="app-container">

    <el-table v-loading="feedbackLoading" :data="feedbackData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="accountId" label="帐户编号" />
      <el-table-column prop="note" label="反馈内容" />
      <el-table-column prop="ext" label="设备信息" />
      <el-table-column prop="createDate" :formatter="dateFormat" width="200" label="创建时间" />
    </el-table>

    <el-pagination
      style="text-align:center;"
      background
      layout="total, sizes, prev, pager, next, jumper"
      :hide-on-single-page="true"
      :page-size="pageParams.rows"
      :page-count="pageParams.totalPage"
      :current-page="pageParams.page"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

  </div>
</template>

<script>
export default {
  name: 'AppVersion',
  data() {
    return {
      feedbackLoading: '',
      feedbackData: [],
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      }
    };
  },
  mounted: function() {
    this.doSearch();
  },
  methods: {
    dateFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      return this.$moment(date).format('YYYY-MM-DD HH:mm:ss');
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.feedbackLoading = true;
      this.$http({
        url: '/common/feedback/data',
        method: 'post',
        data: this.pageParams
      }).then(res => {
        if (res.code === 200) {
          this.feedbackData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.feedbackLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    }
  }
};
</script>

<style lang="scss" scoped>

</style>
