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
      <el-form-item label="合约1">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约1"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesFillInfoLoading" :data="esNpfuturesFillInfoData"
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
      <el-table-column prop="isRiskOrder" label="是否风险报单"/>
      <el-table-column prop="matchSide" label="买入卖出"/>
      <el-table-column prop="positionEffect" label="开平标志1" :formatter="statusFormat"/>
      <el-table-column prop="positionEffectRef" label="开平标志2"/>
      <el-table-column prop="hedgeFlag" label="投机保值"/>
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat"/>
      <el-table-column prop="orderNo" label="委托编码"/>
      <el-table-column prop="orderLocalNo" label="委托本地号"/>
      <el-table-column prop="matchNo" label="本地成交号"/>
      <el-table-column prop="exchangeMatchNo" label="交易所成交号"/>
      <el-table-column prop="matchDateTime" label="成交时间"/>
      <el-table-column prop="upperMatchDateTime" label="上手成交时间"/>
      <el-table-column prop="upperNo" label="上手号"/>
      <el-table-column prop="upperChannelNo" label="上手通道号"/>
      <el-table-column prop="upperSettleNo" label="会员号和清算代码"/>
      <el-table-column prop="upperUserNo" label="上手登录号"/>
      <el-table-column prop="tradeNo" label="交易编码"/>
      <el-table-column prop="matchPrice" label="成交价"/>
      <el-table-column prop="matchQty" label="成交量"/>
      <el-table-column prop="isBackInput" label="是否为录入委托单"/>
      <el-table-column prop="isDeleted" label="委托成交删除标" :formatter="statusFormat"/>
      <el-table-column prop="isAddOne" label="是否为T+1单" :formatter="statusFormat"/>
      <el-table-column prop="matchStreamID" label="委托流水号"/>
      <el-table-column prop="upperStreamID" label="上手流号"/>
      <el-table-column prop="openCloseMode" label="开平方式"/>
      <el-table-column prop="contractSize" label="每手乘数，计算参数"/>
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组"/>
      <el-table-column prop="commodityCurrency" label="品种币种"/>
      <el-table-column prop="feeMode" label="手续费计算方式"/>
      <el-table-column prop="feeParam" label="手续费参数值 冻结手续费均按照开仓手续费计算"/>
      <el-table-column prop="feeCurrencyGroup" label="客户手续费币种组"/>
      <el-table-column prop="feeCurrency" label="客户手续费币种"/>
      <el-table-column prop="preSettlePrice" label="昨结算价"/>
      <el-table-column prop="feeValue" label="手续费"/>
      <el-table-column prop="isManualFee" label="人工客户手续费标记" :formatter="statusFormat"/>
      <el-table-column prop="turnover" label="成交金额"/>
      <el-table-column prop="premiumIncome" label="权利金收取"/>
      <el-table-column prop="premiumPay" label="权利金支付"/>
      <el-table-column prop="oppoMatchNo" label="对手本地成交号（开仓和平仓对应编号）"/>
      <el-table-column prop="closeProfit" label="平仓盈亏"/>
      <el-table-column prop="unExpProfit" label="未到期平盈"/>
      <el-table-column prop="upperMatchPrice" label="上手成交价"/>
      <el-table-column prop="quotePrice" label="当前行情价"/>
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
    <el-dialog title="内盘期货成交表管理" :visible.sync="esNpfuturesFillInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="esNpfuturesFillInfoForm" :model="esNpfuturesFillInfoForm" :rules="esNpfuturesFillInfoRules"
               label-width="150px" class="esNpfuturesFillInfoForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="esNpfuturesFillInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="esNpfuturesFillInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="esNpfuturesFillInfoForm.accountNo" placeholder="请输入客户资金帐号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上级资金账号" prop="parentAccountNo">
              <el-input v-model="esNpfuturesFillInfoForm.parentAccountNo" placeholder="请输入上级资金账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="esNpfuturesFillInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="esNpfuturesFillInfoForm.commodityType" clearable placeholder="请选择品种类型" value="">
                <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="esNpfuturesFillInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="esNpfuturesFillInfoForm.contractNo" placeholder="请输入合约1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="esNpfuturesFillInfoForm.strikePrice" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-input v-model="esNpfuturesFillInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNoRef">
              <el-input v-model="esNpfuturesFillInfoForm.exchangeNoRef" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityTypeRef">
              <el-input v-model="esNpfuturesFillInfoForm.commodityTypeRef" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNoRef">
              <el-input v-model="esNpfuturesFillInfoForm.commodityNoRef" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约" prop="contractNoRef">
              <el-input v-model="esNpfuturesFillInfoForm.contractNoRef" placeholder="请输入合约"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约" prop="contractNoRef">
              <el-input v-model="esNpfuturesFillInfoForm.contractNoRef" placeholder="请输入合约"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePriceRef">
              <el-input v-model="esNpfuturesFillInfoForm.strikePriceRef" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlagRef">
              <el-input v-model="esNpfuturesFillInfoForm.callOrPutFlagRef" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="orderExchangeNo">
              <el-input v-model="esNpfuturesFillInfoForm.orderExchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="品种类型" prop="orderCommodityType">
            <el-input v-model="esNpfuturesFillInfoForm.orderCommodityType" placeholder="请输入品种类型"/>
          </el-form-item>
          </el-col>
          <el-col :span="8"> <el-form-item label="品种编码类型" prop="orderCommodityNo">
            <el-input v-model="esNpfuturesFillInfoForm.orderCommodityNo" placeholder="请输入品种编码类型"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托类型" prop="orderType">
              <el-input v-model="esNpfuturesFillInfoForm.orderType" placeholder="请输入委托类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="委托来源" prop="matchSource">
            <el-input v-model="esNpfuturesFillInfoForm.matchSource" placeholder="请输入委托来源"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托有效类型" prop="timeInForce">
              <el-input v-model="esNpfuturesFillInfoForm.timeInForce" placeholder="请输入委托有效类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托有效类型" prop="timeInForce">
              <el-input v-model="esNpfuturesFillInfoForm.timeInForce" placeholder="请输入委托有效类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有效日期(GTD情况下使用)" prop="expireTime">
              <el-input v-model="esNpfuturesFillInfoForm.expireTime" placeholder="请输入有效日期(GTD情况下使用)"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否风险报单" prop="isRiskOrder">
              <el-input v-model="esNpfuturesFillInfoForm.isRiskOrder" placeholder="请输入是否风险报单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买入卖出" prop="matchSide">
              <el-input v-model="esNpfuturesFillInfoForm.matchSide" placeholder="请输入买入卖出"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开平标志1" prop="positionEffect">
              <el-input v-model="esNpfuturesFillInfoForm.positionEffect" placeholder="请输入开平标志1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平标志2" prop="positionEffectRef">
              <el-input v-model="esNpfuturesFillInfoForm.positionEffectRef" placeholder="请输入开平标志2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-input v-model="esNpfuturesFillInfoForm.hedgeFlag" placeholder="请输入投机保值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="esNpfuturesFillInfoForm.serverFlag" placeholder="请输入服务器标识"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="esNpfuturesFillInfoForm.orderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托本地号" prop="orderLocalNo">
              <el-input v-model="esNpfuturesFillInfoForm.orderLocalNo" placeholder="请输入委托本地号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="本地成交号" prop="matchNo">
              <el-input v-model="esNpfuturesFillInfoForm.matchNo" placeholder="请输入本地成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所成交号" prop="exchangeMatchNo">
              <el-input v-model="esNpfuturesFillInfoForm.exchangeMatchNo" placeholder="请输入交易所成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交时间" prop="matchDateTime">
              <el-input v-model="esNpfuturesFillInfoForm.matchDateTime" placeholder="请输入成交时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手成交时间" prop="upperMatchDateTime">
              <el-input v-model="esNpfuturesFillInfoForm.upperMatchDateTime" placeholder="请输入上手成交时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="esNpfuturesFillInfoForm.upperNo" placeholder="请输入上手号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手通道号" prop="upperChannelNo">
              <el-input v-model="esNpfuturesFillInfoForm.upperChannelNo" placeholder="请输入上手通道号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="会员号和清算代码" prop="upperSettleNo">
              <el-input v-model="esNpfuturesFillInfoForm.upperSettleNo" placeholder="请输入会员号和清算代码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手登录号" prop="upperUserNo">
              <el-input v-model="esNpfuturesFillInfoForm.upperUserNo" placeholder="请输入上手登录号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易编码" prop="tradeNo">
              <el-input v-model="esNpfuturesFillInfoForm.tradeNo" placeholder="请输入交易编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交价" prop="matchPrice">
              <el-input v-model="esNpfuturesFillInfoForm.matchPrice" placeholder="请输入成交价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交量" prop="matchQty">
              <el-input v-model="esNpfuturesFillInfoForm.matchQty" placeholder="请输入成交量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为录入委托单" prop="isBackInput">
              <el-input v-model="esNpfuturesFillInfoForm.isBackInput" placeholder="请输入是否为录入委托单"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托成交删除标" prop="isDeleted">
              <el-input v-model="esNpfuturesFillInfoForm.isDeleted" placeholder="请输入委托成交删除标"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为T+1单" prop="isAddOne">
              <el-input v-model="esNpfuturesFillInfoForm.isAddOne" placeholder="请输入是否为T+1单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托流水号" prop="matchStreamID">
              <el-input v-model="esNpfuturesFillInfoForm.matchStreamID" placeholder="请输入委托流水号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手流号" prop="upperStreamID">
              <el-input v-model="esNpfuturesFillInfoForm.upperStreamID" placeholder="请输入上手流号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平方式" prop="openCloseMode">
              <el-input v-model="esNpfuturesFillInfoForm.openCloseMode" placeholder="请输入开平方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数，计算参数" prop="contractSize">
              <el-input v-model="esNpfuturesFillInfoForm.contractSize" placeholder="请输入每手乘数，计算参数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="esNpfuturesFillInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="esNpfuturesFillInfoForm.commodityCurrency" placeholder="请输入品种币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费计算方式" prop="feeMode">
              <el-input v-model="esNpfuturesFillInfoForm.feeMode" placeholder="请输入手续费计算方式"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费参数值 冻结手续费均按照开仓手续费计算" prop="feeParam">
              <el-input v-model="esNpfuturesFillInfoForm.feeParam" placeholder="请输入手续费参数值 冻结手续费均按照开仓手续费计算"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户手续费币种组" prop="feeCurrencyGroup">
              <el-input v-model="esNpfuturesFillInfoForm.feeCurrencyGroup" placeholder="请输入客户手续费币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户手续费币种" prop="feeCurrency">
              <el-input v-model="esNpfuturesFillInfoForm.feeCurrency" placeholder="请输入客户手续费币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="昨结算价" prop="preSettlePrice">
              <el-input v-model="esNpfuturesFillInfoForm.preSettlePrice" placeholder="请输入昨结算价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费" prop="feeValue">
              <el-input v-model="esNpfuturesFillInfoForm.feeValue" placeholder="请输入手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="人工客户手续费标记" prop="isManualFee">
              <el-input v-model="esNpfuturesFillInfoForm.isManualFee" placeholder="请输入人工客户手续费标记"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="成交金额" prop="turnover">
            <el-input v-model="esNpfuturesFillInfoForm.turnover" placeholder="请输入成交金额"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="权利金收取" prop="premiumIncome">
              <el-input v-model="esNpfuturesFillInfoForm.premiumIncome" placeholder="请输入权利金收取"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="权利金支付" prop="premiumPay">
              <el-input v-model="esNpfuturesFillInfoForm.premiumPay" placeholder="请输入权利金支付"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="对手本地成交号（开仓和平仓对应编号）" prop="oppoMatchNo">
              <el-input v-model="esNpfuturesFillInfoForm.oppoMatchNo" placeholder="请输入对手本地成交号（开仓和平仓对应编号）"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平仓盈亏" prop="closeProfit">
              <el-input v-model="esNpfuturesFillInfoForm.closeProfit" placeholder="请输入平仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="未到期平盈" prop="unExpProfit">
              <el-input v-model="esNpfuturesFillInfoForm.unExpProfit" placeholder="请输入未到期平盈"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手成交价" prop="upperMatchPrice">
              <el-input v-model="esNpfuturesFillInfoForm.upperMatchPrice" placeholder="请输入上手成交价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当前行情价" prop="quotePrice">
              <el-input v-model="esNpfuturesFillInfoForm.quotePrice" placeholder="请输入当前行情价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="逐笔平盈" prop="closePL">
              <el-input v-model="esNpfuturesFillInfoForm.closePL" placeholder="请输入逐笔平盈"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesFillInfoName',
    data() {
      return {
        esNpfuturesFillInfoLoading: true,
        esNpfuturesFillInfoDialog: false,
        esNpfuturesFillInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesFillInfoForm: {
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
          'isRiskOrder': '',
          'matchSide': '',
          'positionEffect': '',
          'positionEffectRef': '',
          'hedgeFlag': '',
          'serverFlag': '',
          'orderNo': '',
          'orderLocalNo': '',
          'matchNo': '',
          'exchangeMatchNo': '',
          'matchDateTime': '',
          'upperMatchDateTime': '',
          'upperNo': '',
          'upperChannelNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'tradeNo': '',
          'matchPrice': '',
          'matchQty': '',
          'isBackInput': '',
          'isDeleted': '',
          'isAddOne': '',
          'matchStreamID': '',
          'upperStreamID': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'feeMode': '',
          'feeParam': '',
          'feeCurrencyGroup': '',
          'feeCurrency': '',
          'preSettlePrice': '',
          'feeValue': '',
          'isManualFee': '',
          'turnover': '',
          'premiumIncome': '',
          'premiumPay': '',
          'oppoMatchNo': '',
          'closeProfit': '',
          'unExpProfit': '',
          'upperMatchPrice': '',
          'quotePrice': '',
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
        esNpfuturesFillInfoRules: {
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
          isRiskOrder: [
            { required: true, message: '是否风险报单不可为空', trigger: 'change' }
          ],
          matchSide: [
            { required: true, message: '买入卖出不可为空', trigger: 'change' }
          ],
          positionEffect: [
            { required: true, message: '开平标志1不可为空', trigger: 'change' }
          ],
          positionEffectRef: [
            { required: true, message: '开平标志2不可为空', trigger: 'change' }
          ],
          hedgeFlag: [
            { required: true, message: '投机保值不可为空', trigger: 'change' }
          ],
          serverFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          orderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          orderLocalNo: [
            { required: true, message: '委托本地号不可为空', trigger: 'change' }
          ],
          matchNo: [
            { required: true, message: '本地成交号不可为空', trigger: 'change' }
          ],
          exchangeMatchNo: [
            { required: true, message: '交易所成交号不可为空', trigger: 'change' }
          ],
          matchDateTime: [
            { required: true, message: '成交时间不可为空', trigger: 'change' }
          ],
          upperMatchDateTime: [
            { required: true, message: '上手成交时间不可为空', trigger: 'change' }
          ],
          upperNo: [
            { required: true, message: '上手号不可为空', trigger: 'change' }
          ],
          upperChannelNo: [
            { required: true, message: '上手通道号不可为空', trigger: 'change' }
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
          matchPrice: [
            { required: true, message: '成交价不可为空', trigger: 'change' }
          ],
          matchQty: [
            { required: true, message: '成交量不可为空', trigger: 'change' }
          ],
          isBackInput: [
            { required: true, message: '是否为录入委托单不可为空', trigger: 'change' }
          ],
          isDeleted: [
            { required: true, message: '委托成交删除标不可为空', trigger: 'change' }
          ],
          isAddOne: [
            { required: true, message: '是否为T+1单不可为空', trigger: 'change' }
          ],
          matchStreamID: [
            { required: true, message: '委托流水号不可为空', trigger: 'change' }
          ],
          upperStreamID: [
            { required: true, message: '上手流号不可为空', trigger: 'change' }
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
          feeMode: [
            { required: true, message: '手续费计算方式不可为空', trigger: 'change' }
          ],
          feeParam: [
            { required: true, message: '手续费参数值 冻结手续费均按照开仓手续费计算不可为空', trigger: 'change' }
          ],
          feeCurrencyGroup: [
            { required: true, message: '客户手续费币种组不可为空', trigger: 'change' }
          ],
          feeCurrency: [
            { required: true, message: '客户手续费币种不可为空', trigger: 'change' }
          ],
          preSettlePrice: [
            { required: true, message: '昨结算价不可为空', trigger: 'change' }
          ],
          feeValue: [
            { required: true, message: '手续费不可为空', trigger: 'change' }
          ],
          isManualFee: [
            { required: true, message: '人工客户手续费标记不可为空', trigger: 'change' }
          ],
          turnover: [
            { required: true, message: '成交金额不可为空', trigger: 'change' }
          ],
          premiumIncome: [
            { required: true, message: '权利金收取不可为空', trigger: 'change' }
          ],
          premiumPay: [
            { required: true, message: '权利金支付不可为空', trigger: 'change' }
          ],
          oppoMatchNo: [
            { required: true, message: '对手本地成交号（开仓和平仓对应编号）不可为空', trigger: 'change' }
          ],
          closeProfit: [
            { required: true, message: '平仓盈亏不可为空', trigger: 'change' }
          ],
          unExpProfit: [
            { required: true, message: '未到期平盈不可为空', trigger: 'change' }
          ],
          upperMatchPrice: [
            { required: true, message: '上手成交价不可为空', trigger: 'change' }
          ],
          quotePrice: [
            { required: true, message: '当前行情价不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesFillInfo',
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
        this.esNpfuturesFillInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesFillInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesFillInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesFillInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesFillInfoForm = {
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
          'isRiskOrder': '',
          'matchSide': '',
          'positionEffect': '',
          'positionEffectRef': '',
          'hedgeFlag': '',
          'serverFlag': '',
          'orderNo': '',
          'orderLocalNo': '',
          'matchNo': '',
          'exchangeMatchNo': '',
          'matchDateTime': '',
          'upperMatchDateTime': '',
          'upperNo': '',
          'upperChannelNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'tradeNo': '',
          'matchPrice': '',
          'matchQty': '',
          'isBackInput': '',
          'isDeleted': '',
          'isAddOne': '',
          'matchStreamID': '',
          'upperStreamID': '',
          'openCloseMode': '',
          'contractSize': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'feeMode': '',
          'feeParam': '',
          'feeCurrencyGroup': '',
          'feeCurrency': '',
          'preSettlePrice': '',
          'feeValue': '',
          'isManualFee': '',
          'turnover': '',
          'premiumIncome': '',
          'premiumPay': '',
          'oppoMatchNo': '',
          'closeProfit': '',
          'unExpProfit': '',
          'upperMatchPrice': '',
          'quotePrice': '',
          'closePL': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesFillInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesFillInfoForm) {
          this.$refs.esNpfuturesFillInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesFillInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesFillInfoForm = {
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
              'isRiskOrder': res.object.isRiskOrder,
              'matchSide': res.object.matchSide,
              'positionEffect': res.object.positionEffect,
              'positionEffectRef': res.object.positionEffectRef,
              'hedgeFlag': res.object.hedgeFlag,
              'serverFlag': res.object.serverFlag,
              'orderNo': res.object.orderNo,
              'orderLocalNo': res.object.orderLocalNo,
              'matchNo': res.object.matchNo,
              'exchangeMatchNo': res.object.exchangeMatchNo,
              'matchDateTime': res.object.matchDateTime,
              'upperMatchDateTime': res.object.upperMatchDateTime,
              'upperNo': res.object.upperNo,
              'upperChannelNo': res.object.upperChannelNo,
              'upperSettleNo': res.object.upperSettleNo,
              'upperUserNo': res.object.upperUserNo,
              'tradeNo': res.object.tradeNo,
              'matchPrice': res.object.matchPrice,
              'matchQty': res.object.matchQty,
              'isBackInput': res.object.isBackInput,
              'isDeleted': res.object.isDeleted,
              'isAddOne': res.object.isAddOne,
              'matchStreamID': res.object.matchStreamID,
              'upperStreamID': res.object.upperStreamID,
              'openCloseMode': res.object.openCloseMode,
              'contractSize': res.object.contractSize,
              'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
              'commodityCurrency': res.object.commodityCurrency,
              'feeMode': res.object.feeMode,
              'feeParam': res.object.feeParam,
              'feeCurrencyGroup': res.object.feeCurrencyGroup,
              'feeCurrency': res.object.feeCurrency,
              'preSettlePrice': res.object.preSettlePrice,
              'feeValue': res.object.feeValue,
              'isManualFee': res.object.isManualFee,
              'turnover': res.object.turnover,
              'premiumIncome': res.object.premiumIncome,
              'premiumPay': res.object.premiumPay,
              'oppoMatchNo': res.object.oppoMatchNo,
              'closeProfit': res.object.closeProfit,
              'unExpProfit': res.object.unExpProfit,
              'upperMatchPrice': res.object.upperMatchPrice,
              'quotePrice': res.object.quotePrice,
              'closePL': res.object.closePL
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesFillInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesFillInfo/save',
              method: 'post',
              data: this.esNpfuturesFillInfoForm
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
            this.esNpfuturesFillInfoDialog = false;
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
            url: '/npfutures/esNpfuturesFillInfo/del',
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
  .esNpfuturesFillInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
