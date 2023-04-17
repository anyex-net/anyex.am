<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="币种组号">
        <el-input v-model="searchForm.currencyGroupNo" clearable placeholder="请输入币种组号"></el-input>
      </el-form-item>
      <el-form-item label="币种号(为空表示币种组基币资金)">
        <el-input v-model="searchForm.currencyNo" clearable placeholder="请输入币种号(为空表示币种组基币资金)"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subWpfuturesFundDataLoading" :data="subWpfuturesFundDataData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
      <el-table-column prop="currencyGroupNo" label="币种组号"/>
      <el-table-column prop="currencyNo" label="币种号(为空表示币种组基币资金)"/>
      <el-table-column prop="tradeRate" label="交易汇率"/>
      <el-table-column prop="futureAlg" label="期货算法" :formatter="statusFormat"/>
      <el-table-column prop="optionAlg" label="期权算法" :formatter="statusFormat"/>
      <el-table-column prop="preBalance" label="上日结存"/>
      <el-table-column prop="preUnExpProfit" label="上日未到期平盈"/>
      <el-table-column prop="preLMEPositionProfit" label="上日LME持仓平盈"/>
      <el-table-column prop="preEquity" label="上日权益"/>
      <el-table-column prop="preAvailable1" label="上日可用"/>
      <el-table-column prop="preMarketEquity" label="上日市值权益"/>
      <el-table-column prop="cashInValue" label="入金"/>
      <el-table-column prop="cashOutValue" label="出金"/>
      <el-table-column prop="cashAdjustValue" label="资金调整"/>
      <el-table-column prop="cashPledged" label="质押资金"/>
      <el-table-column prop="frozenFee" label="冻结手续费"/>
      <el-table-column prop="frozenDeposit" label="冻结保证金"/>
      <el-table-column prop="accountFee" label="客户手续费包含交割手续费"/>
      <el-table-column prop="swapInValue" label="汇入资金"/>
      <el-table-column prop="swapOutValue" label="汇出资金"/>
      <el-table-column prop="premiumIncome" label="权利金收取"/>
      <el-table-column prop="premiumPay" label="权利金支付"/>
      <el-table-column prop="closeProfit" label="平仓盈亏"/>
      <el-table-column prop="frozenFund" label="冻结资金"/>
      <el-table-column prop="unExpProfit" label="未到期平盈"/>
      <el-table-column prop="expProfit" label="到期平仓盈亏"/>
      <el-table-column prop="positionProfit" label="不含LME持仓盈亏"/>
      <el-table-column prop="lmePositionProfit" label="LME持仓盈亏"/>
      <el-table-column prop="optionMarketValue" label="期权市值"/>
      <el-table-column prop="accountIntialMargin" label="客户初始保证金"/>
      <el-table-column prop="accountMaintenanceMargin" label="客户维持保证金"/>
      <el-table-column prop="upperInitalMargin" label="上手初始保证金"/>
      <el-table-column prop="upperMaintenanceMargin" label="上手维持保证金"/>
      <el-table-column prop="discount" label="LME贴现"/>
      <el-table-column prop="balance" label="当日结存"/>
      <el-table-column prop="equity" label="当日权益"/>
      <el-table-column prop="available" label="当日可用"/>
      <el-table-column prop="canDraw" label="可提取"/>
      <el-table-column prop="marketEquity" label="账户市值"/>
      <el-table-column prop="authMoney" label="授信资金"/>
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
    <el-dialog title="子账户资金账户息" :visible.sync="subWpfuturesFundDataDialog" :close-on-click-modal="false" width="70%">
      <el-form ref="subWpfuturesFundDataForm" :model="subWpfuturesFundDataForm" :rules="subWpfuturesFundDataRules"
               label-width="150px" class="subWpfuturesFundDataForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
              <el-input v-model="subWpfuturesFundDataForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种组号" prop="currencyGroupNo">
              <el-input v-model="subWpfuturesFundDataForm.currencyGroupNo" placeholder="请输入币种组号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种号(为空表示币种组基币资金)" prop="currencyNo">
              <el-input v-model="subWpfuturesFundDataForm.currencyNo" placeholder="请输入币种号(为空表示币种组基币资金)"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易汇率" prop="tradeRate">
              <el-input v-model="subWpfuturesFundDataForm.tradeRate" placeholder="请输入交易汇率"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期货算法" prop="futureAlg">
              <el-select v-model="subWpfuturesFundDataForm.futureAlg" clearable placeholder="请输入期货算法" value="">
                <el-option v-for="data in futureAlgSelect" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权算法" prop="optionAlg">
              <el-select v-model="subWpfuturesFundDataForm.optionAlg" clearable placeholder="请输入期权算法" value="">
                <el-option v-for="data in optionAlgSelect" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上日结存" prop="preBalance">
              <el-input v-model="subWpfuturesFundDataForm.preBalance" placeholder="请输入上日结存"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日未到期平盈" prop="preUnExpProfit">
              <el-input v-model="subWpfuturesFundDataForm.preUnExpProfit" placeholder="请输入上日未到期平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日LME持仓平盈" prop="preLMEPositionProfit">
              <el-input v-model="subWpfuturesFundDataForm.preLMEPositionProfit" placeholder="请输入上日LME持仓平盈"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上日权益" prop="preEquity">
              <el-input v-model="subWpfuturesFundDataForm.preEquity" placeholder="请输入上日权益"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日可用" prop="preAvailable1">
              <el-input v-model="subWpfuturesFundDataForm.preAvailable1" placeholder="请输入上日可用"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日市值权益" prop="preMarketEquity">
              <el-input v-model="subWpfuturesFundDataForm.preMarketEquity" placeholder="请输入上日市值权益"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="入金" prop="cashInValue">
              <el-input v-model="subWpfuturesFundDataForm.cashInValue" placeholder="请输入入金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="出金" prop="cashOutValue">
              <el-input v-model="subWpfuturesFundDataForm.cashOutValue" placeholder="请输入出金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="资金调整" prop="cashAdjustValue">
              <el-input v-model="subWpfuturesFundDataForm.cashAdjustValue" placeholder="请输入资金调整"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="质押资金" prop="cashPledged">
              <el-input v-model="subWpfuturesFundDataForm.cashPledged" placeholder="请输入质押资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结手续费" prop="frozenFee">
              <el-input v-model="subWpfuturesFundDataForm.frozenFee" placeholder="请输入冻结手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结保证金" prop="frozenDeposit">
              <el-input v-model="subWpfuturesFundDataForm.frozenDeposit" placeholder="请输入冻结保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户手续费包含交割手续费" prop="accountFee">
              <el-input v-model="subWpfuturesFundDataForm.accountFee" placeholder="请输入客户手续费包含交割手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="汇入资金" prop="swapInValue">
              <el-input v-model="subWpfuturesFundDataForm.swapInValue" placeholder="请输入汇入资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="汇出资金" prop="swapOutValue">
              <el-input v-model="subWpfuturesFundDataForm.swapOutValue" placeholder="请输入汇出资金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="权利金收取" prop="premiumIncome">
              <el-input v-model="subWpfuturesFundDataForm.premiumIncome" placeholder="请输入权利金收取"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="权利金支付" prop="premiumPay">
              <el-input v-model="subWpfuturesFundDataForm.premiumPay" placeholder="请输入权利金支付"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="subWpfuturesFundDataForm.closeProfit" placeholder="请输入平仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冻结资金" prop="frozenFund">
              <el-input v-model="subWpfuturesFundDataForm.frozenFund" placeholder="请输入冻结资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="未到期平盈" prop="unExpProfit">
              <el-input v-model="subWpfuturesFundDataForm.unExpProfit" placeholder="请输入未到期平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="到期平仓盈亏" prop="expProfit">
              <el-input v-model="subWpfuturesFundDataForm.expProfit" placeholder="请输入到期平仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="不含LME持仓盈亏" prop="positionProfit">
              <el-input v-model="subWpfuturesFundDataForm.positionProfit" placeholder="请输入不含LME持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME持仓盈亏" prop="lmePositionProfit">
              <el-input v-model="subWpfuturesFundDataForm.lmePositionProfit" placeholder="请输入LME持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="subWpfuturesFundDataForm.optionMarketValue" placeholder="请输入期权市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户初始保证金" prop="accountIntialMargin">
              <el-input v-model="subWpfuturesFundDataForm.accountIntialMargin" placeholder="请输入客户初始保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="subWpfuturesFundDataForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手初始保证金" prop="upperInitalMargin">
              <el-input v-model="subWpfuturesFundDataForm.upperInitalMargin" placeholder="请输入上手初始保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
              <el-input v-model="subWpfuturesFundDataForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME贴现" prop="discount">
              <el-input v-model="subWpfuturesFundDataForm.discount" placeholder="请输入LME贴现"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当日结存" prop="balance">
              <el-input v-model="subWpfuturesFundDataForm.balance" placeholder="请输入当日结存"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="当日权益" prop="equity">
              <el-input v-model="subWpfuturesFundDataForm.equity" placeholder="请输入当日权益"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当日可用" prop="available">
              <el-input v-model="subWpfuturesFundDataForm.available" placeholder="请输入当日可用"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可提取" prop="canDraw">
              <el-input v-model="subWpfuturesFundDataForm.canDraw" placeholder="请输入可提取"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="账户市值" prop="marketEquity">
              <el-input v-model="subWpfuturesFundDataForm.marketEquity" placeholder="请输入账户市值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="授信资金" prop="authMoney">
              <el-input v-model="subWpfuturesFundDataForm.authMoney" placeholder="请输入授信资金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col align="center">
            <el-button type="success" @click="doSubmit('subWpfuturesFundDataForm')">提交</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubWpfuturesFundDataName',
    data() {
      return {
        subWpfuturesFundDataLoading: true,
        subWpfuturesFundDataDialog: false,
        subWpfuturesFundDataData: [],
        futureAlgSelect: [],
        optionAlgSelect: [],
        dicts: [],
        subWpfuturesFundDataForm: {
          'id': '',
          'subAccountId': '',
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
          'subAccountId': '',
          'currencyGroupNo': '',
          'currencyNo': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subWpfuturesFundDataRules: {
          subAccountId: [
            { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
          ],
          currencyGroupNo: [
            { required: true, message: '币种组号不可为空', trigger: 'change' }
          ],
          tradeRate: [
            { required: true, message: '交易汇率不可为空', trigger: 'change' }
          ],
          futureAlg: [
            { required: true, message: '期货算法不可为空', trigger: 'change' }
          ],
          optionAlg: [
            { required: true, message: '期权算法不可为空', trigger: 'change' }
          ],
          preBalance: [
            { required: true, message: '上日结存不可为空', trigger: 'change' }
          ],
          preUnExpProfit: [
            { required: true, message: '上日未到期平盈不可为空', trigger: 'change' }
          ],
          preLMEPositionProfit: [
            { required: true, message: '上日LME持仓平盈不可为空', trigger: 'change' }
          ],
          preEquity: [
            { required: true, message: '上日权益不可为空', trigger: 'change' }
          ],
          preAvailable1: [
            { required: true, message: '上日可用不可为空', trigger: 'change' }
          ],
          preMarketEquity: [
            { required: true, message: '上日市值权益不可为空', trigger: 'change' }
          ],
          cashInValue: [
            { required: true, message: '入金不可为空', trigger: 'change' }
          ],
          cashOutValue: [
            { required: true, message: '出金不可为空', trigger: 'change' }
          ],
          cashAdjustValue: [
            { required: true, message: '资金调整不可为空', trigger: 'change' }
          ],
          cashPledged: [
            { required: true, message: '质押资金不可为空', trigger: 'change' }
          ],
          frozenFee: [
            { required: true, message: '冻结手续费不可为空', trigger: 'change' }
          ],
          frozenDeposit: [
            { required: true, message: '冻结保证金不可为空', trigger: 'change' }
          ],
          accountFee: [
            { required: true, message: '客户手续费包含交割手续费不可为空', trigger: 'change' }
          ],
          swapInValue: [
            { required: true, message: '汇入资金不可为空', trigger: 'change' }
          ],
          swapOutValue: [
            { required: true, message: '汇出资金不可为空', trigger: 'change' }
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
          frozenFund: [
            { required: true, message: '冻结资金不可为空', trigger: 'change' }
          ],
          unExpProfit: [
            { required: true, message: '未到期平盈不可为空', trigger: 'change' }
          ],
          expProfit: [
            { required: true, message: '到期平仓盈亏不可为空', trigger: 'change' }
          ],
          positionProfit: [
            { required: true, message: '不含LME持仓盈亏不可为空', trigger: 'change' }
          ],
          lmePositionProfit: [
            { required: true, message: 'LME持仓盈亏不可为空', trigger: 'change' }
          ],
          optionMarketValue: [
            { required: true, message: '期权市值不可为空', trigger: 'change' }
          ],
          accountIntialMargin: [
            { required: true, message: '客户初始保证金不可为空', trigger: 'change' }
          ],
          accountMaintenanceMargin: [
            { required: true, message: '客户维持保证金不可为空', trigger: 'change' }
          ],
          upperInitalMargin: [
            { required: true, message: '上手初始保证金不可为空', trigger: 'change' }
          ],
          upperMaintenanceMargin: [
            { required: true, message: '上手维持保证金不可为空', trigger: 'change' }
          ],
          discount: [
            { required: true, message: 'LME贴现不可为空', trigger: 'change' }
          ],
          balance: [
            { required: true, message: '当日结存不可为空', trigger: 'change' }
          ],
          equity: [
            { required: true, message: '当日权益不可为空', trigger: 'change' }
          ],
          available: [
            { required: true, message: '当日可用不可为空', trigger: 'change' }
          ],
          canDraw: [
            { required: true, message: '可提取不可为空', trigger: 'change' }
          ],
          marketEquity: [
            { required: true, message: '账户市值不可为空', trigger: 'change' }
          ],
          authMoney: [
            { required: true, message: '授信资金不可为空', trigger: 'change' }
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
          url: '/wpfutures/dict/wpfuturesFundData',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.futureAlgSelect = res.object.futureAlg;
            this.optionAlgSelect = res.object.optionAlg;
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
        this.subWpfuturesFundDataLoading = true;
        this.$http({
          url: '/wpfutures/subWpfuturesFundData/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesFundDataData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subWpfuturesFundDataLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subWpfuturesFundDataForm = {
          'id': '',
          'subAccountId': '',
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
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subWpfuturesFundDataDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subWpfuturesFundDataForm) {
          this.$refs.subWpfuturesFundDataForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/subWpfuturesFundData/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesFundDataForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
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
        this.subWpfuturesFundDataDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/subWpfuturesFundData/save',
              method: 'post',
              data: this.subWpfuturesFundDataForm
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
            this.subWpfuturesFundDataDialog = false;
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
            url: '/wpfutures/subWpfuturesFundData/del',
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
  .subWpfuturesFundDataForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
