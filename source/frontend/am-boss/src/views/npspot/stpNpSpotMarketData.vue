<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易日">
        <el-input v-model="searchForm.tradingDay" clearable placeholder="请输入交易日"></el-input>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="证券名称">
        <el-input v-model="searchForm.securityName" clearable placeholder="请输入证券名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="stpNpSpotMarketDataLoading" :data="stpNpSpotMarketDataData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="tradingDay" label="交易日"/>
      <el-table-column prop="securityID" label="证券代码"/>
      <el-table-column prop="exchangeID" label="交易所代码"/>
      <el-table-column prop="securityName" label="证券名称"/>
      <el-table-column prop="preClosePrice" label="昨收盘价"/>
      <el-table-column prop="openPrice" label="今开盘价"/>
      <el-table-column prop="volume" label="成交量"/>
      <el-table-column prop="turnover" label="成交额"/>
      <el-table-column prop="tradingCount" label="成交笔数"/>
      <el-table-column prop="lastPrice" label="最新价"/>
      <el-table-column prop="highestPrice" label="最高价"/>
      <el-table-column prop="lowestPrice" label="最低价"/>
      <el-table-column prop="bidPrice1" label="买1价"/>
      <el-table-column prop="askPrice1" label="卖1价"/>
      <el-table-column prop="upperLimitPrice" label="涨停价"/>
      <el-table-column prop="lowerLimitPrice" label="跌停价"/>
      <el-table-column prop="pERatio1" label="市盈率1"/>
      <el-table-column prop="pERatio2" label="市盈率2"/>
      <el-table-column prop="priceUpDown1" label="价格升跌1"/>
      <el-table-column prop="priceUpDown2" label="价格升跌2"/>
      <el-table-column prop="openInterest" label="持仓量"/>
      <el-table-column prop="bidVolume1" label="买1量"/>
      <el-table-column prop="askVolume1" label="卖1量"/>
      <el-table-column prop="bidPrice2" label="买2价"/>
      <el-table-column prop="bidVolume2" label="买2量"/>
      <el-table-column prop="askPrice2" label="卖2价"/>
      <el-table-column prop="askVolume2" label="卖2量"/>
      <el-table-column prop="bidPrice3" label="买3价"/>
      <el-table-column prop="bidVolume3" label="买3量"/>
      <el-table-column prop="askPrice3" label="卖3价"/>
      <el-table-column prop="askVolume3" label="卖3量"/>
      <el-table-column prop="bidPrice4" label="买4价"/>
      <el-table-column prop="bidVolume4" label="买4量"/>
      <el-table-column prop="askPrice4" label="卖4价"/>
      <el-table-column prop="askVolume4" label="卖4量"/>
      <el-table-column prop="bidPrice5" label="买5价"/>
      <el-table-column prop="bidVolume5" label="买5量"/>
      <el-table-column prop="askPrice5" label="卖5价"/>
      <el-table-column prop="askVolume5" label="卖5量"/>
      <el-table-column prop="updateTime" label="更新时间"/>
      <el-table-column prop="updateMillisec" label="更新毫秒"/>
      <el-table-column prop="closePrice" label="今收盘价"/>
      <el-table-column prop="settlementPrice" label="今结算价"/>
      <el-table-column prop="mDSecurityStat" label="行情产品实时状态"/>
      <el-table-column prop="hWFlag" label="是否警示板块"/>
      <el-table-column prop="preCloseIOPV" label="基金T-1日收盘时刻净值"/>
      <el-table-column prop="iOPV" label="基金实时参考净值"/>
      <el-table-column prop="changeReason" label="行情变动原因"/>
      <el-table-column prop="lastVolume" label="最新成交量"/>
      <el-table-column prop="longUpdateTime" label="行情更新时间" :formatter="dateFormat"/>
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
    <el-dialog title="内盘现货深度行情" :visible.sync="stpNpSpotMarketDataDialog" :close-on-click-modal="false" width="600">
      <el-form ref="stpNpSpotMarketDataForm" :model="stpNpSpotMarketDataForm" :rules="stpNpSpotMarketDataRules"
               label-width="150px" class="stpNpSpotMarketDataForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="stpNpSpotMarketDataForm.tradingDay" placeholder="请输入交易日"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券代码" prop="securityID">
              <el-input v-model="stpNpSpotMarketDataForm.securityID" placeholder="请输入证券代码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="stpNpSpotMarketDataForm.exchangeID" placeholder="请输入交易所代码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="证券名称" prop="securityName">
              <el-input v-model="stpNpSpotMarketDataForm.securityName" placeholder="请输入证券名称"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨收盘价" prop="preClosePrice">
              <el-input v-model="stpNpSpotMarketDataForm.preClosePrice" placeholder="请输入昨收盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="今开盘价" prop="openPrice">
              <el-input v-model="stpNpSpotMarketDataForm.openPrice" placeholder="请输入今开盘价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交量" prop="volume">
              <el-input v-model="stpNpSpotMarketDataForm.volume" placeholder="请输入成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交额" prop="turnover">
              <el-input v-model="stpNpSpotMarketDataForm.turnover" placeholder="请输入成交额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交笔数" prop="tradingCount">
              <el-input v-model="stpNpSpotMarketDataForm.tradingCount" placeholder="请输入成交笔数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最新价" prop="lastPrice">
              <el-input v-model="stpNpSpotMarketDataForm.lastPrice" placeholder="请输入最新价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最高价" prop="highestPrice">
              <el-input v-model="stpNpSpotMarketDataForm.highestPrice" placeholder="请输入最高价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最低价" prop="lowestPrice">
              <el-input v-model="stpNpSpotMarketDataForm.lowestPrice" placeholder="请输入最低价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="买1价" prop="bidPrice1">
              <el-input v-model="stpNpSpotMarketDataForm.bidPrice1" placeholder="请输入买1价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖1价" prop="askPrice1">
              <el-input v-model="stpNpSpotMarketDataForm.askPrice1" placeholder="请输入卖1价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="涨停价" prop="upperLimitPrice">
              <el-input v-model="stpNpSpotMarketDataForm.upperLimitPrice" placeholder="请输入涨停价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="跌停价" prop="lowerLimitPrice">
              <el-input v-model="stpNpSpotMarketDataForm.lowerLimitPrice" placeholder="请输入跌停价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市盈率1" prop="pERatio1">
              <el-input v-model="stpNpSpotMarketDataForm.pERatio1" placeholder="请输入市盈率1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市盈率2" prop="pERatio2">
              <el-input v-model="stpNpSpotMarketDataForm.pERatio2" placeholder="请输入市盈率2"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="价格升跌1" prop="priceUpDown1">
              <el-input v-model="stpNpSpotMarketDataForm.priceUpDown1" placeholder="请输入价格升跌1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格升跌2" prop="priceUpDown2">
              <el-input v-model="stpNpSpotMarketDataForm.priceUpDown2" placeholder="请输入价格升跌2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓量" prop="openInterest">
              <el-input v-model="stpNpSpotMarketDataForm.openInterest" placeholder="请输入持仓量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="买1量" prop="bidVolume1">
              <el-input v-model="stpNpSpotMarketDataForm.bidVolume1" placeholder="请输入买1量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖1量" prop="askVolume1">
              <el-input v-model="stpNpSpotMarketDataForm.askVolume1" placeholder="请输入卖1量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买2价" prop="bidPrice2">
              <el-input v-model="stpNpSpotMarketDataForm.bidPrice2" placeholder="请输入买2价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="买2量" prop="bidVolume2">
              <el-input v-model="stpNpSpotMarketDataForm.bidVolume2" placeholder="请输入买2量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖2价" prop="askPrice2">
              <el-input v-model="stpNpSpotMarketDataForm.askPrice2" placeholder="请输入卖2价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖2量" prop="askVolume2">
              <el-input v-model="stpNpSpotMarketDataForm.askVolume2" placeholder="请输入卖2量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="买3价" prop="bidPrice3">
              <el-input v-model="stpNpSpotMarketDataForm.bidPrice3" placeholder="请输入买3价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买3量" prop="bidVolume3">
              <el-input v-model="stpNpSpotMarketDataForm.bidVolume3" placeholder="请输入买3量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖3价" prop="askPrice3">
              <el-input v-model="stpNpSpotMarketDataForm.askPrice3" placeholder="请输入卖3价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="卖3量" prop="askVolume3">
              <el-input v-model="stpNpSpotMarketDataForm.askVolume3" placeholder="请输入卖3量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买4价" prop="bidPrice4">
              <el-input v-model="stpNpSpotMarketDataForm.bidPrice4" placeholder="请输入买4价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买4量" prop="bidVolume4">
              <el-input v-model="stpNpSpotMarketDataForm.bidVolume4" placeholder="请输入买4量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="卖4价" prop="askPrice4">
              <el-input v-model="stpNpSpotMarketDataForm.askPrice4" placeholder="请输入卖4价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖4量" prop="askVolume4">
              <el-input v-model="stpNpSpotMarketDataForm.askVolume4" placeholder="请输入卖4量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买5价" prop="bidPrice5">
              <el-input v-model="stpNpSpotMarketDataForm.bidPrice5" placeholder="请输入买5价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="买5量" prop="bidVolume5">
              <el-input v-model="stpNpSpotMarketDataForm.bidVolume5" placeholder="请输入买5量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖5价" prop="askPrice5">
              <el-input v-model="stpNpSpotMarketDataForm.askPrice5" placeholder="请输入卖5价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖5量" prop="askVolume5">
              <el-input v-model="stpNpSpotMarketDataForm.askVolume5" placeholder="请输入卖5量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="更新时间" prop="updateTime">
              <el-input v-model="stpNpSpotMarketDataForm.updateTime" placeholder="请输入更新时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="更新毫秒" prop="updateMillisec">
              <el-input v-model="stpNpSpotMarketDataForm.updateMillisec" placeholder="请输入更新毫秒"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="今收盘价" prop="closePrice">
              <el-input v-model="stpNpSpotMarketDataForm.closePrice" placeholder="请输入今收盘价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="今结算价" prop="settlementPrice">
              <el-input v-model="stpNpSpotMarketDataForm.settlementPrice" placeholder="请输入今结算价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行情产品实时状态" prop="mDSecurityStat">
              <el-input v-model="stpNpSpotMarketDataForm.mDSecurityStat" placeholder="请输入行情产品实时状态"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否警示板块" prop="hWFlag">
              <el-input v-model="stpNpSpotMarketDataForm.hWFlag" placeholder="请输入是否警示板块"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="基金T-1日收盘时刻净值" prop="preCloseIOPV">
              <el-input v-model="stpNpSpotMarketDataForm.preCloseIOPV" placeholder="请输入基金T-1日收盘时刻净值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="基金实时参考净值" prop="iOPV">
              <el-input v-model="stpNpSpotMarketDataForm.iOPV" placeholder="请输入基金实时参考净值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行情变动原因(委托盘口entrust、撮和成交trade)" prop="changeReason">
              <el-input v-model="stpNpSpotMarketDataForm.changeReason" placeholder="请输入行情变动原因(委托盘口entrust、撮和成交trade)"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最新成交量" prop="lastVolume">
              <el-input v-model="stpNpSpotMarketDataForm.lastVolume" placeholder="请输入最新成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行情更新时间" prop="longUpdateTime">
              <el-input v-model="stpNpSpotMarketDataForm.longUpdateTime" placeholder="请输入行情更新时间"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'StpNpSpotMarketDataName',
    data() {
      return {
        stpNpSpotMarketDataLoading: true,
        stpNpSpotMarketDataDialog: false,
        stpNpSpotMarketDataData: [],
        commodityTypeSelects: [],
        dicts: [],
        stpNpSpotMarketDataForm: {
          'id': '',
          'tradingDay': '',
          'securityID': '',
          'exchangeID': '',
          'securityName': '',
          'preClosePrice': '',
          'openPrice': '',
          'volume': '',
          'turnover': '',
          'tradingCount': '',
          'lastPrice': '',
          'highestPrice': '',
          'lowestPrice': '',
          'bidPrice1': '',
          'askPrice1': '',
          'upperLimitPrice': '',
          'lowerLimitPrice': '',
          'pERatio1': '',
          'pERatio2': '',
          'priceUpDown1': '',
          'priceUpDown2': '',
          'openInterest': '',
          'bidVolume1': '',
          'askVolume1': '',
          'bidPrice2': '',
          'bidVolume2': '',
          'askPrice2': '',
          'askVolume2': '',
          'bidPrice3': '',
          'bidVolume3': '',
          'askPrice3': '',
          'askVolume3': '',
          'bidPrice4': '',
          'bidVolume4': '',
          'askPrice4': '',
          'askVolume4': '',
          'bidPrice5': '',
          'bidVolume5': '',
          'askPrice5': '',
          'askVolume5': '',
          'updateTime': '',
          'updateMillisec': '',
          'closePrice': '',
          'settlementPrice': '',
          'mDSecurityStat': '',
          'hWFlag': '',
          'preCloseIOPV': '',
          'iOPV': '',
          'changeReason': '',
          'lastVolume': '',
          'longUpdateTime': ''
        },
        searchForm: {
          'tradingDay': '',
          'securityID': '',
          'exchangeID': '',
          'securityName': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        stpNpSpotMarketDataRules: {
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
        this.stpNpSpotMarketDataLoading = true;
        this.$http({
          url: '/npspot/stpNpSpotMarketData/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotMarketDataData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.stpNpSpotMarketDataLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.stpNpSpotMarketDataForm = {
          'id': '',
          'tradingDay': '',
          'securityID': '',
          'exchangeID': '',
          'securityName': '',
          'preClosePrice': '',
          'openPrice': '',
          'volume': '',
          'turnover': '',
          'tradingCount': '',
          'lastPrice': '',
          'highestPrice': '',
          'lowestPrice': '',
          'bidPrice1': '',
          'askPrice1': '',
          'upperLimitPrice': '',
          'lowerLimitPrice': '',
          'pERatio1': '',
          'pERatio2': '',
          'priceUpDown1': '',
          'priceUpDown2': '',
          'openInterest': '',
          'bidVolume1': '',
          'askVolume1': '',
          'bidPrice2': '',
          'bidVolume2': '',
          'askPrice2': '',
          'askVolume2': '',
          'bidPrice3': '',
          'bidVolume3': '',
          'askPrice3': '',
          'askVolume3': '',
          'bidPrice4': '',
          'bidVolume4': '',
          'askPrice4': '',
          'askVolume4': '',
          'bidPrice5': '',
          'bidVolume5': '',
          'askPrice5': '',
          'askVolume5': '',
          'updateTime': '',
          'updateMillisec': '',
          'closePrice': '',
          'settlementPrice': '',
          'mDSecurityStat': '',
          'hWFlag': '',
          'preCloseIOPV': '',
          'iOPV': '',
          'changeReason': '',
          'lastVolume': '',
          'longUpdateTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.stpNpSpotMarketDataDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.stpNpSpotMarketDataForm) {
          this.$refs.stpNpSpotMarketDataForm.resetFields();
        }
        this.$http({
          url: '/npspot/stpNpSpotMarketData/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotMarketDataForm = {
              'id': res.object.id,
              'tradingDay': res.object.tradingDay,
              'securityID': res.object.securityID,
              'exchangeID': res.object.exchangeID,
              'securityName': res.object.securityName,
              'preClosePrice': res.object.preClosePrice,
              'openPrice': res.object.openPrice,
              'volume': res.object.volume,
              'turnover': res.object.turnover,
              'tradingCount': res.object.tradingCount,
              'lastPrice': res.object.lastPrice,
              'highestPrice': res.object.highestPrice,
              'lowestPrice': res.object.lowestPrice,
              'bidPrice1': res.object.bidPrice1,
              'askPrice1': res.object.askPrice1,
              'upperLimitPrice': res.object.upperLimitPrice,
              'lowerLimitPrice': res.object.lowerLimitPrice,
              'pERatio1': res.object.pERatio1,
              'pERatio2': res.object.pERatio2,
              'priceUpDown1': res.object.priceUpDown1,
              'priceUpDown2': res.object.priceUpDown2,
              'openInterest': res.object.openInterest,
              'bidVolume1': res.object.bidVolume1,
              'askVolume1': res.object.askVolume1,
              'bidPrice2': res.object.bidPrice2,
              'bidVolume2': res.object.bidVolume2,
              'askPrice2': res.object.askPrice2,
              'askVolume2': res.object.askVolume2,
              'bidPrice3': res.object.bidPrice3,
              'bidVolume3': res.object.bidVolume3,
              'askPrice3': res.object.askPrice3,
              'askVolume3': res.object.askVolume3,
              'bidPrice4': res.object.bidPrice4,
              'bidVolume4': res.object.bidVolume4,
              'askPrice4': res.object.askPrice4,
              'askVolume4': res.object.askVolume4,
              'bidPrice5': res.object.bidPrice5,
              'bidVolume5': res.object.bidVolume5,
              'askPrice5': res.object.askPrice5,
              'askVolume5': res.object.askVolume5,
              'updateTime': res.object.updateTime,
              'updateMillisec': res.object.updateMillisec,
              'closePrice': res.object.closePrice,
              'settlementPrice': res.object.settlementPrice,
              'mDSecurityStat': res.object.mDSecurityStat,
              'hWFlag': res.object.hWFlag,
              'preCloseIOPV': res.object.preCloseIOPV,
              'iOPV': res.object.iOPV,
              'changeReason': res.object.changeReason,
              'lastVolume': res.object.lastVolume,
              'longUpdateTime': res.object.longUpdateTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.stpNpSpotMarketDataDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npspot/stpNpSpotMarketData/save',
              method: 'post',
              data: this.stpNpSpotMarketDataForm
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
            this.stpNpSpotMarketDataDialog = false;
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
            url: '/npspot/stpNpSpotMarketData/del',
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
  .stpNpSpotMarketDataForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
