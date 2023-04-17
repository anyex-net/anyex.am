<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-select v-model="searchForm.brokerNo" clearable placeholder="请选择经纪商编码" value="">
          <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="客户资金帐号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金帐号"></el-input>
      </el-form-item>
      <el-form-item label="上级资金账号">
        <el-input v-model="searchForm.parentAccountNo" clearable placeholder="请输入上级资金账号"></el-input>
      </el-form-item>
      <el-form-item label="交易所编号">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编号"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码类型">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码类型"></el-input>
      </el-form-item>
      <el-form-item label="合约">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesCloseInfoLoading" :data="esNpfuturesCloseInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="客户资金帐号"/>
      <el-table-column prop="parentAccountNo" label="上级资金账号"/>
      <el-table-column prop="exchangeNo" label="交易所编号" :formatter="statusFormat"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编码类型"/>
      <el-table-column prop="contractNo" label="合约"/>
      <el-table-column prop="strikePrice" label="执行价格"/>
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat"/>
      <el-table-column prop="openOrderExchangeNo" label="交易所编号"/>
      <el-table-column prop="openOrderCommodityType" label="品种类型"/>
      <el-table-column prop="openOrderCommodityNo" label="品种编码类型"/>
      <el-table-column prop="closeOrderExchangeNo" label="交易所编号"/>
      <el-table-column prop="closeOrderCommodityType" label="品种类型"/>
      <el-table-column prop="closeOrderCommodityNo" label="品种编码类型"/>
      <el-table-column prop="openMatchSource" label="OpenMatchSource"/>
      <el-table-column prop="closeMatchSource" label="CloseMatchSource"/>
      <el-table-column prop="closeSide" label="平仓一边的买入卖出"/>
      <el-table-column prop="closeQty" label="平仓成交量"/>
      <el-table-column prop="openPrice" label="开仓成交价"/>
      <el-table-column prop="closePrice" label="平仓成交价"/>
      <el-table-column prop="openServerFlag" label="服务器标识"/>
      <el-table-column prop="openOrderNo" label="委托编码"/>
      <el-table-column prop="openMatchNo" label="本地成交号"/>
      <el-table-column prop="openExchangeMatchNo" label="交易所成交号"/>
      <el-table-column prop="openMatchDateTime" label="成交时间"/>
      <el-table-column prop="closeServerFlag" label="服务器标识"/>
      <el-table-column prop="closeOrderNo" label="委托编码"/>
      <el-table-column prop="closeMatchNo" label="本地成交号"/>
      <el-table-column prop="closeExchangeMatchNo" label="交易所成交号"/>
      <el-table-column prop="closeMatchDateTime" label="成交时间"/>
      <el-table-column prop="closeStreamId" label="平仓流号"/>
      <el-table-column prop="openCloseMode" label="开平方式" :formatter="statusFormat"/>
      <el-table-column prop="contractSize" label="每手乘数，计算参数"/>
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组"/>
      <el-table-column prop="commodityCurrency" label="品种币种"/>
      <el-table-column prop="preSettlePrice" label="昨结算价"/>
      <el-table-column prop="premiumIncome" label="权利金收取"/>
      <el-table-column prop="premiumPay" label="权利金支付"/>
      <el-table-column prop="closeProfit" label="平仓盈亏"/>
      <el-table-column prop="unExpProfit" label="未到期平盈"/>
      <el-table-column prop="closePL" label="逐笔平盈"/>
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
    <el-dialog title="内盘期货平仓记录表管理" :visible.sync="esNpfuturesCloseInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="esNpfuturesCloseInfoForm" :model="esNpfuturesCloseInfoForm" :rules="esNpfuturesCloseInfoRules"
               label-width="150px" class="esNpfuturesCloseInfoForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="esNpfuturesCloseInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="esNpfuturesCloseInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="esNpfuturesCloseInfoForm.accountNo" placeholder="请输入客户资金帐号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上级资金账号" prop="parentAccountNo">
              <el-input v-model="esNpfuturesCloseInfoForm.parentAccountNo" placeholder="请输入上级资金账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="esNpfuturesCloseInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-input v-model="esNpfuturesCloseInfoForm.commodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="esNpfuturesCloseInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约" prop="contractNo">
              <el-input v-model="esNpfuturesCloseInfoForm.contractNo" placeholder="请输入合约"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="esNpfuturesCloseInfoForm.strikePrice" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-input v-model="esNpfuturesCloseInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="openOrderExchangeNo">
              <el-input v-model="esNpfuturesCloseInfoForm.openOrderExchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="openOrderCommodityType">
              <el-input v-model="esNpfuturesCloseInfoForm.openOrderCommodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="openOrderCommodityNo">
              <el-input v-model="esNpfuturesCloseInfoForm.openOrderCommodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="closeOrderExchangeNo">
              <el-input v-model="esNpfuturesCloseInfoForm.closeOrderExchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="closeOrderCommodityType">
              <el-input v-model="esNpfuturesCloseInfoForm.closeOrderCommodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="closeOrderCommodityNo">
              <el-input v-model="esNpfuturesCloseInfoForm.closeOrderCommodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="OpenMatchSource" prop="openMatchSource">
              <el-input v-model="esNpfuturesCloseInfoForm.openMatchSource" placeholder="请输入OpenMatchSource"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="CloseMatchSource" prop="closeMatchSource">
              <el-input v-model="esNpfuturesCloseInfoForm.closeMatchSource" placeholder="请输入CloseMatchSource"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="平仓一边的买入卖出" prop="closeSide">
            <el-input v-model="esNpfuturesCloseInfoForm.closeSide" placeholder="请输入平仓一边的买入卖出"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓成交量" prop="closeQty">
              <el-input v-model="esNpfuturesCloseInfoForm.closeQty" placeholder="请输入平仓成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"></el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓成交价" prop="openPrice">
              <el-input v-model="esNpfuturesCloseInfoForm.openPrice" placeholder="请输入开仓成交价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓成交价" prop="closePrice">
              <el-input v-model="esNpfuturesCloseInfoForm.closePrice" placeholder="请输入平仓成交价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"><el-form-item label="服务器标识" prop="openServerFlag">
            <el-input v-model="esNpfuturesCloseInfoForm.openServerFlag" placeholder="请输入服务器标识"/>
          </el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="openOrderNo">
              <el-input v-model="esNpfuturesCloseInfoForm.openOrderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地成交号" prop="openMatchNo">
              <el-input v-model="esNpfuturesCloseInfoForm.openMatchNo" placeholder="请输入本地成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所成交号" prop="openExchangeMatchNo">
              <el-input v-model="esNpfuturesCloseInfoForm.openExchangeMatchNo" placeholder="请输入交易所成交号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交时间" prop="openMatchDateTime">
              <el-input v-model="esNpfuturesCloseInfoForm.openMatchDateTime" placeholder="请输入成交时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="closeServerFlag">
              <el-input v-model="esNpfuturesCloseInfoForm.closeServerFlag" placeholder="请输入服务器标识"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="closeOrderNo">
              <el-input v-model="esNpfuturesCloseInfoForm.closeOrderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="本地成交号" prop="closeMatchNo">
              <el-input v-model="esNpfuturesCloseInfoForm.closeMatchNo" placeholder="请输入本地成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所成交号" prop="closeExchangeMatchNo">
              <el-input v-model="esNpfuturesCloseInfoForm.closeExchangeMatchNo" placeholder="请输入交易所成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交时间" prop="closeMatchDateTime">
              <el-input v-model="esNpfuturesCloseInfoForm.closeMatchDateTime" placeholder="请输入成交时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="平仓流号" prop="closeStreamId">
              <el-input v-model="esNpfuturesCloseInfoForm.closeStreamId" placeholder="请输入平仓流号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"><el-form-item label="开平方式" prop="openCloseMode">
            <el-input v-model="esNpfuturesCloseInfoForm.openCloseMode" placeholder="请输入开平方式"/>
          </el-form-item></el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数，计算参数" prop="contractSize">
              <el-input v-model="esNpfuturesCloseInfoForm.contractSize" placeholder="请输入每手乘数，计算参数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="esNpfuturesCloseInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="esNpfuturesCloseInfoForm.commodityCurrency" placeholder="请输入品种币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨结算价" prop="preSettlePrice">
              <el-input v-model="esNpfuturesCloseInfoForm.preSettlePrice" placeholder="请输入昨结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="权利金收取" prop="premiumIncome">
              <el-input v-model="esNpfuturesCloseInfoForm.premiumIncome" placeholder="请输入权利金收取"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="权利金支付" prop="premiumPay">
              <el-input v-model="esNpfuturesCloseInfoForm.premiumPay" placeholder="请输入权利金支付"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="esNpfuturesCloseInfoForm.closeProfit" placeholder="请输入平仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="未到期平盈" prop="unExpProfit">
              <el-input v-model="esNpfuturesCloseInfoForm.unExpProfit" placeholder="请输入未到期平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"> <el-form-item label="逐笔平盈" prop="closePL">
            <el-input v-model="esNpfuturesCloseInfoForm.closePL" placeholder="请输入逐笔平盈"/>
          </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesCloseInfoName',
    data() {
      return {
        esNpfuturesCloseInfoLoading: true,
        esNpfuturesCloseInfoDialog: false,
        esNpfuturesCloseInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesCloseInfoForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'parentAccountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'openOrderExchangeNo': '',
          'openOrderCommodityType': '',
          'openOrderCommodityNo': '',
          'closeOrderExchangeNo': '',
          'closeOrderCommodityType': '',
          'closeOrderCommodityNo': '',
          'openMatchSource': '',
          'closeMatchSource': '',
          'closeSide': '',
          'closeQty': '',
          'openPrice': '',
          'closePrice': '',
          'openServerFlag': '',
          'openOrderNo': '',
          'openMatchNo': '',
          'openExchangeMatchNo': '',
          'openMatchDateTime': '',
          'closeServerFlag': '',
          'closeOrderNo': '',
          'closeMatchNo': '',
          'closeExchangeMatchNo': '',
          'closeMatchDateTime': '',
          'closeStreamId': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'preSettlePrice': '',
          'premiumIncome': '',
          'premiumPay': '',
          'closeProfit': '',
          'unExpProfit': '',
          'closePL': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'parentAccountNo': '',
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
        esNpfuturesCloseInfoRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '客户资金帐号不可为空', trigger: 'change' }
          ],
          parentAccountNo: [
            { required: true, message: '上级资金账号不可为空', trigger: 'change' }
          ],
          exchangeNo: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          commodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          contractNo: [
            { required: true, message: '合约不可为空', trigger: 'change' }
          ],
          strikePrice: [
            { required: true, message: '执行价格不可为空', trigger: 'change' }
          ],
          callOrPutFlag: [
            { required: true, message: '看张看跌不可为空', trigger: 'change' }
          ],
          openOrderExchangeNo: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          openOrderCommodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          openOrderCommodityNo: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          closeOrderExchangeNo: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          closeOrderCommodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          closeOrderCommodityNo: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          openMatchSource: [
            { required: true, message: 'OpenMatchSource不可为空', trigger: 'change' }
          ],
          closeMatchSource: [
            { required: true, message: 'CloseMatchSource不可为空', trigger: 'change' }
          ],
          closeSide: [
            { required: true, message: '平仓一边的买入卖出不可为空', trigger: 'change' }
          ],
          closeQty: [
            { required: true, message: '平仓成交量不可为空', trigger: 'change' }
          ],
          openPrice: [
            { required: true, message: '开仓成交价不可为空', trigger: 'change' }
          ],
          closePrice: [
            { required: true, message: '平仓成交价不可为空', trigger: 'change' }
          ],
          openServerFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          openOrderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          openMatchNo: [
            { required: true, message: '本地成交号不可为空', trigger: 'change' }
          ],
          openExchangeMatchNo: [
            { required: true, message: '交易所成交号不可为空', trigger: 'change' }
          ],
          openMatchDateTime: [
            { required: true, message: '成交时间不可为空', trigger: 'change' }
          ],
          closeServerFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          closeOrderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          closeMatchNo: [
            { required: true, message: '本地成交号不可为空', trigger: 'change' }
          ],
          closeExchangeMatchNo: [
            { required: true, message: '交易所成交号不可为空', trigger: 'change' }
          ],
          closeMatchDateTime: [
            { required: true, message: '成交时间不可为空', trigger: 'change' }
          ],
          closeStreamId: [
            { required: true, message: '平仓流号不可为空', trigger: 'change' }
          ],
          openCloseMode: [
            { required: true, message: '开平方式不可为空', trigger: 'change' }
          ],
          contractSize: [
            { required: true, message: '每手乘数，计算参数不可为空', trigger: 'change' }
          ],
          commodityCurrencyGroup: [
            { required: true, message: '品种币种组不可为空', trigger: 'change' }
          ],
          commodityCurrency: [
            { required: true, message: '品种币种不可为空', trigger: 'change' }
          ],
          preSettlePrice: [
            { required: true, message: '昨结算价不可为空', trigger: 'change' }
          ],
          premiumIncome: [
            { required: true, message: '权利金收取不可为空', trigger: 'change' }
          ],
          premiumPay: [
            { required: true, message: '权利金支付不可为空', trigger: 'change' }
          ],
          closeProfit: [
            { required: true, message: '平仓盈亏不可为空', trigger: 'change' }
          ],
          unExpProfit: [
            { required: true, message: '未到期平盈不可为空', trigger: 'change' }
          ],
          closePL: [
            { required: true, message: '逐笔平盈不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesCloseInfo',
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
        this.esNpfuturesCloseInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesCloseInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesCloseInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesCloseInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesCloseInfoForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'parentAccountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'openOrderExchangeNo': '',
          'openOrderCommodityType': '',
          'openOrderCommodityNo': '',
          'closeOrderExchangeNo': '',
          'closeOrderCommodityType': '',
          'closeOrderCommodityNo': '',
          'openMatchSource': '',
          'closeMatchSource': '',
          'closeSide': '',
          'closeQty': '',
          'openPrice': '',
          'closePrice': '',
          'openServerFlag': '',
          'openOrderNo': '',
          'openMatchNo': '',
          'openExchangeMatchNo': '',
          'openMatchDateTime': '',
          'closeServerFlag': '',
          'closeOrderNo': '',
          'closeMatchNo': '',
          'closeExchangeMatchNo': '',
          'closeMatchDateTime': '',
          'closeStreamId': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'preSettlePrice': '',
          'premiumIncome': '',
          'premiumPay': '',
          'closeProfit': '',
          'unExpProfit': '',
          'closePL': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesCloseInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesCloseInfoForm) {
          this.$refs.esNpfuturesCloseInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesCloseInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesCloseInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'parentAccountNo': res.object.parentAccountNo,
              'exchangeNo': res.object.exchangeNo,
              'commodityType': res.object.commodityType,
              'commodityNo': res.object.commodityNo,
              'contractNo': res.object.contractNo,
              'strikePrice': res.object.strikePrice,
              'callOrPutFlag': res.object.callOrPutFlag,
              'openOrderExchangeNo': res.object.openOrderExchangeNo,
              'openOrderCommodityType': res.object.openOrderCommodityType,
              'openOrderCommodityNo': res.object.openOrderCommodityNo,
              'closeOrderExchangeNo': res.object.closeOrderExchangeNo,
              'closeOrderCommodityType': res.object.closeOrderCommodityType,
              'closeOrderCommodityNo': res.object.closeOrderCommodityNo,
              'openMatchSource': res.object.openMatchSource,
              'closeMatchSource': res.object.closeMatchSource,
              'closeSide': res.object.closeSide,
              'closeQty': res.object.closeQty,
              'openPrice': res.object.openPrice,
              'closePrice': res.object.closePrice,
              'openServerFlag': res.object.openServerFlag,
              'openOrderNo': res.object.openOrderNo,
              'openMatchNo': res.object.openMatchNo,
              'openExchangeMatchNo': res.object.openExchangeMatchNo,
              'openMatchDateTime': res.object.openMatchDateTime,
              'closeServerFlag': res.object.closeServerFlag,
              'closeOrderNo': res.object.closeOrderNo,
              'closeMatchNo': res.object.closeMatchNo,
              'closeExchangeMatchNo': res.object.closeExchangeMatchNo,
              'closeMatchDateTime': res.object.closeMatchDateTime,
              'closeStreamId': res.object.closeStreamId,
              'openCloseMode': res.object.openCloseMode,
              'contractSize': res.object.contractSize,
              'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
              'commodityCurrency': res.object.commodityCurrency,
              'preSettlePrice': res.object.preSettlePrice,
              'premiumIncome': res.object.premiumIncome,
              'premiumPay': res.object.premiumPay,
              'closeProfit': res.object.closeProfit,
              'unExpProfit': res.object.unExpProfit,
              'closePL': res.object.closePL
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesCloseInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesCloseInfo/save',
              method: 'post',
              data: this.esNpfuturesCloseInfoForm
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
            this.esNpfuturesCloseInfoDialog = false;
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
            url: '/npfutures/esNpfuturesCloseInfo/del',
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
  .esNpfuturesCloseInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
