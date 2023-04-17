<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商名称">
        <el-select v-model="searchForm.brokerNo" clearable placeholder="请选择经纪商名称" value="">
          <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="客户资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金账号"></el-input>
      </el-form-item>
      <el-form-item label="币种组号">
        <el-input v-model="searchForm.currencyGroupNo" clearable placeholder="请输入币种组号"></el-input>
      </el-form-item>
      <el-form-item label="币种号">
        <el-input v-model="searchForm.currencyNo" clearable placeholder="请输入币种号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesFundDataLoading" :data="wpfuturesFundDataData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerNo" label="经纪商编号"/>
      <el-table-column prop="brokerNo" label="经纪商名称" :formatter="statusFormat" />
      <el-table-column prop="accountNo" label="客户资金账号" />
      <el-table-column prop="currencyGroupNo" label="币种组号" />
      <el-table-column prop="currencyNo" label="币种号" />
      <el-table-column prop="tradeRate" label="交易汇率" />
      <el-table-column prop="futureAlg" label="期货算法" :formatter="statusFormat" />
      <el-table-column prop="optionAlg" label="期权算法" :formatter="statusFormat" />
      <el-table-column prop="preBalance" label="上日结存" />
      <el-table-column prop="preUnExpProfit" label="上日未到期平盈" />
      <el-table-column prop="preLMEPositionProfit" label="上日LME持仓平盈" />
      <el-table-column prop="preEquity" label="上日权益" />
      <el-table-column prop="preAvailable1" label="上日可用" />
      <el-table-column prop="preMarketEquity" label="上日市值权益" />
      <el-table-column prop="cashInValue" label="入金" />
      <el-table-column prop="cashOutValue" label="出金" />
      <el-table-column prop="cashAdjustValue" label="资金调整" />
      <el-table-column prop="cashPledged" label="质押资金" />
      <el-table-column prop="frozenFee" label="冻结手续费" />
      <el-table-column prop="frozenDeposit" label="冻结保证金" />
      <el-table-column prop="accountFee" label="客户手续费包含交割手续费" />
      <el-table-column prop="swapInValue" label="汇入资金" />
      <el-table-column prop="swapOutValue" label="汇出资金" />
      <el-table-column prop="premiumIncome" label="权利金收取" />
      <el-table-column prop="premiumPay" label="权利金支付" />
      <el-table-column prop="closeProfit" label="平仓盈亏" />
      <el-table-column prop="frozenFund" label="冻结资金" />
      <el-table-column prop="unExpProfit" label="未到期平盈" />
      <el-table-column prop="expProfit" label="到期平仓盈亏" />
      <el-table-column prop="positionProfit" label="不含LME持仓盈亏" />
      <el-table-column prop="lmePositionProfit" label="LME持仓盈亏" />
      <el-table-column prop="optionMarketValue" label="期权市值" />
      <el-table-column prop="accountIntialMargin" label="客户初始保证金" />
      <el-table-column prop="accountMaintenanceMargin" label="客户维持保证金" />
      <el-table-column prop="upperInitalMargin" label="上手初始保证金" />
      <el-table-column prop="upperMaintenanceMargin" label="上手维持保证金" />
      <el-table-column prop="discount" label="LME贴现" />
      <el-table-column prop="balance" label="当日结存" />
      <el-table-column prop="equity" label="当日权益" />
      <el-table-column prop="available" label="当日可用" />
      <el-table-column prop="canDraw" label="可提取" />
      <el-table-column prop="marketEquity" label="账户市值" />
      <el-table-column prop="authMoney" label="授信资金" />
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
    <el-dialog title="期货资金账号资金信息" :visible.sync="wpfuturesFundDataDialog" :close-on-click-modal="false" width="1800">
      <el-form
        ref="wpfuturesFundDataForm"
        :model="wpfuturesFundDataForm"
        label-width="130px"
        class="wpfuturesFundDataForm"
      >
        <el-row>
          <el-col :span=8>
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="wpfuturesFundDataForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="wpfuturesFundDataForm.brokerNo" placeholder="请输入经纪商编码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户资金账号" prop="accountNo">
              <el-input v-model="wpfuturesFundDataForm.accountNo" placeholder="请输入客户资金账号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="币种组号" prop="currencyGroupNo">
              <el-input v-model="wpfuturesFundDataForm.currencyGroupNo" placeholder="请输入币种组号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="币种号" prop="currencyNo">
              <el-input v-model="wpfuturesFundDataForm.currencyNo" placeholder="请输入币种号(为空表示币种组基币资金)" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="交易汇率" prop="tradeRate">
              <el-input v-model="wpfuturesFundDataForm.tradeRate" placeholder="请输入交易汇率" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="期货算法" prop="futureAlg">
              <el-input v-model="wpfuturesFundDataForm.futureAlg" placeholder="请输入期货算法" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="期权算法" prop="optionAlg">
              <el-input v-model="wpfuturesFundDataForm.optionAlg" placeholder="请输入期权算法" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上日结存" prop="preBalance">
              <el-input v-model="wpfuturesFundDataForm.preBalance" placeholder="请输入上日结存" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="上日未到期平盈" prop="preUnExpProfit">
              <el-input v-model="wpfuturesFundDataForm.preUnExpProfit" placeholder="请输入上日未到期平盈" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上日LME持仓平盈" prop="preLMEPositionProfit">
              <el-input v-model="wpfuturesFundDataForm.preLMEPositionProfit" placeholder="请输入上日LME持仓平盈" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上日权益" prop="preEquity">
              <el-input v-model="wpfuturesFundDataForm.preEquity" placeholder="请输入上日权益" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="上日可用" prop="preAvailable1">
              <el-input v-model="wpfuturesFundDataForm.preAvailable1" placeholder="请输入上日可用" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上日市值权益" prop="preMarketEquity">
              <el-input v-model="wpfuturesFundDataForm.preMarketEquity" placeholder="请输入上日市值权益" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="入金" prop="cashInValue">
              <el-input v-model="wpfuturesFundDataForm.cashInValue" placeholder="请输入入金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="出金" prop="cashOutValue">
              <el-input v-model="wpfuturesFundDataForm.cashOutValue" placeholder="请输入出金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="资金调整" prop="cashAdjustValue">
              <el-input v-model="wpfuturesFundDataForm.cashAdjustValue" placeholder="请输入资金调整" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="质押资金" prop="cashPledged">
              <el-input v-model="wpfuturesFundDataForm.cashPledged" placeholder="请输入质押资金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="冻结手续费" prop="frozenFee">
              <el-input v-model="wpfuturesFundDataForm.frozenFee" placeholder="请输入冻结手续费" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="冻结保证金" prop="frozenDeposit">
              <el-input v-model="wpfuturesFundDataForm.frozenDeposit" placeholder="请输入冻结保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户手续费" prop="accountFee">
              <el-input v-model="wpfuturesFundDataForm.accountFee" placeholder="请输入客户手续费包含交割手续费" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="汇入资金" prop="swapInValue">
              <el-input v-model="wpfuturesFundDataForm.swapInValue" placeholder="请输入汇入资金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="汇出资金" prop="swapOutValue">
              <el-input v-model="wpfuturesFundDataForm.swapOutValue" placeholder="请输入汇出资金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="权利金收取" prop="premiumIncome">
              <el-input v-model="wpfuturesFundDataForm.premiumIncome" placeholder="请输入权利金收取" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="权利金支付" prop="premiumPay">
              <el-input v-model="wpfuturesFundDataForm.premiumPay" placeholder="请输入权利金支付" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="wpfuturesFundDataForm.closeProfit" placeholder="请输入平仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="冻结资金" prop="frozenFund">
              <el-input v-model="wpfuturesFundDataForm.frozenFund" placeholder="请输入冻结资金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="未到期平盈" prop="unExpProfit">
              <el-input v-model="wpfuturesFundDataForm.unExpProfit" placeholder="请输入未到期平盈" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="到期平仓盈亏" prop="expProfit">
              <el-input v-model="wpfuturesFundDataForm.expProfit" placeholder="请输入到期平仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="不含LME持仓盈亏" prop="positionProfit">
              <el-input v-model="wpfuturesFundDataForm.positionProfit" placeholder="请输入不含LME持仓盈亏" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="LME持仓盈亏" prop="lmePositionProfit">
              <el-input v-model="wpfuturesFundDataForm.lmePositionProfit" placeholder="请输入LME持仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="wpfuturesFundDataForm.optionMarketValue" placeholder="请输入期权市值" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户初始保证金" prop="accountIntialMargin">
              <el-input v-model="wpfuturesFundDataForm.accountIntialMargin" placeholder="请输入客户初始保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="wpfuturesFundDataForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手初始保证金" prop="upperInitalMargin">
              <el-input v-model="wpfuturesFundDataForm.upperInitalMargin" placeholder="请输入上手初始保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
              <el-input v-model="wpfuturesFundDataForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="LME贴现" prop="discount">
              <el-input v-model="wpfuturesFundDataForm.discount" placeholder="请输入LME贴现" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="当日结存" prop="balance">
              <el-input v-model="wpfuturesFundDataForm.balance" placeholder="请输入当日结存" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="当日权益" prop="equity">
              <el-input v-model="wpfuturesFundDataForm.equity" placeholder="请输入当日权益" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="当日可用" prop="available">
              <el-input v-model="wpfuturesFundDataForm.available" placeholder="请输入当日可用" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="可提取" prop="canDraw">
              <el-input v-model="wpfuturesFundDataForm.canDraw" placeholder="请输入可提取" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="账户市值" prop="marketEquity">
              <el-input v-model="wpfuturesFundDataForm.marketEquity" placeholder="请输入账户市值" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="授信资金" prop="authMoney">
              <el-input v-model="wpfuturesFundDataForm.authMoney" placeholder="请输入授信资金" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpfuturesFundDataName',
  data() {
    return {
      wpfuturesFundDataLoading: true,
      wpfuturesFundDataDialog: false,
      wpfuturesFundDataData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpfuturesFundDataForm: {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'currencyGroupNo': '',
        'currencyNo': '',
        'tradeRate': '',
        'futureAlg': '',
        'optionAlg': '',
        'preBalance': '',
        'preUnExpProfit': '',
        'preLMEPositionProfit': '',
        'preEquity': '',
        'preAvailable1': '',
        'preMarketEquity': '',
        'cashInValue': '',
        'cashOutValue': '',
        'cashAdjustValue': '',
        'cashPledged': '',
        'frozenFee': '',
        'frozenDeposit': '',
        'accountFee': '',
        'swapInValue': '',
        'swapOutValue': '',
        'premiumIncome': '',
        'premiumPay': '',
        'closeProfit': '',
        'frozenFund': '',
        'unExpProfit': '',
        'expProfit': '',
        'positionProfit': '',
        'lmePositionProfit': '',
        'optionMarketValue': '',
        'accountIntialMargin': '',
        'accountMaintenanceMargin': '',
        'upperInitalMargin': '',
        'upperMaintenanceMargin': '',
        'discount': '',
        'balance': '',
        'equity': '',
        'available': '',
        'canDraw': '',
        'marketEquity': '',
        'authMoney': ''
      },
      searchForm: {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'currencyGroupNo': '',
        'currencyNo': '',
        'tradeRate': '',
        'futureAlg': '',
        'optionAlg': '',
        'preBalance': '',
        'preUnExpProfit': '',
        'preLMEPositionProfit': '',
        'preEquity': '',
        'preAvailable1': '',
        'preMarketEquity': '',
        'cashInValue': '',
        'cashOutValue': '',
        'cashAdjustValue': '',
        'cashPledged': '',
        'frozenFee': '',
        'frozenDeposit': '',
        'accountFee': '',
        'swapInValue': '',
        'swapOutValue': '',
        'premiumIncome': '',
        'premiumPay': '',
        'closeProfit': '',
        'frozenFund': '',
        'unExpProfit': '',
        'expProfit': '',
        'positionProfit': '',
        'lmePositionProfit': '',
        'optionMarketValue': '',
        'accountIntialMargin': '',
        'accountMaintenanceMargin': '',
        'upperInitalMargin': '',
        'upperMaintenanceMargin': '',
        'discount': '',
        'balance': '',
        'equity': '',
        'available': '',
        'canDraw': '',
        'marketEquity': '',
        'authMoney': '',
        'sort': 'id',
        'order': 'asc'
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
        url: '/wpfutures/dict/wpfuturesFundData',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesFundDataForm) {
        this.$refs.wpfuturesFundDataForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesFundData/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesFundDataForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerNo': res.object.brokerNo,
            'accountNo': res.object.accountNo,
            'currencyGroupNo': res.object.currencyGroupNo,
            'currencyNo': res.object.currencyNo,
            'tradeRate': res.object.tradeRate,
            'futureAlg': res.object.futureAlg,
            'optionAlg': res.object.optionAlg,
            'preBalance': res.object.preBalance,
            'preUnExpProfit': res.object.preUnExpProfit,
            'preLMEPositionProfit': res.object.preLMEPositionProfit,
            'preEquity': res.object.preEquity,
            'preAvailable1': res.object.preAvailable1,
            'preMarketEquity': res.object.preMarketEquity,
            'cashInValue': res.object.cashInValue,
            'cashOutValue': res.object.cashOutValue,
            'cashAdjustValue': res.object.cashAdjustValue,
            'cashPledged': res.object.cashPledged,
            'frozenFee': res.object.frozenFee,
            'frozenDeposit': res.object.frozenDeposit,
            'accountFee': res.object.accountFee,
            'swapInValue': res.object.swapInValue,
            'swapOutValue': res.object.swapOutValue,
            'premiumIncome': res.object.premiumIncome,
            'premiumPay': res.object.premiumPay,
            'closeProfit': res.object.closeProfit,
            'frozenFund': res.object.frozenFund,
            'unExpProfit': res.object.unExpProfit,
            'expProfit': res.object.expProfit,
            'positionProfit': res.object.positionProfit,
            'lmePositionProfit': res.object.lmePositionProfit,
            'optionMarketValue': res.object.optionMarketValue,
            'accountIntialMargin': res.object.accountIntialMargin,
            'accountMaintenanceMargin': res.object.accountMaintenanceMargin,
            'upperInitalMargin': res.object.upperInitalMargin,
            'upperMaintenanceMargin': res.object.upperMaintenanceMargin,
            'discount': res.object.discount,
            'balance': res.object.balance,
            'equity': res.object.equity,
            'available': res.object.available,
            'canDraw': res.object.canDraw,
            'marketEquity': res.object.marketEquity,
            'authMoney': res.object.authMoney
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesFundDataDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.wpfuturesFundDataLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesFundData/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesFundDataData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesFundDataLoading = false;
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

<style lang="scss" scoped>
.wpfuturesFundDataForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
