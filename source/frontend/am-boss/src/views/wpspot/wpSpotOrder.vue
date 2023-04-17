<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-select v-model="searchForm.direction" placeholder="请输入买卖方向">
          <el-option key="0" label="买" value="0"/>
          <el-option key="1" label="卖" value="1"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="wpSpotOrderLoading" :data="wpSpotOrderData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="orderRef" label="报单引用" />
      <el-table-column prop="userID" label="用户代码" />
      <el-table-column prop="orderPriceType" label="报单价格条件" :formatter="statusFormat" />
      <el-table-column prop="direction" label="买卖方向">
        <template scope="scope">
          <p v-if="scope.row.direction=0">买</p>
          <p v-if="scope.row.direction=1">卖</p>
        </template>
      </el-table-column>
      <el-table-column prop="combOffsetFlag" label="组合开平标志" >
        <template scope="scope">
          <p v-if="scope.row.combOffsetFlag==0">开仓</p>
          <p v-if="scope.row.combOffsetFlag==1">平仓</p>
          <p v-if="scope.row.combOffsetFlag==3">平今</p>
        </template>
      </el-table-column>
      <el-table-column prop="combHedgeFlag" label="组合投机套保标志" />
      <el-table-column prop="limitPrice" label="价格" />
      <el-table-column prop="volumeTotalOriginal" label="数量" />
      <el-table-column prop="timeCondition" label="有效期类型" />
      <el-table-column prop="gTDDate" label="GTD日期" />
      <el-table-column prop="volumeCondition" label="成交量类型" :formatter="statusFormat" />
      <el-table-column prop="minVolume" label="最小成交量" />
      <el-table-column prop="contingentCondition" label="触发条件" :formatter="statusFormat" />
      <el-table-column prop="stopPrice" label="止损价" />
      <el-table-column prop="forceCloseReason" label="强平原因" :formatter="statusFormat" />
      <el-table-column prop="isAutoSuspend" label="自动挂起标志" />
      <el-table-column prop="businessUnit" label="业务单元" />
      <el-table-column prop="requestID" label="请求编号" />
      <el-table-column prop="orderLocalID" label="本地报单编号" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="participantID" label="会员代码" />
      <el-table-column prop="clientID" label="客户代码" />
      <el-table-column prop="exchangeInstID" label="合约在交易所的代码" />
      <el-table-column prop="traderID" label="交易所交易员代码" />
      <el-table-column prop="installID" label="安装编号" />
      <el-table-column prop="orderSubmitStatus" label="报单提交状态" :formatter="statusFormat" />
      <el-table-column prop="notifySequence" label="报单提示序号" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="settlementID" label="结算编号" />
      <el-table-column prop="orderSysID" label="报单编号" />
      <el-table-column prop="orderSource" label="报单来源" :formatter="statusFormat" />
      <el-table-column prop="orderStatus" label="报单状态" :formatter="statusFormat" />
      <el-table-column prop="orderType" label="报单类型" :formatter="statusFormat" />
      <el-table-column prop="volumeTraded" label="今成交数量" />
      <el-table-column prop="volumeTotal" label="剩余数量" />
      <el-table-column prop="insertDate" label="报单日期"/>
      <el-table-column prop="insertTime" label="委托时间"/>
      <el-table-column prop="activeTime" label="激活时间"/>
      <el-table-column prop="suspendTime" label="挂起时间"/>
      <el-table-column prop="updateTime" label="最后修改时间"/>
      <el-table-column prop="cancelTime" label="撤销时间"/>
      <el-table-column prop="activeTraderID" label="最后修改交易所交易员代码" />
      <el-table-column prop="clearingPartID" label="结算会员编号" />
      <el-table-column prop="sequenceNo" label="序号" />
      <el-table-column prop="frontID" label="前置编号" />
      <el-table-column prop="sessionID" label="会话编号" />
      <el-table-column prop="userProductInfo" label="用户端产品信息" />
      <el-table-column prop="statusMsg" label="状态信息" />
      <el-table-column prop="userForceClose" label="用户强评标志" />
      <el-table-column prop="activeUserID" label="操作用户代码" />
      <el-table-column prop="brokerOrderSeq" label="经纪公司报单编号" />
      <el-table-column prop="relativeOrderSysID" label="相关报单" />
      <el-table-column prop="zCETotalTradedVolume" label="郑商所成交数量" />
      <el-table-column prop="isSwapOrder" label="互换单标志" />
      <el-table-column prop="branchID" label="营业部编号" />
      <el-table-column prop="investUnitID" label="投资单元代码" />
      <el-table-column prop="currencyID" label="币种代码" />
      <el-table-column prop="iPAddress" label="IP地址" />
      <el-table-column prop="macAddress" label="Mac地址" />
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
    <el-dialog title="外盘现货委托订单表管理" :visible.sync="wpSpotOrderDialog" :close-on-click-modal="false" width="600">
      <el-form ref="wpSpotOrderForm" :model="wpSpotOrderForm" :rules="wpSpotOrderRules" label-width="150px" class="wpSpotOrderForm">
        <el-row>
          <el-col :span=8>
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="wpSpotOrderForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="经纪公司代码" prop="brokerID">
              <el-input v-model="wpSpotOrderForm.brokerID" placeholder="请输入经纪公司代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="投资者代码" prop="investorID">
              <el-input v-model="wpSpotOrderForm.investorID" placeholder="请输入投资者代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="合约代码" prop="instrumentID">
              <el-input v-model="wpSpotOrderForm.instrumentID" placeholder="请输入合约代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单引用" prop="orderRef">
              <el-input v-model="wpSpotOrderForm.orderRef" placeholder="请输入报单引用" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="用户代码" prop="userID">
              <el-input v-model="wpSpotOrderForm.userID" placeholder="请输入用户代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="用户代码" prop="userID">
              <el-input v-model="wpSpotOrderForm.userID" placeholder="请输入用户代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单价格条件" prop="orderPriceType">
              <el-input v-model="wpSpotOrderForm.orderPriceType" placeholder="请输入报单价格条件" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="买卖方向" prop="direction">
              <el-input v-model="wpSpotOrderForm.direction" placeholder="请输入买卖方向(0买、1卖)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="组合开平标志" prop="combOffsetFlag">
              <el-input v-model="wpSpotOrderForm.combOffsetFlag" placeholder="请输入组合开平标志" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="组合投机套保标志" prop="combHedgeFlag">
              <el-input v-model="wpSpotOrderForm.combHedgeFlag" placeholder="请输入组合投机套保标志" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="价格" prop="limitPrice">
              <el-input v-model="wpSpotOrderForm.limitPrice" placeholder="请输入价格" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="数量" prop="volumeTotalOriginal">
              <el-input v-model="wpSpotOrderForm.volumeTotalOriginal" placeholder="请输入数量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="有效期类型" prop="timeCondition">
              <el-input v-model="wpSpotOrderForm.timeCondition" placeholder="请输入有效期类型" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="GTD日期" prop="gTDDate">
              <el-input v-model="wpSpotOrderForm.gTDDate" placeholder="请输入GTD日期" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="成交量类型" prop="volumeCondition">
              <el-input v-model="wpSpotOrderForm.volumeCondition" placeholder="请输入成交量类型" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="最小成交量" prop="minVolume">
              <el-input v-model="wpSpotOrderForm.minVolume" placeholder="请输入最小成交量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="触发条件" prop="contingentCondition">
              <el-input v-model="wpSpotOrderForm.contingentCondition" placeholder="请输入触发条件" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="止损价" prop="stopPrice">
              <el-input v-model="wpSpotOrderForm.stopPrice" placeholder="请输入止损价" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="强平原因" prop="forceCloseReason">
              <el-input v-model="wpSpotOrderForm.forceCloseReason" placeholder="请输入强平原因" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="自动挂起标志" prop="isAutoSuspend">
              <el-input v-model="wpSpotOrderForm.isAutoSuspend" placeholder="请输入自动挂起标志" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="业务单元" prop="businessUnit">
              <el-input v-model="wpSpotOrderForm.businessUnit" placeholder="请输入业务单元" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="请求编号" prop="requestID">
              <el-input v-model="wpSpotOrderForm.requestID" placeholder="请输入请求编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="本地报单编号" prop="orderLocalID">
              <el-input v-model="wpSpotOrderForm.orderLocalID" placeholder="请输入本地报单编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="wpSpotOrderForm.exchangeID" placeholder="请输入交易所代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="会员代码" prop="participantID">
              <el-input v-model="wpSpotOrderForm.participantID" placeholder="请输入会员代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户代码" prop="clientID">
              <el-input v-model="wpSpotOrderForm.clientID" placeholder="请输入客户代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="合约在交易所的代码" prop="exchangeInstID">
              <el-input v-model="wpSpotOrderForm.exchangeInstID" placeholder="请输入合约在交易所的代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="交易所交易员代码" prop="traderID">
              <el-input v-model="wpSpotOrderForm.traderID" placeholder="请输入交易所交易员代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="安装编号" prop="installID">
              <el-input v-model="wpSpotOrderForm.installID" placeholder="请输入安装编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="报单提交状态" prop="orderSubmitStatus">
              <el-input v-model="wpSpotOrderForm.orderSubmitStatus" placeholder="请输入报单提交状态" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单提示序号" prop="notifySequence">
              <el-input v-model="wpSpotOrderForm.notifySequence" placeholder="请输入报单提示序号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="wpSpotOrderForm.tradingDay" placeholder="请输入交易日" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="结算编号" prop="settlementID">
              <el-input v-model="wpSpotOrderForm.settlementID" placeholder="请输入结算编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单编号" prop="orderSysID">
              <el-input v-model="wpSpotOrderForm.orderSysID" placeholder="请输入报单编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单来源" prop="orderSource">
              <el-input v-model="wpSpotOrderForm.orderSource" placeholder="请输入报单来源" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="报单状态" prop="orderStatus">
              <el-input v-model="wpSpotOrderForm.orderStatus" placeholder="请输入报单状态" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单类型" prop="orderType">
              <el-input v-model="wpSpotOrderForm.orderType" placeholder="请输入报单类型" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="今成交数量" prop="volumeTraded">
              <el-input v-model="wpSpotOrderForm.volumeTraded" placeholder="请输入今成交数量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="今成交数量" prop="volumeTraded">
              <el-input v-model="wpSpotOrderForm.volumeTraded" placeholder="请输入今成交数量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="剩余数量" prop="volumeTotal">
              <el-input v-model="wpSpotOrderForm.volumeTotal" placeholder="请输入剩余数量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="报单日期" prop="insertDate">
              <el-input v-model="wpSpotOrderForm.insertDate" placeholder="请输入报单日期" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="委托时间" prop="insertTime">
              <el-input v-model="wpSpotOrderForm.insertTime" placeholder="请输入委托时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="激活时间" prop="activeTime">
              <el-input v-model="wpSpotOrderForm.activeTime" placeholder="请输入激活时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="挂起时间" prop="suspendTime">
              <el-input v-model="wpSpotOrderForm.suspendTime" placeholder="请输入挂起时间" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="最后修改时间" prop="updateTime">
              <el-input v-model="wpSpotOrderForm.updateTime" placeholder="请输入最后修改时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="撤销时间" prop="cancelTime">
              <el-input v-model="wpSpotOrderForm.cancelTime" placeholder="请输入撤销时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="最后修改交易所交易员代码" prop="activeTraderID">
              <el-input v-model="wpSpotOrderForm.activeTraderID" placeholder="请输入最后修改交易所交易员代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="结算会员编号" prop="clearingPartID">
              <el-input v-model="wpSpotOrderForm.clearingPartID" placeholder="请输入结算会员编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="序号" prop="sequenceNo">
              <el-input v-model="wpSpotOrderForm.sequenceNo" placeholder="请输入序号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="前置编号" prop="frontID">
              <el-input v-model="wpSpotOrderForm.frontID" placeholder="请输入前置编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="会话编号" prop="sessionID">
              <el-input v-model="wpSpotOrderForm.sessionID" placeholder="请输入会话编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="用户端产品信息" prop="userProductInfo">
              <el-input v-model="wpSpotOrderForm.userProductInfo" placeholder="请输入用户端产品信息" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="状态信息" prop="statusMsg">
              <el-input v-model="wpSpotOrderForm.statusMsg" placeholder="请输入状态信息" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="用户强评标志" prop="userForceClose">
              <el-input v-model="wpSpotOrderForm.userForceClose" placeholder="请输入用户强评标志" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="操作用户代码" prop="activeUserID">
              <el-input v-model="wpSpotOrderForm.activeUserID" placeholder="请输入操作用户代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="经纪公司报单编号" prop="brokerOrderSeq">
              <el-input v-model="wpSpotOrderForm.brokerOrderSeq" placeholder="请输入经纪公司报单编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="相关报单" prop="relativeOrderSysID">
              <el-input v-model="wpSpotOrderForm.relativeOrderSysID" placeholder="请输入相关报单" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="郑商所成交数量" prop="zCETotalTradedVolume">
              <el-input v-model="wpSpotOrderForm.zCETotalTradedVolume" placeholder="请输入郑商所成交数量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="互换单标志" prop="isSwapOrder">
              <el-input v-model="wpSpotOrderForm.isSwapOrder" placeholder="请输入互换单标志" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="营业部编号" prop="branchID">
              <el-input v-model="wpSpotOrderForm.branchID" placeholder="请输入营业部编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="投资单元代码" prop="investUnitID">
              <el-input v-model="wpSpotOrderForm.investUnitID" placeholder="请输入投资单元代码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="币种代码" prop="currencyID">
              <el-input v-model="wpSpotOrderForm.currencyID" placeholder="请输入币种代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="IP地址" prop="iPAddress">
              <el-input v-model="wpSpotOrderForm.iPAddress" placeholder="请输入IP地址" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="Mac地址" prop="macAddress">
              <el-input v-model="wpSpotOrderForm.macAddress" placeholder="请输入Mac地址" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpSpotOrderName',
  data() {
    return {
      wpSpotOrderLoading: true,
      wpSpotOrderDialog: false,
      wpSpotOrderData: [],
      commodityTypeSelects: [],
      dicts: [],
      orderPriceType: [],
      wpSpotOrderForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'instrumentID': '',
        'orderRef': '',
        'userID': '',
        'orderPriceType': '',
        'direction': '',
        'combOffsetFlag': '',
        'combHedgeFlag': '',
        'limitPrice': '',
        'volumeTotalOriginal': '',
        'timeCondition': '',
        'gTDDate': '',
        'volumeCondition': '',
        'minVolume': '',
        'contingentCondition': '',
        'stopPrice': '',
        'forceCloseReason': '',
        'isAutoSuspend': '',
        'businessUnit': '',
        'requestID': '',
        'orderLocalID': '',
        'exchangeID': '',
        'participantID': '',
        'clientID': '',
        'exchangeInstID': '',
        'traderID': '',
        'installID': '',
        'orderSubmitStatus': '',
        'notifySequence': '',
        'tradingDay': '',
        'settlementID': '',
        'orderSysID': '',
        'orderSource': '',
        'orderStatus': '',
        'orderType': '',
        'volumeTraded': '',
        'volumeTotal': '',
        'insertDate': '',
        'insertTime': '',
        'activeTime': '',
        'suspendTime': '',
        'updateTime': '',
        'cancelTime': '',
        'activeTraderID': '',
        'clearingPartID': '',
        'sequenceNo': '',
        'frontID': '',
        'sessionID': '',
        'userProductInfo': '',
        'statusMsg': '',
        'userForceClose': '',
        'activeUserID': '',
        'brokerOrderSeq': '',
        'relativeOrderSysID': '',
        'zCETotalTradedVolume': '',
        'isSwapOrder': '',
        'branchID': '',
        'investUnitID': '',
        'accountNo': '',
        'currencyID': '',
        'iPAddress': '',
        'macAddress': '',
        'errorID': '',
        'errorMsg': '',
        'orderActionRef': '',
        'actionFlag': '',
        'volumeChange': '',
        'actionDate': '',
        'actionTime': '',
        'actionLocalID': '',
        'orderActionStatus': ''
      },
      searchForm: {
        'accountId': '',
        'investorID': '',
        'instrumentID': '',
        'orderPriceType': '',
        'direction': '',
        'orderStatus': '',
        'currencyID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpSpotOrderRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者代码不可为空', trigger: 'change' }
        ],
        instrumentID: [
          { required: true, message: '合约代码不可为空', trigger: 'change' }
        ],
        orderRef: [
          { required: true, message: '报单引用不可为空', trigger: 'change' }
        ],
        userID: [
          { required: true, message: '用户代码不可为空', trigger: 'change' }
        ],
        orderPriceType: [
          { required: true, message: '报单价格条件(报单价格条件类型数据字典)不可为空', trigger: 'change' }
        ],
        direction: [
          { required: true, message: '买卖方向(0买、1卖)不可为空', trigger: 'change' }
        ],
        combOffsetFlag: [
          { required: true, message: '组合开平标志不可为空', trigger: 'change' }
        ],
        combHedgeFlag: [
          { required: true, message: '组合投机套保标志不可为空', trigger: 'change' }
        ],
        limitPrice: [
          { required: true, message: '价格不可为空', trigger: 'change' }
        ],
        volumeTotalOriginal: [
          { required: true, message: '数量不可为空', trigger: 'change' }
        ],
        timeCondition: [
          { required: true, message: '有效期类型不可为空', trigger: 'change' }
        ],
        volumeCondition: [
          { required: true, message: '成交量类型(成交量类型类型数据字典)不可为空', trigger: 'change' }
        ],
        minVolume: [
          { required: true, message: '最小成交量不可为空', trigger: 'change' }
        ],
        contingentCondition: [
          { required: true, message: '触发条件(触发条件类型数据字典)不可为空', trigger: 'change' }
        ],
        stopPrice: [
          { required: true, message: '止损价不可为空', trigger: 'change' }
        ],
        forceCloseReason: [
          { required: true, message: '强平原因(强平原因类型数据字典)不可为空', trigger: 'change' }
        ],
        isAutoSuspend: [
          { required: true, message: '自动挂起标志不可为空', trigger: 'change' }
        ],
        requestID: [
          { required: true, message: '请求编号不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        clientID: [
          { required: true, message: '客户代码不可为空', trigger: 'change' }
        ],
        userForceClose: [
          { required: true, message: '用户强评标志不可为空', trigger: 'change' }
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
        url: '/wpspot/dict/wpSpotOrder',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          this.orderPriceType = res.object.orderPriceType.list;
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
      this.wpSpotOrderLoading = true;
      this.$http({
        url: '/wpspot/wpSpotOrder/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotOrderData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpSpotOrderLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpSpotOrderForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'instrumentID': '',
        'orderRef': '',
        'userID': '',
        'orderPriceType': '',
        'direction': '',
        'combOffsetFlag': '',
        'combHedgeFlag': '',
        'limitPrice': '',
        'volumeTotalOriginal': '',
        'timeCondition': '',
        'gTDDate': '',
        'volumeCondition': '',
        'minVolume': '',
        'contingentCondition': '',
        'stopPrice': '',
        'forceCloseReason': '',
        'isAutoSuspend': '',
        'businessUnit': '',
        'requestID': '',
        'orderLocalID': '',
        'exchangeID': '',
        'participantID': '',
        'clientID': '',
        'exchangeInstID': '',
        'traderID': '',
        'installID': '',
        'orderSubmitStatus': '',
        'notifySequence': '',
        'tradingDay': '',
        'settlementID': '',
        'orderSysID': '',
        'orderSource': '',
        'orderStatus': '',
        'orderType': '',
        'volumeTraded': '',
        'volumeTotal': '',
        'insertDate': '',
        'insertTime': '',
        'activeTime': '',
        'suspendTime': '',
        'updateTime': '',
        'cancelTime': '',
        'activeTraderID': '',
        'clearingPartID': '',
        'sequenceNo': '',
        'frontID': '',
        'sessionID': '',
        'userProductInfo': '',
        'statusMsg': '',
        'userForceClose': '',
        'activeUserID': '',
        'brokerOrderSeq': '',
        'relativeOrderSysID': '',
        'zCETotalTradedVolume': '',
        'isSwapOrder': '',
        'branchID': '',
        'investUnitID': '',
        'accountNo': '',
        'currencyID': '',
        'iPAddress': '',
        'macAddress': '',
        'errorID': '',
        'errorMsg': '',
        'orderActionRef': '',
        'actionFlag': '',
        'volumeChange': '',
        'actionDate': '',
        'actionTime': '',
        'actionLocalID': '',
        'orderActionStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpSpotOrderDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpSpotOrderForm) {
        this.$refs.wpSpotOrderForm.resetFields();
      }
      this.$http({
        url: '/wpspot/wpSpotOrder/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotOrderForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'instrumentID': res.object.instrumentID,
            'orderRef': res.object.orderRef,
            'userID': res.object.userID,
            'orderPriceType': res.object.orderPriceType,
            'direction': res.object.direction,
            'combOffsetFlag': res.object.combOffsetFlag,
            'combHedgeFlag': res.object.combHedgeFlag,
            'limitPrice': res.object.limitPrice,
            'volumeTotalOriginal': res.object.volumeTotalOriginal,
            'timeCondition': res.object.timeCondition,
            'gTDDate': res.object.gTDDate,
            'volumeCondition': res.object.volumeCondition,
            'minVolume': res.object.minVolume,
            'contingentCondition': res.object.contingentCondition,
            'stopPrice': res.object.stopPrice,
            'forceCloseReason': res.object.forceCloseReason,
            'isAutoSuspend': res.object.isAutoSuspend,
            'businessUnit': res.object.businessUnit,
            'requestID': res.object.requestID,
            'orderLocalID': res.object.orderLocalID,
            'exchangeID': res.object.exchangeID,
            'participantID': res.object.participantID,
            'clientID': res.object.clientID,
            'exchangeInstID': res.object.exchangeInstID,
            'traderID': res.object.traderID,
            'installID': res.object.installID,
            'orderSubmitStatus': res.object.orderSubmitStatus,
            'notifySequence': res.object.notifySequence,
            'tradingDay': res.object.tradingDay,
            'settlementID': res.object.settlementID,
            'orderSysID': res.object.orderSysID,
            'orderSource': res.object.orderSource,
            'orderStatus': res.object.orderStatus,
            'orderType': res.object.orderType,
            'volumeTraded': res.object.volumeTraded,
            'volumeTotal': res.object.volumeTotal,
            'insertDate': res.object.insertDate,
            'insertTime': res.object.insertTime,
            'activeTime': res.object.activeTime,
            'suspendTime': res.object.suspendTime,
            'updateTime': res.object.updateTime,
            'cancelTime': res.object.cancelTime,
            'activeTraderID': res.object.activeTraderID,
            'clearingPartID': res.object.clearingPartID,
            'sequenceNo': res.object.sequenceNo,
            'frontID': res.object.frontID,
            'sessionID': res.object.sessionID,
            'userProductInfo': res.object.userProductInfo,
            'statusMsg': res.object.statusMsg,
            'userForceClose': res.object.userForceClose,
            'activeUserID': res.object.activeUserID,
            'brokerOrderSeq': res.object.brokerOrderSeq,
            'relativeOrderSysID': res.object.relativeOrderSysID,
            'zCETotalTradedVolume': res.object.zCETotalTradedVolume,
            'isSwapOrder': res.object.isSwapOrder,
            'branchID': res.object.branchID,
            'investUnitID': res.object.investUnitID,
            'accountNo': res.object.accountNo,
            'currencyID': res.object.currencyID,
            'iPAddress': res.object.iPAddress,
            'macAddress': res.object.macAddress,
            'errorID': res.object.errorID,
            'errorMsg': res.object.errorMsg,
            'orderActionRef': res.object.orderActionRef,
            'actionFlag': res.object.actionFlag,
            'volumeChange': res.object.volumeChange,
            'actionDate': res.object.actionDate,
            'actionTime': res.object.actionTime,
            'actionLocalID': res.object.actionLocalID,
            'orderActionStatus': res.object.orderActionStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpSpotOrderDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/wpSpotOrder/save',
            method: 'post',
            data: this.wpSpotOrderForm
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
          this.wpSpotOrderDialog = false;
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
          url: '/wpspot/wpSpotOrder/del',
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
		.wpSpotOrderForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
