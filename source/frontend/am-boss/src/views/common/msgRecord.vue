<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="recordForm" :inline="true" size="mini">
      <el-form-item label="发送对象">
        <el-input v-model="recordForm.object" clearable placeholder="请输入发送对象"></el-input>
      </el-form-item>
      <el-form-item label="消息类型">
        <el-select v-model="recordForm.type" clearable placeholder="请输入消息类型">
          <el-option value="email" label="邮箱"></el-option>
          <el-option value="sms" label="短信"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="recordLoading" :data="recordData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="object" label="发送对象" width="200" />
      <el-table-column prop="type" label="消息类型" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.type === 'email'">邮箱</span>
          <span v-if="scope.row.type === 'sms'">短信</span>
        </template>
      </el-table-column>
      <el-table-column prop="content" label="发送内容">
        <template slot-scope="scope">
          <span v-html="scope.row.content"></span>
        </template>
      </el-table-column>
      <el-table-column label="发送状态" width="200">
        <template slot-scope="scope">
          <span v-if="scope.row.status === true">成功</span>
          <span v-if="scope.row.status === false">失败</span>
        </template>
      </el-table-column>
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
  name: 'MsgRecord',
  data() {
    return {
      recordLoading: '',
      recordData: [],
      recordForm: {
        'object': '',
        'type': ''
      },
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
      this.recordLoading = true;
      this.$http({
        url: '/common/msgrecord/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.recordForm)
      }).then(res => {
        if (res.code === 200) {
          this.recordData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.recordLoading = false;
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
