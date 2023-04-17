<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="subWpSpotTradeLoading" :data="subWpSpotTradeData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" />
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="orderRef" label="报单引用" />
      <el-table-column prop="userID" label="用户代码" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="tradeID" label="成交编号" />
      <el-table-column prop="direction" label="买卖方向" :formatter="statusFormat" />
      <el-table-column prop="orderSysID" label="报单编号" />
<!--      <el-table-column prop="participantID" label="会员代码" />-->
<!--      <el-table-column prop="clientID" label="客户代码" />-->
<!--      <el-table-column prop="tradingRole" label="交易角色(" />-->
<!--      <el-table-column prop="exchangeInstID" label="合约在交易所的代码" />-->
      <el-table-column prop="offsetFlag" label="开平标志" :formatter="statusFormat" />
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat" />
      <el-table-column prop="price" label="价格" />
      <el-table-column prop="volume" label="数量" />
      <el-table-column prop="tradeDate" label="成交日期" />
      <el-table-column prop="tradeTime" label="成交时间" />
      <el-table-column prop="tradeType" label="成交类型" :formatter="statusFormat" />
<!--      <el-table-column prop="priceSource" label="成交价来源" />-->
<!--      <el-table-column prop="traderID" label="交易所交易员代码" />-->
<!--      <el-table-column prop="orderLocalID" label="本地报单编号" />-->
<!--      <el-table-column prop="clearingPartID" label="结算会员编号" />-->
<!--      <el-table-column prop="businessUnit" label="业务单元" />-->
      <el-table-column prop="sequenceNo" label="序号" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="settlementID" label="结算编号" />
      <el-table-column prop="brokerOrderSeq" label="经纪公司报单编号" />
