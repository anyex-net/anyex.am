<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="品种代码">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入品种代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiFuturesSettlementRecordLoading" :data="huobiFuturesSettlementRecordData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="marginBalanceInit" label="本期初始账户权益"/>
      <el-table-column prop="marginBalance" label="本期结算后账户权益"/>
      <el-table-column prop="settlementProfitReal" label="本期结算已实现盈亏"/>
      <el-table-column prop="settlementTime" label="本期结算时间" :formatter="dateFormat"/>
      <el-table-column prop="clawback" label="本期分摊费用"/>
      <el-table-column prop="deliveryFee" label="本期交割手续费"/>
      <el-table-column prop="offsetProfitloss" label="本期平仓盈亏"/>
      <el-table-column prop="fee" label="本期交易手续费"/>
      <el-table-column prop="feeAsset" label="手续费币种"/>
      <el-table-column prop="positions" label="仓位信息"/>
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
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
    <el-dialog title="交割合约账户结算记录管理" :visible.sync="huobiFuturesSettlementRecordDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiFuturesSettlementRecordForm" :model="huobiFuturesSettlementRecordForm"
               :rules="huobiFuturesSettlementRecordRules" label-width="150px" class="huobiFuturesSettlementRecordForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiFuturesSettlementRecordForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiFuturesSettlementRecordForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiFuturesSettlementRecordForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiFuturesSettlementRecordForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="本期初始账户权益" prop="marginBalanceInit">
          <el-input v-model="huobiFuturesSettlementRecordForm.marginBalanceInit" placeholder="请输入本期初始账户权益"/>
        </el-form-item>
        <el-form-item label="本期结算后账户权益" prop="marginBalance">
          <el-input v-model="huobiFuturesSettlementRecordForm.marginBalance" placeholder="请输入本期结算后账户权益"/>
        </el-form-item>
        <el-form-item label="本期结算已实现盈亏" prop="settlementProfitReal">
          <el-input v-model="huobiFuturesSettlementRecordForm.settlementProfitReal" placeholder="请输入本期结算已实现盈亏"/>
        </el-form-item>
        <el-form-item label="本期结算时间" prop="settlementTime">
          <el-input v-model="huobiFuturesSettlementRecordForm.settlementTime" placeholder="请输入本期结算时间"/>
        </el-form-item>
        <el-form-item label="本期分摊费用" prop="clawback">
          <el-input v-model="huobiFuturesSettlementRecordForm.clawback" placeholder="请输入本期分摊费用"/>
        </el-form-item>
        <el-form-item label="本期交割手续费" prop="deliveryFee">
          <el-input v-model="huobiFuturesSettlementRecordForm.deliveryFee" placeholder="请输入本期交割手续费"/>
        </el-form-item>
        <el-form-item label="本期平仓盈亏" prop="offsetProfitloss">
          <el-input v-model="huobiFuturesSettlementRecordForm.offsetProfitloss" placeholder="请输入本期平仓盈亏"/>
        </el-form-item>
        <el-form-item label="本期交易手续费" prop="fee">
          <el-input v-model="huobiFuturesSettlementRecordForm.fee" placeholder="请输入本期交易手续费"/>
        </el-form-item>
        <el-form-item label="手续费币种" prop="feeAsset">
          <el-input v-model="huobiFuturesSettlementRecordForm.feeAsset" placeholder="请输入手续费币种"/>
        </el-form-item>
        <el-form-item label="仓位信息" prop="positions">
          <el-input v-model="huobiFuturesSettlementRecordForm.positions" placeholder="请输入仓位信息"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiFuturesSettlementRecordForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiFuturesSettlementRecordName',
    data() {
      return {
        huobiFuturesSettlementRecordLoading: true,
        huobiFuturesSettlementRecordDialog: false,
        huobiFuturesSettlementRecordData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiFuturesSettlementRecordForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'marginBalanceInit': '',
          'marginBalance': '',
          'settlementProfitReal': '',
          'settlementTime': '',
          'clawback': '',
          'deliveryFee': '',
          'offsetProfitloss': '',
          'fee': '',
          'feeAsset': '',
          'positions': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiFuturesSettlementRecordRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
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
          url: '/digitalcurrency/huobi/dict/huobiFuturesSettlementRecord',
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
        this.huobiFuturesSettlementRecordLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesSettlementRecord/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesSettlementRecordData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiFuturesSettlementRecordLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiFuturesSettlementRecordForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'marginBalanceInit': '',
          'marginBalance': '',
          'settlementProfitReal': '',
          'settlementTime': '',
          'clawback': '',
          'deliveryFee': '',
          'offsetProfitloss': '',
          'fee': '',
          'feeAsset': '',
          'positions': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiFuturesSettlementRecordDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiFuturesSettlementRecordForm) {
          this.$refs.huobiFuturesSettlementRecordForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesSettlementRecord/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesSettlementRecordForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'marginBalanceInit': res.object.marginBalanceInit,
              'marginBalance': res.object.marginBalance,
              'settlementProfitReal': res.object.settlementProfitReal,
              'settlementTime': res.object.settlementTime,
              'clawback': res.object.clawback,
              'deliveryFee': res.object.deliveryFee,
              'offsetProfitloss': res.object.offsetProfitloss,
              'fee': res.object.fee,
              'feeAsset': res.object.feeAsset,
              'positions': res.object.positions
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiFuturesSettlementRecordDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiFuturesSettlementRecord/save',
              method: 'post',
              data: this.huobiFuturesSettlementRecordForm
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
            this.huobiFuturesSettlementRecordDialog = false;
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
            url: '/digitalcurrency/huobi/huobiFuturesSettlementRecord/del',
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
  .huobiFuturesSettlementRecordForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
