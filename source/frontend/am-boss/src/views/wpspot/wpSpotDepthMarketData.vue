<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="业务日">
        <el-input v-model="searchForm.actionDay" clearable placeholder="请输入业务日"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpSpotDepthMarketDataLoading" :data="wpSpotDepthMarketDataData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="exchangeInstID" label="合约在交易所的代码" />
      <el-table-column prop="lastPrice" label="最新价" />
      <el-table-column prop="preSettlementPrice" label="上次结算价" />
      <el-table-column prop="preClosePrice" label="昨收盘" />
      <el-table-column prop="preOpenInterest" label="昨持仓量" />
      <el-table-column prop="openPrice" label="今开盘价" />
      <el-table-column prop="highestPrice" label="最高价" />
      <el-table-column prop="lowestPrice" label="最低价" />
      <el-table-column prop="volume" label="成交数量" />
      <el-table-column prop="turnover" label="成交金额" />
      <el-table-column prop="openInterest" label="持仓量" />
      <el-table-column prop="closePrice" label="今收盘" />
      <el-table-column prop="settlementPrice" label="本次结算价" />
      <el-table-column prop="upperLimitPrice" label="涨停板价" />
      <el-table-column prop="lowerLimitPrice" label="跌停板价" />
      <el-table-column prop="preDelta" label="昨虚实度" />
      <el-table-column prop="currDelta" label="今虚实度" />
      <el-table-column prop="updateTime" label="最后修改时间" />
      <el-table-column prop="updateMillisec" label="最后修改毫秒" />
      <el-table-column prop="bidPrice1" label="申买价一" />
      <el-table-column prop="bidVolume1" label="申买量一" />
      <el-table-column prop="askPrice1" label="申卖价一" />
      <el-table-column prop="askVolume1" label="申卖量一" />
      <el-table-column prop="bidPrice2" label="申买价二" />
      <el-table-column prop="bidVolume2" label="申买量二" />
      <el-table-column prop="askPrice2" label="申卖价二" />
      <el-table-column prop="askVolume2" label="申卖量二" />
      <el-table-column prop="bidPrice3" label="申买价三" />
      <el-table-column prop="bidVolume3" label="申买量三" />
      <el-table-column prop="askPrice3" label="申卖价三" />
      <el-table-column prop="askVolume3" label="申卖量三" />
      <el-table-column prop="bidPrice4" label="申买价四" />
      <el-table-column prop="bidVolume4" label="申买量四" />
      <el-table-column prop="askPrice4" label="申卖价四" />
      <el-table-column prop="askVolume4" label="申卖量四" />
      <el-table-column prop="bidPrice5" label="申买价五" />
      <el-table-column prop="bidVolume5" label="申买量五" />
      <el-table-column prop="askPrice5" label="申卖价五" />
      <el-table-column prop="askVolume5" label="申卖量五" />
      <el-table-column prop="averagePrice" label="当日均价" />
      <el-table-column prop="actionDay" label="业务日期" />
      <el-table-column prop="changeReason" label="行情变动原因(委托盘口entrust、撮和成交trade)" />
      <el-table-column prop="lastVolume" label="最新成交量" />
      <el-table-column prop="longUpdateTime" label="行情更新时间" />
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
    <el-dialog title="外盘现货深度行情表管理" :visible.sync="wpSpotDepthMarketDataDialog" :close-on-click-modal="false" width="600">
      <el-form ref="wpSpotDepthMarketDataForm" :model="wpSpotDepthMarketDataForm" :rules="wpSpotDepthMarketDataRules" label-width="150px" class="wpSpotDepthMarketDataForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="wpSpotDepthMarketDataForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="wpSpotDepthMarketDataForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="wpSpotDepthMarketDataForm.instrumentID" placeholder="请输入合约代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="wpSpotDepthMarketDataForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="合约在交易所的代码" prop="exchangeInstID">
          <el-input v-model="wpSpotDepthMarketDataForm.exchangeInstID" placeholder="请输入合约在交易所的代码" />
        </el-form-item>
        <el-form-item label="最新价" prop="lastPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.lastPrice" placeholder="请输入最新价" />
        </el-form-item>
        <el-form-item label="上次结算价" prop="preSettlementPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.preSettlementPrice" placeholder="请输入上次结算价" />
        </el-form-item>
        <el-form-item label="昨收盘" prop="preClosePrice">
          <el-input v-model="wpSpotDepthMarketDataForm.preClosePrice" placeholder="请输入昨收盘" />
        </el-form-item>
        <el-form-item label="昨持仓量" prop="preOpenInterest">
          <el-input v-model="wpSpotDepthMarketDataForm.preOpenInterest" placeholder="请输入昨持仓量" />
        </el-form-item>
        <el-form-item label="今开盘价" prop="openPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.openPrice" placeholder="请输入今开盘价" />
        </el-form-item>
        <el-form-item label="最高价" prop="highestPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.highestPrice" placeholder="请输入最高价" />
        </el-form-item>
        <el-form-item label="最低价" prop="lowestPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.lowestPrice" placeholder="请输入最低价" />
        </el-form-item>
        <el-form-item label="成交数量" prop="volume">
          <el-input v-model="wpSpotDepthMarketDataForm.volume" placeholder="请输入成交数量" />
        </el-form-item>
        <el-form-item label="成交金额" prop="turnover">
          <el-input v-model="wpSpotDepthMarketDataForm.turnover" placeholder="请输入成交金额" />
        </el-form-item>
        <el-form-item label="持仓量" prop="openInterest">
          <el-input v-model="wpSpotDepthMarketDataForm.openInterest" placeholder="请输入持仓量" />
        </el-form-item>
        <el-form-item label="今收盘" prop="closePrice">
          <el-input v-model="wpSpotDepthMarketDataForm.closePrice" placeholder="请输入今收盘" />
        </el-form-item>
        <el-form-item label="本次结算价" prop="settlementPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.settlementPrice" placeholder="请输入本次结算价" />
        </el-form-item>
        <el-form-item label="涨停板价" prop="upperLimitPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.upperLimitPrice" placeholder="请输入涨停板价" />
        </el-form-item>
        <el-form-item label="跌停板价" prop="lowerLimitPrice">
          <el-input v-model="wpSpotDepthMarketDataForm.lowerLimitPrice" placeholder="请输入跌停板价" />
        </el-form-item>
        <el-form-item label="昨虚实度" prop="preDelta">
          <el-input v-model="wpSpotDepthMarketDataForm.preDelta" placeholder="请输入昨虚实度" />
        </el-form-item>
        <el-form-item label="今虚实度" prop="currDelta">
          <el-input v-model="wpSpotDepthMarketDataForm.currDelta" placeholder="请输入今虚实度" />
        </el-form-item>
        <el-form-item label="最后修改时间" prop="updateTime">
          <el-input v-model="wpSpotDepthMarketDataForm.updateTime" placeholder="请输入最后修改时间" />
        </el-form-item>
        <el-form-item label="最后修改毫秒" prop="updateMillisec">
          <el-input v-model="wpSpotDepthMarketDataForm.updateMillisec" placeholder="请输入最后修改毫秒" />
        </el-form-item>
        <el-form-item label="申买价一" prop="bidPrice1">
          <el-input v-model="wpSpotDepthMarketDataForm.bidPrice1" placeholder="请输入申买价一" />
        </el-form-item>
        <el-form-item label="申买量一" prop="bidVolume1">
          <el-input v-model="wpSpotDepthMarketDataForm.bidVolume1" placeholder="请输入申买量一" />
        </el-form-item>
        <el-form-item label="申卖价一" prop="askPrice1">
          <el-input v-model="wpSpotDepthMarketDataForm.askPrice1" placeholder="请输入申卖价一" />
        </el-form-item>
        <el-form-item label="申卖量一" prop="askVolume1">
          <el-input v-model="wpSpotDepthMarketDataForm.askVolume1" placeholder="请输入申卖量一" />
        </el-form-item>
        <el-form-item label="申买价二" prop="bidPrice2">
          <el-input v-model="wpSpotDepthMarketDataForm.bidPrice2" placeholder="请输入申买价二" />
        </el-form-item>
        <el-form-item label="申买量二" prop="bidVolume2">
          <el-input v-model="wpSpotDepthMarketDataForm.bidVolume2" placeholder="请输入申买量二" />
        </el-form-item>
        <el-form-item label="申卖价二" prop="askPrice2">
          <el-input v-model="wpSpotDepthMarketDataForm.askPrice2" placeholder="请输入申卖价二" />
        </el-form-item>
        <el-form-item label="申卖量二" prop="askVolume2">
          <el-input v-model="wpSpotDepthMarketDataForm.askVolume2" placeholder="请输入申卖量二" />
        </el-form-item>
        <el-form-item label="申买价三" prop="bidPrice3">
          <el-input v-model="wpSpotDepthMarketDataForm.bidPrice3" placeholder="请输入申买价三" />
        </el-form-item>
        <el-form-item label="申买量三" prop="bidVolume3">
          <el-input v-model="wpSpotDepthMarketDataForm.bidVolume3" placeholder="请输入申买量三" />
        </el-form-item>
        <el-form-item label="申卖价三" prop="askPrice3">
          <el-input v-model="wpSpotDepthMarketDataForm.askPrice3" placeholder="请输入申卖价三" />
        </el-form-item>
        <el-form-item label="申卖量三" prop="askVolume3">
          <el-input v-model="wpSpotDepthMarketDataForm.askVolume3" placeholder="请输入申卖量三" />
        </el-form-item>
        <el-form-item label="申买价四" prop="bidPrice4">
          <el-input v-model="wpSpotDepthMarketDataForm.bidPrice4" placeholder="请输入申买价四" />
        </el-form-item>
        <el-form-item label="申买量四" prop="bidVolume4">
          <el-input v-model="wpSpotDepthMarketDataForm.bidVolume4" placeholder="请输入申买量四" />
        </el-form-item>
        <el-form-item label="申卖价四" prop="askPrice4">
          <el-input v-model="wpSpotDepthMarketDataForm.askPrice4" placeholder="请输入申卖价四" />
        </el-form-item>
        <el-form-item label="申卖量四" prop="askVolume4">
          <el-input v-model="wpSpotDepthMarketDataForm.askVolume4" placeholder="请输入申卖量四" />
        </el-form-item>
        <el-form-item label="申买价五" prop="bidPrice5">
          <el-input v-model="wpSpotDepthMarketDataForm.bidPrice5" placeholder="请输入申买价五" />
        </el-form-item>
        <el-form-item label="申买量五" prop="bidVolume5">
          <el-input v-model="wpSpotDepthMarketDataForm.bidVolume5" placeholder="请输入申买量五" />
        </el-form-item>
        <el-form-item label="申卖价五" prop="askPrice5">
          <el-input v-model="wpSpotDepthMarketDataForm.askPrice5" placeholder="请输入申卖价五" />
        </el-form-item>
        <el-form-item label="申卖量五" prop="askVolume5">
          <el-input v-model="wpSpotDepthMarketDataForm.askVolume5" placeholder="请输入申卖量五" />
        </el-form-item>
        <el-form-item label="当日均价" prop="averagePrice">
          <el-input v-model="wpSpotDepthMarketDataForm.averagePrice" placeholder="请输入当日均价" />
        </el-form-item>
        <el-form-item label="业务日期" prop="actionDay">
          <el-input v-model="wpSpotDepthMarketDataForm.actionDay" placeholder="请输入业务日期" />
        </el-form-item>
        <el-form-item label="行情变动原因(委托盘口entrust、撮和成交trade)" prop="changeReason">
          <el-input v-model="wpSpotDepthMarketDataForm.changeReason" placeholder="请输入行情变动原因(委托盘口entrust、撮和成交trade)" />
        </el-form-item>
        <el-form-item label="最新成交量" prop="lastVolume">
          <el-input v-model="wpSpotDepthMarketDataForm.lastVolume" placeholder="请输入最新成交量" />
        </el-form-item>
        <el-form-item label="行情更新时间" prop="longUpdateTime">
          <el-input v-model="wpSpotDepthMarketDataForm.longUpdateTime" placeholder="请输入行情更新时间" />
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpSpotDepthMarketDataName',
  data() {
    return {
      wpSpotDepthMarketDataLoading: true,
      wpSpotDepthMarketDataDialog: false,
      wpSpotDepthMarketDataData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpSpotDepthMarketDataForm: {
        'id': '',
        'tradingDay': '',
        'instrumentID': '',
        'exchangeID': '',
        'exchangeInstID': '',
        'lastPrice': '',
        'preSettlementPrice': '',
        'preClosePrice': '',
        'preOpenInterest': '',
        'openPrice': '',
        'highestPrice': '',
        'lowestPrice': '',
        'volume': '',
        'turnover': '',
        'openInterest': '',
        'closePrice': '',
        'settlementPrice': '',
        'upperLimitPrice': '',
        'lowerLimitPrice': '',
        'preDelta': '',
        'currDelta': '',
        'updateTime': '',
        'updateMillisec': '',
        'bidPrice1': '',
        'bidVolume1': '',
        'askPrice1': '',
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
        'averagePrice': '',
        'actionDay': '',
        'changeReason': '',
        'lastVolume': '',
        'longUpdateTime': ''
      },
      searchForm: {
        'instrumentID': '',
        'exchangeID': '',
        'actionDay': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpSpotDepthMarketDataRules: {
        instrumentID: [
          { required: true, message: '合约代码不可为空', trigger: 'change' }
        ],
        lastPrice: [
          { required: true, message: '最新价不可为空', trigger: 'change' }
        ],
        preSettlementPrice: [
          { required: true, message: '上次结算价不可为空', trigger: 'change' }
        ],
        preClosePrice: [
          { required: true, message: '昨收盘不可为空', trigger: 'change' }
        ],
        preOpenInterest: [
          { required: true, message: '昨持仓量不可为空', trigger: 'change' }
        ],
        openPrice: [
          { required: true, message: '今开盘价不可为空', trigger: 'change' }
        ],
        highestPrice: [
          { required: true, message: '最高价不可为空', trigger: 'change' }
        ],
        lowestPrice: [
          { required: true, message: '最低价不可为空', trigger: 'change' }
        ],
        volume: [
          { required: true, message: '成交数量不可为空', trigger: 'change' }
        ],
        turnover: [
          { required: true, message: '成交金额不可为空', trigger: 'change' }
        ],
        openInterest: [
          { required: true, message: '持仓量不可为空', trigger: 'change' }
        ],
        closePrice: [
          { required: true, message: '今收盘不可为空', trigger: 'change' }
        ],
        settlementPrice: [
          { required: true, message: '本次结算价不可为空', trigger: 'change' }
        ],
        upperLimitPrice: [
          { required: true, message: '涨停板价不可为空', trigger: 'change' }
        ],
        lowerLimitPrice: [
          { required: true, message: '跌停板价不可为空', trigger: 'change' }
        ],
        preDelta: [
          { required: true, message: '昨虚实度不可为空', trigger: 'change' }
        ],
        currDelta: [
          { required: true, message: '今虚实度不可为空', trigger: 'change' }
        ],
        updateTime: [
          { required: true, message: '最后修改时间不可为空', trigger: 'change' }
        ],
        updateMillisec: [
          { required: true, message: '最后修改毫秒不可为空', trigger: 'change' }
        ],
        bidPrice1: [
          { required: true, message: '申买价一不可为空', trigger: 'change' }
        ],
        bidVolume1: [
          { required: true, message: '申买量一不可为空', trigger: 'change' }
        ],
        askPrice1: [
          { required: true, message: '申卖价一不可为空', trigger: 'change' }
        ],
        askVolume1: [
          { required: true, message: '申卖量一不可为空', trigger: 'change' }
        ],
        bidPrice2: [
          { required: true, message: '申买价二不可为空', trigger: 'change' }
        ],
        bidVolume2: [
          { required: true, message: '申买量二不可为空', trigger: 'change' }
        ],
        askPrice2: [
          { required: true, message: '申卖价二不可为空', trigger: 'change' }
        ],
        askVolume2: [
          { required: true, message: '申卖量二不可为空', trigger: 'change' }
        ],
        bidPrice3: [
          { required: true, message: '申买价三不可为空', trigger: 'change' }
        ],
        bidVolume3: [
          { required: true, message: '申买量三不可为空', trigger: 'change' }
        ],
        askPrice3: [
          { required: true, message: '申卖价三不可为空', trigger: 'change' }
        ],
        askVolume3: [
          { required: true, message: '申卖量三不可为空', trigger: 'change' }
        ],
        bidPrice4: [
          { required: true, message: '申买价四不可为空', trigger: 'change' }
        ],
        bidVolume4: [
          { required: true, message: '申买量四不可为空', trigger: 'change' }
        ],
        askPrice4: [
          { required: true, message: '申卖价四不可为空', trigger: 'change' }
        ],
        askVolume4: [
          { required: true, message: '申卖量四不可为空', trigger: 'change' }
        ],
        bidPrice5: [
          { required: true, message: '申买价五不可为空', trigger: 'change' }
        ],
        bidVolume5: [
          { required: true, message: '申买量五不可为空', trigger: 'change' }
        ],
        askPrice5: [
          { required: true, message: '申卖价五不可为空', trigger: 'change' }
        ],
        askVolume5: [
          { required: true, message: '申卖量五不可为空', trigger: 'change' }
        ],
        averagePrice: [
          { required: true, message: '当日均价不可为空', trigger: 'change' }
        ],
        actionDay: [
          { required: true, message: '业务日期不可为空', trigger: 'change' }
        ],
        changeReason: [
          { required: true, message: '行情变动原因(委托盘口entrust、撮和成交trade)不可为空', trigger: 'change' }
        ],
        lastVolume: [
          { required: true, message: '最新成交量不可为空', trigger: 'change' }
        ],
        longUpdateTime: [
          { required: true, message: '行情更新时间不可为空', trigger: 'change' }
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
        url: '/wpspot/dict/wpSpotDepthMarketData',
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
      this.wpSpotDepthMarketDataLoading = true;
      this.$http({
        url: '/wpspot/wpSpotDepthMarketData/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotDepthMarketDataData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpSpotDepthMarketDataLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpSpotDepthMarketDataForm = {
        'id': '',
        'tradingDay': '',
        'instrumentID': '',
        'exchangeID': '',
        'exchangeInstID': '',
        'lastPrice': '',
        'preSettlementPrice': '',
        'preClosePrice': '',
        'preOpenInterest': '',
        'openPrice': '',
        'highestPrice': '',
        'lowestPrice': '',
        'volume': '',
        'turnover': '',
        'openInterest': '',
        'closePrice': '',
        'settlementPrice': '',
        'upperLimitPrice': '',
        'lowerLimitPrice': '',
        'preDelta': '',
        'currDelta': '',
        'updateTime': '',
        'updateMillisec': '',
        'bidPrice1': '',
        'bidVolume1': '',
        'askPrice1': '',
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
        'averagePrice': '',
        'actionDay': '',
        'changeReason': '',
        'lastVolume': '',
        'longUpdateTime': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpSpotDepthMarketDataDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpSpotDepthMarketDataForm) {
        this.$refs.wpSpotDepthMarketDataForm.resetFields();
      }
      this.$http({
        url: '/wpspot/wpSpotDepthMarketData/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotDepthMarketDataForm = {
            'id': res.object.id,
            'tradingDay': res.object.tradingDay,
            'instrumentID': res.object.instrumentID,
            'exchangeID': res.object.exchangeID,
            'exchangeInstID': res.object.exchangeInstID,
            'lastPrice': res.object.lastPrice,
            'preSettlementPrice': res.object.preSettlementPrice,
            'preClosePrice': res.object.preClosePrice,
            'preOpenInterest': res.object.preOpenInterest,
            'openPrice': res.object.openPrice,
            'highestPrice': res.object.highestPrice,
            'lowestPrice': res.object.lowestPrice,
            'volume': res.object.volume,
            'turnover': res.object.turnover,
            'openInterest': res.object.openInterest,
            'closePrice': res.object.closePrice,
            'settlementPrice': res.object.settlementPrice,
            'upperLimitPrice': res.object.upperLimitPrice,
            'lowerLimitPrice': res.object.lowerLimitPrice,
            'preDelta': res.object.preDelta,
            'currDelta': res.object.currDelta,
            'updateTime': res.object.updateTime,
            'updateMillisec': res.object.updateMillisec,
            'bidPrice1': res.object.bidPrice1,
            'bidVolume1': res.object.bidVolume1,
            'askPrice1': res.object.askPrice1,
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
            'averagePrice': res.object.averagePrice,
            'actionDay': res.object.actionDay,
            'changeReason': res.object.changeReason,
            'lastVolume': res.object.lastVolume,
            'longUpdateTime': res.object.longUpdateTime
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpSpotDepthMarketDataDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/wpSpotDepthMarketData/save',
            method: 'post',
            data: this.wpSpotDepthMarketDataForm
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
          this.wpSpotDepthMarketDataDialog = false;
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
          url: '/wpspot/wpSpotDepthMarketData/del',
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
		.wpSpotDepthMarketDataForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
