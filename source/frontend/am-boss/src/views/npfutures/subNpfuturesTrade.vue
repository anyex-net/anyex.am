<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="报单引用">
        <el-input v-model="searchForm.orderRef" clearable placeholder="请输入报单引用"></el-input>
      </el-form-item>
      <el-form-item label="用户代码">
        <el-input v-model="searchForm.userID" clearable placeholder="请输入用户代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subNpfuturesTradeLoading" :data="subNpfuturesTradeData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
      <el-table-column prop="instrumentID" label="合约代码"/>
      <el-table-column prop="orderRef" label="报单引用"/>
      <el-table-column prop="userID" label="用户代码"/>
      <el-table-column prop="exchangeID" label="交易所代码"/>
      <el-table-column prop="tradeID" label="成交编号"/>
      <el-table-column prop="direction" label="买卖方向" :formatter="statusFormat"/>
      <el-table-column prop="orderSysID" label="报单编号"/>
      <el-table-column prop="participantID" label="会员代码"/>
      <el-table-column prop="clientID" label="客户代码"/>
      <el-table-column prop="tradingRole" label="交易角色" :formatter="statusFormat"/>
      <el-table-column prop="exchangeInstID" label="合约在交易所的代码"/>
      <el-table-column prop="offsetFlag" label="开平标志" :formatter="statusFormat"/>
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat"/>
      <el-table-column prop="price" label="价格"/>
      <el-table-column prop="volume" label="数量"/>
      <el-table-column prop="tradeDate" label="成交日期"/>
      <el-table-column prop="tradeTime" label="成交时间"/>
      <el-table-column prop="tradeType" label="成交类型" :formatter="statusFormat"/>
      <el-table-column prop="priceSource" label="成交价来源" :formatter="statusFormat"/>
      <el-table-column prop="traderID" label="交易所交易员代码"/>
      <el-table-column prop="orderLocalID" label="本地报单编号"/>
      <el-table-column prop="clearingPartID" label="结算会员编号"/>
      <el-table-column prop="businessUnit" label="业务单元"/>
      <el-table-column prop="sequenceNo" label="序号"/>
      <el-table-column prop="tradingDay" label="交易日"/>
      <el-table-column prop="settlementID" label="结算编号"/>
      <el-table-column prop="brokerOrderSeq" label="经纪公司报单编号"/>
      <el-table-column prop="tradeSource" label="成交来源" :formatter="statusFormat"/>
      <el-table-column prop="investUnitID" label="投资单元代码"/>
      <el-table-column prop="motherTradeId" label="母账户唯一成交ID"/>
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
    <el-dialog title="子账户成交" :visible.sync="subNpfuturesTradeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="subNpfuturesTradeForm" :model="subNpfuturesTradeForm" :rules="subNpfuturesTradeRules"
               label-width="150px" class="subNpfuturesTradeForm">
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subNpfuturesTradeForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="subNpfuturesTradeForm.instrumentID" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="报单引用" prop="orderRef">
          <el-input v-model="subNpfuturesTradeForm.orderRef" placeholder="请输入报单引用"/>
        </el-form-item>
        <el-form-item label="用户代码" prop="userID">
          <el-input v-model="subNpfuturesTradeForm.userID" placeholder="请输入用户代码"/>
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="subNpfuturesTradeForm.exchangeID" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="成交编号" prop="tradeID">
          <el-input v-model="subNpfuturesTradeForm.tradeID" placeholder="请输入成交编号"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="subNpfuturesTradeForm.direction" placeholder="请输入买卖方向(买卖方向类型数据字典)"/>
        </el-form-item>
        <el-form-item label="报单编号" prop="orderSysID">
          <el-input v-model="subNpfuturesTradeForm.orderSysID" placeholder="请输入报单编号"/>
        </el-form-item>
        <el-form-item label="会员代码" prop="participantID">
          <el-input v-model="subNpfuturesTradeForm.participantID" placeholder="请输入会员代码"/>
        </el-form-item>
        <el-form-item label="客户代码" prop="clientID">
          <el-input v-model="subNpfuturesTradeForm.clientID" placeholder="请输入客户代码"/>
        </el-form-item>
        <el-form-item label="交易角色" prop="tradingRole">
          <el-input v-model="subNpfuturesTradeForm.tradingRole" placeholder="请输入交易角色(交易角色类型数据字典)"/>
        </el-form-item>
        <el-form-item label="合约在交易所的代码" prop="exchangeInstID">
          <el-input v-model="subNpfuturesTradeForm.exchangeInstID" placeholder="请输入合约在交易所的代码"/>
        </el-form-item>
        <el-form-item label="开平标志" prop="offsetFlag">
          <el-input v-model="subNpfuturesTradeForm.offsetFlag" placeholder="请输入开平标志(开平标志类型数据字典)"/>
        </el-form-item>
        <el-form-item label="投机套保标志" prop="hedgeFlag">
          <el-input v-model="subNpfuturesTradeForm.hedgeFlag" placeholder="请输入投机套保标志(投机套保标志类型数据字典)"/>
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input v-model="subNpfuturesTradeForm.price" placeholder="请输入价格"/>
        </el-form-item>
        <el-form-item label="数量" prop="volume">
          <el-input v-model="subNpfuturesTradeForm.volume" placeholder="请输入数量"/>
        </el-form-item>
        <el-form-item label="成交日期" prop="tradeDate">
          <el-input v-model="subNpfuturesTradeForm.tradeDate" placeholder="请输入成交日期"/>
        </el-form-item>
        <el-form-item label="成交时间" prop="tradeTime">
          <el-input v-model="subNpfuturesTradeForm.tradeTime" placeholder="请输入成交时间"/>
        </el-form-item>
        <el-form-item label="成交类型" prop="tradeType">
          <el-input v-model="subNpfuturesTradeForm.tradeType" placeholder="请输入成交类型(成交类型类型数据字典)"/>
        </el-form-item>
        <el-form-item label="成交价来源" prop="priceSource">
          <el-input v-model="subNpfuturesTradeForm.priceSource" placeholder="请输入成交价来源(成交价来源类型数据字典)"/>
        </el-form-item>
        <el-form-item label="交易所交易员代码" prop="traderID">
          <el-input v-model="subNpfuturesTradeForm.traderID" placeholder="请输入交易所交易员代码"/>
        </el-form-item>
        <el-form-item label="本地报单编号" prop="orderLocalID">
          <el-input v-model="subNpfuturesTradeForm.orderLocalID" placeholder="请输入本地报单编号"/>
        </el-form-item>
        <el-form-item label="结算会员编号" prop="clearingPartID">
          <el-input v-model="subNpfuturesTradeForm.clearingPartID" placeholder="请输入结算会员编号"/>
        </el-form-item>
        <el-form-item label="业务单元" prop="businessUnit">
          <el-input v-model="subNpfuturesTradeForm.businessUnit" placeholder="请输入业务单元"/>
        </el-form-item>
        <el-form-item label="序号" prop="sequenceNo">
          <el-input v-model="subNpfuturesTradeForm.sequenceNo" placeholder="请输入序号"/>
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="subNpfuturesTradeForm.tradingDay" placeholder="请输入交易日"/>
        </el-form-item>
        <el-form-item label="结算编号" prop="settlementID">
          <el-input v-model="subNpfuturesTradeForm.settlementID" placeholder="请输入结算编号"/>
        </el-form-item>
        <el-form-item label="经纪公司报单编号" prop="brokerOrderSeq">
          <el-input v-model="subNpfuturesTradeForm.brokerOrderSeq" placeholder="请输入经纪公司报单编号"/>
        </el-form-item>
        <el-form-item label="成交来源" prop="tradeSource">
          <el-input v-model="subNpfuturesTradeForm.tradeSource" placeholder="请输入成交来源(成交来源类型数据字典)"/>
        </el-form-item>
        <el-form-item label="投资单元代码" prop="investUnitID">
          <el-input v-model="subNpfuturesTradeForm.investUnitID" placeholder="请输入投资单元代码"/>
        </el-form-item>
        <el-form-item label="母账户唯一成交ID" prop="motherTradeId">
          <el-input v-model="subNpfuturesTradeForm.motherTradeId" placeholder="请输入母账户唯一成交ID"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubNpfuturesTradeName',
    data() {
      return {
        subNpfuturesTradeLoading: true,
        subNpfuturesTradeDialog: false,
        subNpfuturesTradeData: [],
        commodityTypeSelects: [],
        dicts: [],
        subNpfuturesTradeForm: {
          'id': '',
          'subAccountId': '',
          'instrumentID': '',
          'orderRef': '',
          'userID': '',
          'exchangeID': '',
          'tradeID': '',
          'direction': '',
          'orderSysID': '',
          'participantID': '',
          'clientID': '',
          'tradingRole': '',
          'exchangeInstID': '',
          'offsetFlag': '',
          'hedgeFlag': '',
          'price': '',
          'volume': '',
          'tradeDate': '',
          'tradeTime': '',
          'tradeType': '',
          'priceSource': '',
          'traderID': '',
          'orderLocalID': '',
          'clearingPartID': '',
          'businessUnit': '',
          'sequenceNo': '',
          'tradingDay': '',
          'settlementID': '',
          'brokerOrderSeq': '',
          'tradeSource': '',
          'investUnitID': '',
          'motherTradeId': ''
        },
        searchForm: {
          'subAccountId': '',
          'instrumentID': '',
          'orderRef': '',
          'userID': '',
          'exchangeID': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subNpfuturesTradeRules: {

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
          url: '/npfutures/dict/npfuturesTrade',
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
        this.subNpfuturesTradeLoading = true;
        this.$http({
          url: '/npfutures/subNpfuturesTrade/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesTradeData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subNpfuturesTradeLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subNpfuturesTradeForm = {
          'id': '',
          'subAccountId': '',
          'instrumentID': '',
          'orderRef': '',
          'userID': '',
          'exchangeID': '',
          'tradeID': '',
          'direction': '',
          'orderSysID': '',
          'participantID': '',
          'clientID': '',
          'tradingRole': '',
          'exchangeInstID': '',
          'offsetFlag': '',
          'hedgeFlag': '',
          'price': '',
          'volume': '',
          'tradeDate': '',
          'tradeTime': '',
          'tradeType': '',
          'priceSource': '',
          'traderID': '',
          'orderLocalID': '',
          'clearingPartID': '',
          'businessUnit': '',
          'sequenceNo': '',
          'tradingDay': '',
          'settlementID': '',
          'brokerOrderSeq': '',
          'tradeSource': '',
          'investUnitID': '',
          'motherTradeId': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subNpfuturesTradeDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subNpfuturesTradeForm) {
          this.$refs.subNpfuturesTradeForm.resetFields();
        }
        this.$http({
          url: '/npfutures/subNpfuturesTrade/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesTradeForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
              'instrumentID': res.object.instrumentID,
              'orderRef': res.object.orderRef,
              'userID': res.object.userID,
              'exchangeID': res.object.exchangeID,
              'tradeID': res.object.tradeID,
              'direction': res.object.direction,
              'orderSysID': res.object.orderSysID,
              'participantID': res.object.participantID,
              'clientID': res.object.clientID,
              'tradingRole': res.object.tradingRole,
              'exchangeInstID': res.object.exchangeInstID,
              'offsetFlag': res.object.offsetFlag,
              'hedgeFlag': res.object.hedgeFlag,
              'price': res.object.price,
              'volume': res.object.volume,
              'tradeDate': res.object.tradeDate,
              'tradeTime': res.object.tradeTime,
              'tradeType': res.object.tradeType,
              'priceSource': res.object.priceSource,
              'traderID': res.object.traderID,
              'orderLocalID': res.object.orderLocalID,
              'clearingPartID': res.object.clearingPartID,
              'businessUnit': res.object.businessUnit,
              'sequenceNo': res.object.sequenceNo,
              'tradingDay': res.object.tradingDay,
              'settlementID': res.object.settlementID,
              'brokerOrderSeq': res.object.brokerOrderSeq,
              'tradeSource': res.object.tradeSource,
              'investUnitID': res.object.investUnitID,
              'motherTradeId': res.object.motherTradeId
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.subNpfuturesTradeDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/subNpfuturesTrade/save',
              method: 'post',
              data: this.subNpfuturesTradeForm
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
            this.subNpfuturesTradeDialog = false;
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
            url: '/npfutures/subNpfuturesTrade/del',
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
  .subNpfuturesTradeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