<!--      <el-table-column prop="tradeSource" label="成交来源" />-->
<!--      <el-table-column prop="investUnitID" label="投资单元代码" />-->
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
    <el-dialog title="子账户成交表管理" :visible.sync="subWpSpotTradeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="subWpSpotTradeForm" :model="subWpSpotTradeForm" :rules="subWpSpotTradeRules" label-width="150px" class="subWpSpotTradeForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="subWpSpotTradeForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subWpSpotTradeForm.subAccountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="subWpSpotTradeForm.instrumentID" placeholder="请输入合约代码" />
        </el-form-item>
        <el-form-item label="报单引用" prop="orderRef">
          <el-input v-model="subWpSpotTradeForm.orderRef" placeholder="请输入报单引用" />
        </el-form-item>
        <el-form-item label="用户代码" prop="userID">
          <el-input v-model="subWpSpotTradeForm.userID" placeholder="请输入用户代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="subWpSpotTradeForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="成交编号" prop="tradeID">
          <el-input v-model="subWpSpotTradeForm.tradeID" placeholder="请输入成交编号" />
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="subWpSpotTradeForm.direction" placeholder="请输入买卖方向" />
        </el-form-item>
        <el-form-item label="报单编号" prop="orderSysID">
          <el-input v-model="subWpSpotTradeForm.orderSysID" placeholder="请输入报单编号" />
        </el-form-item>
        <el-form-item label="会员代码" prop="participantID">
          <el-input v-model="subWpSpotTradeForm.participantID" placeholder="请输入会员代码" />
        </el-form-item>
        <el-form-item label="客户代码" prop="clientID">
          <el-input v-model="subWpSpotTradeForm.clientID" placeholder="请输入客户代码" />
        </el-form-item>
        <el-form-item label="交易角色" prop="tradingRole">
          <el-input v-model="subWpSpotTradeForm.tradingRole" placeholder="请输入交易角色" />
        </el-form-item>
        <el-form-item label="合约在交易所的代码" prop="exchangeInstID">
          <el-input v-model="subWpSpotTradeForm.exchangeInstID" placeholder="请输入合约在交易所的代码" />
        </el-form-item>
        <el-form-item label="开平标志" prop="offsetFlag">
          <el-input v-model="subWpSpotTradeForm.offsetFlag" placeholder="请输入开平标志" />
        </el-form-item>
        <el-form-item label="投机套保标志" prop="hedgeFlag">
          <el-input v-model="subWpSpotTradeForm.hedgeFlag" placeholder="请输入投机套保标志" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input v-model="subWpSpotTradeForm.price" placeholder="请输入价格" />
        </el-form-item>
        <el-form-item label="数量" prop="volume">
          <el-input v-model="subWpSpotTradeForm.volume" placeholder="请输入数量" />
        </el-form-item>
        <el-form-item label="成交日期" prop="tradeDate">
          <el-input v-model="subWpSpotTradeForm.tradeDate" placeholder="请输入成交日期" />
        </el-form-item>
        <el-form-item label="成交时间" prop="tradeTime">
          <el-input v-model="subWpSpotTradeForm.tradeTime" placeholder="请输入成交时间" />
        </el-form-item>
        <el-form-item label="成交类型" prop="tradeType">
          <el-input v-model="subWpSpotTradeForm.tradeType" placeholder="请输入成交类型" />
        </el-form-item>
        <el-form-item label="成交价来源" prop="priceSource">
          <el-input v-model="subWpSpotTradeForm.priceSource" placeholder="请输入成交价来源" />
        </el-form-item>
        <el-form-item label="交易所交易员代码" prop="traderID">
          <el-input v-model="subWpSpotTradeForm.traderID" placeholder="请输入交易所交易员代码" />
        </el-form-item>
        <el-form-item label="本地报单编号" prop="orderLocalID">
          <el-input v-model="subWpSpotTradeForm.orderLocalID" placeholder="请输入本地报单编号" />
        </el-form-item>
        <el-form-item label="结算会员编号" prop="clearingPartID">
          <el-input v-model="subWpSpotTradeForm.clearingPartID" placeholder="请输入结算会员编号" />
        </el-form-item>
        <el-form-item label="业务单元" prop="businessUnit">
          <el-input v-model="subWpSpotTradeForm.businessUnit" placeholder="请输入业务单元" />
        </el-form-item>
        <el-form-item label="序号" prop="sequenceNo">
          <el-input v-model="subWpSpotTradeForm.sequenceNo" placeholder="请输入序号" />
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="subWpSpotTradeForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="结算编号" prop="settlementID">
          <el-input v-model="subWpSpotTradeForm.settlementID" placeholder="请输入结算编号" />
        </el-form-item>
        <el-form-item label="经纪公司报单编号" prop="brokerOrderSeq">
          <el-input v-model="subWpSpotTradeForm.brokerOrderSeq" placeholder="请输入经纪公司报单编号" />
        </el-form-item>
        <el-form-item label="成交来源(成交来源类型数据字典)" prop="tradeSource">
          <el-input v-model="subWpSpotTradeForm.tradeSource" placeholder="请输入成交来源" />
        </el-form-item>
        <el-form-item label="投资单元代码" prop="investUnitID">
          <el-input v-model="subWpSpotTradeForm.investUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubWpSpotTradeName',
  data() {
    return {
      subWpSpotTradeLoading: true,
      subWpSpotTradeDialog: false,
      subWpSpotTradeData: [],
      commodityTypeSelects: [],
      dicts: [],
      subWpSpotTradeForm: {
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
        'investUnitID': ''
      },
      searchForm: {
        'subAccountId': '',
        'investorID': '',
        'instrumentID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subWpSpotTradeRules: {
        subAccountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        instrumentID: [
          { required: true, message: '合约代码不可为空', trigger: 'change' }
        ],
        orderRef: [
          { required: true, message: '报单引用不可为空', trigger: 'change' }
        ],
        userID: [
          { required: true, message: '用户代码不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        tradeID: [
          { required: true, message: '成交编号不可为空', trigger: 'change' }
        ],
        direction: [
          { required: true, message: '买卖方向不可为空', trigger: 'change' }
        ],
        orderSysID: [
          { required: true, message: '报单编号不可为空', trigger: 'change' }
        ],
        offsetFlag: [
          { required: true, message: '开平标志不可为空', trigger: 'change' }
        ],
        hedgeFlag: [
          { required: true, message: '投机套保标志不可为空', trigger: 'change' }
        ],
        price: [
          { required: true, message: '价格不可为空', trigger: 'change' }
        ],
        volume: [
          { required: true, message: '数量不可为空', trigger: 'change' }
        ],
        tradeDate: [
          { required: true, message: '成交日期不可为空', trigger: 'change' }
        ],
        tradeTime: [
          { required: true, message: '成交时间不可为空', trigger: 'change' }
        ],
        tradeType: [
          { required: true, message: '成交类型不可为空', trigger: 'change' }
        ],
        sequenceNo: [
          { required: true, message: '序号不可为空', trigger: 'change' }
        ],
        tradingDay: [
          { required: true, message: '交易日不可为空', trigger: 'change' }
        ],
        settlementID: [
          { required: true, message: '结算编号不可为空', trigger: 'change' }
        ],
        brokerOrderSeq: [
          { required: true, message: '经纪公司报单编号不可为空', trigger: 'change' }
        ]
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
        url: '/wpspot/dict/wpSpotTrade',
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
      this.subWpSpotTradeLoading = true;
      this.$http({
        url: '/wpspot/subWpSpotTrade/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subWpSpotTradeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subWpSpotTradeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subWpSpotTradeForm = {
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
        'investUnitID': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subWpSpotTradeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subWpSpotTradeForm) {
        this.$refs.subWpSpotTradeForm.resetFields();
      }
      this.$http({
        url: '/wpspot/subWpSpotTrade/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subWpSpotTradeForm = {
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
            'investUnitID': res.object.investUnitID
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subWpSpotTradeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/subWpSpotTrade/save',
            method: 'post',
            data: this.subWpSpotTradeForm
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
          this.subWpSpotTradeDialog = false;
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
          url: '/wpspot/subWpSpotTrade/del',
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
		.subWpSpotTradeForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
