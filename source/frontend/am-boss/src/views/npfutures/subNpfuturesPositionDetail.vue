<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subNpfuturesPositionDetailLoading" :data="subNpfuturesPositionDetailData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
      <el-table-column prop="instrumentID" label="合约代码"/>
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat"/>
      <el-table-column prop="direction" label="买卖" :formatter="statusFormat"/>
      <el-table-column prop="openDate" label="开仓日期"/>
      <el-table-column prop="tradeID" label="成交编号"/>
      <el-table-column prop="volume" label="数量"/>
      <el-table-column prop="openPrice" label="开仓价"/>
      <el-table-column prop="tradingDay" label="交易日"/>
      <el-table-column prop="settlementID" label="结算编号"/>
      <el-table-column prop="tradeType" label="成交类型" :formatter="statusFormat"/>
      <el-table-column prop="combInstrumentID" label="组合合约代码"/>
      <el-table-column prop="exchangeID" label="交易所代码"/>
      <el-table-column prop="closeProfitByDate" label="逐日盯市平仓盈亏"/>
      <el-table-column prop="closeProfitByTrade" label="逐笔对冲平仓盈亏"/>
      <el-table-column prop="positionProfitByDate" label="逐日盯市持仓盈亏"/>
      <el-table-column prop="positionProfitByTrade" label="逐笔对冲持仓盈亏"/>
      <el-table-column prop="margin" label="投资者保证金"/>
      <el-table-column prop="exchMargin" label="交易所保证金"/>
      <el-table-column prop="marginRateByMoney" label="保证金率"/>
      <el-table-column prop="marginRateByVolume" label="保证金率(按手数)"/>
      <el-table-column prop="lastSettlementPrice" label="昨结算价"/>
      <el-table-column prop="settlementPrice" label="结算价"/>
      <el-table-column prop="closeVolume" label="平仓量"/>
      <el-table-column prop="closeAmount" label="平仓金额"/>
      <el-table-column prop="timeFirstVolume" label="先开先平剩余数量（DCE）"/>
      <el-table-column prop="investUnitID" label="投资单元代码"/>
      <el-table-column prop="specPosiType" label="特殊持仓标志" :formatter="statusFormat"/>
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
    <el-dialog title="子账户持仓明细表管理" :visible.sync="subNpfuturesPositionDetailDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="subNpfuturesPositionDetailForm" :model="subNpfuturesPositionDetailForm"
               :rules="subNpfuturesPositionDetailRules" label-width="150px" class="subNpfuturesPositionDetailForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="subNpfuturesPositionDetailForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subNpfuturesPositionDetailForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="subNpfuturesPositionDetailForm.instrumentID" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="投机套保标志(投机套保标志类型数据字典)" prop="hedgeFlag">
          <el-input v-model="subNpfuturesPositionDetailForm.hedgeFlag" placeholder="请输入投机套保标志(投机套保标志类型数据字典)"/>
        </el-form-item>
        <el-form-item label="买卖(买卖方向类型数据字典)" prop="direction">
          <el-input v-model="subNpfuturesPositionDetailForm.direction" placeholder="请输入买卖(买卖方向类型数据字典)"/>
        </el-form-item>
        <el-form-item label="开仓日期" prop="openDate">
          <el-input v-model="subNpfuturesPositionDetailForm.openDate" placeholder="请输入开仓日期"/>
        </el-form-item>
        <el-form-item label="成交编号" prop="tradeID">
          <el-input v-model="subNpfuturesPositionDetailForm.tradeID" placeholder="请输入成交编号"/>
        </el-form-item>
        <el-form-item label="数量" prop="volume">
          <el-input v-model="subNpfuturesPositionDetailForm.volume" placeholder="请输入数量"/>
        </el-form-item>
        <el-form-item label="开仓价" prop="openPrice">
          <el-input v-model="subNpfuturesPositionDetailForm.openPrice" placeholder="请输入开仓价"/>
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="subNpfuturesPositionDetailForm.tradingDay" placeholder="请输入交易日"/>
        </el-form-item>
        <el-form-item label="结算编号" prop="settlementID">
          <el-input v-model="subNpfuturesPositionDetailForm.settlementID" placeholder="请输入结算编号"/>
        </el-form-item>
        <el-form-item label="成交类型(成交类型类型数据字典)" prop="tradeType">
          <el-input v-model="subNpfuturesPositionDetailForm.tradeType" placeholder="请输入成交类型(成交类型类型数据字典)"/>
        </el-form-item>
        <el-form-item label="组合合约代码" prop="combInstrumentID">
          <el-input v-model="subNpfuturesPositionDetailForm.combInstrumentID" placeholder="请输入组合合约代码"/>
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="subNpfuturesPositionDetailForm.exchangeID" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="逐日盯市平仓盈亏" prop="closeProfitByDate">
          <el-input v-model="subNpfuturesPositionDetailForm.closeProfitByDate" placeholder="请输入逐日盯市平仓盈亏"/>
        </el-form-item>
        <el-form-item label="逐笔对冲平仓盈亏" prop="closeProfitByTrade">
          <el-input v-model="subNpfuturesPositionDetailForm.closeProfitByTrade" placeholder="请输入逐笔对冲平仓盈亏"/>
        </el-form-item>
        <el-form-item label="逐日盯市持仓盈亏" prop="positionProfitByDate">
          <el-input v-model="subNpfuturesPositionDetailForm.positionProfitByDate" placeholder="请输入逐日盯市持仓盈亏"/>
        </el-form-item>
        <el-form-item label="逐笔对冲持仓盈亏" prop="positionProfitByTrade">
          <el-input v-model="subNpfuturesPositionDetailForm.positionProfitByTrade" placeholder="请输入逐笔对冲持仓盈亏"/>
        </el-form-item>
        <el-form-item label="投资者保证金" prop="margin">
          <el-input v-model="subNpfuturesPositionDetailForm.margin" placeholder="请输入投资者保证金"/>
        </el-form-item>
        <el-form-item label="交易所保证金" prop="exchMargin">
          <el-input v-model="subNpfuturesPositionDetailForm.exchMargin" placeholder="请输入交易所保证金"/>
        </el-form-item>
        <el-form-item label="保证金率" prop="marginRateByMoney">
          <el-input v-model="subNpfuturesPositionDetailForm.marginRateByMoney" placeholder="请输入保证金率"/>
        </el-form-item>
        <el-form-item label="保证金率(按手数)" prop="marginRateByVolume">
          <el-input v-model="subNpfuturesPositionDetailForm.marginRateByVolume" placeholder="请输入保证金率(按手数)"/>
        </el-form-item>
        <el-form-item label="昨结算价" prop="lastSettlementPrice">
          <el-input v-model="subNpfuturesPositionDetailForm.lastSettlementPrice" placeholder="请输入昨结算价"/>
        </el-form-item>
        <el-form-item label="结算价" prop="settlementPrice">
          <el-input v-model="subNpfuturesPositionDetailForm.settlementPrice" placeholder="请输入结算价"/>
        </el-form-item>
        <el-form-item label="平仓量" prop="closeVolume">
          <el-input v-model="subNpfuturesPositionDetailForm.closeVolume" placeholder="请输入平仓量"/>
        </el-form-item>
        <el-form-item label="平仓金额" prop="closeAmount">
          <el-input v-model="subNpfuturesPositionDetailForm.closeAmount" placeholder="请输入平仓金额"/>
        </el-form-item>
        <el-form-item label="先开先平剩余数量（DCE）" prop="timeFirstVolume">
          <el-input v-model="subNpfuturesPositionDetailForm.timeFirstVolume" placeholder="请输入先开先平剩余数量（DCE）"/>
        </el-form-item>
        <el-form-item label="投资单元代码" prop="investUnitID">
          <el-input v-model="subNpfuturesPositionDetailForm.investUnitID" placeholder="请输入投资单元代码"/>
        </el-form-item>
        <el-form-item label="特殊持仓标志(特殊持仓明细标识类型数据字典)" prop="specPosiType">
          <el-input v-model="subNpfuturesPositionDetailForm.specPosiType" placeholder="请输入特殊持仓标志(特殊持仓明细标识类型数据字典)"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubNpfuturesPositionDetailName',
    data() {
      return {
        subNpfuturesPositionDetailLoading: true,
        subNpfuturesPositionDetailDialog: false,
        subNpfuturesPositionDetailData: [],
        commodityTypeSelects: [],
        dicts: [],
        subNpfuturesPositionDetailForm: {
          'id': '',
          'subAccountId': '',
          'instrumentID': '',
          'hedgeFlag': '',
          'direction': '',
          'openDate': '',
          'tradeID': '',
          'volume': '',
          'openPrice': '',
          'tradingDay': '',
          'settlementID': '',
          'tradeType': '',
          'combInstrumentID': '',
          'exchangeID': '',
          'closeProfitByDate': '',
          'closeProfitByTrade': '',
          'positionProfitByDate': '',
          'positionProfitByTrade': '',
          'margin': '',
          'exchMargin': '',
          'marginRateByMoney': '',
          'marginRateByVolume': '',
          'lastSettlementPrice': '',
          'settlementPrice': '',
          'closeVolume': '',
          'closeAmount': '',
          'timeFirstVolume': '',
          'investUnitID': '',
          'specPosiType': ''
        },
        searchForm: {
          'subAccountId': '',
          'instrumentID': '',
          'hedgeFlag': '',
          'direction': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subNpfuturesPositionDetailRules: {

        }
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
          url: '/npfutures/dict/npfuturesInvestorPositionDetail',
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
        this.subNpfuturesPositionDetailLoading = true;
        this.$http({
          url: '/npfutures/subNpfuturesPositionDetail/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesPositionDetailData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subNpfuturesPositionDetailLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subNpfuturesPositionDetailForm = {
          'id': '',
          'subAccountId': '',
          'instrumentID': '',
          'hedgeFlag': '',
          'direction': '',
          'openDate': '',
          'tradeID': '',
          'volume': '',
          'openPrice': '',
          'tradingDay': '',
          'settlementID': '',
          'tradeType': '',
          'combInstrumentID': '',
          'exchangeID': '',
          'closeProfitByDate': '',
          'closeProfitByTrade': '',
          'positionProfitByDate': '',
          'positionProfitByTrade': '',
          'margin': '',
          'exchMargin': '',
          'marginRateByMoney': '',
          'marginRateByVolume': '',
          'lastSettlementPrice': '',
          'settlementPrice': '',
          'closeVolume': '',
          'closeAmount': '',
          'timeFirstVolume': '',
          'investUnitID': '',
          'specPosiType': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subNpfuturesPositionDetailDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subNpfuturesPositionDetailForm) {
          this.$refs.subNpfuturesPositionDetailForm.resetFields();
        }
        this.$http({
          url: '/npfutures/subNpfuturesPositionDetail/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesPositionDetailForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
              'instrumentID': res.object.instrumentID,
              'hedgeFlag': res.object.hedgeFlag,
              'direction': res.object.direction,
              'openDate': res.object.openDate,
              'tradeID': res.object.tradeID,
              'volume': res.object.volume,
              'openPrice': res.object.openPrice,
              'tradingDay': res.object.tradingDay,
              'settlementID': res.object.settlementID,
              'tradeType': res.object.tradeType,
              'combInstrumentID': res.object.combInstrumentID,
              'exchangeID': res.object.exchangeID,
              'closeProfitByDate': res.object.closeProfitByDate,
              'closeProfitByTrade': res.object.closeProfitByTrade,
              'positionProfitByDate': res.object.positionProfitByDate,
              'positionProfitByTrade': res.object.positionProfitByTrade,
              'margin': res.object.margin,
              'exchMargin': res.object.exchMargin,
              'marginRateByMoney': res.object.marginRateByMoney,
              'marginRateByVolume': res.object.marginRateByVolume,
              'lastSettlementPrice': res.object.lastSettlementPrice,
              'settlementPrice': res.object.settlementPrice,
              'closeVolume': res.object.closeVolume,
              'closeAmount': res.object.closeAmount,
              'timeFirstVolume': res.object.timeFirstVolume,
              'investUnitID': res.object.investUnitID,
              'specPosiType': res.object.specPosiType
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.subNpfuturesPositionDetailDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/subNpfuturesPositionDetail/save',
              method: 'post',
              data: this.subNpfuturesPositionDetailForm
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
            this.subNpfuturesPositionDetailDialog = false;
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
            url: '/npfutures/subNpfuturesPositionDetail/del',
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
  .subNpfuturesPositionDetailForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
