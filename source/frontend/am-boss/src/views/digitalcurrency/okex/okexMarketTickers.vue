<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.instType" clearable placeholder="请输入产品类型">
        <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="产品ID">
        <el-input v-model="searchForm.instId" clearable placeholder="请输入产品ID"></el-input>
      </el-form-item>
      <el-form-item label="最新成交价">
        <el-input v-model="searchForm.last" clearable placeholder="请输入最新成交价"></el-input>
      </el-form-item>
      <el-form-item label="最新成交的数量">
        <el-input v-model="searchForm.lastSz" clearable placeholder="请输入最新成交的数量"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexMarketTickersLoading"
      :data="okexMarketTickersData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="" />
      <el-table-column prop="instType" label="产品类型" :formatter="statusFormat"/>
      <el-table-column prop="instId" label="产品ID" />
      <el-table-column prop="last" label="最新成交价" />
      <el-table-column prop="lastSz" label="最新成交的数量" />
      <el-table-column prop="askPx" label="卖一价" />
      <el-table-column prop="askSz" label="卖一价的挂单数数量" />
      <el-table-column prop="bidPx" label="买一价" />
      <el-table-column prop="bidSz" label="买一价的挂单数量" />
      <el-table-column prop="open24h" label="24小时开盘价" />
      <el-table-column prop="high24h" label="24小时最高价" />
      <el-table-column prop="low24h" label="24小时最低价" />
      <el-table-column prop="volCcy24h" label="24小时成交量" />
      <el-table-column prop="vol24h" label="24小时成交量" />
      <el-table-column prop="sodUtc0" label="UTC 0 时开盘价" />
      <el-table-column prop="sodUtc8" label="UTC+8 时开盘价" />
      <el-table-column prop="ts" label="时间" :formatter="dateFormat" />
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
    <el-dialog title="行情信息管理" :visible.sync="okexMarketTickersDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexMarketTickersForm"
        :model="okexMarketTickersForm"
        :rules="okexMarketTickersRules"
        label-width="150px"
        class="okexMarketTickersForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexMarketTickersForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="产品类型" prop="instType">
          <el-input v-model="okexMarketTickersForm.instType" placeholder="请输入产品类型" />
        </el-form-item>
        <el-form-item label="产品ID" prop="instId">
          <el-input v-model="okexMarketTickersForm.instId" placeholder="请输入产品ID" />
        </el-form-item>
        <el-form-item label="最新成交价" prop="last">
          <el-input v-model="okexMarketTickersForm.last" placeholder="请输入最新成交价" />
        </el-form-item>
        <el-form-item label="最新成交的数量" prop="lastSz">
          <el-input v-model="okexMarketTickersForm.lastSz" placeholder="请输入最新成交的数量" />
        </el-form-item>
        <el-form-item label="卖一价" prop="askPx">
          <el-input v-model="okexMarketTickersForm.askPx" placeholder="请输入卖一价" />
        </el-form-item>
        <el-form-item label="卖一价的挂单数数量" prop="askSz">
          <el-input v-model="okexMarketTickersForm.askSz" placeholder="请输入卖一价的挂单数数量" />
        </el-form-item>
        <el-form-item label="买一价" prop="bidPx">
          <el-input v-model="okexMarketTickersForm.bidPx" placeholder="请输入买一价" />
        </el-form-item>
        <el-form-item label="买一价的挂单数量" prop="bidSz">
          <el-input v-model="okexMarketTickersForm.bidSz" placeholder="请输入买一价的挂单数量" />
        </el-form-item>
        <el-form-item label="24小时开盘价" prop="open24h">
          <el-input v-model="okexMarketTickersForm.open24h" placeholder="请输入24小时开盘价" />
        </el-form-item>
        <el-form-item label="24小时最高价" prop="high24h">
          <el-input v-model="okexMarketTickersForm.high24h" placeholder="请输入24小时最高价" />
        </el-form-item>
        <el-form-item label="24小时最低价" prop="low24h">
          <el-input v-model="okexMarketTickersForm.low24h" placeholder="请输入24小时最低价" />
        </el-form-item>
        <el-form-item label="24小时成交量" prop="volCcy24h">
          <el-input v-model="okexMarketTickersForm.volCcy24h" placeholder="请输入24小时成交量" />
        </el-form-item>
        <el-form-item label="24小时成交量" prop="vol24h">
          <el-input v-model="okexMarketTickersForm.vol24h" placeholder="请输入24小时成交量" />
        </el-form-item>
        <el-form-item label="UTC 0 时开盘价" prop="sodUtc0">
          <el-input v-model="okexMarketTickersForm.sodUtc0" placeholder="请输入UTC 0 时开盘价" />
        </el-form-item>
        <el-form-item label="UTC+8 时开盘价" prop="sodUtc8">
          <el-input v-model="okexMarketTickersForm.sodUtc8" placeholder="请输入UTC+8 时开盘价" />
        </el-form-item>
        <el-form-item label="时间" prop="ts">
          <el-input v-model="okexMarketTickersForm.ts" placeholder="请输入时间" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexMarketTickersForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexMarketTickersName',
  data() {
    return {
      okexMarketTickersLoading: true,
      okexMarketTickersDialog: false,
      okexMarketTickersData: [],
      commodityTypeSelects: [],
      dicts: [],
      instTypeList: [],
      okexMarketTickersForm: {
        'id': '',
        'instType': '',
        'instId': '',
        'last': '',
        'lastSz': '',
        'askPx': '',
        'askSz': '',
        'bidPx': '',
        'bidSz': '',
        'open24h': '',
        'high24h': '',
        'low24h': '',
        'volCcy24h': '',
        'vol24h': '',
        'sodUtc0': '',
        'sodUtc8': '',
        'ts': ''
      },
      searchForm: {
        'instType': '',
        'instId': '',
        'last': '',
        'lastSz': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexMarketTickersRules: {}
    };
  },
  mounted: function() {
    this.doInitData();
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
      if(this.dicts[p] === undefined){
        return ''
      }
      const obj = this.dicts[p].list;
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
        url: '/digitalcurrency/okex/dict/okexMarketTickers',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object.list;
          this.instTypeList = res.object.list.instType.list
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
      this.okexMarketTickersLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexMarketTickers/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexMarketTickersData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexMarketTickersLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexMarketTickersForm = {
        'id': '',
        'instType': '',
        'instId': '',
        'last': '',
        'lastSz': '',
        'askPx': '',
        'askSz': '',
        'bidPx': '',
        'bidSz': '',
        'open24h': '',
        'high24h': '',
        'low24h': '',
        'volCcy24h': '',
        'vol24h': '',
        'sodUtc0': '',
        'sodUtc8': '',
        'ts': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexMarketTickersDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexMarketTickersForm) {
        this.$refs.okexMarketTickersForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexMarketTickers/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexMarketTickersForm = {
            'id': res.object.id,
            'instType': res.object.instType,
            'instId': res.object.instId,
            'last': res.object.last,
            'lastSz': res.object.lastSz,
            'askPx': res.object.askPx,
            'askSz': res.object.askSz,
            'bidPx': res.object.bidPx,
            'bidSz': res.object.bidSz,
            'open24h': res.object.open24h,
            'high24h': res.object.high24h,
            'low24h': res.object.low24h,
            'volCcy24h': res.object.volCcy24h,
            'vol24h': res.object.vol24h,
            'sodUtc0': res.object.sodUtc0,
            'sodUtc8': res.object.sodUtc8,
            'ts': res.object.ts
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexMarketTickersDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexMarketTickers/save',
            method: 'post',
            data: this.okexMarketTickersForm
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
          this.okexMarketTickersDialog = false;
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
          url: '/digitalcurrency/okex/okexMarketTickers/del',
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
  .okexMarketTickersForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
