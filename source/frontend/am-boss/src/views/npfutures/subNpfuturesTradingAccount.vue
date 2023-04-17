<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subNpfuturesTradingAccountLoading" :data="subNpfuturesTradingAccountData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
      <el-table-column prop="preMortgage" label="上次质押金额"/>
      <el-table-column prop="preCredit" label="上次信用额度"/>
      <el-table-column prop="preDeposit" label="上次存款额"/>
      <el-table-column prop="preBalance" label="上次结算准备金"/>
      <el-table-column prop="preMargin" label="上次占用的保证金"/>
      <el-table-column prop="interestBase" label="利息基数"/>
      <el-table-column prop="interest" label="利息收入"/>
      <el-table-column prop="deposit" label="入金金额"/>
      <el-table-column prop="withdraw" label="出金金额"/>
      <el-table-column prop="frozenMargin" label="冻结的保证金"/>
      <el-table-column prop="frozenCash" label="冻结的资金"/>
      <el-table-column prop="frozenCommission" label="冻结的手续费"/>
      <el-table-column prop="currMargin" label="当前保证金总额"/>
      <el-table-column prop="cashIn" label="资金差额"/>
      <el-table-column prop="commission" label="手续费"/>
      <el-table-column prop="closeProfit" label="平仓盈亏"/>
      <el-table-column prop="positionProfit" label="持仓盈亏"/>
      <el-table-column prop="balance" label="期货结算准备金"/>
      <el-table-column prop="available" label="可用资金"/>
      <el-table-column prop="withdrawQuota" label="可取资金"/>
      <el-table-column prop="reserve" label="基本准备金"/>
      <el-table-column prop="tradingDay" label="交易日"/>
      <el-table-column prop="settlementID" label="结算编号"/>
      <el-table-column prop="credit" label="信用额度"/>
      <el-table-column prop="mortgage" label="质押金额"/>
      <el-table-column prop="exchangeMargin" label="交易所保证金"/>
      <el-table-column prop="deliveryMargin" label="投资者交割保证金"/>
      <el-table-column prop="exchangeDeliveryMargin" label="交易所交割保证金"/>
      <el-table-column prop="reserveBalance" label="保底期货结算准备金"/>
      <el-table-column prop="currencyID" label="币种代码"/>
      <el-table-column prop="preFundMortgageIn" label="上次货币质入金额"/>
      <el-table-column prop="preFundMortgageOut" label="上次货币质出金额"/>
      <el-table-column prop="fundMortgageIn" label="货币质入金额"/>
      <el-table-column prop="fundMortgageOut" label="货币质出金额"/>
      <el-table-column prop="fundMortgageAvailable" label="货币质押余额"/>
      <el-table-column prop="mortgageableFund" label="可质押货币金额"/>
      <el-table-column prop="specProductMargin" label="特殊产品占用保证金"/>
      <el-table-column prop="specProductFrozenMargin" label="特殊产品冻结保证金"/>
      <el-table-column prop="specProductCommission" label="特殊产品手续费"/>
      <el-table-column prop="specProductFrozenCommission" label="特殊产品冻结手续费"/>
      <el-table-column prop="specProductPositionProfit" label="特殊产品持仓盈亏"/>
      <el-table-column prop="specProductCloseProfit" label="特殊产品平仓盈亏"/>
      <el-table-column prop="specProductPositionProfitByAlg" label="根据持仓盈亏算法计算的特殊产品持仓盈亏"/>
      <el-table-column prop="specProductExchangeMargin" label="特殊产品交易所保证金"/>
      <el-table-column prop="bizType" label="业务类型" :formatter="statusFormat"/>
      <el-table-column prop="frozenSwap" label="延时换汇冻结金额"/>
      <el-table-column prop="remainSwap" label="剩余换汇额度"/>
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
    <el-dialog title="子账户资金账户息" :visible.sync="subNpfuturesTradingAccountDialog" :close-on-click-modal="false"
               width="75%">
      <el-form ref="subNpfuturesTradingAccountForm" :model="subNpfuturesTradingAccountForm"
               :rules="subNpfuturesTradingAccountRules" label-width="150px" class="subNpfuturesTradingAccountForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
              <el-input v-model="subNpfuturesTradingAccountForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次质押金额" prop="preMortgage">
              <el-input v-model="subNpfuturesTradingAccountForm.preMortgage" placeholder="请输入上次质押金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次信用额度" prop="preCredit">
              <el-input v-model="subNpfuturesTradingAccountForm.preCredit" placeholder="请输入上次信用额度"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上次存款额" prop="preDeposit">
              <el-input v-model="subNpfuturesTradingAccountForm.preDeposit" placeholder="请输入上次存款额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次结算准备金" prop="preBalance">
              <el-input v-model="subNpfuturesTradingAccountForm.preBalance" placeholder="请输入上次结算准备金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次占用的保证金" prop="preMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.preMargin" placeholder="请输入上次占用的保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="利息基数" prop="interestBase">
              <el-input v-model="subNpfuturesTradingAccountForm.interestBase" placeholder="请输入利息基数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="利息收入" prop="interest">
              <el-input v-model="subNpfuturesTradingAccountForm.interest" placeholder="请输入利息收入"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="入金金额" prop="deposit">
              <el-input v-model="subNpfuturesTradingAccountForm.deposit" placeholder="请输入入金金额"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="出金金额" prop="withdraw">
              <el-input v-model="subNpfuturesTradingAccountForm.withdraw" placeholder="请输入出金金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结的保证金" prop="frozenMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.frozenMargin" placeholder="请输入冻结的保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结的资金" prop="frozenCash">
              <el-input v-model="subNpfuturesTradingAccountForm.frozenCash" placeholder="请输入冻结的资金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冻结的手续费" prop="frozenCommission">
              <el-input v-model="subNpfuturesTradingAccountForm.frozenCommission" placeholder="请输入冻结的手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当前保证金总额" prop="currMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.currMargin" placeholder="请输入当前保证金总额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="资金差额" prop="cashIn">
              <el-input v-model="subNpfuturesTradingAccountForm.cashIn" placeholder="请输入资金差额"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费" prop="commission">
              <el-input v-model="subNpfuturesTradingAccountForm.commission" placeholder="请输入手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="subNpfuturesTradingAccountForm.closeProfit" placeholder="请输入平仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓盈亏" prop="positionProfit">
              <el-input v-model="subNpfuturesTradingAccountForm.positionProfit" placeholder="请输入持仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="期货结算准备金" prop="balance">
              <el-input v-model="subNpfuturesTradingAccountForm.balance" placeholder="请输入期货结算准备金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可用资金" prop="available">
              <el-input v-model="subNpfuturesTradingAccountForm.available" placeholder="请输入可用资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可取资金" prop="withdrawQuota">
              <el-input v-model="subNpfuturesTradingAccountForm.withdrawQuota" placeholder="请输入可取资金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="基本准备金" prop="reserve">
              <el-input v-model="subNpfuturesTradingAccountForm.reserve" placeholder="请输入基本准备金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="subNpfuturesTradingAccountForm.tradingDay" placeholder="请输入交易日"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="结算编号" prop="settlementID">
              <el-input v-model="subNpfuturesTradingAccountForm.settlementID" placeholder="请输入结算编号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="信用额度" prop="credit">
              <el-input v-model="subNpfuturesTradingAccountForm.credit" placeholder="请输入信用额度"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="质押金额" prop="mortgage">
              <el-input v-model="subNpfuturesTradingAccountForm.mortgage" placeholder="请输入质押金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所保证金" prop="exchangeMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.exchangeMargin" placeholder="请输入交易所保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投资者交割保证金" prop="deliveryMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.deliveryMargin" placeholder="请输入投资者交割保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所交割保证金" prop="exchangeDeliveryMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.exchangeDeliveryMargin" placeholder="请输入交易所交割保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保底期货结算准备金" prop="reserveBalance">
              <el-input v-model="subNpfuturesTradingAccountForm.reserveBalance" placeholder="请输入保底期货结算准备金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="币种代码" prop="currencyID">
              <el-input v-model="subNpfuturesTradingAccountForm.currencyID" placeholder="请输入币种代码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次货币质入金额" prop="preFundMortgageIn">
              <el-input v-model="subNpfuturesTradingAccountForm.preFundMortgageIn" placeholder="请输入上次货币质入金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上次货币质出金额" prop="preFundMortgageOut">
              <el-input v-model="subNpfuturesTradingAccountForm.preFundMortgageOut" placeholder="请输入上次货币质出金额"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上次货币质出金额" prop="preFundMortgageOut">
              <el-input v-model="subNpfuturesTradingAccountForm.preFundMortgageOut" placeholder="请输入上次货币质出金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="货币质入金额" prop="fundMortgageIn">
              <el-input v-model="subNpfuturesTradingAccountForm.fundMortgageIn" placeholder="请输入货币质入金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="货币质出金额" prop="fundMortgageOut">
              <el-input v-model="subNpfuturesTradingAccountForm.fundMortgageOut" placeholder="请输入货币质出金额"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="货币质押余额" prop="fundMortgageAvailable">
              <el-input v-model="subNpfuturesTradingAccountForm.fundMortgageAvailable" placeholder="请输入货币质押余额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可质押货币金额" prop="mortgageableFund">
              <el-input v-model="subNpfuturesTradingAccountForm.mortgageableFund" placeholder="请输入可质押货币金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品占用保证金" prop="specProductMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductMargin" placeholder="请输入特殊产品占用保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品冻结保证金" prop="specProductFrozenMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductFrozenMargin" placeholder="请输入特殊产品冻结保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品手续费" prop="specProductCommission">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductCommission" placeholder="请输入特殊产品手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品冻结手续费" prop="specProductFrozenCommission">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductFrozenCommission" placeholder="请输入特殊产品冻结手续费"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品持仓盈亏" prop="specProductPositionProfit">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductPositionProfit" placeholder="请输入特殊产品持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品平仓盈亏" prop="specProductCloseProfit">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductCloseProfit" placeholder="请输入特殊产品平仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="根据持仓盈亏算法计算的特殊产品持仓盈亏" prop="specProductPositionProfitByAlg">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductPositionProfitByAlg"
                        placeholder="请输入根据持仓盈亏算法计算的特殊产品持仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品交易所保证金" prop="specProductExchangeMargin">
              <el-input v-model="subNpfuturesTradingAccountForm.specProductExchangeMargin" placeholder="请输入特殊产品交易所保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="业务类型" prop="bizType">
              <el-select v-model="subNpfuturesTradingAccountForm.bizType" placeholder="请输入业务类型">
                <el-option v-for="data in bizType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="延时换汇冻结金额" prop="frozenSwap">
              <el-input v-model="subNpfuturesTradingAccountForm.frozenSwap" placeholder="请输入延时换汇冻结金额"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="剩余换汇额度" prop="remainSwap">
            <el-input v-model="subNpfuturesTradingAccountForm.remainSwap" placeholder="请输入剩余换汇额度"/>
          </el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item>
              <el-button type="success" @click="doSubmit('subNpfuturesTradingAccountForm')">提交</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubNpfuturesTradingAccountName',
    data() {
      return {
        subNpfuturesTradingAccountLoading: true,
        subNpfuturesTradingAccountDialog: false,
        subNpfuturesTradingAccountData: [],
        bizType: [],
        dicts: [],
        subNpfuturesTradingAccountForm: {
          'id': '',
          'subAccountId': '',
          'preMortgage': '',
          'preCredit': '',
          'preDeposit': '',
          'preBalance': '',
          'preMargin': '',
          'interestBase': '',
          'interest': '',
          'deposit': '',
          'withdraw': '',
          'frozenMargin': '',
          'frozenCash': '',
          'frozenCommission': '',
          'currMargin': '',
          'cashIn': '',
          'commission': '',
          'closeProfit': '',
          'positionProfit': '',
          'balance': '',
          'available': '',
          'withdrawQuota': '',
          'reserve': '',
          'tradingDay': '',
          'settlementID': '',
          'credit': '',
          'mortgage': '',
          'exchangeMargin': '',
          'deliveryMargin': '',
          'exchangeDeliveryMargin': '',
          'reserveBalance': '',
          'currencyID': '',
          'preFundMortgageIn': '',
          'preFundMortgageOut': '',
          'fundMortgageIn': '',
          'fundMortgageOut': '',
          'fundMortgageAvailable': '',
          'mortgageableFund': '',
          'specProductMargin': '',
          'specProductFrozenMargin': '',
          'specProductCommission': '',
          'specProductFrozenCommission': '',
          'specProductPositionProfit': '',
          'specProductCloseProfit': '',
          'specProductPositionProfitByAlg': '',
          'specProductExchangeMargin': '',
          'bizType': '',
          'frozenSwap': '',
          'remainSwap': ''
        },
        searchForm: {
          'subAccountId': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subNpfuturesTradingAccountRules: {
          subAccountId: [
            { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
          ],
          preMortgage: [
            { required: true, message: '上次质押金额不可为空', trigger: 'change' }
          ],
          preCredit: [
            { required: true, message: '上次信用额度不可为空', trigger: 'change' }
          ],
          preDeposit: [
            { required: true, message: '上次存款额不可为空', trigger: 'change' }
          ],
          preBalance: [
            { required: true, message: '上次结算准备金不可为空', trigger: 'change' }
          ],
          preMargin: [
            { required: true, message: '上次占用的保证金不可为空', trigger: 'change' }
          ],
          interestBase: [
            { required: true, message: '利息基数不可为空', trigger: 'change' }
          ],
          interest: [
            { required: true, message: '利息收入不可为空', trigger: 'change' }
          ],
          deposit: [
            { required: true, message: '入金金额不可为空', trigger: 'change' }
          ],
          withdraw: [
            { required: true, message: '出金金额不可为空', trigger: 'change' }
          ],
          frozenMargin: [
            { required: true, message: '冻结的保证金不可为空', trigger: 'change' }
          ],
          frozenCash: [
            { required: true, message: '冻结的资金不可为空', trigger: 'change' }
          ],
          frozenCommission: [
            { required: true, message: '冻结的手续费不可为空', trigger: 'change' }
          ],
          currMargin: [
            { required: true, message: '当前保证金总额不可为空', trigger: 'change' }
          ],
          cashIn: [
            { required: true, message: '资金差额不可为空', trigger: 'change' }
          ],
          commission: [
            { required: true, message: '手续费不可为空', trigger: 'change' }
          ],
          closeProfit: [
            { required: true, message: '平仓盈亏不可为空', trigger: 'change' }
          ],
          positionProfit: [
            { required: true, message: '持仓盈亏不可为空', trigger: 'change' }
          ],
          balance: [
            { required: true, message: '期货结算准备金不可为空', trigger: 'change' }
          ],
          available: [
            { required: true, message: '可用资金不可为空', trigger: 'change' }
          ],
          withdrawQuota: [
            { required: true, message: '可取资金不可为空', trigger: 'change' }
          ],
          reserve: [
            { required: true, message: '基本准备金不可为空', trigger: 'change' }
          ],
          tradingDay: [
            { required: true, message: '交易日不可为空', trigger: 'change' }
          ],
          settlementID: [
            { required: true, message: '结算编号不可为空', trigger: 'change' }
          ],
          credit: [
            { required: true, message: '信用额度不可为空', trigger: 'change' }
          ],
          mortgage: [
            { required: true, message: '质押金额不可为空', trigger: 'change' }
          ],
          exchangeMargin: [
            { required: true, message: '交易所保证金不可为空', trigger: 'change' }
          ],
          deliveryMargin: [
            { required: true, message: '投资者交割保证金不可为空', trigger: 'change' }
          ],
          exchangeDeliveryMargin: [
            { required: true, message: '交易所交割保证金不可为空', trigger: 'change' }
          ],
          reserveBalance: [
            { required: true, message: '保底期货结算准备金不可为空', trigger: 'change' }
          ],
          currencyID: [
            { required: true, message: '币种代码不可为空', trigger: 'change' }
          ],
          preFundMortgageIn: [
            { required: true, message: '上次货币质入金额不可为空', trigger: 'change' }
          ],
          preFundMortgageOut: [
            { required: true, message: '上次货币质出金额不可为空', trigger: 'change' }
          ],
          fundMortgageIn: [
            { required: true, message: '货币质入金额不可为空', trigger: 'change' }
          ],
          fundMortgageOut: [
            { required: true, message: '货币质出金额不可为空', trigger: 'change' }
          ],
          fundMortgageAvailable: [
            { required: true, message: '货币质押余额不可为空', trigger: 'change' }
          ],
          mortgageableFund: [
            { required: true, message: '可质押货币金额不可为空', trigger: 'change' }
          ],
          specProductMargin: [
            { required: true, message: '特殊产品占用保证金不可为空', trigger: 'change' }
          ],
          specProductFrozenMargin: [
            { required: true, message: '特殊产品冻结保证金不可为空', trigger: 'change' }
          ],
          specProductCommission: [
            { required: true, message: '特殊产品手续费不可为空', trigger: 'change' }
          ],
          specProductFrozenCommission: [
            { required: true, message: '特殊产品冻结手续费不可为空', trigger: 'change' }
          ],
          specProductPositionProfit: [
            { required: true, message: '特殊产品持仓盈亏不可为空', trigger: 'change' }
          ],
          specProductCloseProfit: [
            { required: true, message: '特殊产品平仓盈亏不可为空', trigger: 'change' }
          ],
          specProductPositionProfitByAlg: [
            { required: true, message: '根据持仓盈亏算法计算的特殊产品持仓盈亏不可为空', trigger: 'change' }
          ],
          specProductExchangeMargin: [
            { required: true, message: '特殊产品交易所保证金不可为空', trigger: 'change' }
          ],
          bizType: [
            { required: true, message: '业务类型(业务类型类型数据字典)不可为空', trigger: 'change' }
          ],
          frozenSwap: [
            { required: true, message: '延时换汇冻结金额不可为空', trigger: 'change' }
          ],
          remainSwap: [
            { required: true, message: '剩余换汇额度不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/npfuturesTradingAccount',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.bizType = res.object.bizType.list;
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
        this.subNpfuturesTradingAccountLoading = true;
        this.$http({
          url: '/npfutures/subNpfuturesTradingAccount/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesTradingAccountData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subNpfuturesTradingAccountLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subNpfuturesTradingAccountForm = {
          'id': '',
          'subAccountId': '',
          'preMortgage': '',
          'preCredit': '',
          'preDeposit': '',
          'preBalance': '',
          'preMargin': '',
          'interestBase': '',
          'interest': '',
          'deposit': '',
          'withdraw': '',
          'frozenMargin': '',
          'frozenCash': '',
          'frozenCommission': '',
          'currMargin': '',
          'cashIn': '',
          'commission': '',
          'closeProfit': '',
          'positionProfit': '',
          'balance': '',
          'available': '',
          'withdrawQuota': '',
          'reserve': '',
          'tradingDay': '',
          'settlementID': '',
          'credit': '',
          'mortgage': '',
          'exchangeMargin': '',
          'deliveryMargin': '',
          'exchangeDeliveryMargin': '',
          'reserveBalance': '',
          'currencyID': '',
          'preFundMortgageIn': '',
          'preFundMortgageOut': '',
          'fundMortgageIn': '',
          'fundMortgageOut': '',
          'fundMortgageAvailable': '',
          'mortgageableFund': '',
          'specProductMargin': '',
          'specProductFrozenMargin': '',
          'specProductCommission': '',
          'specProductFrozenCommission': '',
          'specProductPositionProfit': '',
          'specProductCloseProfit': '',
          'specProductPositionProfitByAlg': '',
          'specProductExchangeMargin': '',
          'bizType': '',
          'frozenSwap': '',
          'remainSwap': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subNpfuturesTradingAccountDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subNpfuturesTradingAccountForm) {
          this.$refs.subNpfuturesTradingAccountForm.resetFields();
        }
        this.$http({
          url: '/npfutures/subNpfuturesTradingAccount/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesTradingAccountForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
              'preMortgage': res.object.preMortgage,
              'preCredit': res.object.preCredit,
              'preDeposit': res.object.preDeposit,
              'preBalance': res.object.preBalance,
              'preMargin': res.object.preMargin,
              'interestBase': res.object.interestBase,
              'interest': res.object.interest,
              'deposit': res.object.deposit,
              'withdraw': res.object.withdraw,
              'frozenMargin': res.object.frozenMargin,
              'frozenCash': res.object.frozenCash,
              'frozenCommission': res.object.frozenCommission,
              'currMargin': res.object.currMargin,
              'cashIn': res.object.cashIn,
              'commission': res.object.commission,
              'closeProfit': res.object.closeProfit,
              'positionProfit': res.object.positionProfit,
              'balance': res.object.balance,
              'available': res.object.available,
              'withdrawQuota': res.object.withdrawQuota,
              'reserve': res.object.reserve,
              'tradingDay': res.object.tradingDay,
              'settlementID': res.object.settlementID,
              'credit': res.object.credit,
              'mortgage': res.object.mortgage,
              'exchangeMargin': res.object.exchangeMargin,
              'deliveryMargin': res.object.deliveryMargin,
              'exchangeDeliveryMargin': res.object.exchangeDeliveryMargin,
              'reserveBalance': res.object.reserveBalance,
              'currencyID': res.object.currencyID,
              'preFundMortgageIn': res.object.preFundMortgageIn,
              'preFundMortgageOut': res.object.preFundMortgageOut,
              'fundMortgageIn': res.object.fundMortgageIn,
              'fundMortgageOut': res.object.fundMortgageOut,
              'fundMortgageAvailable': res.object.fundMortgageAvailable,
              'mortgageableFund': res.object.mortgageableFund,
              'specProductMargin': res.object.specProductMargin,
              'specProductFrozenMargin': res.object.specProductFrozenMargin,
              'specProductCommission': res.object.specProductCommission,
              'specProductFrozenCommission': res.object.specProductFrozenCommission,
              'specProductPositionProfit': res.object.specProductPositionProfit,
              'specProductCloseProfit': res.object.specProductCloseProfit,
              'specProductPositionProfitByAlg': res.object.specProductPositionProfitByAlg,
              'specProductExchangeMargin': res.object.specProductExchangeMargin,
              'bizType': res.object.bizType,
              'frozenSwap': res.object.frozenSwap,
              'remainSwap': res.object.remainSwap
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.subNpfuturesTradingAccountDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/subNpfuturesTradingAccount/save',
              method: 'post',
              data: this.subNpfuturesTradingAccountForm
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
            this.subNpfuturesTradingAccountDialog = false;
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
            url: '/npfutures/subNpfuturesTradingAccount/del',
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
  .subNpfuturesTradingAccountForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
