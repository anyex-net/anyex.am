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
      <el-form-item label="客户资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金账号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesFundDataLoading" :data="esNpfuturesFundDataData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="客户资金账号"/>
      <el-table-column prop="parentAccountNo" label="上级资金账号"/>
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
      <el-table-column prop="exchangeFee" label="汇兑手续费"/>
      <el-table-column prop="accountDeliveryFee" label="客户交割手续费"/>
      <el-table-column prop="premiumIncome" label="权利金收取"/>
      <el-table-column prop="premiumPay" label="权利金支付"/>
      <el-table-column prop="closeProfit" label="平仓盈亏"/>
      <el-table-column prop="deliveryProfit" label="交割盈亏"/>
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
      <el-table-column prop="originalCashInOut" label="币种原始出入金"/>
      <el-table-column prop="floatingPL" label="逐笔浮盈"/>
      <el-table-column prop="frozenRiskFundValue" label="风险冻结资金"/>
      <el-table-column prop="closePL" label="逐笔平盈"/>
      <el-table-column prop="noCurrencyPledgeValue" label="非货币质押"/>
      <el-table-column prop="prePledgeValue" label="期初质押"/>
      <el-table-column prop="pledgeIn" label="质入"/>
      <el-table-column prop="pledgeOut" label="质出"/>
      <el-table-column prop="pledgeValue" label="质押余额"/>
      <el-table-column prop="borrowValue" label="借用金额"/>
      <el-table-column prop="specialAccountFrozenMargin" label="特殊产品冻结保证金"/>
      <el-table-column prop="specialAccountMargin" label="特殊产品保证金"/>
      <el-table-column prop="specialAccountFrozenFee" label="特殊产品冻结手续费"/>
      <el-table-column prop="specialAccountFee" label="特殊产品手续费"/>
      <el-table-column prop="specialFloatProfit" label="特殊产品浮盈"/>
      <el-table-column prop="specialCloseProfit" label="特殊产品平盈"/>
      <el-table-column prop="specialFloatPL" label="特殊产品逐笔浮盈"/>
      <el-table-column prop="specialClosePL" label="特殊产品逐笔平盈"/>
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
    <el-dialog title="内盘期货资金账号资金信息表管理" :visible.sync="esNpfuturesFundDataDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesFundDataForm" :model="esNpfuturesFundDataForm" :rules="esNpfuturesFundDataRules"
               label-width="150px" class="esNpfuturesFundDataForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="esNpfuturesFundDataForm.accountId" placeholder="请输入AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="esNpfuturesFundDataForm.brokerNo" placeholder="请输入经纪商编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户资金账号" prop="accountNo">
              <el-input v-model="esNpfuturesFundDataForm.accountNo" placeholder="请输入客户资金账号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上级资金账号" prop="parentAccountNo">
              <el-input v-model="esNpfuturesFundDataForm.parentAccountNo" placeholder="请输入上级资金账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种组号" prop="currencyGroupNo">
              <el-input v-model="esNpfuturesFundDataForm.currencyGroupNo" placeholder="请输入币种组号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种号(为空表示币种组基币资金)" prop="currencyNo">
              <el-input v-model="esNpfuturesFundDataForm.currencyNo" placeholder="请输入币种号(为空表示币种组基币资金)"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易汇率" prop="tradeRate">
              <el-input v-model="esNpfuturesFundDataForm.tradeRate" placeholder="请输入交易汇率"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期货算法" prop="futureAlg">
              <el-input v-model="esNpfuturesFundDataForm.futureAlg" placeholder="请输入期货算法"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权算法" prop="optionAlg">
              <el-input v-model="esNpfuturesFundDataForm.optionAlg" placeholder="请输入期权算法"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上日结存" prop="preBalance">
              <el-input v-model="esNpfuturesFundDataForm.preBalance" placeholder="请输入上日结存"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日未到期平盈" prop="preUnExpProfit">
              <el-input v-model="esNpfuturesFundDataForm.preUnExpProfit" placeholder="请输入上日未到期平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日LME持仓平盈" prop="preLMEPositionProfit">
              <el-input v-model="esNpfuturesFundDataForm.preLMEPositionProfit" placeholder="请输入上日LME持仓平盈"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上日权益" prop="preEquity">
              <el-input v-model="esNpfuturesFundDataForm.preEquity" placeholder="请输入上日权益"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日可用" prop="preAvailable1">
              <el-input v-model="esNpfuturesFundDataForm.preAvailable1" placeholder="请输入上日可用"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上日市值权益" prop="preMarketEquity">
              <el-input v-model="esNpfuturesFundDataForm.preMarketEquity" placeholder="请输入上日市值权益"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="入金" prop="cashInValue">
              <el-input v-model="esNpfuturesFundDataForm.cashInValue" placeholder="请输入入金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="出金" prop="cashOutValue">
              <el-input v-model="esNpfuturesFundDataForm.cashOutValue" placeholder="请输入出金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="资金调整" prop="cashAdjustValue">
              <el-input v-model="esNpfuturesFundDataForm.cashAdjustValue" placeholder="请输入资金调整"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="质押资金" prop="cashPledged">
              <el-input v-model="esNpfuturesFundDataForm.cashPledged" placeholder="请输入质押资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结手续费" prop="frozenFee">
              <el-input v-model="esNpfuturesFundDataForm.frozenFee" placeholder="请输入冻结手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结保证金" prop="frozenDeposit">
              <el-input v-model="esNpfuturesFundDataForm.frozenDeposit" placeholder="请输入冻结保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户手续费包含交割手续费" prop="accountFee">
              <el-input v-model="esNpfuturesFundDataForm.accountFee" placeholder="请输入客户手续费包含交割手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="汇兑手续费" prop="exchangeFee">
              <el-input v-model="esNpfuturesFundDataForm.exchangeFee" placeholder="请输入汇兑手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户交割手续费" prop="accountDeliveryFee">
              <el-input v-model="esNpfuturesFundDataForm.accountDeliveryFee" placeholder="请输入客户交割手续费"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="权利金收取" prop="premiumIncome">
              <el-input v-model="esNpfuturesFundDataForm.premiumIncome" placeholder="请输入权利金收取"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="权利金支付" prop="premiumPay">
              <el-input v-model="esNpfuturesFundDataForm.premiumPay" placeholder="请输入权利金支付"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="esNpfuturesFundDataForm.closeProfit" placeholder="请输入平仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交割盈亏" prop="deliveryProfit">
              <el-input v-model="esNpfuturesFundDataForm.deliveryProfit" placeholder="请输入交割盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="未到期平盈" prop="unExpProfit">
              <el-input v-model="esNpfuturesFundDataForm.unExpProfit" placeholder="请输入未到期平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="到期平仓盈亏" prop="expProfit">
              <el-input v-model="esNpfuturesFundDataForm.expProfit" placeholder="请输入到期平仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="不含LME持仓盈亏" prop="positionProfit">
              <el-input v-model="esNpfuturesFundDataForm.positionProfit" placeholder="请输入不含LME持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME持仓盈亏" prop="lmePositionProfit">
              <el-input v-model="esNpfuturesFundDataForm.lmePositionProfit" placeholder="请输入LME持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="esNpfuturesFundDataForm.optionMarketValue" placeholder="请输入期权市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户初始保证金" prop="accountIntialMargin">
              <el-input v-model="esNpfuturesFundDataForm.accountIntialMargin" placeholder="请输入客户初始保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="esNpfuturesFundDataForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手初始保证金" prop="upperInitalMargin">
              <el-input v-model="esNpfuturesFundDataForm.upperInitalMargin" placeholder="请输入上手初始保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
            <el-input v-model="esNpfuturesFundDataForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME贴现" prop="discount">
              <el-input v-model="esNpfuturesFundDataForm.discount" placeholder="请输入LME贴现"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当日结存" prop="balance">
              <el-input v-model="esNpfuturesFundDataForm.balance" placeholder="请输入当日结存"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="当日权益" prop="equity">
              <el-input v-model="esNpfuturesFundDataForm.equity" placeholder="请输入当日权益"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当日可用" prop="available">
              <el-input v-model="esNpfuturesFundDataForm.available" placeholder="请输入当日可用"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可提取" prop="canDraw">
              <el-input v-model="esNpfuturesFundDataForm.canDraw" placeholder="请输入可提取"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="账户市值" prop="marketEquity">
              <el-input v-model="esNpfuturesFundDataForm.marketEquity" placeholder="请输入账户市值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种原始出入金" prop="originalCashInOut">
              <el-input v-model="esNpfuturesFundDataForm.originalCashInOut" placeholder="请输入币种原始出入金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐笔浮盈" prop="floatingPL">
              <el-input v-model="esNpfuturesFundDataForm.floatingPL" placeholder="请输入逐笔浮盈"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="风险冻结资金" prop="frozenRiskFundValue">
              <el-input v-model="esNpfuturesFundDataForm.frozenRiskFundValue" placeholder="请输入风险冻结资金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐笔平盈" prop="closePL">
              <el-input v-model="esNpfuturesFundDataForm.closePL" placeholder="请输入逐笔平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="非货币质押" prop="noCurrencyPledgeValue">
              <el-input v-model="esNpfuturesFundDataForm.noCurrencyPledgeValue" placeholder="请输入非货币质押"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="期初质押" prop="prePledgeValue">
              <el-input v-model="esNpfuturesFundDataForm.prePledgeValue" placeholder="请输入期初质押"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="质入" prop="pledgeIn">
              <el-input v-model="esNpfuturesFundDataForm.pledgeIn" placeholder="请输入质入"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="质出" prop="pledgeOut">
              <el-input v-model="esNpfuturesFundDataForm.pledgeOut" placeholder="请输入质出"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="质押余额" prop="pledgeValue">
              <el-input v-model="esNpfuturesFundDataForm.pledgeValue" placeholder="请输入质押余额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="借用金额" prop="borrowValue">
              <el-input v-model="esNpfuturesFundDataForm.borrowValue" placeholder="请输入借用金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品冻结保证金" prop="specialAccountFrozenMargin">
              <el-input v-model="esNpfuturesFundDataForm.specialAccountFrozenMargin" placeholder="请输入特殊产品冻结保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品保证金" prop="specialAccountMargin">
              <el-input v-model="esNpfuturesFundDataForm.specialAccountMargin" placeholder="请输入特殊产品保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品冻结手续费" prop="specialAccountFrozenFee">
              <el-input v-model="esNpfuturesFundDataForm.specialAccountFrozenFee" placeholder="请输入特殊产品冻结手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品手续费" prop="specialAccountFee">
              <el-input v-model="esNpfuturesFundDataForm.specialAccountFee" placeholder="请输入特殊产品手续费"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品浮盈" prop="specialFloatProfit">
              <el-input v-model="esNpfuturesFundDataForm.specialFloatProfit" placeholder="请输入特殊产品浮盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="特殊产品平盈" prop="specialCloseProfit">
              <el-input v-model="esNpfuturesFundDataForm.specialCloseProfit" placeholder="请输入特殊产品平盈"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"> <el-form-item label="特殊产品逐笔浮盈" prop="specialFloatPL">
            <el-input v-model="esNpfuturesFundDataForm.specialFloatPL" placeholder="请输入特殊产品逐笔浮盈"/>
          </el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="特殊产品逐笔平盈" prop="specialClosePL">
              <el-input v-model="esNpfuturesFundDataForm.specialClosePL" placeholder="请输入特殊产品逐笔平盈"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item>
              <el-button type="success" @click="doSubmit('esNpfuturesFundDataForm')">提交</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesFundDataName',
    data() {
      return {
        esNpfuturesFundDataLoading: true,
        esNpfuturesFundDataDialog: false,
        esNpfuturesFundDataData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesFundDataForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'parentAccountNo': '',
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
          'exchangeFee': '',
          'accountDeliveryFee': '',
          'premiumIncome': '',
          'premiumPay': '',
          'closeProfit': '',
          'deliveryProfit': '',
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
          'originalCashInOut': '',
          'floatingPL': '',
          'frozenRiskFundValue': '',
          'closePL': '',
          'noCurrencyPledgeValue': '',
          'prePledgeValue': '',
          'pledgeIn': '',
          'pledgeOut': '',
          'pledgeValue': '',
          'borrowValue': '',
          'specialAccountFrozenMargin': '',
          'specialAccountMargin': '',
          'specialAccountFrozenFee': '',
          'specialAccountFee': '',
          'specialFloatProfit': '',
          'specialCloseProfit': '',
          'specialFloatPL': '',
          'specialClosePL': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesFundDataRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '客户资金账号不可为空', trigger: 'change' }
          ],
          currencyGroupNo: [
            { required: true, message: '币种组号不可为空', trigger: 'change' }
          ],
          currencyNo: [
            { required: true, message: '币种号(为空表示币种组基币资金)不可为空', trigger: 'change' }
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
          exchangeFee: [
            { required: true, message: '汇兑手续费不可为空', trigger: 'change' }
          ],
          accountDeliveryFee: [
            { required: true, message: '客户交割手续费不可为空', trigger: 'change' }
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
          deliveryProfit: [
            { required: true, message: '交割盈亏不可为空', trigger: 'change' }
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
          originalCashInOut: [
            { required: true, message: '币种原始出入金不可为空', trigger: 'change' }
          ],
          floatingPL: [
            { required: true, message: '逐笔浮盈不可为空', trigger: 'change' }
          ],
          frozenRiskFundValue: [
            { required: true, message: '风险冻结资金不可为空', trigger: 'change' }
          ],
          closePL: [
            { required: true, message: '逐笔平盈不可为空', trigger: 'change' }
          ],
          noCurrencyPledgeValue: [
            { required: true, message: '非货币质押不可为空', trigger: 'change' }
          ],
          prePledgeValue: [
            { required: true, message: '期初质押不可为空', trigger: 'change' }
          ],
          pledgeIn: [
            { required: true, message: '质入不可为空', trigger: 'change' }
          ],
          pledgeOut: [
            { required: true, message: '质出不可为空', trigger: 'change' }
          ],
          pledgeValue: [
            { required: true, message: '质押余额不可为空', trigger: 'change' }
          ],
          borrowValue: [
            { required: true, message: '借用金额不可为空', trigger: 'change' }
          ],
          specialAccountFrozenMargin: [
            { required: true, message: '特殊产品冻结保证金不可为空', trigger: 'change' }
          ],
          specialAccountMargin: [
            { required: true, message: '特殊产品保证金不可为空', trigger: 'change' }
          ],
          specialAccountFrozenFee: [
            { required: true, message: '特殊产品冻结手续费不可为空', trigger: 'change' }
          ],
          specialAccountFee: [
            { required: true, message: '特殊产品手续费不可为空', trigger: 'change' }
          ],
          specialFloatProfit: [
            { required: true, message: '特殊产品浮盈不可为空', trigger: 'change' }
          ],
          specialCloseProfit: [
            { required: true, message: '特殊产品平盈不可为空', trigger: 'change' }
          ],
          specialFloatPL: [
            { required: true, message: '特殊产品逐笔浮盈不可为空', trigger: 'change' }
          ],
          specialClosePL: [
            { required: true, message: '特殊产品逐笔平盈不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesFundData',
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
        this.esNpfuturesFundDataLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesFundData/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesFundDataData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesFundDataLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesFundDataForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'parentAccountNo': '',
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
          'exchangeFee': '',
          'accountDeliveryFee': '',
          'premiumIncome': '',
          'premiumPay': '',
          'closeProfit': '',
          'deliveryProfit': '',
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
          'originalCashInOut': '',
          'floatingPL': '',
          'frozenRiskFundValue': '',
          'closePL': '',
          'noCurrencyPledgeValue': '',
          'prePledgeValue': '',
          'pledgeIn': '',
          'pledgeOut': '',
          'pledgeValue': '',
          'borrowValue': '',
          'specialAccountFrozenMargin': '',
          'specialAccountMargin': '',
          'specialAccountFrozenFee': '',
          'specialAccountFee': '',
          'specialFloatProfit': '',
          'specialCloseProfit': '',
          'specialFloatPL': '',
          'specialClosePL': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesFundDataDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesFundDataForm) {
          this.$refs.esNpfuturesFundDataForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesFundData/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesFundDataForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'parentAccountNo': res.object.parentAccountNo,
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
              'exchangeFee': res.object.exchangeFee,
              'accountDeliveryFee': res.object.accountDeliveryFee,
              'premiumIncome': res.object.premiumIncome,
              'premiumPay': res.object.premiumPay,
              'closeProfit': res.object.closeProfit,
              'deliveryProfit': res.object.deliveryProfit,
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
              'originalCashInOut': res.object.originalCashInOut,
              'floatingPL': res.object.floatingPL,
              'frozenRiskFundValue': res.object.frozenRiskFundValue,
              'closePL': res.object.closePL,
              'noCurrencyPledgeValue': res.object.noCurrencyPledgeValue,
              'prePledgeValue': res.object.prePledgeValue,
              'pledgeIn': res.object.pledgeIn,
              'pledgeOut': res.object.pledgeOut,
              'pledgeValue': res.object.pledgeValue,
              'borrowValue': res.object.borrowValue,
              'specialAccountFrozenMargin': res.object.specialAccountFrozenMargin,
              'specialAccountMargin': res.object.specialAccountMargin,
              'specialAccountFrozenFee': res.object.specialAccountFrozenFee,
              'specialAccountFee': res.object.specialAccountFee,
              'specialFloatProfit': res.object.specialFloatProfit,
              'specialCloseProfit': res.object.specialCloseProfit,
              'specialFloatPL': res.object.specialFloatPL,
              'specialClosePL': res.object.specialClosePL
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesFundDataDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesFundData/save',
              method: 'post',
              data: this.esNpfuturesFundDataForm
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
            this.esNpfuturesFundDataDialog = false;
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
            url: '/npfutures/esNpfuturesFundData/del',
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
  .esNpfuturesFundDataForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
