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
      <el-form-item label="合约1">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约1"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesPositionInfoLoading" :data="esNpfuturesPositionInfoData"
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
      <el-table-column prop="contractNo" label="合约1"/>
      <el-table-column prop="strikePrice" label="执行价格"/>
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat"/>
      <el-table-column prop="exchangeNoRef" label="交易所编号"/>
      <el-table-column prop="commodityTypeRef" label="品种类型"/>
      <el-table-column prop="commodityNoRef" label="品种编码类型"/>
      <el-table-column prop="contractNoRef" label="合约"/>
      <el-table-column prop="strikePriceRef" label="执行价格"/>
      <el-table-column prop="callOrPutFlagRef" label="看张看跌"/>
      <el-table-column prop="orderExchangeNo" label="交易所编号"/>
      <el-table-column prop="orderCommodityType" label="品种类型"/>
      <el-table-column prop="orderCommodityNo" label="品种编码类型"/>
      <el-table-column prop="orderType" label="委托类型" :formatter="statusFormat"/>
      <el-table-column prop="matchSource" label="委托来源" :formatter="statusFormat"/>
      <el-table-column prop="timeInForce" label="委托有效类型" :formatter="statusFormat"/>
      <el-table-column prop="expireTime" label="有效日期(GTD情况下使用)"/>
      <el-table-column prop="matchSide" label="买入卖出" :formatter="statusFormat"/>
      <el-table-column prop="hedgeFlag" label="投机保值" :formatter="statusFormat"/>
      <el-table-column prop="positionNo" label="本地持仓号，服务器编写"/>
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat"/>
      <el-table-column prop="orderNo" label="委托编码"/>
      <el-table-column prop="matchNo" label="本地成交号"/>
      <el-table-column prop="exchangeMatchNo" label="交易所成交号"/>
      <el-table-column prop="matchDate" label="成交日期"/>
      <el-table-column prop="matchTime" label="成交时间"/>
      <el-table-column prop="upperMatchTime" label="上手成交时间"/>
      <el-table-column prop="upperNo" label="上手号"/>
      <el-table-column prop="upperSettleNo" label="会员号和清算代码"/>
      <el-table-column prop="upperUserNo" label="上手登录号"/>
      <el-table-column prop="tradeNo" label="交易编码"/>
      <el-table-column prop="positionPrice" label="持仓价"/>
      <el-table-column prop="positionQty" label="持仓量"/>
      <el-table-column prop="isBackInput" label="是否为录入委托单" :formatter="statusFormat"/>
      <el-table-column prop="isAddOne" label="是否为T+1单" :formatter="statusFormat"/>
      <el-table-column prop="matchStreamID" label="成交流水号"/>
      <el-table-column prop="positionStreamId" label="持仓流号"/>
      <el-table-column prop="openCloseMode" label="开平方式"/>
      <el-table-column prop="contractSize" label="每手乘数，计算参数"/>
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组"/>
      <el-table-column prop="commodityCurrency" label="品种币种"/>
      <el-table-column prop="preSettlePrice" label="昨结算价"/>
      <el-table-column prop="settlePrice" label="当前计算价格"/>
      <el-table-column prop="turnover" label="持仓金额"/>
      <el-table-column prop="accountMarginMode" label="保证金计算方式"/>
      <el-table-column prop="accountMarginParam" label="保证金参数值"/>
      <el-table-column prop="upperMarginMode" label="保证金计算方式"/>
      <el-table-column prop="upperMarginParam" label="保证金参数值"/>
      <el-table-column prop="accountInitialMargin" label="客户初始保证金"/>
      <el-table-column prop="accountMaintenanceMargin" label="客户维持保证金"/>
      <el-table-column prop="upperInitialMargin" label="上手初始保证金"/>
      <el-table-column prop="upperMaintenanceMargin" label="上手维持保证金"/>
      <el-table-column prop="positionProfit" label="持仓盈亏"/>
      <el-table-column prop="lMEPositionProfit" label="LME持仓盈亏"/>
      <el-table-column prop="optionMarketValue" label="期权市值"/>
      <el-table-column prop="matchCmbNo" label="组合持仓号"/>
      <el-table-column prop="isHistory" label="是否历史持仓" :formatter="statusFormat"/>
      <el-table-column prop="floatingPL" label="逐笔浮盈"/>
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
    <el-dialog title="内盘期货持仓明细表管理" :visible.sync="esNpfuturesPositionInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesPositionInfoForm" :model="esNpfuturesPositionInfoForm"
               :rules="esNpfuturesPositionInfoRules" label-width="150px" class="esNpfuturesPositionInfoForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="esNpfuturesPositionInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="esNpfuturesPositionInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="esNpfuturesPositionInfoForm.accountNo" placeholder="请输入客户资金帐号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上级资金账号" prop="parentAccountNo">
              <el-input v-model="esNpfuturesPositionInfoForm.parentAccountNo" placeholder="请输入上级资金账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="esNpfuturesPositionInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="esNpfuturesPositionInfoForm.contractNo" placeholder="请输入合约1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="esNpfuturesPositionInfoForm.strikePrice" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-input v-model="esNpfuturesPositionInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNoRef">
              <el-input v-model="esNpfuturesPositionInfoForm.exchangeNoRef" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityTypeRef">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityTypeRef" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNoRef">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityNoRef" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约" prop="contractNoRef">
              <el-input v-model="esNpfuturesPositionInfoForm.contractNoRef" placeholder="请输入合约"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePriceRef">
              <el-input v-model="esNpfuturesPositionInfoForm.strikePriceRef" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlagRef">
              <el-input v-model="esNpfuturesPositionInfoForm.callOrPutFlagRef" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="orderExchangeNo">
              <el-input v-model="esNpfuturesPositionInfoForm.orderExchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="orderCommodityType">
              <el-input v-model="esNpfuturesPositionInfoForm.orderCommodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="orderCommodityNo">
              <el-input v-model="esNpfuturesPositionInfoForm.orderCommodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托类型" prop="orderType">
              <el-input v-model="esNpfuturesPositionInfoForm.orderType" placeholder="请输入委托类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托来源" prop="matchSource">
              <el-input v-model="esNpfuturesPositionInfoForm.matchSource" placeholder="请输入委托来源"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托有效类型" prop="timeInForce">
              <el-input v-model="esNpfuturesPositionInfoForm.timeInForce" placeholder="请输入委托有效类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="有效日期(GTD情况下使用)" prop="expireTime">
              <el-input v-model="esNpfuturesPositionInfoForm.expireTime" placeholder="请输入有效日期(GTD情况下使用)"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买入卖出" prop="matchSide">
              <el-input v-model="esNpfuturesPositionInfoForm.matchSide" placeholder="请输入买入卖出"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-input v-model="esNpfuturesPositionInfoForm.hedgeFlag" placeholder="请输入投机保值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地持仓号，服务器编写" prop="positionNo">
              <el-input v-model="esNpfuturesPositionInfoForm.positionNo" placeholder="请输入本地持仓号，服务器编写"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="esNpfuturesPositionInfoForm.serverFlag" placeholder="请输入服务器标识"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="esNpfuturesPositionInfoForm.orderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地成交号" prop="matchNo">
              <el-input v-model="esNpfuturesPositionInfoForm.matchNo" placeholder="请输入本地成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所成交号" prop="exchangeMatchNo">
              <el-input v-model="esNpfuturesPositionInfoForm.exchangeMatchNo" placeholder="请输入交易所成交号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交日期" prop="matchDate">
              <el-input v-model="esNpfuturesPositionInfoForm.matchDate" placeholder="请输入成交日期"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交时间" prop="matchTime">
              <el-input v-model="esNpfuturesPositionInfoForm.matchTime" placeholder="请输入成交时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手成交时间" prop="upperMatchTime">
              <el-input v-model="esNpfuturesPositionInfoForm.upperMatchTime" placeholder="请输入上手成交时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="esNpfuturesPositionInfoForm.upperNo" placeholder="请输入上手号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="会员号和清算代码" prop="upperSettleNo">
              <el-input v-model="esNpfuturesPositionInfoForm.upperSettleNo" placeholder="请输入会员号和清算代码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手登录号" prop="upperUserNo">
              <el-input v-model="esNpfuturesPositionInfoForm.upperUserNo" placeholder="请输入上手登录号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易编码" prop="tradeNo">
              <el-input v-model="esNpfuturesPositionInfoForm.tradeNo" placeholder="请输入交易编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓价" prop="positionPrice">
              <el-input v-model="esNpfuturesPositionInfoForm.positionPrice" placeholder="请输入持仓价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓量" prop="positionQty">
              <el-input v-model="esNpfuturesPositionInfoForm.positionQty" placeholder="请输入持仓量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="是否为录入委托单" prop="isBackInput">
              <el-input v-model="esNpfuturesPositionInfoForm.isBackInput" placeholder="请输入是否为录入委托单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为T+1单" prop="isAddOne">
              <el-input v-model="esNpfuturesPositionInfoForm.isAddOne" placeholder="请输入是否为T+1单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交流水号" prop="matchStreamID">
              <el-input v-model="esNpfuturesPositionInfoForm.matchStreamID" placeholder="请输入成交流水号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓流号" prop="positionStreamId">
              <el-input v-model="esNpfuturesPositionInfoForm.positionStreamId" placeholder="请输入持仓流号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平方式" prop="openCloseMode">
              <el-input v-model="esNpfuturesPositionInfoForm.openCloseMode" placeholder="请输入开平方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数，计算参数" prop="contractSize">
              <el-input v-model="esNpfuturesPositionInfoForm.contractSize" placeholder="请输入每手乘数，计算参数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="esNpfuturesPositionInfoForm.commodityCurrency" placeholder="请输入品种币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨结算价" prop="preSettlePrice">
              <el-input v-model="esNpfuturesPositionInfoForm.preSettlePrice" placeholder="请输入昨结算价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="当前计算价格" prop="settlePrice">
              <el-input v-model="esNpfuturesPositionInfoForm.settlePrice" placeholder="请输入当前计算价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓金额" prop="turnover">
              <el-input v-model="esNpfuturesPositionInfoForm.turnover" placeholder="请输入持仓金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金计算方式" prop="accountMarginMode">
              <el-input v-model="esNpfuturesPositionInfoForm.accountMarginMode" placeholder="请输入保证金计算方式"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="保证金参数值" prop="accountMarginParam">
              <el-input v-model="esNpfuturesPositionInfoForm.accountMarginParam" placeholder="请输入保证金参数值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金计算方式" prop="upperMarginMode">
              <el-input v-model="esNpfuturesPositionInfoForm.upperMarginMode" placeholder="请输入保证金计算方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金参数值" prop="upperMarginParam">
              <el-input v-model="esNpfuturesPositionInfoForm.upperMarginParam" placeholder="请输入保证金参数值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户初始保证金" prop="accountInitialMargin">
              <el-input v-model="esNpfuturesPositionInfoForm.accountInitialMargin" placeholder="请输入客户初始保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="esNpfuturesPositionInfoForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手初始保证金" prop="upperInitialMargin">
              <el-input v-model="esNpfuturesPositionInfoForm.upperInitialMargin" placeholder="请输入上手初始保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
              <el-input v-model="esNpfuturesPositionInfoForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓盈亏" prop="positionProfit">
              <el-input v-model="esNpfuturesPositionInfoForm.positionProfit" placeholder="请输入持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME持仓盈亏" prop="lMEPositionProfit">
              <el-input v-model="esNpfuturesPositionInfoForm.lMEPositionProfit" placeholder="请输入LME持仓盈亏"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="esNpfuturesPositionInfoForm.optionMarketValue" placeholder="请输入期权市值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="组合持仓号" prop="matchCmbNo">
              <el-input v-model="esNpfuturesPositionInfoForm.matchCmbNo" placeholder="请输入组合持仓号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否历史持仓" prop="isHistory">
              <el-input v-model="esNpfuturesPositionInfoForm.isHistory" placeholder="请输入是否历史持仓"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="逐笔浮盈" prop="floatingPL">
              <el-input v-model="esNpfuturesPositionInfoForm.floatingPL" placeholder="请输入逐笔浮盈"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesPositionInfoName',
    data() {
      return {
        esNpfuturesPositionInfoLoading: true,
        esNpfuturesPositionInfoDialog: false,
        esNpfuturesPositionInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesPositionInfoForm: {
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
          'exchangeNoRef': '',
          'commodityTypeRef': '',
          'commodityNoRef': '',
          'contractNoRef': '',
          'strikePriceRef': '',
          'callOrPutFlagRef': '',
          'orderExchangeNo': '',
          'orderCommodityType': '',
          'orderCommodityNo': '',
          'orderType': '',
          'matchSource': '',
          'timeInForce': '',
          'expireTime': '',
          'matchSide': '',
          'hedgeFlag': '',
          'positionNo': '',
          'serverFlag': '',
          'orderNo': '',
          'matchNo': '',
          'exchangeMatchNo': '',
          'matchDate': '',
          'matchTime': '',
          'upperMatchTime': '',
          'upperNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'tradeNo': '',
          'positionPrice': '',
          'positionQty': '',
          'isBackInput': '',
          'isAddOne': '',
          'matchStreamID': '',
          'positionStreamId': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'preSettlePrice': '',
          'settlePrice': '',
          'turnover': '',
          'accountMarginMode': '',
          'accountMarginParam': '',
          'upperMarginMode': '',
          'upperMarginParam': '',
          'accountInitialMargin': '',
          'accountMaintenanceMargin': '',
          'upperInitialMargin': '',
          'upperMaintenanceMargin': '',
          'positionProfit': '',
          'lMEPositionProfit': '',
          'optionMarketValue': '',
          'matchCmbNo': '',
          'isHistory': '',
          'floatingPL': ''
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
        esNpfuturesPositionInfoRules: {
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
            { required: true, message: '合约1不可为空', trigger: 'change' }
          ],
          strikePrice: [
            { required: true, message: '执行价格不可为空', trigger: 'change' }
          ],
          callOrPutFlag: [
            { required: true, message: '看张看跌不可为空', trigger: 'change' }
          ],
          exchangeNoRef: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          commodityTypeRef: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNoRef: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          contractNoRef: [
            { required: true, message: '合约不可为空', trigger: 'change' }
          ],
          strikePriceRef: [
            { required: true, message: '执行价格不可为空', trigger: 'change' }
          ],
          callOrPutFlagRef: [
            { required: true, message: '看张看跌不可为空', trigger: 'change' }
          ],
          orderExchangeNo: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          orderCommodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          orderCommodityNo: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          orderType: [
            { required: true, message: '委托类型不可为空', trigger: 'change' }
          ],
          matchSource: [
            { required: true, message: '委托来源不可为空', trigger: 'change' }
          ],
          timeInForce: [
            { required: true, message: '委托有效类型不可为空', trigger: 'change' }
          ],
          expireTime: [
            { required: true, message: '有效日期(GTD情况下使用)不可为空', trigger: 'change' }
          ],
          matchSide: [
            { required: true, message: '买入卖出不可为空', trigger: 'change' }
          ],
          hedgeFlag: [
            { required: true, message: '投机保值不可为空', trigger: 'change' }
          ],
          positionNo: [
            { required: true, message: '本地持仓号，服务器编写不可为空', trigger: 'change' }
          ],
          serverFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          orderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          matchNo: [
            { required: true, message: '本地成交号不可为空', trigger: 'change' }
          ],
          exchangeMatchNo: [
            { required: true, message: '交易所成交号不可为空', trigger: 'change' }
          ],
          matchDate: [
            { required: true, message: '成交日期不可为空', trigger: 'change' }
          ],
          matchTime: [
            { required: true, message: '成交时间不可为空', trigger: 'change' }
          ],
          upperMatchTime: [
            { required: true, message: '上手成交时间不可为空', trigger: 'change' }
          ],
          upperNo: [
            { required: true, message: '上手号不可为空', trigger: 'change' }
          ],
          upperSettleNo: [
            { required: true, message: '会员号和清算代码不可为空', trigger: 'change' }
          ],
          upperUserNo: [
            { required: true, message: '上手登录号不可为空', trigger: 'change' }
          ],
          tradeNo: [
            { required: true, message: '交易编码不可为空', trigger: 'change' }
          ],
          positionPrice: [
            { required: true, message: '持仓价不可为空', trigger: 'change' }
          ],
          positionQty: [
            { required: true, message: '持仓量不可为空', trigger: 'change' }
          ],
          isBackInput: [
            { required: true, message: '是否为录入委托单不可为空', trigger: 'change' }
          ],
          isAddOne: [
            { required: true, message: '是否为T+1单不可为空', trigger: 'change' }
          ],
          matchStreamID: [
            { required: true, message: '成交流水号不可为空', trigger: 'change' }
          ],
          positionStreamId: [
            { required: true, message: '持仓流号不可为空', trigger: 'change' }
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
          settlePrice: [
            { required: true, message: '当前计算价格不可为空', trigger: 'change' }
          ],
          turnover: [
            { required: true, message: '持仓金额不可为空', trigger: 'change' }
          ],
          accountMarginMode: [
            { required: true, message: '保证金计算方式不可为空', trigger: 'change' }
          ],
          accountMarginParam: [
            { required: true, message: '保证金参数值不可为空', trigger: 'change' }
          ],
          upperMarginMode: [
            { required: true, message: '保证金计算方式不可为空', trigger: 'change' }
          ],
          upperMarginParam: [
            { required: true, message: '保证金参数值不可为空', trigger: 'change' }
          ],
          accountInitialMargin: [
            { required: true, message: '客户初始保证金不可为空', trigger: 'change' }
          ],
          accountMaintenanceMargin: [
            { required: true, message: '客户维持保证金不可为空', trigger: 'change' }
          ],
          upperInitialMargin: [
            { required: true, message: '上手初始保证金不可为空', trigger: 'change' }
          ],
          upperMaintenanceMargin: [
            { required: true, message: '上手维持保证金不可为空', trigger: 'change' }
          ],
          positionProfit: [
            { required: true, message: '持仓盈亏不可为空', trigger: 'change' }
          ],
          lMEPositionProfit: [
            { required: true, message: 'LME持仓盈亏不可为空', trigger: 'change' }
          ],
          optionMarketValue: [
            { required: true, message: '期权市值不可为空', trigger: 'change' }
          ],
          matchCmbNo: [
            { required: true, message: '组合持仓号不可为空', trigger: 'change' }
          ],
          isHistory: [
            { required: true, message: '是否历史持仓不可为空', trigger: 'change' }
          ],
          floatingPL: [
            { required: true, message: '逐笔浮盈不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesPositionInfo',
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
        this.esNpfuturesPositionInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesPositionInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesPositionInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesPositionInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesPositionInfoForm = {
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
          'exchangeNoRef': '',
          'commodityTypeRef': '',
          'commodityNoRef': '',
          'contractNoRef': '',
          'strikePriceRef': '',
          'callOrPutFlagRef': '',
          'orderExchangeNo': '',
          'orderCommodityType': '',
          'orderCommodityNo': '',
          'orderType': '',
          'matchSource': '',
          'timeInForce': '',
          'expireTime': '',
          'matchSide': '',
          'hedgeFlag': '',
          'positionNo': '',
          'serverFlag': '',
          'orderNo': '',
          'matchNo': '',
          'exchangeMatchNo': '',
          'matchDate': '',
          'matchTime': '',
          'upperMatchTime': '',
          'upperNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'tradeNo': '',
          'positionPrice': '',
          'positionQty': '',
          'isBackInput': '',
          'isAddOne': '',
          'matchStreamID': '',
          'positionStreamId': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'preSettlePrice': '',
          'settlePrice': '',
          'turnover': '',
          'accountMarginMode': '',
          'accountMarginParam': '',
          'upperMarginMode': '',
          'upperMarginParam': '',
          'accountInitialMargin': '',
          'accountMaintenanceMargin': '',
          'upperInitialMargin': '',
          'upperMaintenanceMargin': '',
          'positionProfit': '',
          'lMEPositionProfit': '',
          'optionMarketValue': '',
          'matchCmbNo': '',
          'isHistory': '',
          'floatingPL': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesPositionInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesPositionInfoForm) {
          this.$refs.esNpfuturesPositionInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesPositionInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesPositionInfoForm = {
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
              'exchangeNoRef': res.object.exchangeNoRef,
              'commodityTypeRef': res.object.commodityTypeRef,
              'commodityNoRef': res.object.commodityNoRef,
              'contractNoRef': res.object.contractNoRef,
              'strikePriceRef': res.object.strikePriceRef,
              'callOrPutFlagRef': res.object.callOrPutFlagRef,
              'orderExchangeNo': res.object.orderExchangeNo,
              'orderCommodityType': res.object.orderCommodityType,
              'orderCommodityNo': res.object.orderCommodityNo,
              'orderType': res.object.orderType,
              'matchSource': res.object.matchSource,
              'timeInForce': res.object.timeInForce,
              'expireTime': res.object.expireTime,
              'matchSide': res.object.matchSide,
              'hedgeFlag': res.object.hedgeFlag,
              'positionNo': res.object.positionNo,
              'serverFlag': res.object.serverFlag,
              'orderNo': res.object.orderNo,
              'matchNo': res.object.matchNo,
              'exchangeMatchNo': res.object.exchangeMatchNo,
              'matchDate': res.object.matchDate,
              'matchTime': res.object.matchTime,
              'upperMatchTime': res.object.upperMatchTime,
              'upperNo': res.object.upperNo,
              'upperSettleNo': res.object.upperSettleNo,
              'upperUserNo': res.object.upperUserNo,
              'tradeNo': res.object.tradeNo,
              'positionPrice': res.object.positionPrice,
              'positionQty': res.object.positionQty,
              'isBackInput': res.object.isBackInput,
              'isAddOne': res.object.isAddOne,
              'matchStreamID': res.object.matchStreamID,
              'positionStreamId': res.object.positionStreamId,
              'openCloseMode': res.object.openCloseMode,
              'contractSize': res.object.contractSize,
              'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
              'commodityCurrency': res.object.commodityCurrency,
              'preSettlePrice': res.object.preSettlePrice,
              'settlePrice': res.object.settlePrice,
              'turnover': res.object.turnover,
              'accountMarginMode': res.object.accountMarginMode,
              'accountMarginParam': res.object.accountMarginParam,
              'upperMarginMode': res.object.upperMarginMode,
              'upperMarginParam': res.object.upperMarginParam,
              'accountInitialMargin': res.object.accountInitialMargin,
              'accountMaintenanceMargin': res.object.accountMaintenanceMargin,
              'upperInitialMargin': res.object.upperInitialMargin,
              'upperMaintenanceMargin': res.object.upperMaintenanceMargin,
              'positionProfit': res.object.positionProfit,
              'lMEPositionProfit': res.object.lMEPositionProfit,
              'optionMarketValue': res.object.optionMarketValue,
              'matchCmbNo': res.object.matchCmbNo,
              'isHistory': res.object.isHistory,
              'floatingPL': res.object.floatingPL
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesPositionInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesPositionInfo/save',
              method: 'post',
              data: this.esNpfuturesPositionInfoForm
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
            this.esNpfuturesPositionInfoDialog = false;
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
            url: '/npfutures/esNpfuturesPositionInfo/del',
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
  .esNpfuturesPositionInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
