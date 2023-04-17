<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table
      v-loading="subStpNpSpotPositionLoading"
      :data="subStpNpSpotPositionData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
<!--          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>-->
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" width="150"/>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" width="150"/>
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="businessUnitID" label="投资单元代码" />
      <el-table-column prop="marketID" label="市场代码" :formatter="statusFormat"/>
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
    <el-dialog title="子账户持仓汇总表管理" :visible.sync="subStpNpSpotPositionDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="subStpNpSpotPositionForm"
        :model="subStpNpSpotPositionForm"
        :rules="subStpNpSpotPositionRules"
        label-width="150px"
        class="subStpNpSpotPositionForm"
      >
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="subStpNpSpotPositionForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subStpNpSpotPositionForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-select v-model="subStpNpSpotPositionForm.exchangeID" clearable placeholder="请输入交易所代码">
            <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="投资单元代码" prop="businessUnitID">
          <el-input v-model="subStpNpSpotPositionForm.businessUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
        <el-form-item label="市场代码" prop="marketID">
          <el-select v-model="subStpNpSpotPositionForm.marketID" clearable placeholder="请输入市场代码">
            <el-option v-for="data in dicts['marketID']" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="subStpNpSpotPositionForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="subStpNpSpotPositionForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="证券名称" prop="securityName">
          <el-input v-model="subStpNpSpotPositionForm.securityName" placeholder="请输入证券名称" />
        </el-form-item>
        <el-form-item label="昨仓" prop="historyPos">
          <el-input v-model="subStpNpSpotPositionForm.historyPos" placeholder="请输入昨仓" />
        </el-form-item>
        <el-form-item label="昨仓冻结" prop="historyPosFrozen">
          <el-input v-model="subStpNpSpotPositionForm.historyPosFrozen" placeholder="请输入昨仓冻结" />
        </el-form-item>
        <el-form-item label="今买卖仓" prop="todayBSPos">
          <el-input v-model="subStpNpSpotPositionForm.todayBSPos" placeholder="请输入今买卖仓" />
        </el-form-item>
        <el-form-item label="今买卖仓冻结" prop="todayBSPosFrozen">
          <el-input v-model="subStpNpSpotPositionForm.todayBSPosFrozen" placeholder="请输入今买卖仓冻结" />
        </el-form-item>
        <el-form-item label="今日申赎持仓" prop="todayPRPos">
          <el-input v-model="subStpNpSpotPositionForm.todayPRPos" placeholder="请输入今日申赎持仓" />
        </el-form-item>
        <el-form-item label="今日申赎持仓冻结" prop="todayPRPosFrozen">
          <el-input v-model="subStpNpSpotPositionForm.todayPRPosFrozen" placeholder="请输入今日申赎持仓冻结" />
        </el-form-item>
        <el-form-item label="今拆分合并持仓" prop="todaySMPos">
          <el-input v-model="subStpNpSpotPositionForm.todaySMPos" placeholder="请输入今拆分合并持仓" />
        </el-form-item>
        <el-form-item label="今拆分合并持仓冻结" prop="todaySMPosFrozen">
          <el-input v-model="subStpNpSpotPositionForm.todaySMPosFrozen" placeholder="请输入今拆分合并持仓冻结" />
        </el-form-item>
        <el-form-item label="昨仓成本价" prop="historyPosPrice">
          <el-input v-model="subStpNpSpotPositionForm.historyPosPrice" placeholder="请输入昨仓成本价" />
        </el-form-item>
        <el-form-item label="持仓成本" prop="totalPosCost">
          <el-input v-model="subStpNpSpotPositionForm.totalPosCost" placeholder="请输入持仓成本" />
        </el-form-item>
        <el-form-item label="上次余额(盘中不变)" prop="prePosition">
          <el-input v-model="subStpNpSpotPositionForm.prePosition" placeholder="请输入上次余额(盘中不变)" />
        </el-form-item>
        <el-form-item label="股份可用" prop="availablePosition">
          <el-input v-model="subStpNpSpotPositionForm.availablePosition" placeholder="请输入股份可用" />
        </el-form-item>
        <el-form-item label="股份余额" prop="currentPosition">
          <el-input v-model="subStpNpSpotPositionForm.currentPosition" placeholder="请输入股份余额" />
        </el-form-item>
        <el-form-item label="开仓成本" prop="openPosCost">
          <el-input v-model="subStpNpSpotPositionForm.openPosCost" placeholder="请输入开仓成本" />
        </el-form-item>
        <el-form-item label="融资仓位(两融专用)" prop="creditBuyPos">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyPos" placeholder="请输入融资仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="融券仓位(两融专用)" prop="creditSellPos">
          <el-input v-model="subStpNpSpotPositionForm.creditSellPos" placeholder="请输入融券仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="今日融券仓位(两融专用)" prop="todayCreditSellPos">
          <el-input v-model="subStpNpSpotPositionForm.todayCreditSellPos" placeholder="请输入今日融券仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="划出仓位(两融专用)" prop="collateralOutPos">
          <el-input v-model="subStpNpSpotPositionForm.collateralOutPos" placeholder="请输入划出仓位(两融专用)" />
        </el-form-item>
        <el-form-item label="还券未成交数量(两融专用)" prop="repayUntradeVolume">
          <el-input v-model="subStpNpSpotPositionForm.repayUntradeVolume" placeholder="请输入还券未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="直接还券未成交数量(两融专用)" prop="repayTransferUntradeVolume">
          <el-input v-model="subStpNpSpotPositionForm.repayTransferUntradeVolume" placeholder="请输入直接还券未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="担保品买入未成交金额(两融专用)" prop="collateralBuyUntradeAmount">
          <el-input v-model="subStpNpSpotPositionForm.collateralBuyUntradeAmount" placeholder="请输入担保品买入未成交金额(两融专用)" />
        </el-form-item>
        <el-form-item label="担保品买入未成交数量(两融专用)" prop="collateralBuyUntradeVolume">
          <el-input v-model="subStpNpSpotPositionForm.collateralBuyUntradeVolume" placeholder="请输入担保品买入未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入金额(包含交易费用)(两融专用)" prop="creditBuyAmount">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyAmount" placeholder="请输入融资买入金额(包含交易费用)(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入未成交金额(包含交易费用)(两融专用)" prop="creditBuyUntradeAmount">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyUntradeAmount" placeholder="请输入融资买入未成交金额(包含交易费用)(两融专用)" />
        </el-form-item>
        <el-form-item label="融资冻结保证金(两融专用)" prop="creditBuyFrozenMargin">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyFrozenMargin" placeholder="请输入融资冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入利息(两融专用)" prop="creditBuyInterestFee">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyInterestFee" placeholder="请输入融资买入利息(两融专用)" />
        </el-form-item>
        <el-form-item label="融资买入未成交数量(两融专用)" prop="creditBuyUntradeVolume">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyUntradeVolume" placeholder="请输入融资买入未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出金额(以成交价计算)(两融专用)" prop="creditSellAmount">
          <el-input v-model="subStpNpSpotPositionForm.creditSellAmount" placeholder="请输入融券卖出金额(以成交价计算)(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出未成交金额(两融专用)" prop="creditSellUntradeAmount">
          <el-input v-model="subStpNpSpotPositionForm.creditSellUntradeAmount" placeholder="请输入融券卖出未成交金额(两融专用)" />
        </el-form-item>
        <el-form-item label="融券冻结保证金(两融专用)" prop="creditSellFrozenMargin">
          <el-input v-model="subStpNpSpotPositionForm.creditSellFrozenMargin" placeholder="请输入融券冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出息费(两融专用)" prop="creditSellInterestFee">
          <el-input v-model="subStpNpSpotPositionForm.creditSellInterestFee" placeholder="请输入融券卖出息费(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出未成交数量(两融专用)" prop="creditSellUntradeVolume">
          <el-input v-model="subStpNpSpotPositionForm.creditSellUntradeVolume" placeholder="请输入融券卖出未成交数量(两融专用)" />
        </el-form-item>
        <el-form-item label="划入待收仓(两融专用)" prop="collateralInPos">
          <el-input v-model="subStpNpSpotPositionForm.collateralInPos" placeholder="请输入划入待收仓(两融专用)" />
        </el-form-item>
        <el-form-item label="融资流动冻结保证金(两融专用)" prop="creditBuyFrozenCirculateMargin">
          <el-input v-model="subStpNpSpotPositionForm.creditBuyFrozenCirculateMargin" placeholder="请输入融资流动冻结保证金(两融专用)" />
        </el-form-item>
        <el-form-item label="融券流动冻结保证金(两融专用)" prop="creditSellFrozenCirculateMargin">
          <el-input
            v-model="subStpNpSpotPositionForm.creditSellFrozenCirculateMargin"
            placeholder="请输入融券流动冻结保证金(两融专用)"
          />
        </el-form-item>
        <el-form-item label="累计平仓盈亏(两融专用)" prop="closeProfit">
          <el-input v-model="subStpNpSpotPositionForm.closeProfit" placeholder="请输入累计平仓盈亏(两融专用)" />
        </el-form-item>
        <el-form-item label="当日累计开仓数量(两融专用)" prop="todayTotalOpenVolume">
          <el-input v-model="subStpNpSpotPositionForm.todayTotalOpenVolume" placeholder="请输入当日累计开仓数量(两融专用)" />
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('subStpNpSpotPositionForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubStpNpSpotPositionName',
  data() {
    return {
      subStpNpSpotPositionLoading: true,
      subStpNpSpotPositionDialog: false,
      subStpNpSpotPositionData: [],
      commodityTypeSelects: [],
      dicts: [],
      subStpNpSpotPositionForm: {
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'businessUnitID': '',
        'marketID': '',
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
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'marketID': '',
        'securityID': '',
        'securityName': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subStpNpSpotPositionRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        businessUnitID: [
          { required: true, message: '投资单元代码不可为空', trigger: 'change' }
        ],
        marketID: [
          { required: true, message: '市场代码不可为空', trigger: 'change' }
        ],
        tradingDay: [
          { required: true, message: '交易日不可为空', trigger: 'change' }
        ],
        securityID: [
          { required: true, message: '证券代码不可为空', trigger: 'change' }
        ],
        securityName: [
          { required: true, message: '证券名称不可为空', trigger: 'change' }
        ],
        historyPos: [
          { required: true, message: '昨仓不可为空', trigger: 'change' }
        ],
        historyPosFrozen: [
          { required: true, message: '昨仓冻结不可为空', trigger: 'change' }
        ],
        todayBSPos: [
          { required: true, message: '今买卖仓不可为空', trigger: 'change' }
        ],
        todayBSPosFrozen: [
          { required: true, message: '今买卖仓冻结不可为空', trigger: 'change' }
        ],
        todayPRPos: [
          { required: true, message: '今日申赎持仓不可为空', trigger: 'change' }
        ],
        todayPRPosFrozen: [
          { required: true, message: '今日申赎持仓冻结不可为空', trigger: 'change' }
        ],
        todaySMPos: [
          { required: true, message: '今拆分合并持仓不可为空', trigger: 'change' }
        ],
        todaySMPosFrozen: [
          { required: true, message: '今拆分合并持仓冻结不可为空', trigger: 'change' }
        ],
        historyPosPrice: [
          { required: true, message: '昨仓成本价不可为空', trigger: 'change' }
        ],
        totalPosCost: [
          { required: true, message: '持仓成本不可为空', trigger: 'change' }
        ],
        prePosition: [
          { required: true, message: '上次余额(盘中不变)不可为空', trigger: 'change' }
        ],
        availablePosition: [
          { required: true, message: '股份可用不可为空', trigger: 'change' }
        ],
        currentPosition: [
          { required: true, message: '股份余额不可为空', trigger: 'change' }
        ],
        openPosCost: [
          { required: true, message: '开仓成本不可为空', trigger: 'change' }
        ],
        creditBuyPos: [
          { required: true, message: '融资仓位(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellPos: [
          { required: true, message: '融券仓位(两融专用)不可为空', trigger: 'change' }
        ],
        todayCreditSellPos: [
          { required: true, message: '今日融券仓位(两融专用)不可为空', trigger: 'change' }
        ],
        collateralOutPos: [
          { required: true, message: '划出仓位(两融专用)不可为空', trigger: 'change' }
        ],
        repayUntradeVolume: [
          { required: true, message: '还券未成交数量(两融专用)不可为空', trigger: 'change' }
        ],
        repayTransferUntradeVolume: [
          { required: true, message: '直接还券未成交数量(两融专用)不可为空', trigger: 'change' }
        ],
        collateralBuyUntradeAmount: [
          { required: true, message: '担保品买入未成交金额(两融专用)不可为空', trigger: 'change' }
        ],
        collateralBuyUntradeVolume: [
          { required: true, message: '担保品买入未成交数量(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyAmount: [
          { required: true, message: '融资买入金额(包含交易费用)(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyUntradeAmount: [
          { required: true, message: '融资买入未成交金额(包含交易费用)(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyFrozenMargin: [
          { required: true, message: '融资冻结保证金(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyInterestFee: [
          { required: true, message: '融资买入利息(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyUntradeVolume: [
          { required: true, message: '融资买入未成交数量(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellAmount: [
          { required: true, message: '融券卖出金额(以成交价计算)(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellUntradeAmount: [
          { required: true, message: '融券卖出未成交金额(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellFrozenMargin: [
          { required: true, message: '融券冻结保证金(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellInterestFee: [
          { required: true, message: '融券卖出息费(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellUntradeVolume: [
          { required: true, message: '融券卖出未成交数量(两融专用)不可为空', trigger: 'change' }
        ],
        collateralInPos: [
          { required: true, message: '划入待收仓(两融专用)不可为空', trigger: 'change' }
        ],
        creditBuyFrozenCirculateMargin: [
          { required: true, message: '融资流动冻结保证金(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellFrozenCirculateMargin: [
          { required: true, message: '融券流动冻结保证金(两融专用)不可为空', trigger: 'change' }
        ],
        closeProfit: [
          { required: true, message: '累计平仓盈亏(两融专用)不可为空', trigger: 'change' }
        ],
        todayTotalOpenVolume: [
          { required: true, message: '当日累计开仓数量(两融专用)不可为空', trigger: 'change' }
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
      this.subStpNpSpotPositionLoading = true;
      this.$http({
        url: '/npspot/subStpNpSpotPosition/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotPositionData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subStpNpSpotPositionLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subStpNpSpotPositionForm = {
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'businessUnitID': '',
        'marketID': '',
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
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subStpNpSpotPositionDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subStpNpSpotPositionForm) {
        this.$refs.subStpNpSpotPositionForm.resetFields();
      }
      this.$http({
        url: '/npspot/subStpNpSpotPosition/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotPositionForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
            'exchangeID': res.object.exchangeID,
            'businessUnitID': res.object.businessUnitID,
            'marketID': res.object.marketID,
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
      this.subStpNpSpotPositionDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/subStpNpSpotPosition/save',
            method: 'post',
            data: this.subStpNpSpotPositionForm
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
          this.subStpNpSpotPositionDialog = false;
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
          url: '/npspot/subStpNpSpotPosition/del',
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
  .subStpNpSpotPositionForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
