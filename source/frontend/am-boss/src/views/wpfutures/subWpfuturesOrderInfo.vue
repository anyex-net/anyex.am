<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="交易所编号">
        <el-select v-model="searchForm.exchangeNo" clearable placeholder="请选择交易所编号" value="">
          <el-option v-for="data in dicts.exchangeNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码类型">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table
      v-loading="subWpfuturesOrderInfoLoading"
      :data="subWpfuturesOrderInfoData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <!--      <el-table-column prop="id" label="主键"/>-->
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" />
      <el-table-column prop="exchangeNo" label="交易所编号" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat" />
      <el-table-column prop="commodityNo" label="品种编码类型" />
      <el-table-column prop="contractNo" label="合约1" />
      <el-table-column prop="strikePrice" label="执行价格1" />
      <el-table-column prop="callOrPutFlag" label="看张看跌1" :formatter="statusFormat" />
      <el-table-column prop="contractNo2" label="合约2" />
      <el-table-column prop="strikePrice2" label="执行价格2" />
      <el-table-column prop="callOrPutFlag2" label="看张看跌2" :formatter="statusFormat" />
      <el-table-column prop="orderType" label="委托类型" :formatter="statusFormat" />
      <el-table-column prop="orderSource" label="委托来源" :formatter="statusFormat" />
      <el-table-column prop="timeInForce" label="委托有效类型" :formatter="statusFormat" />
      <el-table-column prop="expireTime" label="有效日期(GTD情况下使用)" />
      <el-table-column prop="isRiskOrder" label="是否风险报单" :formatter="statusFormat" />
      <el-table-column prop="orderSide" label="买入卖出" :formatter="statusFormat" />
      <el-table-column prop="positionEffect" label="开平标志1" :formatter="statusFormat" />
      <el-table-column prop="positionEffect2" label="开平标志2" :formatter="statusFormat" />
      <el-table-column prop="inquiryNo" label="询价号" />
      <el-table-column prop="hedgeFlag" label="投机保值" :formatter="statusFormat" />
      <el-table-column prop="orderPrice" label="委托价格1" />
      <el-table-column prop="orderPrice2" label="委托价格2，做市商应价使用" />
      <el-table-column prop="stopPrice" label="触发价格" />
      <el-table-column prop="orderQty" label="委托数量" />
      <el-table-column prop="orderMinQty" label="最小成交量" />
      <el-table-column prop="refInt" label="整型参考值" />
      <el-table-column prop="refDouble" label="浮点参考值" />
      <el-table-column prop="refString" label="字符串参考值" />
      <el-table-column prop="minClipSize" label="冰山单最小随机量" />
      <el-table-column prop="maxClipSize" label="冰山单最大随机量" />
      <el-table-column prop="licenseNo" label="软件授权号" />
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat" />
      <el-table-column prop="orderNo" label="委托编码" />
      <el-table-column prop="clientOrderNo" label="客户端本地委托编号" />
      <el-table-column prop="clientID" label="客户子账号" />
      <el-table-column prop="tacticsType" label="策略单类型" />
      <el-table-column prop="triggerCondition" label="触发条件" :formatter="statusFormat" />
      <el-table-column prop="triggerPriceType" label="触发价格类型" :formatter="statusFormat" />
      <el-table-column prop="addOneIsValid" label="是否T+1有效" :formatter="statusFormat" />
      <el-table-column prop="clientLocalIP" label="终端本地IP" />
      <el-table-column prop="clientMac" label="终端本地Mac地址" />
      <el-table-column prop="clientIP" label="终端网络地址" />
      <el-table-column prop="orderStreamID" label="委托流水号" />
      <el-table-column prop="upperNo" label="上手号" />
      <el-table-column prop="upperChannelNo" label="上手通道号" />
      <el-table-column prop="orderLocalNo" label="本地号" />
      <el-table-column prop="upperStreamID" label="上手流号" />
      <el-table-column prop="orderSystemNo" label="系统号" />
      <el-table-column prop="orderExchangeSystemNo" label="交易所系统号" />
      <el-table-column prop="orderParentSystemNo" label="父单系统号" />
      <el-table-column prop="orderInsertUserNo" label="下单人" />
      <el-table-column prop="orderInsertTime" label="下单时间" />
      <el-table-column prop="orderCommandUserNo" label="录单操作人" />
      <el-table-column prop="orderUpdateUserNo" label="委托更新人" />
      <el-table-column prop="orderUpdateTime" label="委托更新时间" />
      <el-table-column prop="orderState" label="委托状态" :formatter="statusFormat" />
      <el-table-column prop="orderMatchPrice" label="成交价1" />
      <el-table-column prop="orderMatchPrice2" label="成交价2" />
      <el-table-column prop="orderMatchQty" label="成交量1" />
      <el-table-column prop="orderMatchQty2" label="成交量2" />
      <el-table-column prop="errorCode" label="最后一次操作错误信息码" />
      <el-table-column prop="errorText" label="错误信息" />
      <el-table-column prop="isBackInput" label="是否为录入委托单" :formatter="statusFormat" />
      <el-table-column prop="isDeleted" label="委托成交删除标" :formatter="statusFormat" />
      <el-table-column prop="isAddOne" label="是否为T+1单" :formatter="statusFormat" />
      <el-table-column prop="currencyNo" label="币种"/>
      <el-table-column prop="frozenDeposit" label="冻结保证金"/>
      <el-table-column prop="frozenFund" label="冻结资金"/>
      <el-table-column prop="frozenFee" label="冻结手续费"/>
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
    <el-dialog title="子账户委托订单表管理" :visible.sync="subWpfuturesOrderInfoDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="subWpfuturesOrderInfoForm"
        :model="subWpfuturesOrderInfoForm"
        label-width="150px"
        class="subWpfuturesOrderInfoForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="主键" prop="accountId">
              <el-input v-model="subWpfuturesOrderInfoForm.id" placeholder="请输入主键" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="subWpfuturesOrderInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="subWpfuturesOrderInfoForm.exchangeNo" placeholder="请输入交易所编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="subWpfuturesOrderInfoForm.commodityType" clearable placeholder="请输入品种类型" value="">
                <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="subWpfuturesOrderInfoForm.commodityNo" placeholder="请输入品种编码类型" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="subWpfuturesOrderInfoForm.contractNo" placeholder="请输入合约1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格1" prop="strikePrice">
              <el-input v-model="subWpfuturesOrderInfoForm.strikePrice" placeholder="请输入执行价格1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="看张看跌1" prop="callOrPutFlag">
              <el-select v-model="subWpfuturesOrderInfoForm.callOrPutFlag" clearable placeholder="请输入看张看跌1" value="">
                <el-option v-for="data in dicts.callOrPutFlag" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约2" prop="contractNo2">
              <el-input v-model="subWpfuturesOrderInfoForm.contractNo2" placeholder="请输入合约2" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格2" prop="strikePrice2">
              <el-input v-model="subWpfuturesOrderInfoForm.strikePrice2" placeholder="请输入执行价格2" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="看张看跌2" prop="callOrPutFlag2">
              <el-select v-model="subWpfuturesOrderInfoForm.callOrPutFlag2" clearable placeholder="请输入看张看跌2" value="">
                <el-option v-for="data in dicts.callOrPutFlag2" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托类型" prop="orderType">
              <el-select v-model="subWpfuturesOrderInfoForm.orderType" clearable placeholder="请输入委托类型" value="">
                <el-option v-for="data in dicts.orderType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托来源" prop="orderSource">
              <el-select v-model="subWpfuturesOrderInfoForm.orderSource" clearable placeholder="请输入委托来源" value="">
                <el-option v-for="data in dicts.orderSource" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托有效类型" prop="timeInForce">
              <el-select v-model="subWpfuturesOrderInfoForm.timeInForce" clearable placeholder="请输入委托有效类型" value="">
                <el-option v-for="data in dicts.timeInForce" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有效日期" prop="expireTime">
              <el-input v-model="subWpfuturesOrderInfoForm.expireTime" placeholder="请输入有效日期(GTD情况下使用)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否风险报单" prop="isRiskOrder">
              <el-select v-model="subWpfuturesOrderInfoForm.isRiskOrder" clearable placeholder="请输入是否风险报单" value="">
                <el-option v-for="data in dicts.isRiskOrder" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买入卖出" prop="orderSide">
              <el-select v-model="subWpfuturesOrderInfoForm.orderSide" clearable placeholder="请输入买入卖出" value="">
                <el-option v-for="data in dicts.orderSide" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开平标志1" prop="positionEffect">
              <el-select v-model="subWpfuturesOrderInfoForm.positionEffect1" clearable placeholder="请输入开平标志1" value="">
                <el-option v-for="data in dicts.positionEffect1" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平标志2" prop="positionEffect2">
              <el-select v-model="subWpfuturesOrderInfoForm.positionEffect2" clearable placeholder="请输入开平标志2" value="">
                <el-option v-for="data in dicts.positionEffect2" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="询价号" prop="inquiryNo">
              <el-input v-model="subWpfuturesOrderInfoForm.inquiryNo" placeholder="请输入询价号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-select v-model="subWpfuturesOrderInfoForm.hedgeFlag" clearable placeholder="请输入投机保值" value="">
                <el-option v-for="data in dicts.hedgeFlag" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托价格1" prop="orderPrice">
              <el-input v-model="subWpfuturesOrderInfoForm.orderPrice" placeholder="请输入委托价格1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托价格2" prop="orderPrice2">
              <el-input v-model="subWpfuturesOrderInfoForm.orderPrice2" placeholder="请输入委托价格2，做市商应价使用" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="触发价格" prop="stopPrice">
              <el-input v-model="subWpfuturesOrderInfoForm.stopPrice" placeholder="请输入触发价格" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托数量" prop="orderQty">
              <el-input v-model="subWpfuturesOrderInfoForm.orderQty" placeholder="请输入委托数量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最小成交量" prop="orderMinQty">
              <el-input v-model="subWpfuturesOrderInfoForm.orderMinQty" placeholder="请输入最小成交量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="整型参考值" prop="refInt">
              <el-input v-model="subWpfuturesOrderInfoForm.refInt" placeholder="请输入整型参考值" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="浮点参考值" prop="refDouble">
              <el-input v-model="subWpfuturesOrderInfoForm.refDouble" placeholder="请输入浮点参考值" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="字符串参考值" prop="refString">
              <el-input v-model="subWpfuturesOrderInfoForm.refString" placeholder="请输入字符串参考值" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冰山单最小随机量" prop="minClipSize">
              <el-input v-model="subWpfuturesOrderInfoForm.minClipSize" placeholder="请输入冰山单最小随机量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冰山单最大随机量" prop="maxClipSize">
              <el-input v-model="subWpfuturesOrderInfoForm.maxClipSize" placeholder="请输入冰山单最大随机量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="软件授权号" prop="licenseNo">
              <el-input v-model="subWpfuturesOrderInfoForm.licenseNo" placeholder="请输入软件授权号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="subWpfuturesOrderInfoForm.serverFlag" placeholder="请输入服务器标识" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderNo" placeholder="请输入委托编码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地委托编号" prop="clientOrderNo">
              <el-input v-model="subWpfuturesOrderInfoForm.clientOrderNo" placeholder="请输入客户端本地委托编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户子账号(对象)" prop="clientID">
              <el-input v-model="subWpfuturesOrderInfoForm.clientID" placeholder="请输入客户子账号(对象)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="策略单类型" prop="tacticsType">
              <el-input v-model="subWpfuturesOrderInfoForm.tacticsType" placeholder="请输入策略单类型" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="触发条件" prop="triggerCondition">
              <el-select v-model="subWpfuturesOrderInfoForm.triggerCondition" clearable placeholder="请输入触发条件" value="">
                <el-option v-for="data in dicts.triggerCondition" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="触发价格类型" prop="triggerPriceType">
              <el-select v-model="subWpfuturesOrderInfoForm.triggerPriceType" clearable placeholder="请输入触发价格类型" value="">
                <el-option v-for="data in dicts.triggerPriceType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否T+1有效" prop="addOneIsValid">
              <el-select v-model="subWpfuturesOrderInfoForm.addOneIsValid" clearable placeholder="请输入是否T+1有效" value="">
                <el-option v-for="data in dicts.addOneIsValid" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="终端本地IP" prop="clientLocalIP">
              <el-input v-model="subWpfuturesOrderInfoForm.clientLocalIP" placeholder="请输入终端本地IP" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="终端本地Mac地址" prop="clientMac">
              <el-input v-model="subWpfuturesOrderInfoForm.clientMac" placeholder="请输入终端本地Mac地址" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="终端网络地址" prop="clientIP">
              <el-input v-model="subWpfuturesOrderInfoForm.clientIP" placeholder="请输入终端网络地址" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托流水号" prop="orderStreamID">
              <el-input v-model="subWpfuturesOrderInfoForm.orderStreamID" placeholder="请输入委托流水号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="subWpfuturesOrderInfoForm.upperNo" placeholder="请输入上手号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手通道号" prop="upperChannelNo">
              <el-input v-model="subWpfuturesOrderInfoForm.upperChannelNo" placeholder="请输入上手通道号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地号" prop="orderLocalNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderLocalNo" placeholder="请输入本地号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上手流号" prop="upperStreamID">
              <el-input v-model="subWpfuturesOrderInfoForm.upperStreamID" placeholder="请输入上手流号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="系统号" prop="orderSystemNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderSystemNo" placeholder="请输入系统号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所系统号" prop="orderExchangeSystemNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderExchangeSystemNo" placeholder="请输入交易所系统号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="父单系统号" prop="orderParentSystemNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderParentSystemNo" placeholder="请输入父单系统号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="下单人" prop="orderInsertUserNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderInsertUserNo" placeholder="请输入下单人" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="下单时间" prop="orderInsertTime">
              <el-input v-model="subWpfuturesOrderInfoForm.orderInsertTime" placeholder="请输入下单时间" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="录单操作人" prop="orderCommandUserNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderCommandUserNo" placeholder="请输入录单操作人" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托更新人" prop="orderUpdateUserNo">
              <el-input v-model="subWpfuturesOrderInfoForm.orderUpdateUserNo" placeholder="请输入委托更新人" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托更新时间" prop="orderUpdateTime">
              <el-input v-model="subWpfuturesOrderInfoForm.orderUpdateTime" placeholder="请输入委托更新时间" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托状态" prop="orderState">
              <el-select v-model="subWpfuturesOrderInfoForm.orderState" clearable placeholder="请输入委托状态" value="">
                <el-option v-for="data in dicts.orderState" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交价1" prop="orderMatchPrice">
              <el-input v-model="subWpfuturesOrderInfoForm.orderMatchPrice" placeholder="请输入成交价1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交价2" prop="orderMatchPrice2">
              <el-input v-model="subWpfuturesOrderInfoForm.orderMatchPrice2" placeholder="请输入成交价2" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交量1" prop="orderMatchQty">
              <el-input v-model="subWpfuturesOrderInfoForm.orderMatchQty" placeholder="请输入成交量1" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交量2" prop="orderMatchQty2">
              <el-input v-model="subWpfuturesOrderInfoForm.orderMatchQty2" placeholder="请输入成交量2" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="信息码" prop="errorCode">
              <el-input v-model="subWpfuturesOrderInfoForm.errorCode" placeholder="请输入最后一次操作错误信息码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="错误信息" prop="errorText">
              <el-input v-model="subWpfuturesOrderInfoForm.errorText" placeholder="请输入错误信息" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否为录入委托单" prop="isBackInput">
              <el-select v-model="subWpfuturesOrderInfoForm.isBackInput" clearable placeholder="请输入是否为录入委托单" value="">
                <el-option v-for="data in dicts.isBackInput" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托成交删除标" prop="isDeleted">
              <el-select v-model="subWpfuturesOrderInfoForm.isDeleted" clearable placeholder="请输入委托成交删除标" value="">
                <el-option v-for="data in dicts.isDeleted" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="是否为T+1单" prop="isAddOne">
              <el-select v-model="subWpfuturesOrderInfoForm.isAddOne" clearable placeholder="请输入是否为T+1单" value="">
                <el-option v-for="data in dicts.isAddOne" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="币种" prop="currencyNo">
              <el-input v-model="subWpfuturesOrderInfoForm.currencyNo" placeholder="请输入币种" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结保证金" prop="frozenDeposit">
              <el-input v-model="subWpfuturesOrderInfoForm.frozenDeposit" placeholder="请输入冻结保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="冻结资金" prop="frozenFund">
              <el-input v-model="subWpfuturesOrderInfoForm.frozenFund" placeholder="请输入冻结资金" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="冻结手续费" prop="frozenFee">
              <el-input v-model="subWpfuturesOrderInfoForm.frozenFee" placeholder="请输入冻结手续费" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubWpfuturesOrderInfoName',
  data() {
    return {
      subWpfuturesOrderInfoLoading: true,
      subWpfuturesOrderInfoDialog: false,
      subWpfuturesOrderInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      subWpfuturesOrderInfoForm: {
        'id': '',
        'subAccountId': '',
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
        'refInt': '',
        'refDouble': '',
        'refString': '',
        'minClipSize': '',
        'maxClipSize': '',
        'licenseNo': '',
        'serverFlag': '',
        'orderNo': '',
        'clientOrderNo': '',
        'clientID': '',
        'tacticsType': '',
        'triggerCondition': '',
        'triggerPriceType': '',
        'addOneIsValid': '',
        'clientLocalIP': '',
        'clientMac': '',
        'clientIP': '',
        'orderStreamID': '',
        'upperNo': '',
        'upperChannelNo': '',
        'orderLocalNo': '',
        'upperStreamID': '',
        'orderSystemNo': '',
        'orderExchangeSystemNo': '',
        'orderParentSystemNo': '',
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
        'currencyNo': '',
        'frozenDeposit': '',
        'frozenFund': '',
        'frozenFee': ''
      },
      searchForm: {
        'subAccountId': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subWpfuturesOrderInfoRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
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
        orderType: [
          { required: true, message: '委托类型不可为空', trigger: 'change' }
        ],
        orderSource: [
          { required: true, message: '委托来源不可为空', trigger: 'change' }
        ],
        timeInForce: [
          { required: true, message: '委托有效类型不可为空', trigger: 'change' }
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
        refInt: [
          { required: true, message: '整型参考值不可为空', trigger: 'change' }
        ],
        refDouble: [
          { required: true, message: '浮点参考值不可为空', trigger: 'change' }
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
        serverFlag: [
          { required: true, message: '服务器标识不可为空', trigger: 'change' }
        ],
        orderNo: [
          { required: true, message: '委托编码不可为空', trigger: 'change' }
        ],
        clientOrderNo: [
          { required: true, message: '客户端本地委托编号不可为空', trigger: 'change' }
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
        clientLocalIP: [
          { required: true, message: '终端本地IP不可为空', trigger: 'change' }
        ],
        clientMac: [
          { required: true, message: '终端本地Mac地址不可为空', trigger: 'change' }
        ],
        clientIP: [
          { required: true, message: '终端网络地址不可为空', trigger: 'change' }
        ],
        orderStreamID: [
          { required: true, message: '委托流水号不可为空', trigger: 'change' }
        ],
        upperStreamID: [
          { required: true, message: '上手流号不可为空', trigger: 'change' }
        ],
        orderInsertUserNo: [
          { required: true, message: '下单人不可为空', trigger: 'change' }
        ],
        orderInsertTime: [
          { required: true, message: '下单时间不可为空', trigger: 'change' }
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
        isBackInput: [
          { required: true, message: '是否为录入委托单不可为空', trigger: 'change' }
        ],
        isDeleted: [
          { required: true, message: '委托成交删除标不可为空', trigger: 'change' }
        ],
        isAddOne: [
          { required: true, message: '是否为T+1单不可为空', trigger: 'change' }
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
        url: '/wpfutures/dict/wpfuturesOrderInfo',
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
      this.subWpfuturesOrderInfoLoading = true;
      this.$http({
        url: '/wpfutures/subWpfuturesOrderInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subWpfuturesOrderInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subWpfuturesOrderInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subWpfuturesOrderInfoForm = {
        'id': '',
        'subAccountId': '',
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
        'refInt': '',
        'refDouble': '',
        'refString': '',
        'minClipSize': '',
        'maxClipSize': '',
        'licenseNo': '',
        'serverFlag': '',
        'orderNo': '',
        'clientOrderNo': '',
        'clientID': '',
        'tacticsType': '',
        'triggerCondition': '',
        'triggerPriceType': '',
        'addOneIsValid': '',
        'clientLocalIP': '',
        'clientMac': '',
        'clientIP': '',
        'orderStreamID': '',
        'upperNo': '',
        'upperChannelNo': '',
        'orderLocalNo': '',
        'upperStreamID': '',
        'orderSystemNo': '',
        'orderExchangeSystemNo': '',
        'orderParentSystemNo': '',
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
        'currencyNo': '',
        'frozenDeposit': '',
        'frozenFund': '',
        'frozenFee': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subWpfuturesOrderInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subWpfuturesOrderInfoForm) {
        this.$refs.subWpfuturesOrderInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/subWpfuturesOrderInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subWpfuturesOrderInfoForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
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
            'refInt': res.object.refInt,
            'refDouble': res.object.refDouble,
            'refString': res.object.refString,
            'minClipSize': res.object.minClipSize,
            'maxClipSize': res.object.maxClipSize,
            'licenseNo': res.object.licenseNo,
            'serverFlag': res.object.serverFlag,
            'orderNo': res.object.orderNo,
            'clientOrderNo': res.object.clientOrderNo,
            'clientID': res.object.clientID,
            'tacticsType': res.object.tacticsType,
            'triggerCondition': res.object.triggerCondition,
            'triggerPriceType': res.object.triggerPriceType,
            'addOneIsValid': res.object.addOneIsValid,
            'clientLocalIP': res.object.clientLocalIP,
            'clientMac': res.object.clientMac,
            'clientIP': res.object.clientIP,
            'orderStreamID': res.object.orderStreamID,
            'upperNo': res.object.upperNo,
            'upperChannelNo': res.object.upperChannelNo,
            'orderLocalNo': res.object.orderLocalNo,
            'upperStreamID': res.object.upperStreamID,
            'orderSystemNo': res.object.orderSystemNo,
            'orderExchangeSystemNo': res.object.orderExchangeSystemNo,
            'orderParentSystemNo': res.object.orderParentSystemNo,
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
            'currencyNo': res.object.currencyNo,
            'frozenDeposit': res.object.frozenDeposit,
            'frozenFund': res.object.frozenFund,
            'frozenFee': res.object.frozenFee
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subWpfuturesOrderInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/subWpfuturesOrderInfo/save',
            method: 'post',
            data: this.subWpfuturesOrderInfoForm
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
          this.subWpfuturesOrderInfoDialog = false;
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
          url: '/wpfutures/subWpfuturesOrderInfo/del',
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
  .subWpfuturesOrderInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
