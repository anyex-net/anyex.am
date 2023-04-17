<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="品种类型" prop="stockinfoId">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesQuoteLoading" :data="wpfuturesQuoteData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编号" />
      <el-table-column prop="contractNo" label="合约代码1" />
      <el-table-column prop="currencyNo" label="币种编号" />
      <el-table-column label="交易状态">
        <template slot-scope="scope">
          <div v-if="scope.row.tradingState == '0'">常规</div>
          <div v-if="scope.row.tradingState == '1'">集合竞价</div>
          <div v-if="scope.row.tradingState == '2'">集合竞价撮合</div>
          <div v-if="scope.row.tradingState == '3'">连续交易</div>
          <div v-if="scope.row.tradingState == '4'">交易暂停</div>
          <div v-if="scope.row.tradingState == '5'">闭市</div>
        </template>
      </el-table-column>
      <el-table-column prop="dateTimeStamp" label="时间戳" />
      <el-table-column prop="qPreClosingPrice" label="昨收盘价" />
      <el-table-column prop="qPreSettlePrice" label="昨结算价" />
      <el-table-column prop="qPrePositionQty" label="昨持仓量" />
      <el-table-column prop="qOpeningPrice" label="开盘价" />
      <el-table-column prop="qLastPrice" label="最新价" />
      <el-table-column prop="qHighPrice" label="最高价" />
      <el-table-column prop="qLowPrice" label="最低价" />
      <el-table-column prop="qHisHighPrice" label="历史最高价" />
      <el-table-column prop="qHisLowPrice" label="历史最低价" />
      <el-table-column prop="qLimitUpPrice" label="涨停价" />
      <el-table-column prop="qLimitDownPrice" label="跌停价" />
      <el-table-column prop="qTotalQty" label="当日总成交量" />
      <el-table-column prop="qTotalTurnover" label="当日成交金额" />
      <el-table-column prop="qPositionQty" label="持仓量" />
      <el-table-column prop="qAveragePrice" label="均价" />
      <el-table-column prop="qClosingPrice" label="收盘价" />
      <el-table-column prop="qSettlePrice" label="结算价" />
      <el-table-column prop="qLastQty" label="最新成交量" />
      <el-table-column prop="qBidPrice" label="买价1-20档" />
      <el-table-column prop="qBidQty" label="买量1-20档" />
      <el-table-column prop="qAskPrice" label="卖价1-20档" />
      <el-table-column prop="qAskQty" label="卖量1-20档" />
      <el-table-column prop="qImpliedBidPrice" label="隐含买价" />
      <el-table-column prop="qImpliedBidQty" label="隐含买量" />
      <el-table-column prop="qImpliedAskPrice" label="隐含卖价" />
      <el-table-column prop="qImpliedAskQty" label="隐含卖量" />
      <el-table-column prop="qPreDelta" label="昨虚实度" />
      <el-table-column prop="qCurrDelta" label="今虚实度" />
      <el-table-column prop="qInsideQty" label="内盘量" />
      <el-table-column prop="qOutsideQty" label="外盘量" />
      <el-table-column prop="qTurnoverRate" label="换手率" />
      <el-table-column prop="q5DAvgQty" label="五日均量" />
      <el-table-column prop="qPERatio" label="市盈率" />
      <el-table-column prop="qTotalValue" label="总市值" />
      <el-table-column prop="qNegotiableValue" label="流通市值" />
      <el-table-column prop="qPositionTrend" label="持仓走势" />
      <el-table-column prop="qChangeSpeed" label="涨速" />
      <el-table-column prop="qChangeRate" label="涨幅" />
      <el-table-column prop="qChangeValue" label="涨跌值" />
      <el-table-column prop="qSwing" label="振幅" />
      <el-table-column prop="qTotalBidQty" label="委买总量" />
      <el-table-column prop="qTotalAskQty" label="委卖总量" />
      <el-table-column prop="underlyContract" label="虚拟合约对应的真实合约(对象)" />
      <el-table-column prop="changeReason" label="行情变动原因" />
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
    <el-dialog title="期货行情详细" :visible.sync="wpfuturesQuoteDialog" :close-on-click-modal="false" width="1500">
      <el-form ref="wpfuturesQuoteForm" :model="wpfuturesQuoteForm" label-width="100px" class="wpfuturesQuoteForm">
        <el-row>
          <el-col :span=8>
            <el-form-item label="交易所编码" prop="exchangeNo">
              <el-input v-model="wpfuturesQuoteForm.exchangeNo" placeholder="请输入交易所编码"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种类型" prop="commodityType">
              <el-input v-model="wpfuturesQuoteForm.commodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种编号" prop="commodityNo">
              <el-input v-model="wpfuturesQuoteForm.commodityNo" placeholder="请输入品种编号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="合约代码1" prop="contractNo">
              <el-input v-model="wpfuturesQuoteForm.contractNo" placeholder="请输入合约代码1"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="币种编号" prop="currencyNo">
              <el-input v-model="wpfuturesQuoteForm.currencyNo" placeholder="请输入币种编号"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="交易状态" prop="tradingState">
              <el-select v-model="wpfuturesQuoteForm.tradingState" placeholder="请选择交易状态" value="">
                <el-option key="0" label="常规" value="0" />
                <el-option key="1" label="集合竞价" value="1" />
                <el-option key="2" label="集合竞价撮合" value="2" />
                <el-option key="3" label="连续交易" value="3" />
                <el-option key="4" label="交易暂停" value="4" />
                <el-option key="5" label="闭市" value="5" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="时间戳" prop="dateTimeStamp">
              <el-input v-model="wpfuturesQuoteForm.dateTimeStamp" placeholder="请输入时间戳"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="昨收盘价" prop="qPreClosingPrice">
              <el-input v-model="wpfuturesQuoteForm.qPreClosingPrice" placeholder="请输入昨收盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="昨结算价" prop="qPreSettlePrice">
              <el-input v-model="wpfuturesQuoteForm.qPreSettlePrice" placeholder="请输入昨结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="昨持仓量" prop="qPrePositionQty">
              <el-input v-model="wpfuturesQuoteForm.qPrePositionQty" placeholder="请输入昨持仓量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="开盘价" prop="qOpeningPrice">
              <el-input v-model="wpfuturesQuoteForm.qOpeningPrice" placeholder="请输入开盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="最新价" prop="qLastPrice">
              <el-input v-model="wpfuturesQuoteForm.qLastPrice" placeholder="请输入最新价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="最高价" prop="qHighPrice">
              <el-input v-model="wpfuturesQuoteForm.qHighPrice" placeholder="请输入最高价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="最低价" prop="qLowPrice">
              <el-input v-model="wpfuturesQuoteForm.qLowPrice" placeholder="请输入最低价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="历史最高价" prop="qHisHighPrice">
              <el-input v-model="wpfuturesQuoteForm.qHisHighPrice" placeholder="请输入历史最高价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="历史最低价" prop="qHisLowPrice">
              <el-input v-model="wpfuturesQuoteForm.qHisLowPrice" placeholder="请输入历史最低价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="涨停价" prop="qLimitUpPrice">
              <el-input v-model="wpfuturesQuoteForm.qLimitUpPrice" placeholder="请输入涨停价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="跌停价" prop="qLimitDownPrice">
              <el-input v-model="wpfuturesQuoteForm.qLimitDownPrice" placeholder="请输入跌停价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="当日总成交量" prop="qTotalQty">
              <el-input v-model="wpfuturesQuoteForm.qTotalQty" placeholder="请输入当日总成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="当日成交金额" prop="qTotalTurnover">
              <el-input v-model="wpfuturesQuoteForm.qTotalTurnover" placeholder="请输入当日成交金额"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="持仓量" prop="qPositionQty">
              <el-input v-model="wpfuturesQuoteForm.qPositionQty" placeholder="请输入持仓量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="均价" prop="qAveragePrice">
              <el-input v-model="wpfuturesQuoteForm.qAveragePrice" placeholder="请输入均价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="收盘价" prop="qClosingPrice">
              <el-input v-model="wpfuturesQuoteForm.qClosingPrice" placeholder="请输入收盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="结算价" prop="qSettlePrice">
              <el-input v-model="wpfuturesQuoteForm.qSettlePrice" placeholder="请输入结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="最新成交量" prop="qLastQty">
              <el-input v-model="wpfuturesQuoteForm.qLastQty" placeholder="请输入最新成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="买价1-20档" prop="qBidPrice">
              <el-input v-model="wpfuturesQuoteForm.qBidPrice" placeholder="请输入买价1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="买量1-20档" prop="qBidQty">
              <el-input v-model="wpfuturesQuoteForm.qBidQty" placeholder="请输入买量1-20档"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="卖价1-20档" prop="qAskPrice">
              <el-input v-model="wpfuturesQuoteForm.qAskPrice" placeholder="请输入卖价1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="卖量1-20档" prop="qAskQty">
              <el-input v-model="wpfuturesQuoteForm.qAskQty" placeholder="请输入卖量1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="隐含买价" prop="qImpliedBidPrice">
              <el-input v-model="wpfuturesQuoteForm.qImpliedBidPrice" placeholder="请输入隐含买价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="隐含买量" prop="qImpliedBidQty">
              <el-input v-model="wpfuturesQuoteForm.qImpliedBidQty" placeholder="请输入隐含买量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="隐含卖价" prop="qImpliedAskPrice">
              <el-input v-model="wpfuturesQuoteForm.qImpliedAskPrice" placeholder="请输入隐含卖价"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="隐含卖量" prop="qImpliedAskQty">
              <el-input v-model="wpfuturesQuoteForm.qImpliedAskQty" placeholder="请输入隐含卖量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="昨虚实度" prop="qPreDelta">
              <el-input v-model="wpfuturesQuoteForm.qPreDelta" placeholder="请输入昨虚实度"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="今虚实度" prop="qCurrDelta">
              <el-input v-model="wpfuturesQuoteForm.qCurrDelta" placeholder="请输入今虚实度"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="内盘量" prop="qInsideQty">
              <el-input v-model="wpfuturesQuoteForm.qInsideQty" placeholder="请输入内盘量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="外盘量" prop="qOutsideQty">
              <el-input v-model="wpfuturesQuoteForm.qOutsideQty" placeholder="请输入外盘量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="换手率" prop="qTurnoverRate">
              <el-input v-model="wpfuturesQuoteForm.qTurnoverRate" placeholder="请输入换手率"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="五日均量" prop="q5DAvgQty">
              <el-input v-model="wpfuturesQuoteForm.q5DAvgQty" placeholder="请输入五日均量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="市盈率" prop="qPERatio">
              <el-input v-model="wpfuturesQuoteForm.qPERatio" placeholder="请输入市盈率"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="总市值" prop="qTotalValue">
              <el-input v-model="wpfuturesQuoteForm.qTotalValue" placeholder="请输入总市值"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="流通市值" prop="qNegotiableValue">
              <el-input v-model="wpfuturesQuoteForm.qNegotiableValue" placeholder="请输入流通市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="持仓走势" prop="qPositionTrend">
              <el-input v-model="wpfuturesQuoteForm.qPositionTrend" placeholder="请输入持仓走势"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="涨速" prop="qChangeSpeed">
              <el-input v-model="wpfuturesQuoteForm.qChangeSpeed" placeholder="请输入涨速"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="涨幅" prop="qChangeRate">
              <el-input v-model="wpfuturesQuoteForm.qChangeRate" placeholder="请输入涨幅"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="涨跌值" prop="qChangeValue">
              <el-input v-model="wpfuturesQuoteForm.qChangeValue" placeholder="请输入涨跌值"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="振幅" prop="qSwing">
              <el-input v-model="wpfuturesQuoteForm.qSwing" placeholder="请输入振幅"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="委买总量" prop="qTotalBidQty">
              <el-input v-model="wpfuturesQuoteForm.qTotalBidQty" placeholder="请输入委买总量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="委卖总量" prop="qTotalAskQty">
              <el-input v-model="wpfuturesQuoteForm.qTotalAskQty" placeholder="请输入委卖总量"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="真实合约" prop="underlyContract">
              <el-input v-model="wpfuturesQuoteForm.underlyContract" placeholder="请输入虚拟合约对应的真实合约(对象)"/>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="行情变动原因" prop="changeReason">
              <el-input v-model="wpfuturesQuoteForm.changeReason" placeholder="请输入行情变动原因"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OtcDigitalCoinConfig',
  data() {
    return {
      wpfuturesQuoteLoading: true,
      wpfuturesQuoteDialog: false,
      wpfuturesQuoteData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpfuturesQuoteForm: {
        'id': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo': '',
        'currencyNo': '',
        'tradingState': '',
        'dateTimeStamp': '',
        'qPreClosingPrice': '',
        'qPreSettlePrice': '',
        'qPrePositionQty': '',
        'qOpeningPrice': '',
        'qLastPrice': '',
        'qHighPrice': '',
        'qLowPrice': '',
        'qHisHighPrice': '',
        'qHisLowPrice': '',
        'qLimitUpPrice': '',
        'qLimitDownPrice': '',
        'qTotalQty': '',
        'qTotalTurnover': '',
        'qPositionQty': '',
        'qAveragePrice': '',
        'qClosingPrice': '',
        'qSettlePrice': '',
        'qLastQty': '',
        'qBidPrice': '',
        'qBidQty': '',
        'qAskPrice': '',
        'qAskQty': '',
        'qImpliedBidPrice': '',
        'qImpliedBidQty': '',
        'qImpliedAskPrice': '',
        'qImpliedAskQty': '',
        'qPreDelta': '',
        'qCurrDelta': '',
        'qInsideQty': '',
        'qOutsideQty': '',
        'qTurnoverRate': '',
        'q5DAvgQty': '',
        'qPERatio': '',
        'qTotalValue': '',
        'qNegotiableValue': '',
        'qPositionTrend': '',
        'qChangeSpeed': '',
        'qChangeRate': '',
        'qChangeValue': '',
        'qSwing': '',
        'qTotalBidQty': '',
        'qTotalAskQty': '',
        'underlyContract': '',
        'changeReason': ''
      },
      searchForm: {
        'commodityType': '',
        'commodityNo': '',
        'commodityName': '',
        'commodityEngName': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpfuturesQuoteRules: {
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
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesQuoteForm) {
        this.$refs.wpfuturesQuoteForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/WpfuturesQuoteWhole/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesQuoteForm = {
            'id': res.object.id,
            'exchangeNo': res.object.exchangeNo,
            'commodityType': res.object.commodityType,
            'commodityNo': res.object.commodityNo,
            'contractNo': res.object.contractNo,
            'currencyNo': res.object.currencyNo,
            'tradingState': res.object.tradingState,
            'dateTimeStamp': res.object.dateTimeStamp,
            'qPreClosingPrice': res.object.qPreClosingPrice,
            'qPreSettlePrice': res.object.qPreSettlePrice,
            'qPrePositionQty': res.object.qPrePositionQty,
            'qOpeningPrice': res.object.qOpeningPrice,
            'qLastPrice': res.object.qLastPrice,
            'qHighPrice': res.object.qHighPrice,
            'qLowPrice': res.object.qLowPrice,
            'qHisHighPrice': res.object.qHisHighPrice,
            'qHisLowPrice': res.object.qHisLowPrice,
            'qLimitUpPrice': res.object.qLimitUpPrice,
            'qLimitDownPrice': res.object.qLimitDownPrice,
            'qTotalQty': res.object.qTotalQty,
            'qTotalTurnover': res.object.qTotalTurnover,
            'qPositionQty': res.object.qPositionQty,
            'qAveragePrice': res.object.qAveragePrice,
            'qClosingPrice': res.object.qClosingPrice,
            'qSettlePrice': res.object.qSettlePrice,
            'qLastQty': res.object.qLastQty,
            'qBidPrice': res.object.qBidPrice,
            'qBidQty': res.object.qBidQty,
            'qAskPrice': res.object.qAskPrice,
            'qAskQty': res.object.qAskQty,
            'qImpliedBidPrice': res.object.qImpliedBidPrice,
            'qImpliedBidQty': res.object.qImpliedBidQty,
            'qImpliedAskPrice': res.object.qImpliedAskPrice,
            'qImpliedAskQty': res.object.qImpliedAskQty,
            'qPreDelta': res.object.qPreDelta,
            'qCurrDelta': res.object.qCurrDelta,
            'qInsideQty': res.object.qInsideQty,
            'qOutsideQty': res.object.qOutsideQty,
            'qTurnoverRate': res.object.qTurnoverRate,
            'q5DAvgQty': res.object.q5DAvgQty,
            'qPERatio': res.object.qPERatio,
            'qTotalValue': res.object.qTotalValue,
            'qNegotiableValue': res.object.qNegotiableValue,
            'qPositionTrend': res.object.qPositionTrend,
            'qChangeSpeed': res.object.qChangeSpeed,
            'qChangeRate': res.object.qChangeRate,
            'qChangeValue': res.object.qChangeValue,
            'qSwing': res.object.qSwing,
            'qTotalBidQty': res.object.qTotalBidQty,
            'qTotalAskQty': res.object.qTotalAskQty,
            'underlyContract': res.object.underlyContract,
            'changeReason': res.object.changeReason
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesQuoteDialog = true;
    },
    doInitData() {
      this.$http({
        url: '/wpfutures/dict/WpfuturesQuoteWhole',
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
      this.wpfuturesQuoteLoading = true;
      this.$http({
        url: '/wpfutures/WpfuturesQuoteWhole/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesQuoteData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesQuoteLoading = false;
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
.wpfuturesQuoteForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
