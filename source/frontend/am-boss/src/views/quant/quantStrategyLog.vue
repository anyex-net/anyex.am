<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="本平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入本平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="策略类型">
        <el-select v-model="searchForm.strategyType" clearable placeholder="请选择策略类型" value="">
          <!--<el-option v-for="data in symbolData" :key="data.type" :label="data.typeName" :value="data.typeName"></el-option>-->
          <el-option label="浮盈加仓" value="PLAddPos"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="操作类型">
        <el-select v-model="searchForm.opType" placeholder="请选择操作类型" value="" clearable>
          <el-option label="策略信息" value="msg"></el-option>
          <el-option label="期货买入" value="buy"></el-option>
          <el-option label="期货卖出" value="sell"></el-option>
          <el-option label="订单撤销" value="cancel"></el-option>
          <el-option label="合约买多" value="open_long"></el-option>
          <el-option label="合约卖空" value="open_short"></el-option>
          <el-option label="合约平多" value="close_long"></el-option>
          <el-option label="合约平空" value="close_short"></el-option>
          <el-option label="错误提示" value="error"></el-option>
          <el-option label="订单跟踪" value="order_trace"></el-option>
          <el-option label="对冲结果" value="hedge_finish"></el-option>
          <el-option label="资金划转" value="transfer"></el-option>
          <el-option label="订单异常" value="entrust_error"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="strategyLogLoading" :data="strategyLogData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="createDate" label="时间" :formatter="dateFormat" width="170" />
      <el-table-column prop="accountId" label="本平台账户ID" />
      <el-table-column prop="strategyId" label="策略ID" />
      <el-table-column prop="strategyType" label="策略类型" />
      <el-table-column prop="strategyName" label="策略名称" />
      <el-table-column prop="opType" label="操作类型" />
      <el-table-column prop="content" label="日志内容" width="1000" />
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
  import { opTypeFormat } from '../../utils/filters.js';
  export default {
    name: 'QuantStrategyLog',
    data() {
      return {
        strategyLogLoading: true,
        strategyLogData: [],
        currencyData: [],
        symbolData: [],
        searchForm: {
          'accountId': '',
          'opType': '',
          'strategyType': ''
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
        this.strategyLogLoading = true;
        this.$http({
          url: '/quant/quantStrategyLog/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.strategyLogData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.strategyLogLoading = false;
          }
        }).catch(error => {
          console.log(error);
        });
      },
    }
  };
</script>

<style scoped>

</style>
