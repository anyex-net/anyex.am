<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="账户名">
        <el-input v-model="searchForm.accountName" clearable placeholder="请输入账户名"></el-input>
      </el-form-item>
      <el-form-item label="设备类型">
        <el-input v-model="searchForm.deviceType" clearable placeholder="请输入设备类型"></el-input>
      </el-form-item>
      <el-form-item label="app版本号">
        <el-input v-model="searchForm.appVersion" clearable placeholder="请输入app版本号"></el-input>
      </el-form-item>
      <el-form-item label="账户unid">
        <el-input v-model="searchForm.uid" clearable placeholder="请输入账户unid"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="appDeviceLoading" :data="appDeviceData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="uid" label="unid" />
      <el-table-column prop="accountName" label="账户名" />
      <el-table-column prop="accountId" label="账户ID" width="170" />
      <el-table-column prop="deviceType" label="设备类型" />
      <el-table-column prop="deviceName" label="设备名称" />
      <el-table-column prop="deviceNumber" label="设备号" />
      <el-table-column prop="ipAddress" label="ip地址" />
      <el-table-column prop="appVersion" label="app版本" />
      <el-table-column prop="createDate" label="创建时间" :formatter="dateFormat" width="170" />
      <el-table-column prop="lastLoginDate" label="最新登陆时间" :formatter="dateFormat" width="170" />
    </el-table>
    <el-pagination
      style="text-align:center;"
      background
      layout="total, sizes, prev, pager, next, jumper"
      :hide-on-single-page="true"
      :page-size="pageParams.rows"
      :page-count="pageParams.totalPage"
      :current-page="pageParams.page"
      :total="pageParams.total"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />
  </div>
</template>

<script>
export default {
  name: 'AppDevice',
  data() {
    return {
      appDeviceLoading: true,
      appDeviceData: [],
      symbolData: [],
      businessFlagData: [],
      searchForm: {
        'accountName': '',
        'deviceType': '',
        'appVersion': '',
        'uid': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
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
      this.appDeviceLoading = true;
      this.$http({
        url: '/common/appDevice/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.appDeviceData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.appDeviceLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    }
  }
};
</script>

<style scoped>

</style>
