<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="符号">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入符号"></el-input>
      </el-form-item>
      <el-form-item label="货币">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入货币"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="quotationLoading" :data="quotationData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="symbol" label="符号" />
      <el-table-column prop="currency" label="货币" />
      <el-table-column prop="current_price" label="当前价格" />
      <el-table-column prop="market_cap" label="市值" />
      <el-table-column prop="total_volume" label="总量" />
      <el-table-column prop="high_24h" label="24小时最高交易量" />
      <el-table-column prop="low_24h" label="24小时最低交易量" />
      <el-table-column prop="market_cap_change_24h" label="24小时价格变动百分比" />
      <el-table-column prop="last_updated" :formatter="dateFormat" width="200" label="更新时间" />
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
  name: 'Quotation',
  data() {
    return {
      quotationLoading: '',
      quotationData: [],
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      searchForm: {
        'symbol': '',
        'currency': ''
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
      this.quotationLoading = true;
      this.$http({
        url: '/common/quotation/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.quotationData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.quotationLoading = false;
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
