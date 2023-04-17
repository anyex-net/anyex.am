<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所代码">
        <el-select v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码">
          <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="证券名称">
        <el-input v-model="searchForm.securityName" clearable placeholder="请输入证券名称"></el-input>
      </el-form-item>
      <el-form-item label="市场代码">
        <el-select v-model="searchForm.marketID" clearable placeholder="请输入市场代码">
          <el-option v-for="data in dicts['marketID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="产品代码">
        <el-select v-model="searchForm.productID" clearable placeholder="请输入产品代码">
          <el-option v-for="data in dicts['productID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="证券类别">
        <el-select v-model="searchForm.securityType" clearable placeholder="请输入证券类别">
          <el-option v-for="data in dicts['securityType']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="启用状态" prop="enableStatus">
        <el-select v-model="searchForm.enableStatus" placeholder="请选择启用状态">
          <el-option key="enable" label="是" value="enable" />
          <el-option key="disable" label="否" value="disable" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table
      v-loading="stpNpSpotSecurityLoading"
      :data="stpNpSpotSecurityData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="securityName" label="证券名称" />
      <el-table-column prop="shortSecurityName" label="证券名称(短)" />
      <el-table-column prop="underlyingSecurityID" label="基础证券代码" />
      <el-table-column prop="marketID" label="市场代码" :formatter="statusFormat"/>
      <el-table-column prop="productID" label="产品代码" :formatter="statusFormat"/>
      <el-table-column prop="securityType" label="证券类别" :formatter="statusFormat"/>
      <el-table-column prop="orderUnit" label="申报单位" :formatter="statusFormat"/>
      <el-table-column prop="limitBuyTradingUnit" label="限价买入交易单位" />
      <el-table-column prop="maxLimitOrderBuyVolume" label="限价单买最大下单量" />
      <el-table-column prop="minLimitOrderBuyVolume" label="限价单买最小下单量" />
      <el-table-column prop="limitSellTradingUnit" label="限价卖出交易单位" />
      <el-table-column prop="maxLimitOrderSellVolume" label="限价单卖最大下单量" />
      <el-table-column prop="minLimitOrderSellVolume" label="限价单卖最小下单量" />
      <el-table-column prop="marketBuyTradingUnit" label="市价买入交易单位" />
      <el-table-column prop="maxMarketOrderBuyVolume" label="市价单买最大下单量" />
      <el-table-column prop="minMarketOrderBuyVolume" label="市价单买最小下单量" />
      <el-table-column prop="marketSellTradingUnit" label="市价卖出交易单位" />
      <el-table-column prop="maxMarketOrderSellVolume" label="市价单卖最大下单量" />
      <el-table-column prop="minMarketOrderSellVolume" label="市价单卖最小下单量" />
      <el-table-column prop="fixPriceBuyTradingUnit" label="盘后定价买入交易单位" />
      <el-table-column prop="maxFixPriceOrderBuyVolume" label="盘后定价买最大下单量" />
      <el-table-column prop="minFixPriceOrderBuyVolume" label="盘后定价买最小下单量" />
      <el-table-column prop="fixPriceSellTradingUnit" label="盘后定价卖出交易单位" />
      <el-table-column prop="maxFixPriceOrderSellVolume" label="盘后定价卖最大下单量" />
      <el-table-column prop="minFixPriceOrderSellVolume" label="盘后定价卖最小下单量" />
      <el-table-column prop="volumeMultiple" label="数量乘数" />
      <el-table-column prop="priceTick" label="最小变动价位" />
      <el-table-column prop="openDate" label="上市日" />
      <el-table-column prop="parValue" label="面值" />
