<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="产品代码">
        <el-input v-model="searchForm.productID" clearable placeholder="请输入产品代码"></el-input>
      </el-form-item>
      <el-form-item label="星期几(1~7)">
        <el-input v-model="searchForm.weekNum" clearable placeholder="请输入星期几(1~7)"></el-input>
      </el-form-item>
      <el-form-item label="是否交易日">
        <el-select v-model="searchForm.isTradeDay" clearable placeholder="请输入是否交易日">
          <el-option :key="0" label="非交易日" :value="0" />
          <el-option :key="1" label="交易日" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="npfuturesExchangeTradeDayLoading"
      :data="npfuturesExchangeTradeDayData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="productID" label="产品代码" />
      <el-table-column prop="weekNum" label="星期几(1~7)" />
      <el-table-column prop="isTradeDay" label="是否交易日">
        <template scope="scope">
          <div v-if="scope.row.isTradeDay == 0">非交易日</div>
          <div v-else-if="scope.row.isTradeDay == 1">交易日</div>
        </template>
      </el-table-column>
      <el-table-column prop="tradeDayTime" label="交易日零点时间戳" :formatter="dateFormat" />
      <el-table-column prop="tradeDayOpenTime" label="交易日开盘时间戳" :formatter="dateFormat" />
      <el-table-column prop="tradeDayCloseTime" label="交易日收盘时间戳" :formatter="dateFormat" />
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
    <el-dialog
      title="内盘期货交易所交易日表管理"
      :visible.sync="npfuturesExchangeTradeDayDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="npfuturesExchangeTradeDayForm"
        :model="npfuturesExchangeTradeDayForm"
        :rules="npfuturesExchangeTradeDayRules"
        label-width="150px"
        class="npfuturesExchangeTradeDayForm"
      >
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="npfuturesExchangeTradeDayForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="产品代码" prop="productID">
          <el-input v-model="npfuturesExchangeTradeDayForm.productID" placeholder="请输入产品代码" />
        </el-form-item>
        <el-form-item label="星期几(1~7)" prop="weekNum">
          <el-input v-model="npfuturesExchangeTradeDayForm.weekNum" placeholder="请输入星期几(1~7)" />
        </el-form-item>
        <el-form-item label="是否交易日" prop="isTradeDay">
          <el-select v-model="npfuturesExchangeTradeDayForm.isTradeDay" placeholder="请输入是否交易日">
            <el-option :key="0" label="非交易日" :value="0" />
            <el-option :key="1" label="交易日" :value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="交易日零点时间戳" prop="tradeDayTime">
          <el-input v-model="npfuturesExchangeTradeDayForm.tradeDayTime" placeholder="请输入交易日零点时间戳" />
        </el-form-item>
        <el-form-item label="交易日开盘时间戳" prop="tradeDayOpenTime">
          <el-input v-model="npfuturesExchangeTradeDayForm.tradeDayOpenTime" placeholder="请输入交易日开盘时间戳" />
        </el-form-item>
        <el-form-item label="交易日收盘时间戳" prop="tradeDayCloseTime">
          <el-input v-model="npfuturesExchangeTradeDayForm.tradeDayCloseTime" placeholder="请输入交易日收盘时间戳" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('npfuturesExchangeTradeDayForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NpfuturesExchangeTradeDayName',
  data() {
    return {
      npfuturesExchangeTradeDayLoading: true,
      npfuturesExchangeTradeDayDialog: false,
      npfuturesExchangeTradeDayData: [],
      commodityTypeSelects: [],
      dicts: [],
      npfuturesExchangeTradeDayForm: {
        'id': '',
        'exchangeID': '',
        'productID': '',
        'weekNum': '',
        'isTradeDay': '',
        'tradeDayTime': '',
        'tradeDayOpenTime': '',
        'tradeDayCloseTime': ''
      },
      searchForm: {
        'exchangeID': '',
        'productID': '',
        'weekNum': '',
        'isTradeDay': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      npfuturesExchangeTradeDayRules: {
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        productID: [
          { required: true, message: '产品代码不可为空', trigger: 'change' }
        ],
        weekNum: [
          { required: true, message: '星期几(1~7)不可为空', trigger: 'change' }
        ],
        isTradeDay: [
          { required: true, message: '是否交易日不可为空', trigger: 'change' }
        ],
        tradeDayTime: [
          { required: true, message: '交易日零点时间戳不可为空', trigger: 'change' }
        ],
        tradeDayOpenTime: [
          { required: true, message: '交易日开盘时间戳不可为空', trigger: 'change' }
        ],
        tradeDayCloseTime: [
          { required: true, message: '交易日收盘时间戳不可为空', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    // this.doInitData();
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
    statusFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      var p = column.property;
      const obj = this.dicts[p];
      const size = obj.length;
      for (var i = 0; i < size; i++) {
        if (obj[i].key === date) {
          return obj[i].value;
        }
      }
      return '';
    },
    doInitData() {
      this.$http({
        url: '/npfutures/dict/npfuturesExchangeTradeDay',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.npfuturesExchangeTradeDayLoading = true;
      this.$http({
        url: '/npfutures/npfuturesExchangeTradeDay/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeTradeDayData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.npfuturesExchangeTradeDayLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.npfuturesExchangeTradeDayForm = {
        'id': '',
        'exchangeID': '',
        'productID': '',
        'weekNum': '',
        'isTradeDay': '',
        'tradeDayTime': '',
        'tradeDayOpenTime': '',
        'tradeDayCloseTime': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.npfuturesExchangeTradeDayDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.npfuturesExchangeTradeDayForm) {
        this.$refs.npfuturesExchangeTradeDayForm.resetFields();
      }
      this.$http({
        url: '/npfutures/npfuturesExchangeTradeDay/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeTradeDayForm = {
            'id': res.object.id,
            'exchangeID': res.object.exchangeID,
            'productID': res.object.productID,
            'weekNum': res.object.weekNum,
            'isTradeDay': res.object.isTradeDay,
            'tradeDayTime': res.object.tradeDayTime,
            'tradeDayOpenTime': res.object.tradeDayOpenTime,
            'tradeDayCloseTime': res.object.tradeDayCloseTime
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.npfuturesExchangeTradeDayDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npfutures/npfuturesExchangeTradeDay/save',
            method: 'post',
            data: this.npfuturesExchangeTradeDayForm
          }).then(res => {
            if (res.code === 200) {
              this.$message.success(res.message);
              this.doSearch();
            } else {
              this.$message.error(res.message || 'Has Error');
            }
          }).catch(error => {
            this.$message.error(error);
          });
          this.npfuturesExchangeTradeDayDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该记录吗, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/npfutures/npfuturesExchangeTradeDay/del',
          method: 'post',
          data: {
            ids: column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doSearch();
          } else {
            this.$message.error(res.message || 'Has Error');
          }
        }).catch(error => {
          this.$message.error(error);
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
  }
};
</script>

<style lang="scss" scoped>
  .npfuturesExchangeTradeDayForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
