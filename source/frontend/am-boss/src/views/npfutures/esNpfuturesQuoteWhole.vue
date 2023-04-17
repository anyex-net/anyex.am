<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编号">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编号"></el-input>
      </el-form-item>
      <el-form-item label="合约代码1">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约代码1"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesQuoteWholeLoading" :data="esNpfuturesQuoteWholeData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编号"/>
      <el-table-column prop="contractNo" label="合约代码1"/>
      <el-table-column prop="currencyNo" label="币种编号"/>
      <el-table-column prop="tradingState" label="交易状态" :formatter="statusFormat"/>
      <el-table-column prop="dateTimeStamp" label="时间戳"/>
      <el-table-column prop="qPreClosingPrice" label="昨收盘价"/>
      <el-table-column prop="qPreSettlePrice" label="昨结算价"/>
      <el-table-column prop="qPrePositionQty" label="昨持仓量"/>
      <el-table-column prop="qOpeningPrice" label="开盘价"/>
      <el-table-column prop="qLastPrice" label="最新价"/>
      <el-table-column prop="qHighPrice" label="最高价"/>
      <el-table-column prop="qLowPrice" label="最低价"/>
      <el-table-column prop="qHisHighPrice" label="历史最高价"/>
      <el-table-column prop="qHisLowPrice" label="历史最低价"/>
      <el-table-column prop="qLimitUpPrice" label="涨停价"/>
      <el-table-column prop="qLimitDownPrice" label="跌停价"/>
      <el-table-column prop="qTotalQty" label="当日总成交量"/>
      <el-table-column prop="qTotalTurnover" label="当日成交金额"/>
      <el-table-column prop="qPositionQty" label="持仓量"/>
      <el-table-column prop="qAveragePrice" label="均价"/>
      <el-table-column prop="qClosingPrice" label="收盘价"/>
      <el-table-column prop="qSettlePrice" label="结算价"/>
      <el-table-column prop="qLastQty" label="最新成交量"/>
      <el-table-column prop="qBidPrice" label="买价1-20档"/>
      <el-table-column prop="qBidQty" label="买量1-20档"/>
      <el-table-column prop="qAskPrice" label="卖价1-20档"/>
      <el-table-column prop="qAskQty" label="卖量1-20档"/>
      <el-table-column prop="qImpliedBidPrice" label="隐含买价"/>
      <el-table-column prop="qImpliedBidQty" label="隐含买量"/>
      <el-table-column prop="qImpliedAskPrice" label="隐含卖价"/>
      <el-table-column prop="qImpliedAskQty" label="隐含卖量"/>
      <el-table-column prop="qPreDelta" label="昨虚实度"/>
      <el-table-column prop="qCurrDelta" label="今虚实度"/>
      <el-table-column prop="qInsideQty" label="内盘量"/>
      <el-table-column prop="qOutsideQty" label="外盘量"/>
      <el-table-column prop="qTurnoverRate" label="换手率"/>
      <el-table-column prop="q5DAvgQty" label="五日均量"/>
      <el-table-column prop="qPERatio" label="市盈率"/>
      <el-table-column prop="qTotalValue" label="总市值"/>
      <el-table-column prop="qNegotiableValue" label="流通市值"/>
      <el-table-column prop="qPositionTrend" label="持仓走势"/>
      <el-table-column prop="qChangeSpeed" label="涨速"/>
      <el-table-column prop="qChangeRate" label="涨幅"/>
      <el-table-column prop="qChangeValue" label="涨跌值"/>
      <el-table-column prop="qSwing" label="振幅"/>
      <el-table-column prop="qTotalBidQty" label="委买总量"/>
      <el-table-column prop="qTotalAskQty" label="委卖总量"/>
      <el-table-column prop="underlyContract" label="虚拟合约对应的真实合约(对象)"/>
      <el-table-column prop="changeReason" label="行情变动原因"/>
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
    <el-dialog title="内盘期货行情表管理" :visible.sync="esNpfuturesQuoteWholeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="esNpfuturesQuoteWholeForm" :model="esNpfuturesQuoteWholeForm" :rules="esNpfuturesQuoteWholeRules"
               label-width="150px" class="esNpfuturesQuoteWholeForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所编码" prop="exchangeNo">
              <el-input v-model="esNpfuturesQuoteWholeForm.exchangeNo" placeholder="请输入交易所编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-input v-model="esNpfuturesQuoteWholeForm.commodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种编号" prop="commodityNo">
              <el-input v-model="esNpfuturesQuoteWholeForm.commodityNo" placeholder="请输入品种编号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约代码1" prop="contractNo">
              <el-input v-model="esNpfuturesQuoteWholeForm.contractNo" placeholder="请输入合约代码1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种编号" prop="currencyNo">
              <el-input v-model="esNpfuturesQuoteWholeForm.currencyNo" placeholder="请输入币种编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易状态" prop="tradingState">
              <el-input v-model="esNpfuturesQuoteWholeForm.tradingState"
                        placeholder="请输入交易状态"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="时间戳" prop="dateTimeStamp">
              <el-input v-model="esNpfuturesQuoteWholeForm.dateTimeStamp" placeholder="请输入时间戳"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨收盘价" prop="qPreClosingPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPreClosingPrice" placeholder="请输入昨收盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨结算价" prop="qPreSettlePrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPreSettlePrice" placeholder="请输入昨结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="昨持仓量" prop="qPrePositionQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPrePositionQty" placeholder="请输入昨持仓量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开盘价" prop="qOpeningPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qOpeningPrice" placeholder="请输入开盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新价" prop="qLastPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qLastPrice" placeholder="请输入最新价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最高价" prop="qHighPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qHighPrice" placeholder="请输入最高价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最低价" prop="qLowPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qLowPrice" placeholder="请输入最低价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="历史最高价" prop="qHisHighPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qHisHighPrice" placeholder="请输入历史最高价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="历史最低价" prop="qHisLowPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qHisLowPrice" placeholder="请输入历史最低价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="涨停价" prop="qLimitUpPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qLimitUpPrice" placeholder="请输入涨停价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="跌停价" prop="qLimitDownPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qLimitDownPrice" placeholder="请输入跌停价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="当日总成交量" prop="qTotalQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTotalQty" placeholder="请输入当日总成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当日成交金额" prop="qTotalTurnover">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTotalTurnover" placeholder="请输入当日成交金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓量" prop="qPositionQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPositionQty" placeholder="请输入持仓量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="均价" prop="qAveragePrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qAveragePrice" placeholder="请输入均价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收盘价" prop="qClosingPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qClosingPrice" placeholder="请输入收盘价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="结算价" prop="qSettlePrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qSettlePrice" placeholder="请输入结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最新成交量" prop="qLastQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qLastQty" placeholder="请输入最新成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买价1-20档" prop="qBidPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qBidPrice" placeholder="请输入买价1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买量1-20档" prop="qBidQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qBidQty" placeholder="请输入买量1-20档"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="卖价1-20档" prop="qAskPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qAskPrice" placeholder="请输入卖价1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="卖量1-20档" prop="qAskQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qAskQty" placeholder="请输入卖量1-20档"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="隐含买价" prop="qImpliedBidPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qImpliedBidPrice" placeholder="请输入隐含买价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="隐含买量" prop="qImpliedBidQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qImpliedBidQty" placeholder="请输入隐含买量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="隐含卖价" prop="qImpliedAskPrice">
              <el-input v-model="esNpfuturesQuoteWholeForm.qImpliedAskPrice" placeholder="请输入隐含卖价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="隐含卖量" prop="qImpliedAskQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qImpliedAskQty" placeholder="请输入隐含卖量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="昨虚实度" prop="qPreDelta">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPreDelta" placeholder="请输入昨虚实度"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="今虚实度" prop="qCurrDelta">
              <el-input v-model="esNpfuturesQuoteWholeForm.qCurrDelta" placeholder="请输入今虚实度"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="内盘量" prop="qInsideQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qInsideQty" placeholder="请输入内盘量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="外盘量" prop="qOutsideQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qOutsideQty" placeholder="请输入外盘量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="换手率" prop="qTurnoverRate">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTurnoverRate" placeholder="请输入换手率"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="五日均量" prop="q5DAvgQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.q5DAvgQty" placeholder="请输入五日均量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="市盈率" prop="qPERatio">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPERatio" placeholder="请输入市盈率"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总市值" prop="qTotalValue">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTotalValue" placeholder="请输入总市值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="流通市值" prop="qNegotiableValue">
              <el-input v-model="esNpfuturesQuoteWholeForm.qNegotiableValue" placeholder="请输入流通市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓走势" prop="qPositionTrend">
              <el-input v-model="esNpfuturesQuoteWholeForm.qPositionTrend" placeholder="请输入持仓走势"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="涨速" prop="qChangeSpeed">
              <el-input v-model="esNpfuturesQuoteWholeForm.qChangeSpeed" placeholder="请输入涨速"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="涨幅" prop="qChangeRate">
              <el-input v-model="esNpfuturesQuoteWholeForm.qChangeRate" placeholder="请输入涨幅"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="涨跌值" prop="qChangeValue">
              <el-input v-model="esNpfuturesQuoteWholeForm.qChangeValue" placeholder="请输入涨跌值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="振幅" prop="qSwing">
              <el-input v-model="esNpfuturesQuoteWholeForm.qSwing" placeholder="请输入振幅"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委买总量" prop="qTotalBidQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTotalBidQty" placeholder="请输入委买总量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委卖总量" prop="qTotalAskQty">
              <el-input v-model="esNpfuturesQuoteWholeForm.qTotalAskQty" placeholder="请输入委卖总量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="虚拟合约对应的真实合约(对象)" prop="underlyContract">
              <el-input v-model="esNpfuturesQuoteWholeForm.underlyContract" placeholder="请输入虚拟合约对应的真实合约(对象)"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="行情变动原因(委托盘口entrust、撮和成交trade)" prop="changeReason">
              <el-input v-model="esNpfuturesQuoteWholeForm.changeReason" placeholder="请输入行情变动原因"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesQuoteWholeName',
    data() {
      return {
        esNpfuturesQuoteWholeLoading: true,
        esNpfuturesQuoteWholeDialog: false,
        esNpfuturesQuoteWholeData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesQuoteWholeForm: {
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
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesQuoteWholeRules: {
          exchangeNo: [
            { required: true, message: '交易所编码不可为空', trigger: 'change' }
          ],
          commodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编号不可为空', trigger: 'change' }
          ],
          contractNo: [
            { required: true, message: '合约代码1不可为空', trigger: 'change' }
          ],
          currencyNo: [
            { required: true, message: '币种编号不可为空', trigger: 'change' }
          ],
          tradingState: [
            { required: true, message: '交易状态1,集合竞价2,集合竞价撮合3,连续交易4,交易暂停5,闭市不可为空', trigger: 'change' }
          ],
          dateTimeStamp: [
            { required: true, message: '时间戳不可为空', trigger: 'change' }
          ],
          qPreClosingPrice: [
            { required: true, message: '昨收盘价不可为空', trigger: 'change' }
          ],
          qPreSettlePrice: [
            { required: true, message: '昨结算价不可为空', trigger: 'change' }
          ],
          qPrePositionQty: [
            { required: true, message: '昨持仓量不可为空', trigger: 'change' }
          ],
          qOpeningPrice: [
            { required: true, message: '开盘价不可为空', trigger: 'change' }
          ],
          qLastPrice: [
            { required: true, message: '最新价不可为空', trigger: 'change' }
          ],
          qHighPrice: [
            { required: true, message: '最高价不可为空', trigger: 'change' }
          ],
          qLowPrice: [
            { required: true, message: '最低价不可为空', trigger: 'change' }
          ],
          qHisHighPrice: [
            { required: true, message: '历史最高价不可为空', trigger: 'change' }
          ],
          qHisLowPrice: [
            { required: true, message: '历史最低价不可为空', trigger: 'change' }
          ],
          qLimitUpPrice: [
            { required: true, message: '涨停价不可为空', trigger: 'change' }
          ],
          qLimitDownPrice: [
            { required: true, message: '跌停价不可为空', trigger: 'change' }
          ],
          qTotalQty: [
            { required: true, message: '当日总成交量不可为空', trigger: 'change' }
          ],
          qTotalTurnover: [
            { required: true, message: '当日成交金额不可为空', trigger: 'change' }
          ],
          qPositionQty: [
            { required: true, message: '持仓量不可为空', trigger: 'change' }
          ],
          qAveragePrice: [
            { required: true, message: '均价不可为空', trigger: 'change' }
          ],
          qClosingPrice: [
            { required: true, message: '收盘价不可为空', trigger: 'change' }
          ],
          qSettlePrice: [
            { required: true, message: '结算价不可为空', trigger: 'change' }
          ],
          qLastQty: [
            { required: true, message: '最新成交量不可为空', trigger: 'change' }
          ],
          qBidPrice: [
            { required: true, message: '买价1-20档不可为空', trigger: 'change' }
          ],
          qBidQty: [
            { required: true, message: '买量1-20档不可为空', trigger: 'change' }
          ],
          qAskPrice: [
            { required: true, message: '卖价1-20档不可为空', trigger: 'change' }
          ],
          qAskQty: [
            { required: true, message: '卖量1-20档不可为空', trigger: 'change' }
          ],
          qImpliedBidPrice: [
            { required: true, message: '隐含买价不可为空', trigger: 'change' }
          ],
          qImpliedBidQty: [
            { required: true, message: '隐含买量不可为空', trigger: 'change' }
          ],
          qImpliedAskPrice: [
            { required: true, message: '隐含卖价不可为空', trigger: 'change' }
          ],
          qImpliedAskQty: [
            { required: true, message: '隐含卖量不可为空', trigger: 'change' }
          ],
          qPreDelta: [
            { required: true, message: '昨虚实度不可为空', trigger: 'change' }
          ],
          qCurrDelta: [
            { required: true, message: '今虚实度不可为空', trigger: 'change' }
          ],
          qInsideQty: [
            { required: true, message: '内盘量不可为空', trigger: 'change' }
          ],
          qOutsideQty: [
            { required: true, message: '外盘量不可为空', trigger: 'change' }
          ],
          qTurnoverRate: [
            { required: true, message: '换手率不可为空', trigger: 'change' }
          ],
          q5DAvgQty: [
            { required: true, message: '五日均量不可为空', trigger: 'change' }
          ],
          qPERatio: [
            { required: true, message: '市盈率不可为空', trigger: 'change' }
          ],
          qTotalValue: [
            { required: true, message: '总市值不可为空', trigger: 'change' }
          ],
          qNegotiableValue: [
            { required: true, message: '流通市值不可为空', trigger: 'change' }
          ],
          qPositionTrend: [
            { required: true, message: '持仓走势不可为空', trigger: 'change' }
          ],
          qChangeSpeed: [
            { required: true, message: '涨速不可为空', trigger: 'change' }
          ],
          qChangeRate: [
            { required: true, message: '涨幅不可为空', trigger: 'change' }
          ],
          qChangeValue: [
            { required: true, message: '涨跌值不可为空', trigger: 'change' }
          ],
          qSwing: [
            { required: true, message: '振幅不可为空', trigger: 'change' }
          ],
          qTotalBidQty: [
            { required: true, message: '委买总量不可为空', trigger: 'change' }
          ],
          qTotalAskQty: [
            { required: true, message: '委卖总量不可为空', trigger: 'change' }
          ],
          changeReason: [
            { required: true, message: '行情变动原因(委托盘口entrust、撮和成交trade)不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesQuoteWhole',
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
        this.esNpfuturesQuoteWholeLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesQuoteWhole/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesQuoteWholeData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesQuoteWholeLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesQuoteWholeForm = {
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
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesQuoteWholeDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesQuoteWholeForm) {
          this.$refs.esNpfuturesQuoteWholeForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesQuoteWhole/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesQuoteWholeForm = {
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
        this.esNpfuturesQuoteWholeDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesQuoteWhole/save',
              method: 'post',
              data: this.esNpfuturesQuoteWholeForm
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
            this.esNpfuturesQuoteWholeDialog = false;
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
            url: '/npfutures/esNpfuturesQuoteWhole/del',
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
  .esNpfuturesQuoteWholeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
