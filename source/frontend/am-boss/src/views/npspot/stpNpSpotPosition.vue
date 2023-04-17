<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-select v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码">
          <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="证券名称">
        <el-input v-model="searchForm.securityName" clearable placeholder="请输入证券名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="stpNpSpotPositionLoading"
      :data="stpNpSpotPositionData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
<!--      <el-table-column prop="id" label="主键" />-->
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="businessUnitID" label="投资单元代码" />
      <el-table-column prop="marketID" label="市场代码"  :formatter="statusFormat"/>
      <el-table-column prop="shareholderID" label="股东账户代码" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="securityName" label="证券名称" />
      <el-table-column prop="historyPos" label="昨仓" />
      <el-table-column prop="historyPosFrozen" label="昨仓冻结" />
      <el-table-column prop="todayBSPos" label="今买卖仓" />
      <el-table-column prop="todayBSPosFrozen" label="今买卖仓冻结" />
      <el-table-column prop="todayPRPos" label="今日申赎持仓" />
      <el-table-column prop="todayPRPosFrozen" label="今日申赎持仓冻结" />
      <el-table-column prop="todaySMPos" label="今拆分合并持仓" />
      <el-table-column prop="todaySMPosFrozen" label="今拆分合并持仓冻结" />
      <el-table-column prop="historyPosPrice" label="昨仓成本价" />
      <el-table-column prop="totalPosCost" label="持仓成本" />
      <el-table-column prop="prePosition" label="上次余额(盘中不变)" />
      <el-table-column prop="availablePosition" label="股份可用" />
      <el-table-column prop="currentPosition" label="股份余额" />
      <el-table-column prop="openPosCost" label="开仓成本" />
      <el-table-column prop="creditBuyPos" label="融资仓位(两融专用)" />
      <el-table-column prop="creditSellPos" label="融券仓位(两融专用)" />
      <el-table-column prop="todayCreditSellPos" label="今日融券仓位(两融专用)" />
      <el-table-column prop="collateralOutPos" label="划出仓位(两融专用)" />
      <el-table-column prop="repayUntradeVolume" label="还券未成交数量(两融专用)" />
      <el-table-column prop="repayTransferUntradeVolume" label="直接还券未成交数量(两融专用)" />
      <el-table-column prop="collateralBuyUntradeAmount" label="担保品买入未成交金额(两融专用)" />
      <el-table-column prop="collateralBuyUntradeVolume" label="担保品买入未成交数量(两融专用)" />
      <el-table-column prop="creditBuyAmount" label="融资买入金额(包含交易费用)(两融专用)" />
      <el-table-column prop="creditBuyUntradeAmount" label="融资买入未成交金额(包含交易费用)(两融专用)" />
      <el-table-column prop="creditBuyFrozenMargin" label="融资冻结保证金(两融专用)" />
      <el-table-column prop="creditBuyInterestFee" label="融资买入利息(两融专用)" />
      <el-table-column prop="creditBuyUntradeVolume" label="融资买入未成交数量(两融专用)" />
      <el-table-column prop="creditSellAmount" label="融券卖出金额(以成交价计算)(两融专用)" />
      <el-table-column prop="creditSellUntradeAmount" label="融券卖出未成交金额(两融专用)" />
      <el-table-column prop="creditSellFrozenMargin" label="融券冻结保证金(两融专用)" />
      <el-table-column prop="creditSellInterestFee" label="融券卖出息费(两融专用)" />
      <el-table-column prop="creditSellUntradeVolume" label="融券卖出未成交数量(两融专用)" />
      <el-table-column prop="collateralInPos" label="划入待收仓(两融专用)" />
      <el-table-column prop="creditBuyFrozenCirculateMargin" label="融资流动冻结保证金(两融专用)" />
      <el-table-column prop="creditSellFrozenCirculateMargin" label="融券流动冻结保证金(两融专用)" />
      <el-table-column prop="closeProfit" label="累计平仓盈亏(两融专用)" />
      <el-table-column prop="todayTotalOpenVolume" label="当日累计开仓数量(两融专用)" />
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
    <el-dialog title="内盘现货持仓汇总" :visible.sync="stpNpSpotPositionDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="stpNpSpotPositionForm"
        :model="stpNpSpotPositionForm"
        label-width="150px"
        class="stpNpSpotPositionForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="stpNpSpotPositionForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="stpNpSpotPositionForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="stpNpSpotPositionForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="stpNpSpotPositionForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="投资者代码" prop="investorID">
          <el-input v-model="stpNpSpotPositionForm.investorID" placeholder="请输入投资者代码" />
        </el-form-item>
        <el-form-item label="投资单元代码" prop="businessUnitID">
          <el-input v-model="stpNpSpotPositionForm.businessUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
        <el-form-item label="市场代码" prop="marketID">
          <el-input v-model="stpNpSpotPositionForm.marketID" placeholder="请输入市场代码" />
        </el-form-item>
        <el-form-item label="股东账户代码" prop="shareholderID">
          <el-input v-model="stpNpSpotPositionForm.shareholderID" placeholder="请输入股东账户代码" />
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="stpNpSpotPositionForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="stpNpSpotPositionForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="证券名称" prop="securityName">
          <el-input v-model="stpNpSpotPositionForm.securityName" placeholder="请输入证券名称" />
        </el-form-item>
        <el-form-item label="昨仓" prop="historyPos">
          <el-input v-model="stpNpSpotPositionForm.historyPos" placeholder="请输入昨仓" />
        </el-form-item>
        <el-form-item label="昨仓冻结" prop="historyPosFrozen">
          <el-input v-model="stpNpSpotPositionForm.historyPosFrozen" placeholder="请输入昨仓冻结" />
        </el-form-item>
        <el-form-item label="今买卖仓" prop="todayBSPos">
          <el-input v-model="stpNpSpotPositionForm.todayBSPos" placeholder="请输入今买卖仓" />
        </el-form-item>
        <el-form-item label="今买卖仓冻结" prop="todayBSPosFrozen">
          <el-input v-model="stpNpSpotPositionForm.todayBSPosFrozen" placeholder="请输入今买卖仓冻结" />
        </el-form-item>
        <el-form-item label="今日申赎持仓" prop="todayPRPos">
          <el-input v-model="stpNpSpotPositionForm.todayPRPos" placeholder="请输入今日申赎持仓" />
        </el-form-item>
        <el-form-item label="今日申赎持仓冻结" prop="todayPRPosFrozen">
          <el-input v-model="stpNpSpotPositionForm.todayPRPosFrozen" placeholder="请输入今日申赎持仓冻结" />
        </el-form-item>
        <el-form-item label="今拆分合并持仓" prop="todaySMPos">
          <el-input v-model="stpNpSpotPositionForm.todaySMPos" placeholder="请输入今拆分合并持仓" />
        </el-form-item>
        <el-form-item label="今拆分合并持仓冻结" prop="todaySMPosFrozen">
          <el-input v-model="stpNpSpotPositionForm.todaySMPosFrozen" placeholder="请输入今拆分合并持仓冻结" />
        </el-form-item>
        <el-form-item label="昨仓成本价" prop="historyPosPrice">
          <el-input v-model="stpNpSpotPositionForm.historyPosPrice" placeholder="请输入昨仓成本价" />
        </el-form-item>
        <el-form-item label="持仓成本" prop="totalPosCost">
          <el-input v-model="stpNpSpotPositionForm.totalPosCost" placeholder="请输入持仓成本" />
        </el-form-item>
        <el-form-item label="上次余额(盘中不变)" prop="prePosition">
          <el-input v-model="stpNpSpotPositionForm.prePosition" placeholder="请输入上次余额(盘中不变)" />
        </el-form-item>
        <el-form-item label="股份可用" prop="availablePosition">
          <el-input v-model="stpNpSpotPositionForm.availablePosition" placeholder="请输入股份可用" />
        </el-form-item>
        <el-form-item label="股份余额" prop="currentPosition">
          <el-input v-model="stpNpSpotPositionForm.currentPosition" placeholder="请输入股份余额" />
        </el-form-item>
        <el-form-item label="开仓成本" prop="openPosCost">
          <el-input v-model="stpNpSpotPositionForm.openPosCost" placeholder="请输入开仓成本" />
        </el-form-item>
        <el-form-item label="融资仓位(两融专用)" prop="creditBuyPos">
          <el-input v-model="stpNpSpotPositionForm.creditBuyPos" placeholder="请输入融资仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="融券仓位(两融专用)" prop="creditSellPos">
          <el-input v-model="stpNpSpotPositionForm.creditSellPos" placeholder="请输入融券仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="今日融券仓位(两融专用)" prop="todayCreditSellPos">
          <el-input v-model="stpNpSpotPositionForm.todayCreditSellPos" placeholder="请输入今日融券仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="划出仓位(两融专用)" prop="collateralOutPos">
          <el-input v-model="stpNpSpotPositionForm.collateralOutPos" placeholder="请输入划出仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="还券未成交数量(两融专用)" prop="repayUntradeVolume">
          <el-input v-model="stpNpSpotPositionForm.repayUntradeVolume" placeholder="请输入还券未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="直接还券未成交数量(两融专用)" prop="repayTransferUntradeVolume">
          <el-input v-model="stpNpSpotPositionForm.repayTransferUntradeVolume" placeholder="请输入直接还券未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="担保品买入未成交金额(两融专用)" prop="collateralBuyUntradeAmount">
          <el-input v-model="stpNpSpotPositionForm.collateralBuyUntradeAmount" placeholder="请输入担保品买入未成交金额(两融专用)" />
        </el-form-item>
        <el-form-item label="担保品买入未成交数量(两融专用)" prop="collateralBuyUntradeVolume">
          <el-input v-model="stpNpSpotPositionForm.collateralBuyUntradeVolume" placeholder="请输入担保品买入未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入金额(包含交易费用)(两融专用)" prop="creditBuyAmount">
          <el-input v-model="stpNpSpotPositionForm.creditBuyAmount" placeholder="请输入融资买入金额(包含交易费用)(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入未成交金额(包含交易费用)(两融专用)" prop="creditBuyUntradeAmount">
          <el-input v-model="stpNpSpotPositionForm.creditBuyUntradeAmount" placeholder="请输入融资买入未成交金额(包含交易费用)(两融专用)" />
        </el-form-item>
        <el-form-item label="融资冻结保证金(两融专用)" prop="creditBuyFrozenMargin">
          <el-input v-model="stpNpSpotPositionForm.creditBuyFrozenMargin" placeholder="请输入融资冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入利息(两融专用)" prop="creditBuyInterestFee">
          <el-input v-model="stpNpSpotPositionForm.creditBuyInterestFee" placeholder="请输入融资买入利息(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入未成交数量(两融专用)" prop="creditBuyUntradeVolume">
          <el-input v-model="stpNpSpotPositionForm.creditBuyUntradeVolume" placeholder="请输入融资买入未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出金额(以成交价计算)(两融专用)" prop="creditSellAmount">
          <el-input v-model="stpNpSpotPositionForm.creditSellAmount" placeholder="请输入融券卖出金额(以成交价计算)(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出未成交金额(两融专用)" prop="creditSellUntradeAmount">
          <el-input v-model="stpNpSpotPositionForm.creditSellUntradeAmount" placeholder="请输入融券卖出未成交金额(两融专用)" />
        </el-form-item>
        <el-form-item label="融券冻结保证金(两融专用)" prop="creditSellFrozenMargin">
          <el-input v-model="stpNpSpotPositionForm.creditSellFrozenMargin" placeholder="请输入融券冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出息费(两融专用)" prop="creditSellInterestFee">
          <el-input v-model="stpNpSpotPositionForm.creditSellInterestFee" placeholder="请输入融券卖出息费(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出未成交数量(两融专用)" prop="creditSellUntradeVolume">
          <el-input v-model="stpNpSpotPositionForm.creditSellUntradeVolume" placeholder="请输入融券卖出未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="划入待收仓(两融专用)" prop="collateralInPos">
          <el-input v-model="stpNpSpotPositionForm.collateralInPos" placeholder="请输入划入待收仓(两融专用)" />
        </el-form-item>
        <el-form-item label="融资流动冻结保证金(两融专用)" prop="creditBuyFrozenCirculateMargin">
          <el-input v-model="stpNpSpotPositionForm.creditBuyFrozenCirculateMargin" placeholder="请输入融资流动冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融券流动冻结保证金(两融专用)" prop="creditSellFrozenCirculateMargin">
          <el-input v-model="stpNpSpotPositionForm.creditSellFrozenCirculateMargin" placeholder="请输入融券流动冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="累计平仓盈亏(两融专用)" prop="closeProfit">
          <el-input v-model="stpNpSpotPositionForm.closeProfit" placeholder="请输入累计平仓盈亏(两融专用)" />
        </el-form-item>
        <el-form-item label="当日累计开仓数量(两融专用)" prop="todayTotalOpenVolume">
          <el-input v-model="stpNpSpotPositionForm.todayTotalOpenVolume" placeholder="请输入当日累计开仓数量(两融专用)" />
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotPositionName',
  data() {
    return {
      stpNpSpotPositionLoading: true,
      stpNpSpotPositionDialog: false,
      stpNpSpotPositionData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotPositionForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'exchangeID': '',
        'investorID': '',
        'businessUnitID': '',
        'marketID': '',
        'shareholderID': '',
        'tradingDay': '',
        'securityID': '',
        'securityName': '',
        'historyPos': '',
        'historyPosFrozen': '',
        'todayBSPos': '',
        'todayBSPosFrozen': '',
        'todayPRPos': '',
        'todayPRPosFrozen': '',
        'todaySMPos': '',
        'todaySMPosFrozen': '',
        'historyPosPrice': '',
        'totalPosCost': '',
        'prePosition': '',
        'availablePosition': '',
        'currentPosition': '',
        'openPosCost': '',
        'creditBuyPos': '',
        'creditSellPos': '',
        'todayCreditSellPos': '',
        'collateralOutPos': '',
        'repayUntradeVolume': '',
        'repayTransferUntradeVolume': '',
        'collateralBuyUntradeAmount': '',
        'collateralBuyUntradeVolume': '',
        'creditBuyAmount': '',
        'creditBuyUntradeAmount': '',
        'creditBuyFrozenMargin': '',
        'creditBuyInterestFee': '',
        'creditBuyUntradeVolume': '',
        'creditSellAmount': '',
        'creditSellUntradeAmount': '',
        'creditSellFrozenMargin': '',
        'creditSellInterestFee': '',
        'creditSellUntradeVolume': '',
        'collateralInPos': '',
        'creditBuyFrozenCirculateMargin': '',
        'creditSellFrozenCirculateMargin': '',
        'closeProfit': '',
        'todayTotalOpenVolume': ''
      },
      searchForm: {
        'accountId': '',
        'brokerID': '',
        'exchangeID': '',
        'investorID': '',
        'securityID': '',
        'securityName': ''
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
        url: '/npspot/dict/stpNpSpotPosition',
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
      this.stpNpSpotPositionLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotPosition/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotPositionData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotPositionLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotPositionForm) {
        this.$refs.stpNpSpotPositionForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotPosition/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotPositionForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'exchangeID': res.object.exchangeID,
            'investorID': res.object.investorID,
            'businessUnitID': res.object.businessUnitID,
            'marketID': res.object.marketID,
            'shareholderID': res.object.shareholderID,
            'tradingDay': res.object.tradingDay,
            'securityID': res.object.securityID,
            'securityName': res.object.securityName,
            'historyPos': res.object.historyPos,
            'historyPosFrozen': res.object.historyPosFrozen,
            'todayBSPos': res.object.todayBSPos,
            'todayBSPosFrozen': res.object.todayBSPosFrozen,
            'todayPRPos': res.object.todayPRPos,
            'todayPRPosFrozen': res.object.todayPRPosFrozen,
            'todaySMPos': res.object.todaySMPos,
            'todaySMPosFrozen': res.object.todaySMPosFrozen,
            'historyPosPrice': res.object.historyPosPrice,
            'totalPosCost': res.object.totalPosCost,
            'prePosition': res.object.prePosition,
            'availablePosition': res.object.availablePosition,
            'currentPosition': res.object.currentPosition,
            'openPosCost': res.object.openPosCost,
            'creditBuyPos': res.object.creditBuyPos,
            'creditSellPos': res.object.creditSellPos,
            'todayCreditSellPos': res.object.todayCreditSellPos,
            'collateralOutPos': res.object.collateralOutPos,
            'repayUntradeVolume': res.object.repayUntradeVolume,
            'repayTransferUntradeVolume': res.object.repayTransferUntradeVolume,
            'collateralBuyUntradeAmount': res.object.collateralBuyUntradeAmount,
            'collateralBuyUntradeVolume': res.object.collateralBuyUntradeVolume,
            'creditBuyAmount': res.object.creditBuyAmount,
            'creditBuyUntradeAmount': res.object.creditBuyUntradeAmount,
            'creditBuyFrozenMargin': res.object.creditBuyFrozenMargin,
            'creditBuyInterestFee': res.object.creditBuyInterestFee,
            'creditBuyUntradeVolume': res.object.creditBuyUntradeVolume,
            'creditSellAmount': res.object.creditSellAmount,
            'creditSellUntradeAmount': res.object.creditSellUntradeAmount,
            'creditSellFrozenMargin': res.object.creditSellFrozenMargin,
            'creditSellInterestFee': res.object.creditSellInterestFee,
            'creditSellUntradeVolume': res.object.creditSellUntradeVolume,
            'collateralInPos': res.object.collateralInPos,
            'creditBuyFrozenCirculateMargin': res.object.creditBuyFrozenCirculateMargin,
            'creditSellFrozenCirculateMargin': res.object.creditSellFrozenCirculateMargin,
            'closeProfit': res.object.closeProfit,
            'todayTotalOpenVolume': res.object.todayTotalOpenVolume
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotPositionDialog = true;
    }
  }
};
</script>

<style lang="scss" scoped>
  .stpNpSpotPositionForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
