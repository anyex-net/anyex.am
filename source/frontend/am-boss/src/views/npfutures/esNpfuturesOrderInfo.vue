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
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesOrderInfoLoading" :data="esNpfuturesOrderInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="客户资金帐号"/>
      <el-table-column prop="exchangeNo" label="交易所编号" :formatter="statusFormat"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编码类型"/>
      <el-table-column prop="contractNo" label="合约1"/>
      <el-table-column prop="strikePrice" label="执行价格1"/>
      <el-table-column prop="callOrPutFlag" label="看张看跌1" :formatter="statusFormat"/>
      <el-table-column prop="contractNo2" label="合约2"/>
      <el-table-column prop="strikePrice2" label="执行价格2"/>
      <el-table-column prop="callOrPutFlag2" label="看张看跌2" :formatter="statusFormat"/>
      <el-table-column prop="orderType" label="委托类型" :formatter="statusFormat"/>
      <el-table-column prop="orderSource" label="委托来源" :formatter="statusFormat"/>
      <el-table-column prop="timeInForce" label="委托有效类型" :formatter="statusFormat"/>
      <el-table-column prop="expireTime" label="有效日期(GTD情况下使用)"/>
      <el-table-column prop="isRiskOrder" label="是否风险报单" :formatter="statusFormat"/>
      <el-table-column prop="orderSide" label="买入卖出" :formatter="statusFormat"/>
      <el-table-column prop="positionEffect" label="开平标志1" :formatter="statusFormat"/>
      <el-table-column prop="positionEffect2" label="开平标志2" :formatter="statusFormat"/>
      <el-table-column prop="inquiryNo" label="询价号"/>
      <el-table-column prop="hedgeFlag" label="投机保值" :formatter="statusFormat"/>
      <el-table-column prop="orderPrice" label="委托价格1"/>
      <el-table-column prop="orderPrice2" label="委托价格2，做市商应价使用"/>
      <el-table-column prop="stopPrice" label="触发价格"/>
      <el-table-column prop="orderQty" label="委托数量"/>
      <el-table-column prop="orderMinQty" label="最小成交量"/>
      <el-table-column prop="orderCanceledQty" label="撤单数量"/>
      <el-table-column prop="minClipSize" label="冰山单最小随机量"/>
      <el-table-column prop="maxClipSize" label="冰山单最大随机量"/>
      <el-table-column prop="licenseNo" label="软件授权号"/>
      <el-table-column prop="refInt" label="整型参考值"/>
      <el-table-column prop="refString" label="字符串参考值"/>
      <el-table-column prop="parentAccountNo" label="上级资金账号"/>
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat"/>
      <el-table-column prop="orderNo" label="委托编码"/>
      <el-table-column prop="clientOrderNo" label="客户端本地委托编号"/>
      <el-table-column prop="orderLocalNo" label="本地号"/>
      <el-table-column prop="orderSystemNo" label="系统号"/>
      <el-table-column prop="orderExchangeSystemNo" label="交易所系统号"/>
      <el-table-column prop="orderParentNo" label="父单号"/>
      <el-table-column prop="orderParentSystemNo" label="父单系统号"/>
      <el-table-column prop="tradeNo" label="交易编码"/>
      <el-table-column prop="upperNo" label="上手号"/>
      <el-table-column prop="upperChannelNo" label="上手通道号"/>
      <el-table-column prop="upperSettleNo" label="会员号和清算号"/>
      <el-table-column prop="upperUserNo" label="上手登录号"/>
      <el-table-column prop="orderInsertUserNo" label="下单人"/>
      <el-table-column prop="orderInsertTime" label="下单时间"/>
      <el-table-column prop="orderCommandUserNo" label="录单操作人"/>
      <el-table-column prop="orderUpdateUserNo" label="委托更新人"/>
      <el-table-column prop="orderUpdateTime" label="委托更新时间"/>
      <el-table-column prop="orderState" label="委托状态" :formatter="statusFormat"/>
      <el-table-column prop="orderMatchPrice" label="成交价1"/>
      <el-table-column prop="orderMatchPrice2" label="成交价2"/>
      <el-table-column prop="orderMatchQty" label="成交量1"/>
      <el-table-column prop="orderMatchQty2" label="成交量2"/>
      <el-table-column prop="errorCode" label="最后一次操作错误信息码"/>
      <el-table-column prop="errorText" label="错误信息"/>
      <el-table-column prop="isBackInput" label="是否为录入委托单" :formatter="statusFormat"/>
      <el-table-column prop="isDeleted" label="委托成交删除标" :formatter="statusFormat"/>
      <el-table-column prop="isAddOne" label="是否为T+1单" :formatter="statusFormat"/>
      <el-table-column prop="orderStreamID" label="委托流水号"/>
      <el-table-column prop="upperStreamID" label="上手流号"/>
      <el-table-column prop="contractSize" label="每手乘数，计算参数"/>
      <el-table-column prop="contractSize2" label="每手乘数，计算参数"/>
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组"/>
      <el-table-column prop="commodityCurrency" label="品种币种"/>
      <el-table-column prop="feeMode" label="手续费计算方式"/>
      <el-table-column prop="feeParam" label="手续费参数值 冻结手续费均按照开仓手续费计算"/>
      <el-table-column prop="feeCurrencyGroup" label="客户手续费币种组"/>
      <el-table-column prop="feeCurrency" label="客户手续费币种"/>
      <el-table-column prop="feeMode2" label="手续费计算方式"/>
      <el-table-column prop="feeParam2" label="手续费参数值 冻结手续费均按照开仓手续费计算"/>
      <el-table-column prop="feeCurrencyGroup2" label="客户手续费币种组"/>
      <el-table-column prop="feeCurrency2" label="客户手续费币种"/>
      <el-table-column prop="marginMode" label="保证金计算方式"/>
      <el-table-column prop="marginParam" label="保证金参数值"/>
      <el-table-column prop="marginMode2" label="保证金计算方式"/>
      <el-table-column prop="marginParam2" label="保证金参数值"/>
      <el-table-column prop="preSettlePrice" label="昨结算价  比例方式的市价单和组合订单使用"/>
      <el-table-column prop="preSettlePrice2" label="昨结算价  比例方式的市价单和组合订单使用"/>
      <el-table-column prop="openVol" label="预开仓数量 委托数量中的开仓部分"/>
      <el-table-column prop="coverVol" label="预平仓数量 委托数量中的平仓部分"/>
      <el-table-column prop="openVol2" label="预开仓数量 委托数量中的开仓部分"/>
      <el-table-column prop="coverVol2" label="预平仓数量 委托数量中的平仓部分"/>
      <el-table-column prop="feeValue" label="冻结手续费"/>
      <el-table-column prop="marginValue" label="冻结保证金 合并计算的此项为0"/>
      <el-table-column prop="tacticsType" label="策略单类型"/>
      <el-table-column prop="triggerCondition" label="触发条件" :formatter="statusFormat"/>
      <el-table-column prop="triggerPriceType" label="触发价格类型" :formatter="statusFormat"/>
      <el-table-column prop="addOneIsValid" label="是否T+1有效" :formatter="statusFormat"/>
      <el-table-column prop="orderQty2" label="委托数量2"/>
      <el-table-column prop="hedgeFlag2" label="投机保值2"/>
      <el-table-column prop="marketLevel" label="市价撮合深度"/>
      <el-table-column prop="orderDeleteByDisConnFlag" label="心跳检测失败时，服务器自动撤单标识"/>
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
    <el-dialog title="内盘盘期货委托订单表管理" :visible.sync="esNpfuturesOrderInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesOrderInfoForm" :model="esNpfuturesOrderInfoForm" :rules="esNpfuturesOrderInfoRules"
               label-width="150px" class="esNpfuturesOrderInfoForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="esNpfuturesOrderInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-input v-model="esNpfuturesOrderInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="esNpfuturesOrderInfoForm.accountNo" placeholder="请输入客户资金帐号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="esNpfuturesOrderInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-input v-model="esNpfuturesOrderInfoForm.commodityType" placeholder="请输入品种类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="esNpfuturesOrderInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="esNpfuturesOrderInfoForm.contractNo" placeholder="请输入合约1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格1" prop="strikePrice">
              <el-input v-model="esNpfuturesOrderInfoForm.strikePrice" placeholder="请输入执行价格1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="看张看跌1" prop="callOrPutFlag">
              <el-input v-model="esNpfuturesOrderInfoForm.callOrPutFlag" placeholder="请输入看张看跌1"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约2" prop="contractNo2">
              <el-input v-model="esNpfuturesOrderInfoForm.contractNo2" placeholder="请输入合约2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格2" prop="strikePrice2">
              <el-input v-model="esNpfuturesOrderInfoForm.strikePrice2" placeholder="请输入执行价格2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="看张看跌2" prop="callOrPutFlag2">
              <el-input v-model="esNpfuturesOrderInfoForm.callOrPutFlag2" placeholder="请输入看张看跌2"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托类型" prop="orderType">
              <el-input v-model="esNpfuturesOrderInfoForm.orderType" placeholder="请输入委托类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托来源" prop="orderSource">
              <el-input v-model="esNpfuturesOrderInfoForm.orderSource" placeholder="请输入委托来源"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托有效类型" prop="timeInForce">
              <el-input v-model="esNpfuturesOrderInfoForm.timeInForce" placeholder="请输入委托有效类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有效日期(GTD情况下使用)" prop="expireTime">
              <el-input v-model="esNpfuturesOrderInfoForm.expireTime" placeholder="请输入有效日期(GTD情况下使用)"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否风险报单" prop="isRiskOrder">
              <el-input v-model="esNpfuturesOrderInfoForm.isRiskOrder" placeholder="请输入是否风险报单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买入卖出" prop="orderSide">
              <el-input v-model="esNpfuturesOrderInfoForm.orderSide" placeholder="请输入买入卖出"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开平标志1" prop="positionEffect">
              <el-input v-model="esNpfuturesOrderInfoForm.positionEffect" placeholder="请输入开平标志1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平标志2" prop="positionEffect2">
              <el-input v-model="esNpfuturesOrderInfoForm.positionEffect2" placeholder="请输入开平标志2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="询价号" prop="inquiryNo">
              <el-input v-model="esNpfuturesOrderInfoForm.inquiryNo" placeholder="请输入询价号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-input v-model="esNpfuturesOrderInfoForm.hedgeFlag" placeholder="请输入投机保值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托价格1" prop="orderPrice">
              <el-input v-model="esNpfuturesOrderInfoForm.orderPrice" placeholder="请输入委托价格1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托价格2，做市商应价使用" prop="orderPrice2">
              <el-input v-model="esNpfuturesOrderInfoForm.orderPrice2" placeholder="请输入委托价格2，做市商应价使用"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="触发价格" prop="stopPrice">
              <el-input v-model="esNpfuturesOrderInfoForm.stopPrice" placeholder="请输入触发价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托数量" prop="orderQty">
              <el-input v-model="esNpfuturesOrderInfoForm.orderQty" placeholder="请输入委托数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最小成交量" prop="orderMinQty">
              <el-input v-model="esNpfuturesOrderInfoForm.orderMinQty" placeholder="请输入最小成交量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="撤单数量" prop="orderCanceledQty">
              <el-input v-model="esNpfuturesOrderInfoForm.orderCanceledQty" placeholder="请输入撤单数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冰山单最小随机量" prop="minClipSize">
              <el-input v-model="esNpfuturesOrderInfoForm.minClipSize" placeholder="请输入冰山单最小随机量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冰山单最大随机量" prop="maxClipSize">
              <el-input v-model="esNpfuturesOrderInfoForm.maxClipSize" placeholder="请输入冰山单最大随机量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="软件授权号" prop="licenseNo">
              <el-input v-model="esNpfuturesOrderInfoForm.licenseNo" placeholder="请输入软件授权号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="整型参考值" prop="refInt">
              <el-input v-model="esNpfuturesOrderInfoForm.refInt" placeholder="请输入整型参考值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="字符串参考值" prop="refString">
              <el-input v-model="esNpfuturesOrderInfoForm.refString" placeholder="请输入字符串参考值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上级资金账号" prop="parentAccountNo">
              <el-input v-model="esNpfuturesOrderInfoForm.parentAccountNo" placeholder="请输入上级资金账号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="esNpfuturesOrderInfoForm.serverFlag" placeholder="请输入服务器标识"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户端本地委托编号" prop="clientOrderNo">
              <el-input v-model="esNpfuturesOrderInfoForm.clientOrderNo" placeholder="请输入客户端本地委托编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地号" prop="orderLocalNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderLocalNo" placeholder="请输入本地号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="系统号" prop="orderSystemNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderSystemNo" placeholder="请输入系统号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所系统号" prop="orderExchangeSystemNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderExchangeSystemNo" placeholder="请输入交易所系统号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="父单号" prop="orderParentNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderParentNo" placeholder="请输入父单号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="父单系统号" prop="orderParentSystemNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderParentSystemNo" placeholder="请输入父单系统号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易编码" prop="tradeNo">
              <el-input v-model="esNpfuturesOrderInfoForm.tradeNo" placeholder="请输入交易编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="esNpfuturesOrderInfoForm.upperNo" placeholder="请输入上手号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手通道号" prop="upperChannelNo">
              <el-input v-model="esNpfuturesOrderInfoForm.upperChannelNo" placeholder="请输入上手通道号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="会员号和清算号" prop="upperSettleNo">
              <el-input v-model="esNpfuturesOrderInfoForm.upperSettleNo" placeholder="请输入会员号和清算号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手登录号" prop="upperUserNo">
              <el-input v-model="esNpfuturesOrderInfoForm.upperUserNo" placeholder="请输入上手登录号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="下单人" prop="orderInsertUserNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderInsertUserNo" placeholder="请输入下单人"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="下单时间" prop="orderInsertTime">
              <el-input v-model="esNpfuturesOrderInfoForm.orderInsertTime" placeholder="请输入下单时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="录单操作人" prop="orderCommandUserNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderCommandUserNo" placeholder="请输入录单操作人"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托更新人" prop="orderUpdateUserNo">
              <el-input v-model="esNpfuturesOrderInfoForm.orderUpdateUserNo" placeholder="请输入委托更新人"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托更新时间" prop="orderUpdateTime">
              <el-input v-model="esNpfuturesOrderInfoForm.orderUpdateTime" placeholder="请输入委托更新时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托状态" prop="orderState">
              <el-input v-model="esNpfuturesOrderInfoForm.orderState" placeholder="请输入委托状态"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交价1" prop="orderMatchPrice">
              <el-input v-model="esNpfuturesOrderInfoForm.orderMatchPrice" placeholder="请输入成交价1"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交价2" prop="orderMatchPrice2">
              <el-input v-model="esNpfuturesOrderInfoForm.orderMatchPrice2" placeholder="请输入成交价2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交量1" prop="orderMatchQty">
              <el-input v-model="esNpfuturesOrderInfoForm.orderMatchQty" placeholder="请输入成交量1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交量2" prop="orderMatchQty2">
              <el-input v-model="esNpfuturesOrderInfoForm.orderMatchQty2" placeholder="请输入成交量2"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最后一次操作错误信息码" prop="errorCode">
              <el-input v-model="esNpfuturesOrderInfoForm.errorCode" placeholder="请输入最后一次操作错误信息码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="错误信息" prop="errorText">
              <el-input v-model="esNpfuturesOrderInfoForm.errorText" placeholder="请输入错误信息"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为录入委托单" prop="isBackInput">
              <el-input v-model="esNpfuturesOrderInfoForm.isBackInput" placeholder="请输入是否为录入委托单"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托成交删除标" prop="isDeleted">
              <el-input v-model="esNpfuturesOrderInfoForm.isDeleted" placeholder="请输入委托成交删除标"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为T+1单" prop="isAddOne">
              <el-input v-model="esNpfuturesOrderInfoForm.isAddOne" placeholder="请输入是否为T+1单"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托流水号" prop="orderStreamID">
              <el-input v-model="esNpfuturesOrderInfoForm.orderStreamID" placeholder="请输入委托流水号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手流号" prop="upperStreamID">
              <el-input v-model="esNpfuturesOrderInfoForm.upperStreamID" placeholder="请输入上手流号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数，计算参数" prop="contractSize">
              <el-input v-model="esNpfuturesOrderInfoForm.contractSize" placeholder="请输入每手乘数，计算参数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数，计算参数" prop="contractSize2">
              <el-input v-model="esNpfuturesOrderInfoForm.contractSize2" placeholder="请输入每手乘数，计算参数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="esNpfuturesOrderInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="esNpfuturesOrderInfoForm.commodityCurrency" placeholder="请输入品种币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费计算方式" prop="feeMode">
              <el-input v-model="esNpfuturesOrderInfoForm.feeMode" placeholder="请输入手续费计算方式"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费参数值 冻结手续费均按照开仓手续费计算" prop="feeParam">
              <el-input v-model="esNpfuturesOrderInfoForm.feeParam" placeholder="请输入手续费参数值 冻结手续费均按照开仓手续费计算"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户手续费币种组" prop="feeCurrencyGroup">
              <el-input v-model="esNpfuturesOrderInfoForm.feeCurrencyGroup" placeholder="请输入客户手续费币种组"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户手续费币种" prop="feeCurrency">
              <el-input v-model="esNpfuturesOrderInfoForm.feeCurrency" placeholder="请输入客户手续费币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费计算方式" prop="feeMode2">
              <el-input v-model="esNpfuturesOrderInfoForm.feeMode2" placeholder="请输入手续费计算方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费参数值 冻结手续费均按照开仓手续费计算" prop="feeParam2">
              <el-input v-model="esNpfuturesOrderInfoForm.feeParam2" placeholder="请输入手续费参数值 冻结手续费均按照开仓手续费计算"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户手续费币种组" prop="feeCurrencyGroup2">
              <el-input v-model="esNpfuturesOrderInfoForm.feeCurrencyGroup2" placeholder="请输入客户手续费币种组"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户手续费币种" prop="feeCurrency2">
              <el-input v-model="esNpfuturesOrderInfoForm.feeCurrency2" placeholder="请输入客户手续费币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金计算方式" prop="marginMode">
              <el-input v-model="esNpfuturesOrderInfoForm.marginMode" placeholder="请输入保证金计算方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金参数值" prop="marginParam">
              <el-input v-model="esNpfuturesOrderInfoForm.marginParam" placeholder="请输入保证金参数值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="保证金计算方式" prop="marginMode2">
              <el-input v-model="esNpfuturesOrderInfoForm.marginMode2" placeholder="请输入保证金计算方式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金参数值" prop="marginParam2">
              <el-input v-model="esNpfuturesOrderInfoForm.marginParam2" placeholder="请输入保证金参数值"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="昨结算价  比例方式的市价单和组合订单使用" prop="preSettlePrice">
              <el-input v-model="esNpfuturesOrderInfoForm.preSettlePrice" placeholder="请输入昨结算价  比例方式的市价单和组合订单使用"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="昨结算价  比例方式的市价单和组合订单使用" prop="preSettlePrice2">
              <el-input v-model="esNpfuturesOrderInfoForm.preSettlePrice2" placeholder="请输入昨结算价  比例方式的市价单和组合订单使用"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预开仓数量 委托数量中的开仓部分" prop="openVol">
              <el-input v-model="esNpfuturesOrderInfoForm.openVol" placeholder="请输入预开仓数量 委托数量中的开仓部分"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预平仓数量 委托数量中的平仓部分" prop="coverVol">
            <el-input v-model="esNpfuturesOrderInfoForm.coverVol" placeholder="请输入预平仓数量 委托数量中的平仓部分"/>
          </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="预开仓数量 委托数量中的开仓部分" prop="openVol2">
              <el-input v-model="esNpfuturesOrderInfoForm.openVol2" placeholder="请输入预开仓数量 委托数量中的开仓部分"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预平仓数量 委托数量中的平仓部分" prop="coverVol2">
              <el-input v-model="esNpfuturesOrderInfoForm.coverVol2" placeholder="请输入预平仓数量 委托数量中的平仓部分"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结手续费" prop="feeValue">
              <el-input v-model="esNpfuturesOrderInfoForm.feeValue" placeholder="请输入冻结手续费"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冻结保证金 合并计算的此项为0" prop="marginValue">
              <el-input v-model="esNpfuturesOrderInfoForm.marginValue" placeholder="请输入冻结保证金 合并计算的此项为0"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="策略单类型" prop="tacticsType">
              <el-input v-model="esNpfuturesOrderInfoForm.tacticsType" placeholder="请输入策略单类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="触发条件" prop="triggerCondition">
              <el-input v-model="esNpfuturesOrderInfoForm.triggerCondition" placeholder="请输入触发条件"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="触发价格类型" prop="triggerPriceType">
              <el-input v-model="esNpfuturesOrderInfoForm.triggerPriceType" placeholder="请输入触发价格类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否T+1有效" prop="addOneIsValid">
              <el-input v-model="esNpfuturesOrderInfoForm.addOneIsValid" placeholder="请输入是否T+1有效"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托数量2" prop="orderQty2">
              <el-input v-model="esNpfuturesOrderInfoForm.orderQty2" placeholder="请输入委托数量2"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投机保值2" prop="hedgeFlag2">
              <el-input v-model="esNpfuturesOrderInfoForm.hedgeFlag2" placeholder="请输入投机保值2"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价撮合深度" prop="marketLevel">
              <el-input v-model="esNpfuturesOrderInfoForm.marketLevel" placeholder="请输入市价撮合深度"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="心跳检测失败时，服务器自动撤单标识" prop="orderDeleteByDisConnFlag">
              <el-input v-model="esNpfuturesOrderInfoForm.orderDeleteByDisConnFlag" placeholder="请输入心跳检测失败时，服务器自动撤单标识"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesOrderInfoName',
    data() {
      return {
        esNpfuturesOrderInfoLoading: true,
        esNpfuturesOrderInfoDialog: false,
        esNpfuturesOrderInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesOrderInfoForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'contractNo2': '',
          'strikePrice2': '',
          'callOrPutFlag2': '',
          'orderType': '',
          'orderSource': '',
          'timeInForce': '',
          'expireTime': '',
          'isRiskOrder': '',
          'orderSide': '',
          'positionEffect': '',
          'positionEffect2': '',
          'inquiryNo': '',
          'hedgeFlag': '',
          'orderPrice': '',
          'orderPrice2': '',
          'stopPrice': '',
          'orderQty': '',
          'orderMinQty': '',
          'orderCanceledQty': '',
          'minClipSize': '',
          'maxClipSize': '',
          'licenseNo': '',
          'refInt': '',
          'refString': '',
          'parentAccountNo': '',
          'serverFlag': '',
          'orderNo': '',
          'clientOrderNo': '',
          'orderLocalNo': '',
          'orderSystemNo': '',
          'orderExchangeSystemNo': '',
          'orderParentNo': '',
          'orderParentSystemNo': '',
          'tradeNo': '',
          'upperNo': '',
          'upperChannelNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'orderInsertUserNo': '',
          'orderInsertTime': '',
          'orderCommandUserNo': '',
          'orderUpdateUserNo': '',
          'orderUpdateTime': '',
          'orderState': '',
          'orderMatchPrice': '',
          'orderMatchPrice2': '',
          'orderMatchQty': '',
          'orderMatchQty2': '',
          'errorCode': '',
          'errorText': '',
          'isBackInput': '',
          'isDeleted': '',
          'isAddOne': '',
          'orderStreamID': '',
          'upperStreamID': '',
          'contractSize': '',
          'contractSize2': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'feeMode': '',
          'feeParam': '',
          'feeCurrencyGroup': '',
          'feeCurrency': '',
          'feeMode2': '',
          'feeParam2': '',
          'feeCurrencyGroup2': '',
          'feeCurrency2': '',
          'marginMode': '',
          'marginParam': '',
          'marginMode2': '',
          'marginParam2': '',
          'preSettlePrice': '',
          'preSettlePrice2': '',
          'openVol': '',
          'coverVol': '',
          'openVol2': '',
          'coverVol2': '',
          'feeValue': '',
          'marginValue': '',
          'tacticsType': '',
          'triggerCondition': '',
          'triggerPriceType': '',
          'addOneIsValid': '',
          'orderQty2': '',
          'hedgeFlag2': '',
          'marketLevel': '',
          'orderDeleteByDisConnFlag': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
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
        esNpfuturesOrderInfoRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '客户资金帐号不可为空', trigger: 'change' }
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
            { required: true, message: '执行价格1不可为空', trigger: 'change' }
          ],
          callOrPutFlag: [
            { required: true, message: '看张看跌1不可为空', trigger: 'change' }
          ],
          contractNo2: [
            { required: true, message: '合约2不可为空', trigger: 'change' }
          ],
          strikePrice2: [
            { required: true, message: '执行价格2不可为空', trigger: 'change' }
          ],
          callOrPutFlag2: [
            { required: true, message: '看张看跌2不可为空', trigger: 'change' }
          ],
          orderType: [
            { required: true, message: '委托类型不可为空', trigger: 'change' }
          ],
          orderSource: [
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
          orderSide: [
            { required: true, message: '买入卖出不可为空', trigger: 'change' }
          ],
          positionEffect: [
            { required: true, message: '开平标志1不可为空', trigger: 'change' }
          ],
          positionEffect2: [
            { required: true, message: '开平标志2不可为空', trigger: 'change' }
          ],
          inquiryNo: [
            { required: true, message: '询价号不可为空', trigger: 'change' }
          ],
          hedgeFlag: [
            { required: true, message: '投机保值不可为空', trigger: 'change' }
          ],
          orderPrice: [
            { required: true, message: '委托价格1不可为空', trigger: 'change' }
          ],
          orderPrice2: [
            { required: true, message: '委托价格2，做市商应价使用不可为空', trigger: 'change' }
          ],
          stopPrice: [
            { required: true, message: '触发价格不可为空', trigger: 'change' }
          ],
          orderQty: [
            { required: true, message: '委托数量不可为空', trigger: 'change' }
          ],
          orderMinQty: [
            { required: true, message: '最小成交量不可为空', trigger: 'change' }
          ],
          orderCanceledQty: [
            { required: true, message: '撤单数量不可为空', trigger: 'change' }
          ],
          minClipSize: [
            { required: true, message: '冰山单最小随机量不可为空', trigger: 'change' }
          ],
          maxClipSize: [
            { required: true, message: '冰山单最大随机量不可为空', trigger: 'change' }
          ],
          licenseNo: [
            { required: true, message: '软件授权号不可为空', trigger: 'change' }
          ],
          refInt: [
            { required: true, message: '整型参考值不可为空', trigger: 'change' }
          ],
          refString: [
            { required: true, message: '字符串参考值不可为空', trigger: 'change' }
          ],
          parentAccountNo: [
            { required: true, message: '上级资金账号不可为空', trigger: 'change' }
          ],
          serverFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          orderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          clientOrderNo: [
            { required: true, message: '客户端本地委托编号不可为空', trigger: 'change' }
          ],
          orderLocalNo: [
            { required: true, message: '本地号不可为空', trigger: 'change' }
          ],
          orderSystemNo: [
            { required: true, message: '系统号不可为空', trigger: 'change' }
          ],
          orderExchangeSystemNo: [
            { required: true, message: '交易所系统号不可为空', trigger: 'change' }
          ],
          orderParentNo: [
            { required: true, message: '父单号不可为空', trigger: 'change' }
          ],
          orderParentSystemNo: [
            { required: true, message: '父单系统号不可为空', trigger: 'change' }
          ],
          tradeNo: [
            { required: true, message: '交易编码不可为空', trigger: 'change' }
          ],
          upperNo: [
            { required: true, message: '上手号不可为空', trigger: 'change' }
          ],
          upperChannelNo: [
            { required: true, message: '上手通道号不可为空', trigger: 'change' }
          ],
          upperSettleNo: [
            { required: true, message: '会员号和清算号不可为空', trigger: 'change' }
          ],
          upperUserNo: [
            { required: true, message: '上手登录号不可为空', trigger: 'change' }
          ],
          orderInsertUserNo: [
            { required: true, message: '下单人不可为空', trigger: 'change' }
          ],
          orderInsertTime: [
            { required: true, message: '下单时间不可为空', trigger: 'change' }
          ],
          orderCommandUserNo: [
            { required: true, message: '录单操作人不可为空', trigger: 'change' }
          ],
          orderUpdateUserNo: [
            { required: true, message: '委托更新人不可为空', trigger: 'change' }
          ],
          orderUpdateTime: [
            { required: true, message: '委托更新时间不可为空', trigger: 'change' }
          ],
          orderState: [
            { required: true, message: '委托状态不可为空', trigger: 'change' }
          ],
          orderMatchPrice: [
            { required: true, message: '成交价1不可为空', trigger: 'change' }
          ],
          orderMatchPrice2: [
            { required: true, message: '成交价2不可为空', trigger: 'change' }
          ],
          orderMatchQty: [
            { required: true, message: '成交量1不可为空', trigger: 'change' }
          ],
          orderMatchQty2: [
            { required: true, message: '成交量2不可为空', trigger: 'change' }
          ],
          errorCode: [
            { required: true, message: '最后一次操作错误信息码不可为空', trigger: 'change' }
          ],
          errorText: [
            { required: true, message: '错误信息不可为空', trigger: 'change' }
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
          orderStreamID: [
            { required: true, message: '委托流水号不可为空', trigger: 'change' }
          ],
          upperStreamID: [
            { required: true, message: '上手流号不可为空', trigger: 'change' }
          ],
          contractSize: [
            { required: true, message: '每手乘数，计算参数不可为空', trigger: 'change' }
          ],
          contractSize2: [
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
          feeMode2: [
            { required: true, message: '手续费计算方式不可为空', trigger: 'change' }
          ],
          feeParam2: [
            { required: true, message: '手续费参数值 冻结手续费均按照开仓手续费计算不可为空', trigger: 'change' }
          ],
          feeCurrencyGroup2: [
            { required: true, message: '客户手续费币种组不可为空', trigger: 'change' }
          ],
          feeCurrency2: [
            { required: true, message: '客户手续费币种不可为空', trigger: 'change' }
          ],
          marginMode: [
            { required: true, message: '保证金计算方式不可为空', trigger: 'change' }
          ],
          marginParam: [
            { required: true, message: '保证金参数值不可为空', trigger: 'change' }
          ],
          marginMode2: [
            { required: true, message: '保证金计算方式不可为空', trigger: 'change' }
          ],
          marginParam2: [
            { required: true, message: '保证金参数值不可为空', trigger: 'change' }
          ],
          preSettlePrice: [
            { required: true, message: '昨结算价  比例方式的市价单和组合订单使用不可为空', trigger: 'change' }
          ],
          preSettlePrice2: [
            { required: true, message: '昨结算价  比例方式的市价单和组合订单使用不可为空', trigger: 'change' }
          ],
          openVol: [
            { required: true, message: '预开仓数量 委托数量中的开仓部分不可为空', trigger: 'change' }
          ],
          coverVol: [
            { required: true, message: '预平仓数量 委托数量中的平仓部分不可为空', trigger: 'change' }
          ],
          openVol2: [
            { required: true, message: '预开仓数量 委托数量中的开仓部分不可为空', trigger: 'change' }
          ],
          coverVol2: [
            { required: true, message: '预平仓数量 委托数量中的平仓部分不可为空', trigger: 'change' }
          ],
          feeValue: [
            { required: true, message: '冻结手续费不可为空', trigger: 'change' }
          ],
          marginValue: [
            { required: true, message: '冻结保证金 合并计算的此项为0不可为空', trigger: 'change' }
          ],
          tacticsType: [
            { required: true, message: '策略单类型不可为空', trigger: 'change' }
          ],
          triggerCondition: [
            { required: true, message: '触发条件不可为空', trigger: 'change' }
          ],
          triggerPriceType: [
            { required: true, message: '触发价格类型不可为空', trigger: 'change' }
          ],
          addOneIsValid: [
            { required: true, message: '是否T+1有效不可为空', trigger: 'change' }
          ],
          orderQty2: [
            { required: true, message: '委托数量2不可为空', trigger: 'change' }
          ],
          hedgeFlag2: [
            { required: true, message: '投机保值2不可为空', trigger: 'change' }
          ],
          marketLevel: [
            { required: true, message: '市价撮合深度不可为空', trigger: 'change' }
          ],
          orderDeleteByDisConnFlag: [
            { required: true, message: '心跳检测失败时，服务器自动撤单标识不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesOrderInfo',
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
        this.esNpfuturesOrderInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesOrderInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesOrderInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesOrderInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesOrderInfoForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'contractNo2': '',
          'strikePrice2': '',
          'callOrPutFlag2': '',
          'orderType': '',
          'orderSource': '',
          'timeInForce': '',
          'expireTime': '',
          'isRiskOrder': '',
          'orderSide': '',
          'positionEffect': '',
          'positionEffect2': '',
          'inquiryNo': '',
          'hedgeFlag': '',
          'orderPrice': '',
          'orderPrice2': '',
          'stopPrice': '',
          'orderQty': '',
          'orderMinQty': '',
          'orderCanceledQty': '',
          'minClipSize': '',
          'maxClipSize': '',
          'licenseNo': '',
          'refInt': '',
          'refString': '',
          'parentAccountNo': '',
          'serverFlag': '',
          'orderNo': '',
          'clientOrderNo': '',
          'orderLocalNo': '',
          'orderSystemNo': '',
          'orderExchangeSystemNo': '',
          'orderParentNo': '',
          'orderParentSystemNo': '',
          'tradeNo': '',
          'upperNo': '',
          'upperChannelNo': '',
          'upperSettleNo': '',
          'upperUserNo': '',
          'orderInsertUserNo': '',
          'orderInsertTime': '',
          'orderCommandUserNo': '',
          'orderUpdateUserNo': '',
          'orderUpdateTime': '',
          'orderState': '',
          'orderMatchPrice': '',
          'orderMatchPrice2': '',
          'orderMatchQty': '',
          'orderMatchQty2': '',
          'errorCode': '',
          'errorText': '',
          'isBackInput': '',
          'isDeleted': '',
          'isAddOne': '',
          'orderStreamID': '',
          'upperStreamID': '',
          'contractSize': '',
          'contractSize2': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'feeMode': '',
          'feeParam': '',
          'feeCurrencyGroup': '',
          'feeCurrency': '',
          'feeMode2': '',
          'feeParam2': '',
          'feeCurrencyGroup2': '',
          'feeCurrency2': '',
          'marginMode': '',
          'marginParam': '',
          'marginMode2': '',
          'marginParam2': '',
          'preSettlePrice': '',
          'preSettlePrice2': '',
          'openVol': '',
          'coverVol': '',
          'openVol2': '',
          'coverVol2': '',
          'feeValue': '',
          'marginValue': '',
          'tacticsType': '',
          'triggerCondition': '',
          'triggerPriceType': '',
          'addOneIsValid': '',
          'orderQty2': '',
          'hedgeFlag2': '',
          'marketLevel': '',
          'orderDeleteByDisConnFlag': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesOrderInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesOrderInfoForm) {
          this.$refs.esNpfuturesOrderInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesOrderInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesOrderInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'exchangeNo': res.object.exchangeNo,
              'commodityType': res.object.commodityType,
              'commodityNo': res.object.commodityNo,
              'contractNo': res.object.contractNo,
              'strikePrice': res.object.strikePrice,
              'callOrPutFlag': res.object.callOrPutFlag,
              'contractNo2': res.object.contractNo2,
              'strikePrice2': res.object.strikePrice2,
              'callOrPutFlag2': res.object.callOrPutFlag2,
              'orderType': res.object.orderType,
              'orderSource': res.object.orderSource,
              'timeInForce': res.object.timeInForce,
              'expireTime': res.object.expireTime,
              'isRiskOrder': res.object.isRiskOrder,
              'orderSide': res.object.orderSide,
              'positionEffect': res.object.positionEffect,
              'positionEffect2': res.object.positionEffect2,
              'inquiryNo': res.object.inquiryNo,
              'hedgeFlag': res.object.hedgeFlag,
              'orderPrice': res.object.orderPrice,
              'orderPrice2': res.object.orderPrice2,
              'stopPrice': res.object.stopPrice,
              'orderQty': res.object.orderQty,
              'orderMinQty': res.object.orderMinQty,
              'orderCanceledQty': res.object.orderCanceledQty,
              'minClipSize': res.object.minClipSize,
              'maxClipSize': res.object.maxClipSize,
              'licenseNo': res.object.licenseNo,
              'refInt': res.object.refInt,
              'refString': res.object.refString,
              'parentAccountNo': res.object.parentAccountNo,
              'serverFlag': res.object.serverFlag,
              'orderNo': res.object.orderNo,
              'clientOrderNo': res.object.clientOrderNo,
              'orderLocalNo': res.object.orderLocalNo,
              'orderSystemNo': res.object.orderSystemNo,
              'orderExchangeSystemNo': res.object.orderExchangeSystemNo,
              'orderParentNo': res.object.orderParentNo,
              'orderParentSystemNo': res.object.orderParentSystemNo,
              'tradeNo': res.object.tradeNo,
              'upperNo': res.object.upperNo,
              'upperChannelNo': res.object.upperChannelNo,
              'upperSettleNo': res.object.upperSettleNo,
              'upperUserNo': res.object.upperUserNo,
              'orderInsertUserNo': res.object.orderInsertUserNo,
              'orderInsertTime': res.object.orderInsertTime,
              'orderCommandUserNo': res.object.orderCommandUserNo,
              'orderUpdateUserNo': res.object.orderUpdateUserNo,
              'orderUpdateTime': res.object.orderUpdateTime,
              'orderState': res.object.orderState,
              'orderMatchPrice': res.object.orderMatchPrice,
              'orderMatchPrice2': res.object.orderMatchPrice2,
              'orderMatchQty': res.object.orderMatchQty,
              'orderMatchQty2': res.object.orderMatchQty2,
              'errorCode': res.object.errorCode,
              'errorText': res.object.errorText,
              'isBackInput': res.object.isBackInput,
              'isDeleted': res.object.isDeleted,
              'isAddOne': res.object.isAddOne,
              'orderStreamID': res.object.orderStreamID,
              'upperStreamID': res.object.upperStreamID,
              'contractSize': res.object.contractSize,
              'contractSize2': res.object.contractSize2,
              'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
              'commodityCurrency': res.object.commodityCurrency,
              'feeMode': res.object.feeMode,
              'feeParam': res.object.feeParam,
              'feeCurrencyGroup': res.object.feeCurrencyGroup,
              'feeCurrency': res.object.feeCurrency,
              'feeMode2': res.object.feeMode2,
              'feeParam2': res.object.feeParam2,
              'feeCurrencyGroup2': res.object.feeCurrencyGroup2,
              'feeCurrency2': res.object.feeCurrency2,
              'marginMode': res.object.marginMode,
              'marginParam': res.object.marginParam,
              'marginMode2': res.object.marginMode2,
              'marginParam2': res.object.marginParam2,
              'preSettlePrice': res.object.preSettlePrice,
              'preSettlePrice2': res.object.preSettlePrice2,
              'openVol': res.object.openVol,
              'coverVol': res.object.coverVol,
              'openVol2': res.object.openVol2,
              'coverVol2': res.object.coverVol2,
              'feeValue': res.object.feeValue,
              'marginValue': res.object.marginValue,
              'tacticsType': res.object.tacticsType,
              'triggerCondition': res.object.triggerCondition,
              'triggerPriceType': res.object.triggerPriceType,
              'addOneIsValid': res.object.addOneIsValid,
              'orderQty2': res.object.orderQty2,
              'hedgeFlag2': res.object.hedgeFlag2,
              'marketLevel': res.object.marketLevel,
              'orderDeleteByDisConnFlag': res.object.orderDeleteByDisConnFlag
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesOrderInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesOrderInfo/save',
              method: 'post',
              data: this.esNpfuturesOrderInfoForm
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
            this.esNpfuturesOrderInfoDialog = false;
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
            url: '/npfutures/esNpfuturesOrderInfo/del',
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
  .esNpfuturesOrderInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