<!--      <el-table-column prop="securityStatus" label="证券状态" />-->
      <el-table-column prop="bondInterest" label="债券应计利息" />
      <el-table-column prop="conversionRate" label="折算率" />
      <el-table-column prop="totalEquity" label="总股本" />
      <el-table-column prop="circulationEquity" label="流通股本" />
      <el-table-column prop="bPriceLimit" label="是否限制涨跌停板价" />
      <el-table-column prop="preClosePrice" label="昨收盘价" />
      <el-table-column prop="upperLimitPrice" label="涨停板价" />
      <el-table-column prop="lowerLimitPrice" label="跌停板价" />
      <el-table-column prop="enableStatus" label="是否启用">
        <template scope="scope">
          <div v-if="scope.row.enableStatus == 'enable'">是</div>
          <div v-else-if="scope.row.enableStatus == 'disable'">否</div>
        </template>
      </el-table-column>
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
    <el-dialog title="内盘现货证券信息表管理" :visible.sync="stpNpSpotSecurityDialog" :close-on-click-modal="false" width=70%>
      <el-form
        ref="stpNpSpotSecurityForm"
        :model="stpNpSpotSecurityForm"
        :rules="stpNpSpotSecurityRules"
        label-width="150px"
        class="stpNpSpotSecurityForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="stpNpSpotSecurityForm.tradingDay" placeholder="请输入交易日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-select v-model="stpNpSpotSecurityForm.exchangeID" placeholder="请输入交易所代码">
                <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券代码" prop="securityID">
              <el-input v-model="stpNpSpotSecurityForm.securityID" placeholder="请输入证券代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="证券名称" prop="securityName">
              <el-input v-model="stpNpSpotSecurityForm.securityName" placeholder="请输入证券名称" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券名称(短)" prop="shortSecurityName">
              <el-input v-model="stpNpSpotSecurityForm.shortSecurityName" placeholder="请输入证券名称(短)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="基础证券代码" prop="underlyingSecurityID">
              <el-input v-model="stpNpSpotSecurityForm.underlyingSecurityID" placeholder="请输入基础证券代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="市场代码" prop="marketID">
              <el-select v-model="stpNpSpotSecurityForm.marketID" placeholder="请输入市场代码">
                <el-option v-for="data in dicts['marketID']" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品代码" prop="productID">
              <el-select v-model="stpNpSpotSecurityForm.productID" placeholder="请输入产品代码">
                <el-option v-for="data in dicts['productID']" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券类别" prop="securityType">
              <el-select v-model="stpNpSpotSecurityForm.securityType" placeholder="请输入证券类别">
                <el-option v-for="data in dicts['securityType']" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="申报单位" prop="orderUnit">
              <el-select v-model="stpNpSpotSecurityForm.orderUnit" placeholder="请输入申报单位">
                <el-option v-for="data in dicts['orderUnit']" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价买入交易单位" prop="limitBuyTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.limitBuyTradingUnit" placeholder="请输入限价买入交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价单买最大下单量" prop="maxLimitOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxLimitOrderBuyVolume" placeholder="请输入限价单买最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="限价单买最小下单量" prop="minLimitOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.minLimitOrderBuyVolume" placeholder="请输入限价单买最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价卖出交易单位" prop="limitSellTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.limitSellTradingUnit" placeholder="请输入限价卖出交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价单卖最大下单量" prop="maxLimitOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxLimitOrderSellVolume" placeholder="请输入限价单卖最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="限价单卖最小下单量" prop="minLimitOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.minLimitOrderSellVolume" placeholder="请输入限价单卖最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价买入交易单位" prop="marketBuyTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.marketBuyTradingUnit" placeholder="请输入市价买入交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价单买最大下单量" prop="maxMarketOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxMarketOrderBuyVolume" placeholder="请输入市价单买最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="市价单买最小下单量" prop="minMarketOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.minMarketOrderBuyVolume" placeholder="请输入市价单买最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价卖出交易单位" prop="marketSellTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.marketSellTradingUnit" placeholder="请输入市价卖出交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价单卖最大下单量" prop="maxMarketOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxMarketOrderSellVolume" placeholder="请输入市价单卖最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="市价单卖最小下单量" prop="minMarketOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.minMarketOrderSellVolume" placeholder="请输入市价单卖最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="盘后定价买入交易单位" prop="fixPriceBuyTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.fixPriceBuyTradingUnit" placeholder="请输入盘后定价买入交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="盘后定价买最大下单量" prop="maxFixPriceOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxFixPriceOrderBuyVolume" placeholder="请输入盘后定价买最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="盘后定价买最小下单量" prop="minFixPriceOrderBuyVolume">
              <el-input v-model="stpNpSpotSecurityForm.minFixPriceOrderBuyVolume" placeholder="请输入盘后定价买最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="盘后定价卖出交易单位" prop="fixPriceSellTradingUnit">
              <el-input v-model="stpNpSpotSecurityForm.fixPriceSellTradingUnit" placeholder="请输入盘后定价卖出交易单位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="盘后定价卖最大下单量" prop="maxFixPriceOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.maxFixPriceOrderSellVolume" placeholder="请输入盘后定价卖最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="盘后定价卖最小下单量" prop="minFixPriceOrderSellVolume">
              <el-input v-model="stpNpSpotSecurityForm.minFixPriceOrderSellVolume" placeholder="请输入盘后定价卖最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="数量乘数" prop="volumeMultiple">
              <el-input v-model="stpNpSpotSecurityForm.volumeMultiple" placeholder="请输入数量乘数" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最小变动价位" prop="priceTick">
              <el-input v-model="stpNpSpotSecurityForm.priceTick" placeholder="请输入最小变动价位" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上市日" prop="openDate">
              <el-input v-model="stpNpSpotSecurityForm.openDate" placeholder="请输入上市日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="面值" prop="parValue">
              <el-input v-model="stpNpSpotSecurityForm.parValue" placeholder="请输入面值" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券状态" prop="securityStatus">
              <el-input v-model="stpNpSpotSecurityForm.securityStatus" placeholder="请输入证券状态" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="债券应计利息" prop="bondInterest">
              <el-input v-model="stpNpSpotSecurityForm.bondInterest" placeholder="请输入债券应计利息" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="折算率" prop="conversionRate">
              <el-input v-model="stpNpSpotSecurityForm.conversionRate" placeholder="请输入折算率" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="总股本" prop="totalEquity">
              <el-input v-model="stpNpSpotSecurityForm.totalEquity" placeholder="请输入总股本" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="流通股本" prop="circulationEquity">
              <el-input v-model="stpNpSpotSecurityForm.circulationEquity" placeholder="请输入流通股本" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否限制涨跌停板价" prop="bPriceLimit">
              <el-input v-model="stpNpSpotSecurityForm.bPriceLimit" placeholder="请输入是否限制涨跌停板价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨收盘价" prop="preClosePrice">
              <el-input v-model="stpNpSpotSecurityForm.preClosePrice" placeholder="请输入昨收盘价" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="涨停板价" prop="upperLimitPrice">
              <el-input v-model="stpNpSpotSecurityForm.upperLimitPrice" placeholder="请输入涨停板价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="跌停板价" prop="lowerLimitPrice">
              <el-input v-model="stpNpSpotSecurityForm.lowerLimitPrice" placeholder="请输入跌停板价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否启用" prop="enableStatus">
              <el-select v-model="stpNpSpotSecurityForm.enableStatus" placeholder="是否启用">
                <el-option key="enable" label="启用" value="enable" />
                <el-option key="disable" label="禁用" value="disable" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24" align="center">
            <el-form-item>
              <el-button type="success" @click="doSubmit('stpNpSpotSecurityForm')">提交</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotSecurityName',
  data() {
    return {
      stpNpSpotSecurityLoading: true,
      stpNpSpotSecurityDialog: false,
      stpNpSpotSecurityData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotSecurityForm: {
        'id': '',
        'tradingDay': '',
        'exchangeID': '',
        'securityID': '',
        'securityName': '',
        'shortSecurityName': '',
        'underlyingSecurityID': '',
        'marketID': '',
        'productID': '',
        'securityType': '',
        'orderUnit': '',
        'limitBuyTradingUnit': '',
        'maxLimitOrderBuyVolume': '',
        'minLimitOrderBuyVolume': '',
        'limitSellTradingUnit': '',
        'maxLimitOrderSellVolume': '',
        'minLimitOrderSellVolume': '',
        'marketBuyTradingUnit': '',
        'maxMarketOrderBuyVolume': '',
        'minMarketOrderBuyVolume': '',
        'marketSellTradingUnit': '',
        'maxMarketOrderSellVolume': '',
        'minMarketOrderSellVolume': '',
        'fixPriceBuyTradingUnit': '',
        'maxFixPriceOrderBuyVolume': '',
        'minFixPriceOrderBuyVolume': '',
        'fixPriceSellTradingUnit': '',
        'maxFixPriceOrderSellVolume': '',
        'minFixPriceOrderSellVolume': '',
        'volumeMultiple': '',
        'priceTick': '',
        'openDate': '',
        'parValue': '',
        'securityStatus': '',
        'bondInterest': '',
        'conversionRate': '',
        'totalEquity': '',
        'circulationEquity': '',
        'bPriceLimit': '',
        'preClosePrice': '',
        'upperLimitPrice': '',
        'lowerLimitPrice': '',
        'enableStatus': ''
      },
      searchForm: {
        'exchangeID': '',
        'securityID': '',
        'securityName': '',
        'marketID': '',
        'productID': '',
        'securityType': '',
        'enableStatus': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotSecurityRules: {
        tradingDay: [
          { required: true, message: '交易日不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        securityID: [
          { required: true, message: '证券代码不可为空', trigger: 'change' }
        ],
        securityName: [
          { required: true, message: '证券名称不可为空', trigger: 'change' }
        ],
        shortSecurityName: [
          { required: true, message: '证券名称(短)不可为空', trigger: 'change' }
        ],
        underlyingSecurityID: [
          { required: true, message: '基础证券代码不可为空', trigger: 'change' }
        ],
        marketID: [
          { required: true, message: '市场代码不可为空', trigger: 'change' }
        ],
        productID: [
          { required: true, message: '产品代码不可为空', trigger: 'change' }
        ],
        securityType: [
          { required: true, message: '证券类别不可为空', trigger: 'change' }
        ],
        orderUnit: [
          { required: true, message: '申报单位不可为空', trigger: 'change' }
        ],
        limitBuyTradingUnit: [
          { required: true, message: '限价买入交易单位不可为空', trigger: 'change' }
        ],
        maxLimitOrderBuyVolume: [
          { required: true, message: '限价单买最大下单量不可为空', trigger: 'change' }
        ],
        minLimitOrderBuyVolume: [
          { required: true, message: '限价单买最小下单量不可为空', trigger: 'change' }
        ],
        limitSellTradingUnit: [
          { required: true, message: '限价卖出交易单位不可为空', trigger: 'change' }
        ],
        maxLimitOrderSellVolume: [
          { required: true, message: '限价单卖最大下单量不可为空', trigger: 'change' }
        ],
        minLimitOrderSellVolume: [
          { required: true, message: '限价单卖最小下单量不可为空', trigger: 'change' }
        ],
        marketBuyTradingUnit: [
          { required: true, message: '市价买入交易单位不可为空', trigger: 'change' }
        ],
        maxMarketOrderBuyVolume: [
          { required: true, message: '市价单买最大下单量不可为空', trigger: 'change' }
        ],
        minMarketOrderBuyVolume: [
          { required: true, message: '市价单买最小下单量不可为空', trigger: 'change' }
        ],
        marketSellTradingUnit: [
          { required: true, message: '市价卖出交易单位不可为空', trigger: 'change' }
        ],
        maxMarketOrderSellVolume: [
          { required: true, message: '市价单卖最大下单量不可为空', trigger: 'change' }
        ],
        minMarketOrderSellVolume: [
          { required: true, message: '市价单卖最小下单量不可为空', trigger: 'change' }
        ],
        fixPriceBuyTradingUnit: [
          { required: true, message: '盘后定价买入交易单位不可为空', trigger: 'change' }
        ],
        maxFixPriceOrderBuyVolume: [
          { required: true, message: '盘后定价买最大下单量不可为空', trigger: 'change' }
        ],
        minFixPriceOrderBuyVolume: [
          { required: true, message: '盘后定价买最小下单量不可为空', trigger: 'change' }
        ],
        fixPriceSellTradingUnit: [
          { required: true, message: '盘后定价卖出交易单位不可为空', trigger: 'change' }
        ],
        maxFixPriceOrderSellVolume: [
          { required: true, message: '盘后定价卖最大下单量不可为空', trigger: 'change' }
        ],
        minFixPriceOrderSellVolume: [
          { required: true, message: '盘后定价卖最小下单量不可为空', trigger: 'change' }
        ],
        volumeMultiple: [
          { required: true, message: '数量乘数不可为空', trigger: 'change' }
        ],
        priceTick: [
          { required: true, message: '最小变动价位不可为空', trigger: 'change' }
        ],
        openDate: [
          { required: true, message: '上市日不可为空', trigger: 'change' }
        ],
        parValue: [
          { required: true, message: '面值不可为空', trigger: 'change' }
        ],
        securityStatus: [
          { required: true, message: '证券状态不可为空', trigger: 'change' }
        ],
        bondInterest: [
          { required: true, message: '债券应计利息不可为空', trigger: 'change' }
        ],
        conversionRate: [
          { required: true, message: '折算率不可为空', trigger: 'change' }
        ],
        totalEquity: [
          { required: true, message: '总股本不可为空', trigger: 'change' }
        ],
        circulationEquity: [
          { required: true, message: '流通股本不可为空', trigger: 'change' }
        ],
        bPriceLimit: [
          { required: true, message: '是否限制涨跌停板价不可为空', trigger: 'change' }
        ],
        preClosePrice: [
          { required: true, message: '昨收盘价不可为空', trigger: 'change' }
        ],
        upperLimitPrice: [
          { required: true, message: '涨停板价不可为空', trigger: 'change' }
        ],
        lowerLimitPrice: [
          { required: true, message: '跌停板价不可为空', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '是否启用不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotSecurity',
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
      this.stpNpSpotSecurityLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotSecurity/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotSecurityData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotSecurityLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotSecurityForm = {
        'id': '',
        'tradingDay': '',
        'exchangeID': '',
        'securityID': '',
        'securityName': '',
        'shortSecurityName': '',
        'underlyingSecurityID': '',
        'marketID': '',
        'productID': '',
        'securityType': '',
        'orderUnit': '',
        'limitBuyTradingUnit': '',
        'maxLimitOrderBuyVolume': '',
        'minLimitOrderBuyVolume': '',
        'limitSellTradingUnit': '',
        'maxLimitOrderSellVolume': '',
        'minLimitOrderSellVolume': '',
        'marketBuyTradingUnit': '',
        'maxMarketOrderBuyVolume': '',
        'minMarketOrderBuyVolume': '',
        'marketSellTradingUnit': '',
        'maxMarketOrderSellVolume': '',
        'minMarketOrderSellVolume': '',
        'fixPriceBuyTradingUnit': '',
        'maxFixPriceOrderBuyVolume': '',
        'minFixPriceOrderBuyVolume': '',
        'fixPriceSellTradingUnit': '',
        'maxFixPriceOrderSellVolume': '',
        'minFixPriceOrderSellVolume': '',
        'volumeMultiple': '',
        'priceTick': '',
        'openDate': '',
        'parValue': '',
        'securityStatus': '',
        'bondInterest': '',
        'conversionRate': '',
        'totalEquity': '',
        'circulationEquity': '',
        'bPriceLimit': '',
        'preClosePrice': '',
        'upperLimitPrice': '',
        'lowerLimitPrice': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotSecurityDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotSecurityForm) {
        this.$refs.stpNpSpotSecurityForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotSecurity/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotSecurityForm = {
            'id': res.object.id,
            'tradingDay': res.object.tradingDay,
            'exchangeID': res.object.exchangeID,
            'securityID': res.object.securityID,
            'securityName': res.object.securityName,
            'shortSecurityName': res.object.shortSecurityName,
            'underlyingSecurityID': res.object.underlyingSecurityID,
            'marketID': res.object.marketID,
            'productID': res.object.productID,
            'securityType': res.object.securityType,
            'orderUnit': res.object.orderUnit,
            'limitBuyTradingUnit': res.object.limitBuyTradingUnit,
            'maxLimitOrderBuyVolume': res.object.maxLimitOrderBuyVolume,
            'minLimitOrderBuyVolume': res.object.minLimitOrderBuyVolume,
            'limitSellTradingUnit': res.object.limitSellTradingUnit,
            'maxLimitOrderSellVolume': res.object.maxLimitOrderSellVolume,
            'minLimitOrderSellVolume': res.object.minLimitOrderSellVolume,
            'marketBuyTradingUnit': res.object.marketBuyTradingUnit,
            'maxMarketOrderBuyVolume': res.object.maxMarketOrderBuyVolume,
            'minMarketOrderBuyVolume': res.object.minMarketOrderBuyVolume,
            'marketSellTradingUnit': res.object.marketSellTradingUnit,
            'maxMarketOrderSellVolume': res.object.maxMarketOrderSellVolume,
            'minMarketOrderSellVolume': res.object.minMarketOrderSellVolume,
            'fixPriceBuyTradingUnit': res.object.fixPriceBuyTradingUnit,
            'maxFixPriceOrderBuyVolume': res.object.maxFixPriceOrderBuyVolume,
            'minFixPriceOrderBuyVolume': res.object.minFixPriceOrderBuyVolume,
            'fixPriceSellTradingUnit': res.object.fixPriceSellTradingUnit,
            'maxFixPriceOrderSellVolume': res.object.maxFixPriceOrderSellVolume,
            'minFixPriceOrderSellVolume': res.object.minFixPriceOrderSellVolume,
            'volumeMultiple': res.object.volumeMultiple,
            'priceTick': res.object.priceTick,
            'openDate': res.object.openDate,
            'parValue': res.object.parValue,
            'securityStatus': res.object.securityStatus,
            'bondInterest': res.object.bondInterest,
            'conversionRate': res.object.conversionRate,
            'totalEquity': res.object.totalEquity,
            'circulationEquity': res.object.circulationEquity,
            'bPriceLimit': res.object.bPriceLimit,
            'preClosePrice': res.object.preClosePrice,
            'upperLimitPrice': res.object.upperLimitPrice,
            'lowerLimitPrice': res.object.lowerLimitPrice,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotSecurityDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotSecurity/save',
            method: 'post',
            data: this.stpNpSpotSecurityForm
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
          this.stpNpSpotSecurityDialog = false;
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
          url: '/npspot/stpNpSpotSecurity/del',
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
  .stpNpSpotSecurityForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
