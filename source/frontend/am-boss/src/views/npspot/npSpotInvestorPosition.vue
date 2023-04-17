<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item label="持仓多空方向">
        <el-select v-model="searchForm.posiDirection" clearable placeholder="请输入持仓多空方向">
          <el-option v-for="data in posiDirection" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="npSpotInvestorPositionLoading"
      :data="npSpotInvestorPositionData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="instrumentID" label="证券代码" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="posiDirection" label="持仓多空方向" :formatter="statusFormat" />
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat" />
      <el-table-column prop="positionDate" label="持仓日期" :formatter="statusFormat" />
      <el-table-column prop="ydPosition" label="上日持仓" />
      <el-table-column prop="position" label="今日持仓" />
      <el-table-column prop="longFrozen" label="多头冻结" />
      <el-table-column prop="shortFrozen" label="空头冻结" />
      <el-table-column prop="longFrozenAmount" label="开仓冻结金额" />
      <el-table-column prop="shortFrozenAmount" label="开仓冻结金额" />
      <el-table-column prop="openVolume" label="开仓量" />
      <el-table-column prop="closeVolume" label="平仓量" />
      <el-table-column prop="openAmount" label="开仓金额" />
      <el-table-column prop="closeAmount" label="平仓金额" />
      <el-table-column prop="positionCost" label="持仓成本" />
      <el-table-column prop="preMargin" label="上次占用的保证金" />
      <el-table-column prop="useMargin" label="占用的保证金" />
      <el-table-column prop="frozenMargin" label="冻结的保证金" />
      <el-table-column prop="frozenCash" label="冻结的资金" />
      <el-table-column prop="frozenCommission" label="冻结的手续费" />
      <el-table-column prop="cashIn" label="资金差额" />
      <el-table-column prop="commission" label="手续费" />
      <el-table-column prop="closeProfit" label="平仓盈亏" />
      <el-table-column prop="positionProfit" label="持仓盈亏" />
      <el-table-column prop="preSettlementPrice" label="上次结算价" />
      <el-table-column prop="settlementPrice" label="本次结算价" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="settlementID" label="结算编号" />
      <el-table-column prop="openCost" label="开仓成本" />
      <el-table-column prop="exchangeMargin" label="交易所保证金" />
      <el-table-column prop="combPosition" label="组合成交形成的持仓" />
      <el-table-column prop="combLongFrozen" label="组合多头冻结" />
      <el-table-column prop="combShortFrozen" label="组合空头冻结" />
      <el-table-column prop="closeProfitByDate" label="逐日盯市平仓盈亏" />
      <el-table-column prop="closeProfitByTrade" label="逐笔对冲平仓盈亏" />
      <el-table-column prop="todayPosition" label="今日持仓" />
      <el-table-column prop="marginRateByMoney" label="保证金率" />
      <el-table-column prop="marginRateByVolume" label="保证金率(按手数)" />
      <el-table-column prop="strikeFrozen" label="执行冻结" />
      <el-table-column prop="strikeFrozenAmount" label="执行冻结金额" />
      <el-table-column prop="abandonFrozen" label="放弃执行冻结" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="ydStrikeFrozen" label="执行冻结的昨仓" />
      <el-table-column prop="investUnitID" label="投资单元代码" />
      <el-table-column prop="positionCostOffset" label="大商所持仓成本差值，只有大商所使用" />
      <el-table-column prop="tasPosition" label="tas持仓手数" />
      <el-table-column prop="tasPositionCost" label="tas持仓成本" />
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
    <el-dialog
      title="内盘现货持仓汇总表管理"
      :visible.sync="npSpotInvestorPositionDialog"
      :close-on-click-modal="false"
      width="75%"
    >
      <el-form
        ref="npSpotInvestorPositionForm"
        :model="npSpotInvestorPositionForm"
        label-width="150px"
        class="npSpotInvestorPositionForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="npSpotInvestorPositionForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="证券代码" prop="instrumentID">
              <el-input v-model="npSpotInvestorPositionForm.instrumentID" placeholder="请输入证券代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪公司代码" prop="brokerID">
              <el-input v-model="npSpotInvestorPositionForm.brokerID" placeholder="请输入经纪公司代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投资者代码" prop="investorID">
              <el-input v-model="npSpotInvestorPositionForm.investorID" placeholder="请输入投资者代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓多空方向" prop="posiDirection">
              <el-select v-model="npSpotInvestorPositionForm.posiDirection" placeholder="请输入持仓多空方向">
                <el-option v-for="data in posiDirection" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投机套保标志" prop="hedgeFlag">
              <el-select v-model="npSpotInvestorPositionForm.hedgeFlag" placeholder="请输入投机套保标志">
                <el-option v-for="data in hedgeFlag" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓日期" prop="positionDate">
              <el-input v-model="npSpotInvestorPositionForm.positionDate" placeholder="请输入持仓日期">
                <el-option v-for="data in positionDate" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日持仓" prop="ydPosition">
              <el-input v-model="npSpotInvestorPositionForm.ydPosition" placeholder="请输入上日持仓" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="今日持仓" prop="position">
              <el-input v-model="npSpotInvestorPositionForm.position" placeholder="请输入今日持仓" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="多头冻结" prop="longFrozen">
              <el-input v-model="npSpotInvestorPositionForm.longFrozen" placeholder="请输入多头冻结" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="空头冻结" prop="shortFrozen">
              <el-input v-model="npSpotInvestorPositionForm.shortFrozen" placeholder="请输入空头冻结" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开仓冻结金额" prop="longFrozenAmount">
              <el-input v-model="npSpotInvestorPositionForm.longFrozenAmount" placeholder="请输入开仓冻结金额" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓冻结金额" prop="shortFrozenAmount">
              <el-input v-model="npSpotInvestorPositionForm.shortFrozenAmount" placeholder="请输入开仓冻结金额" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开仓量" prop="openVolume">
              <el-input v-model="npSpotInvestorPositionForm.openVolume" placeholder="请输入开仓量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓量" prop="closeVolume">
              <el-input v-model="npSpotInvestorPositionForm.closeVolume" placeholder="请输入平仓量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓金额" prop="openAmount">
              <el-input v-model="npSpotInvestorPositionForm.openAmount" placeholder="请输入开仓金额" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓金额" prop="closeAmount">
              <el-input v-model="npSpotInvestorPositionForm.closeAmount" placeholder="请输入平仓金额" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓成本" prop="positionCost">
              <el-input v-model="npSpotInvestorPositionForm.positionCost" placeholder="请输入持仓成本" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上次占用的保证金" prop="preMargin">
              <el-input v-model="npSpotInvestorPositionForm.preMargin" placeholder="请输入上次占用的保证金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="占用的保证金" prop="useMargin">
              <el-input v-model="npSpotInvestorPositionForm.useMargin" placeholder="请输入占用的保证金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结的保证金" prop="frozenMargin">
              <el-input v-model="npSpotInvestorPositionForm.frozenMargin" placeholder="请输入冻结的保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冻结的资金" prop="frozenCash">
              <el-input v-model="npSpotInvestorPositionForm.frozenCash" placeholder="请输入冻结的资金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结的手续费" prop="frozenCommission">
              <el-input v-model="npSpotInvestorPositionForm.frozenCommission" placeholder="请输入冻结的手续费" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="资金差额" prop="cashIn">
              <el-input v-model="npSpotInvestorPositionForm.cashIn" placeholder="请输入资金差额" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费" prop="commission">
              <el-input v-model="npSpotInvestorPositionForm.commission" placeholder="请输入手续费" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费" prop="commission">
              <el-input v-model="npSpotInvestorPositionForm.commission" placeholder="请输入手续费" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="npSpotInvestorPositionForm.closeProfit" placeholder="请输入平仓盈亏" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓盈亏" prop="positionProfit">
              <el-input v-model="npSpotInvestorPositionForm.positionProfit" placeholder="请输入持仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次结算价" prop="preSettlementPrice">
              <el-input v-model="npSpotInvestorPositionForm.preSettlementPrice" placeholder="请输入上次结算价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本次结算价" prop="settlementPrice">
              <el-input v-model="npSpotInvestorPositionForm.settlementPrice" placeholder="请输入本次结算价" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="npSpotInvestorPositionForm.tradingDay" placeholder="请输入交易日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="结算编号" prop="settlementID">
              <el-input v-model="npSpotInvestorPositionForm.settlementID" placeholder="请输入结算编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开仓成本" prop="openCost">
              <el-input v-model="npSpotInvestorPositionForm.openCost" placeholder="请输入开仓成本" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所保证金" prop="exchangeMargin">
              <el-input v-model="npSpotInvestorPositionForm.exchangeMargin" placeholder="请输入交易所保证金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="组合成交形成的持仓" prop="combPosition">
              <el-input v-model="npSpotInvestorPositionForm.combPosition" placeholder="请输入组合成交形成的持仓" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="组合多头冻结" prop="combLongFrozen">
              <el-input v-model="npSpotInvestorPositionForm.combLongFrozen" placeholder="请输入组合多头冻结" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="组合空头冻结" prop="combShortFrozen">
              <el-input v-model="npSpotInvestorPositionForm.combShortFrozen" placeholder="请输入组合空头冻结" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐日盯市平仓盈亏" prop="closeProfitByDate">
              <el-input v-model="npSpotInvestorPositionForm.closeProfitByDate" placeholder="请输入逐日盯市平仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐笔对冲平仓盈亏" prop="closeProfitByTrade">
              <el-input v-model="npSpotInvestorPositionForm.closeProfitByTrade" placeholder="请输入逐笔对冲平仓盈亏" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="今日持仓" prop="todayPosition">
              <el-input v-model="npSpotInvestorPositionForm.todayPosition" placeholder="请输入今日持仓" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金率" prop="marginRateByMoney">
              <el-input v-model="npSpotInvestorPositionForm.marginRateByMoney" placeholder="请输入保证金率" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金率(按手数)" prop="marginRateByVolume">
              <el-input v-model="npSpotInvestorPositionForm.marginRateByVolume" placeholder="请输入保证金率(按手数)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="执行冻结" prop="strikeFrozen">
              <el-input v-model="npSpotInvestorPositionForm.strikeFrozen" placeholder="请输入执行冻结" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行冻结金额" prop="strikeFrozenAmount">
              <el-input v-model="npSpotInvestorPositionForm.strikeFrozenAmount" placeholder="请输入执行冻结金额" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="放弃执行冻结" prop="abandonFrozen">
              <el-input v-model="npSpotInvestorPositionForm.abandonFrozen" placeholder="请输入放弃执行冻结" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="npSpotInvestorPositionForm.exchangeID" placeholder="请输入交易所代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行冻结的昨仓" prop="ydStrikeFrozen">
              <el-input v-model="npSpotInvestorPositionForm.ydStrikeFrozen" placeholder="请输入执行冻结的昨仓" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投资单元代码" prop="investUnitID">
              <el-input v-model="npSpotInvestorPositionForm.investUnitID" placeholder="请输入投资单元代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="大商所持仓成本差值，只有大商所使用" prop="positionCostOffset">
              <el-input v-model="npSpotInvestorPositionForm.positionCostOffset" placeholder="请输入大商所持仓成本差值，只有大商所使用" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="tas持仓手数" prop="tasPosition">
              <el-input v-model="npSpotInvestorPositionForm.tasPosition" placeholder="请输入tas持仓手数" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="tas持仓手数" prop="tasPosition">
              <el-input v-model="npSpotInvestorPositionForm.tasPosition" placeholder="请输入tas持仓手数" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="tas持仓成本" prop="tasPositionCost">
              <el-input v-model="npSpotInvestorPositionForm.tasPositionCost" placeholder="请输入tas持仓成本" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'NpSpotInvestorPosition',
    data() {
      return {
        npSpotInvestorPositionLoading: true,
        npSpotInvestorPositionDialog: false,
        npSpotInvestorPositionData: [],
        posiDirection: [],
        hedgeFlag: [],
        positionDate: [],
        dicts: [],
        npSpotInvestorPositionForm: {
          'id': '',
          'accountId': '',
          'instrumentID': '',
          'brokerID': '',
          'investorID': '',
          'posiDirection': '',
          'hedgeFlag': '',
          'positionDate': '',
          'ydPosition': '',
          'position': '',
          'longFrozen': '',
          'shortFrozen': '',
          'longFrozenAmount': '',
          'shortFrozenAmount': '',
          'openVolume': '',
          'closeVolume': '',
          'openAmount': '',
          'closeAmount': '',
          'positionCost': '',
          'preMargin': '',
          'useMargin': '',
          'frozenMargin': '',
          'frozenCash': '',
          'frozenCommission': '',
          'cashIn': '',
          'commission': '',
          'closeProfit': '',
          'positionProfit': '',
          'preSettlementPrice': '',
          'settlementPrice': '',
          'tradingDay': '',
          'settlementID': '',
          'openCost': '',
          'exchangeMargin': '',
          'combPosition': '',
          'combLongFrozen': '',
          'combShortFrozen': '',
          'closeProfitByDate': '',
          'closeProfitByTrade': '',
          'todayPosition': '',
          'marginRateByMoney': '',
          'marginRateByVolume': '',
          'strikeFrozen': '',
          'strikeFrozenAmount': '',
          'abandonFrozen': '',
          'exchangeID': '',
          'ydStrikeFrozen': '',
          'investUnitID': '',
          'positionCostOffset': '',
          'tasPosition': '',
          'tasPositionCost': ''
        },
        searchForm: {
          'accountId': '',
          'instrumentID': '',
          'brokerID': '',
          'investorID': '',
          'posiDirection': ''
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
          url: '/npspot/dict/npSpotInvestorPosition',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.posiDirection = res.object.posiDirection.list;
            this.hedgeFlag = res.object.hedgeFlag.list;
            this.positionDate = res.object.positionDate.list;
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
        this.npSpotInvestorPositionLoading = true;
        this.$http({
          url: '/npspot/npSpotInvestorPosition/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.npSpotInvestorPositionData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.npSpotInvestorPositionLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.npSpotInvestorPositionForm = {
          'id': '',
          'accountId': '',
          'instrumentID': '',
          'brokerID': '',
          'investorID': '',
          'posiDirection': '',
          'hedgeFlag': '',
          'positionDate': '',
          'ydPosition': '',
          'position': '',
          'longFrozen': '',
          'shortFrozen': '',
          'longFrozenAmount': '',
          'shortFrozenAmount': '',
          'openVolume': '',
          'closeVolume': '',
          'openAmount': '',
          'closeAmount': '',
          'positionCost': '',
          'preMargin': '',
          'useMargin': '',
          'frozenMargin': '',
          'frozenCash': '',
          'frozenCommission': '',
          'cashIn': '',
          'commission': '',
          'closeProfit': '',
          'positionProfit': '',
          'preSettlementPrice': '',
          'settlementPrice': '',
          'tradingDay': '',
          'settlementID': '',
          'openCost': '',
          'exchangeMargin': '',
          'combPosition': '',
          'combLongFrozen': '',
          'combShortFrozen': '',
          'closeProfitByDate': '',
          'closeProfitByTrade': '',
          'todayPosition': '',
          'marginRateByMoney': '',
          'marginRateByVolume': '',
          'strikeFrozen': '',
          'strikeFrozenAmount': '',
          'abandonFrozen': '',
          'exchangeID': '',
          'ydStrikeFrozen': '',
          'investUnitID': '',
          'positionCostOffset': '',
          'tasPosition': '',
          'tasPositionCost': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.npSpotInvestorPositionDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.npSpotInvestorPositionForm) {
          this.$refs.npSpotInvestorPositionForm.resetFields();
        }
        this.$http({
          url: '/npspot/npSpotInvestorPosition/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.npSpotInvestorPositionForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'instrumentID': res.object.instrumentID,
              'brokerID': res.object.brokerID,
              'investorID': res.object.investorID,
              'posiDirection': res.object.posiDirection,
              'hedgeFlag': res.object.hedgeFlag,
              'positionDate': res.object.positionDate,
              'ydPosition': res.object.ydPosition,
              'position': res.object.position,
              'longFrozen': res.object.longFrozen,
              'shortFrozen': res.object.shortFrozen,
              'longFrozenAmount': res.object.longFrozenAmount,
              'shortFrozenAmount': res.object.shortFrozenAmount,
              'openVolume': res.object.openVolume,
              'closeVolume': res.object.closeVolume,
              'openAmount': res.object.openAmount,
              'closeAmount': res.object.closeAmount,
              'positionCost': res.object.positionCost,
              'preMargin': res.object.preMargin,
              'useMargin': res.object.useMargin,
              'frozenMargin': res.object.frozenMargin,
              'frozenCash': res.object.frozenCash,
              'frozenCommission': res.object.frozenCommission,
              'cashIn': res.object.cashIn,
              'commission': res.object.commission,
              'closeProfit': res.object.closeProfit,
              'positionProfit': res.object.positionProfit,
              'preSettlementPrice': res.object.preSettlementPrice,
              'settlementPrice': res.object.settlementPrice,
              'tradingDay': res.object.tradingDay,
              'settlementID': res.object.settlementID,
              'openCost': res.object.openCost,
              'exchangeMargin': res.object.exchangeMargin,
              'combPosition': res.object.combPosition,
              'combLongFrozen': res.object.combLongFrozen,
              'combShortFrozen': res.object.combShortFrozen,
              'closeProfitByDate': res.object.closeProfitByDate,
              'closeProfitByTrade': res.object.closeProfitByTrade,
              'todayPosition': res.object.todayPosition,
              'marginRateByMoney': res.object.marginRateByMoney,
              'marginRateByVolume': res.object.marginRateByVolume,
              'strikeFrozen': res.object.strikeFrozen,
              'strikeFrozenAmount': res.object.strikeFrozenAmount,
              'abandonFrozen': res.object.abandonFrozen,
              'exchangeID': res.object.exchangeID,
              'ydStrikeFrozen': res.object.ydStrikeFrozen,
              'investUnitID': res.object.investUnitID,
              'positionCostOffset': res.object.positionCostOffset,
              'tasPosition': res.object.tasPosition,
              'tasPositionCost': res.object.tasPositionCost
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.npSpotInvestorPositionDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npspot/npSpotInvestorPosition/save',
              method: 'post',
              data: this.npSpotInvestorPositionForm
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
            this.npSpotInvestorPositionDialog = false;
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
            url: '/npspot/npSpotInvestorPosition/del',
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
  .npSpotInvestorPositionForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
