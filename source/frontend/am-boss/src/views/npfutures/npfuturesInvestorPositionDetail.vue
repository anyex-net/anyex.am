<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="npfuturesInvestorPositionDetailLoading"
      :data="npfuturesInvestorPositionDetailData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat" />
      <el-table-column prop="direction" label="买卖" :formatter="statusFormat" />
      <el-table-column prop="openDate" label="开仓日期" />
      <el-table-column prop="tradeID" label="成交编号" />
      <el-table-column prop="volume" label="数量" />
      <el-table-column prop="openPrice" label="开仓价" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="settlementID" label="结算编号" />
      <el-table-column prop="tradeType" label="成交类型" :formatter="statusFormat" />
      <el-table-column prop="combInstrumentID" label="组合合约代码" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="closeProfitByDate" label="逐日盯市平仓盈亏" />
      <el-table-column prop="closeProfitByTrade" label="逐笔对冲平仓盈亏" />
      <el-table-column prop="positionProfitByDate" label="逐日盯市持仓盈亏" />
      <el-table-column prop="positionProfitByTrade" label="逐笔对冲持仓盈亏" />
      <el-table-column prop="margin" label="投资者保证金" />
      <el-table-column prop="exchMargin" label="交易所保证金" />
      <el-table-column prop="marginRateByMoney" label="保证金率" />
      <el-table-column prop="marginRateByVolume" label="保证金率(按手数)" />
      <el-table-column prop="lastSettlementPrice" label="昨结算价" />
      <el-table-column prop="settlementPrice" label="结算价" />
      <el-table-column prop="closeVolume" label="平仓量" />
      <el-table-column prop="closeAmount" label="平仓金额" />
      <el-table-column prop="timeFirstVolume" label="先开先平剩余数量（DCE）" />
      <el-table-column prop="investUnitID" label="投资单元代码" />
      <el-table-column prop="specPosiType" label="特殊持仓标志" :formatter="statusFormat" />
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
      title="内盘期货持仓明细表管理"
      :visible.sync="npfuturesInvestorPositionDetailDialog"
      :close-on-click-modal="false"
      width="75%"
    >
      <el-form
        ref="npfuturesInvestorPositionDetailForm"
        :model="npfuturesInvestorPositionDetailForm"
        label-width="150px"
        class="npfuturesInvestorPositionDetailForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="npfuturesInvestorPositionDetailForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约代码" prop="instrumentID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.instrumentID" placeholder="请输入合约代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪公司代码" prop="brokerID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.brokerID" placeholder="请输入经纪公司代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投资者代码" prop="investorID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.investorID" placeholder="请输入投资者代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投机套保标志" prop="hedgeFlag">
              <el-select v-model="npfuturesInvestorPositionDetailForm.hedgeFlag" placeholder="请输入投机套保标志">
                <el-option v-for="data in hedgeFlag" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买卖" prop="direction">
              <el-select v-model="npfuturesInvestorPositionDetailForm.direction" placeholder="请输入买卖">
                <el-option v-for="data in direction" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓日期" prop="openDate">
              <el-input v-model="npfuturesInvestorPositionDetailForm.openDate" placeholder="请输入开仓日期" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交编号" prop="tradeID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.tradeID" placeholder="请输入成交编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="数量" prop="volume">
              <el-input v-model="npfuturesInvestorPositionDetailForm.volume" placeholder="请输入数量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓价" prop="openPrice">
              <el-input v-model="npfuturesInvestorPositionDetailForm.openPrice" placeholder="请输入开仓价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="npfuturesInvestorPositionDetailForm.tradingDay" placeholder="请输入交易日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="结算编号" prop="settlementID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.settlementID" placeholder="请输入结算编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交类型" prop="tradeType">
              <el-select v-model="npfuturesInvestorPositionDetailForm.tradeType" placeholder="请输入成交类型">
                <el-option v-for="data in tradeType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="组合合约代码" prop="combInstrumentID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.combInstrumentID" placeholder="请输入组合合约代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.exchangeID" placeholder="请输入交易所代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="逐日盯市平仓盈亏" prop="closeProfitByDate">
              <el-input v-model="npfuturesInvestorPositionDetailForm.closeProfitByDate" placeholder="请输入逐日盯市平仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐笔对冲平仓盈亏" prop="closeProfitByTrade">
              <el-input v-model="npfuturesInvestorPositionDetailForm.closeProfitByTrade" placeholder="请输入逐笔对冲平仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐日盯市持仓盈亏" prop="positionProfitByDate">
              <el-input v-model="npfuturesInvestorPositionDetailForm.positionProfitByDate" placeholder="请输入逐日盯市持仓盈亏" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="逐笔对冲持仓盈亏" prop="positionProfitByTrade">
              <el-input v-model="npfuturesInvestorPositionDetailForm.positionProfitByTrade" placeholder="请输入逐笔对冲持仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投资者保证金" prop="margin">
              <el-input v-model="npfuturesInvestorPositionDetailForm.margin" placeholder="请输入投资者保证金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所保证金" prop="exchMargin">
              <el-input v-model="npfuturesInvestorPositionDetailForm.exchMargin" placeholder="请输入交易所保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="保证金率" prop="marginRateByMoney">
              <el-input v-model="npfuturesInvestorPositionDetailForm.marginRateByMoney" placeholder="请输入保证金率" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金率(按手数)" prop="marginRateByVolume">
              <el-input v-model="npfuturesInvestorPositionDetailForm.marginRateByVolume" placeholder="请输入保证金率(按手数)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨结算价" prop="lastSettlementPrice">
              <el-input v-model="npfuturesInvestorPositionDetailForm.lastSettlementPrice" placeholder="请输入昨结算价" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="结算价" prop="settlementPrice">
              <el-input v-model="npfuturesInvestorPositionDetailForm.settlementPrice" placeholder="请输入结算价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓量" prop="closeVolume">
              <el-input v-model="npfuturesInvestorPositionDetailForm.closeVolume" placeholder="请输入平仓量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓金额" prop="closeAmount">
              <el-input v-model="npfuturesInvestorPositionDetailForm.closeAmount" placeholder="请输入平仓金额" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="先开先平剩余数量（DCE）" prop="timeFirstVolume">
              <el-input v-model="npfuturesInvestorPositionDetailForm.timeFirstVolume" placeholder="请输入先开先平剩余数量（DCE）" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投资单元代码" prop="investUnitID">
              <el-input v-model="npfuturesInvestorPositionDetailForm.investUnitID" placeholder="请输入投资单元代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊持仓标志" prop="specPosiType">
              <el-select v-model="npfuturesInvestorPositionDetailForm.specPosiType" placeholder="请输入特殊持仓标志">
                <el-option v-for="data in specPosiType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NpfuturesInvestorPositionDetailName',
  data() {
    return {
      npfuturesInvestorPositionDetailLoading: true,
      npfuturesInvestorPositionDetailDialog: false,
      npfuturesInvestorPositionDetailData: [],
      hedgeFlag: [],
      direction: [],
      specPosiType: [],
      tradeType: [],
      dicts: [],
      npfuturesInvestorPositionDetailForm: {
        'id': '',
        'accountId': '',
        'instrumentID': '',
        'brokerID': '',
        'investorID': '',
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
        'id': '',
        'accountId': '',
        'instrumentID': '',
        'brokerID': '',
        'investorID': ''
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
        url: '/npfutures/dict/npfuturesInvestorPositionDetail',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          this.specPosiType = res.object.specPosiType.list;
          this.hedgeFlag = res.object.hedgeFlag.list;
          this.direction = res.object.direction.list;
          this.tradeType = res.object.tradeType.list;
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
      this.npfuturesInvestorPositionDetailLoading = true;
      this.$http({
        url: '/npfutures/npfuturesInvestorPositionDetail/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesInvestorPositionDetailData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.npfuturesInvestorPositionDetailLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.npfuturesInvestorPositionDetailForm = {
        'id': '',
        'accountId': '',
        'instrumentID': '',
        'brokerID': '',
        'investorID': '',
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
      this.npfuturesInvestorPositionDetailDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.npfuturesInvestorPositionDetailForm) {
        this.$refs.npfuturesInvestorPositionDetailForm.resetFields();
      }
      this.$http({
        url: '/npfutures/npfuturesInvestorPositionDetail/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesInvestorPositionDetailForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'instrumentID': res.object.instrumentID,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
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
      this.npfuturesInvestorPositionDetailDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npfutures/npfuturesInvestorPositionDetail/save',
            method: 'post',
            data: this.npfuturesInvestorPositionDetailForm
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
          this.npfuturesInvestorPositionDetailDialog = false;
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
          url: '/npfutures/npfuturesInvestorPositionDetail/del',
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
  .npfuturesInvestorPositionDetailForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
