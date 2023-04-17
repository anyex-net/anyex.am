<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-input v-model="searchForm.direction" clearable placeholder="请输入买卖方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="stpNpSpotOrderLoading"
      :data="stpNpSpotOrderData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
          <!--          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>-->
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="businessUnitID" label="投资单元代码" />
      <el-table-column prop="shareholderID" label="股东账户代码" />
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="direction" label="买卖方向" :formatter="statusFormat" />
      <el-table-column prop="orderPriceType" label="报单价格条件" :formatter="statusFormat" />
      <el-table-column prop="timeCondition" label="有效期类型" :formatter="statusFormat" />
      <el-table-column prop="volumeCondition" label="成交量类型" :formatter="statusFormat" />
      <el-table-column prop="limitPrice" label="价格" />
      <el-table-column prop="volumeTotalOriginal" label="数量" />
      <el-table-column prop="lotType" label="港股通订单数量类型" />
      <el-table-column prop="gTDate" label="有效日期" :formatter="dateFormat" />
      <el-table-column prop="operway" label="委托方式" />
      <el-table-column prop="condCheck" label="条件检查" />
      <el-table-column prop="sInfo" label="字符串附加信息" />
      <el-table-column prop="iInfo" label="整形附加信息" />
      <el-table-column prop="requestID" label="请求编号" />
      <el-table-column prop="frontID" label="前置编号" />
      <el-table-column prop="sessionID" label="会话编号" />
      <el-table-column prop="orderRef" label="报单引用" />
      <el-table-column prop="orderLocalID" label="本地报单编号" />
      <el-table-column prop="orderSysID" label="系统报单编号" />
      <el-table-column prop="orderStatus" label="报单状态" :formatter="statusFormat" />
      <el-table-column prop="orderSubmitStatus" label="报单提交状态" :formatter="statusFormat" />
      <el-table-column prop="statusMsg" label="状态信息" />
      <el-table-column prop="volumeTraded" label="已成交数量" />
      <el-table-column prop="volumeCanceled" label="已撤销数量" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="insertUser" label="申报用户" />
      <el-table-column prop="insertDate" label="申报日期" />
      <el-table-column prop="insertTime" label="申报时间" />
      <el-table-column prop="acceptTime" label="交易所接收时间" />
      <el-table-column prop="cancelUser" label="撤销用户" />
      <el-table-column prop="cancelTime" label="撤销时间" />
      <el-table-column prop="departmentID" label="经纪公司部门代码" />
      <el-table-column prop="accountNo" label="资金账户代码(对应AccountID)" />
      <el-table-column prop="currencyID" label="币种" />
      <el-table-column prop="pbuID" label="交易单元代码" />
      <el-table-column prop="turnover" label="成交金额" />
      <el-table-column prop="orderType" label="报单类型" :formatter="statusFormat" />
      <el-table-column prop="userProductInfo" label="用户端产品信息" />
      <el-table-column prop="forceCloseReason" label="强平原因(两融专用)" />
      <el-table-column prop="creditQuotaID" label="信用头寸编号(两融专用)" />
      <el-table-column prop="creditQuotaType" label="头寸类型(两融专用)" />
      <el-table-column prop="creditDebtID" label="信用负债编号(两融专用)" />
      <el-table-column prop="iPAddress" label="IP地址" />
      <el-table-column prop="macAddress" label="Mac地址" />
      <el-table-column prop="rtnFloatInfo" label="回报附加浮点型数据信息" />
      <el-table-column prop="rtnIntInfo" label="回报附加整型数据" />
      <el-table-column prop="errorID" label="错误代码" />
      <el-table-column prop="errorMsg" label="错误信息" />
      <el-table-column prop="discountCouponID" label="费息折扣券编号（0表示不使用折扣券）(两融专用)" />
      <el-table-column prop="actionFlag" label="操作标志" :formatter="statusFormat" />
      <el-table-column prop="orderActionRef" label="报单操作引用" />
      <el-table-column prop="cancelOrderSysID" label="系统撤单编号" />
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
    <el-dialog title="内盘现货委托订单" :visible.sync="stpNpSpotOrderDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="stpNpSpotOrderForm"
        :model="stpNpSpotOrderForm"
        :rules="stpNpSpotOrderRules"
        label-width="150px"
        class="stpNpSpotOrderForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="stpNpSpotOrderForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪公司代码" prop="brokerID">
              <el-input v-model="stpNpSpotOrderForm.brokerID" placeholder="请输入经纪公司代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="stpNpSpotOrderForm.exchangeID" placeholder="请输入交易所代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="投资者代码" prop="investorID">
              <el-input v-model="stpNpSpotOrderForm.investorID" placeholder="请输入投资者代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投资单元代码" prop="businessUnitID">
              <el-input v-model="stpNpSpotOrderForm.businessUnitID" placeholder="请输入投资单元代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="股东账户代码" prop="shareholderID">
              <el-input v-model="stpNpSpotOrderForm.shareholderID" placeholder="请输入股东账户代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="证券代码" prop="securityID">
              <el-input v-model="stpNpSpotOrderForm.securityID" placeholder="请输入证券代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买卖方向" prop="direction">
              <el-input v-model="stpNpSpotOrderForm.direction" placeholder="请输入买卖方向" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报单价格条件" prop="orderPriceType">
              <el-input v-model="stpNpSpotOrderForm.orderPriceType" placeholder="请输入报单价格条件" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="有效期类型" prop="timeCondition">
              <el-input v-model="stpNpSpotOrderForm.timeCondition" placeholder="请输入有效期类型" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交量类型" prop="volumeCondition">
              <el-input v-model="stpNpSpotOrderForm.volumeCondition" placeholder="请输入成交量类型" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格" prop="limitPrice">
              <el-input v-model="stpNpSpotOrderForm.limitPrice" placeholder="请输入价格" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="数量" prop="volumeTotalOriginal">
              <el-input v-model="stpNpSpotOrderForm.volumeTotalOriginal" placeholder="请输入数量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="港股通订单数量类型" prop="lotType">
              <el-input v-model="stpNpSpotOrderForm.lotType" placeholder="请输入港股通订单数量类型" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="有效日期" prop="gTDate">
              <el-input v-model="stpNpSpotOrderForm.gTDate" placeholder="请输入有效日期" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托方式" prop="operway">
              <el-input v-model="stpNpSpotOrderForm.operway" placeholder="请输入委托方式" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="条件检查" prop="condCheck">
              <el-input v-model="stpNpSpotOrderForm.condCheck" placeholder="请输入条件检查" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="字符串附加信息" prop="sInfo">
              <el-input v-model="stpNpSpotOrderForm.sInfo" placeholder="请输入字符串附加信息" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="整形附加信息" prop="iInfo">
              <el-input v-model="stpNpSpotOrderForm.iInfo" placeholder="请输入整形附加信息" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="请求编号" prop="requestID">
              <el-input v-model="stpNpSpotOrderForm.requestID" placeholder="请输入请求编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="前置编号" prop="frontID">
              <el-input v-model="stpNpSpotOrderForm.frontID" placeholder="请输入前置编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="会话编号" prop="sessionID">
              <el-input v-model="stpNpSpotOrderForm.sessionID" placeholder="请输入会话编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报单引用" prop="orderRef">
              <el-input v-model="stpNpSpotOrderForm.orderRef" placeholder="请输入报单引用" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="本地报单编号" prop="orderLocalID">
              <el-input v-model="stpNpSpotOrderForm.orderLocalID" placeholder="请输入本地报单编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="系统报单编号" prop="orderSysID">
              <el-input v-model="stpNpSpotOrderForm.orderSysID" placeholder="请输入系统报单编号" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报单状态" prop="orderStatus">
              <el-input v-model="stpNpSpotOrderForm.orderStatus" placeholder="请输入报单状态" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报单提交状态" prop="orderSubmitStatus">
              <el-input v-model="stpNpSpotOrderForm.orderSubmitStatus" placeholder="请输入报单提交状态" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="状态信息" prop="statusMsg">
              <el-input v-model="stpNpSpotOrderForm.statusMsg" placeholder="请输入状态信息" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="已成交数量" prop="volumeTraded">
              <el-input v-model="stpNpSpotOrderForm.volumeTraded" placeholder="请输入已成交数量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="已撤销数量" prop="volumeCanceled">
              <el-input v-model="stpNpSpotOrderForm.volumeCanceled" placeholder="请输入已撤销数量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易日" prop="tradingDay">
              <el-input v-model="stpNpSpotOrderForm.tradingDay" placeholder="请输入交易日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="申报用户" prop="insertUser">
              <el-input v-model="stpNpSpotOrderForm.insertUser" placeholder="请输入申报用户" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="申报日期" prop="insertDate">
              <el-input v-model="stpNpSpotOrderForm.insertDate" placeholder="请输入申报日期" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="申报时间" prop="insertTime">
              <el-input v-model="stpNpSpotOrderForm.insertTime" placeholder="请输入申报时间" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所接收时间" prop="acceptTime">
              <el-input v-model="stpNpSpotOrderForm.acceptTime" placeholder="请输入交易所接收时间" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="撤销用户" prop="cancelUser">
              <el-input v-model="stpNpSpotOrderForm.cancelUser" placeholder="请输入撤销用户" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="撤销时间" prop="cancelTime">
              <el-input v-model="stpNpSpotOrderForm.cancelTime" placeholder="请输入撤销时间" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="经纪公司部门代码" prop="departmentID">
              <el-input v-model="stpNpSpotOrderForm.departmentID" placeholder="请输入经纪公司部门代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="资金账户代码(对应AccountID)" prop="accountNo">
              <el-input v-model="stpNpSpotOrderForm.accountNo" placeholder="请输入资金账户代码(对应AccountID)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="币种" prop="currencyID">
              <el-input v-model="stpNpSpotOrderForm.currencyID" placeholder="请输入币种" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易单元代码" prop="pbuID">
              <el-input v-model="stpNpSpotOrderForm.pbuID" placeholder="请输入交易单元代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="成交金额" prop="turnover">
              <el-input v-model="stpNpSpotOrderForm.turnover" placeholder="请输入成交金额" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="报单类型" prop="orderType">
              <el-input v-model="stpNpSpotOrderForm.orderType" placeholder="请输入报单类型" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="用户端产品信息" prop="userProductInfo">
              <el-input v-model="stpNpSpotOrderForm.userProductInfo" placeholder="请输入用户端产品信息" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="强平原因(两融专用)" prop="forceCloseReason">
              <el-input v-model="stpNpSpotOrderForm.forceCloseReason" placeholder="请输入强平原因(两融专用)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="信用头寸编号(两融专用)" prop="creditQuotaID">
              <el-input v-model="stpNpSpotOrderForm.creditQuotaID" placeholder="请输入信用头寸编号(两融专用)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="头寸类型(两融专用)" prop="creditQuotaType">
              <el-input v-model="stpNpSpotOrderForm.creditQuotaType" placeholder="请输入头寸类型(两融专用)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="信用负债编号(两融专用)" prop="creditDebtID">
              <el-input v-model="stpNpSpotOrderForm.creditDebtID" placeholder="请输入信用负债编号(两融专用)" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="IP地址" prop="iPAddress">
              <el-input v-model="stpNpSpotOrderForm.iPAddress" placeholder="请输入IP地址" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Mac地址" prop="macAddress">
              <el-input v-model="stpNpSpotOrderForm.macAddress" placeholder="请输入Mac地址" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="回报附加浮点型数据信息" prop="rtnFloatInfo">
              <el-input v-model="stpNpSpotOrderForm.rtnFloatInfo" placeholder="请输入回报附加浮点型数据信息" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="回报附加整型数据" prop="rtnIntInfo">
              <el-input v-model="stpNpSpotOrderForm.rtnIntInfo" placeholder="请输入回报附加整型数据" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="错误代码" prop="errorID">
              <el-input v-model="stpNpSpotOrderForm.errorID" placeholder="请输入错误代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="错误信息" prop="errorMsg">
              <el-input v-model="stpNpSpotOrderForm.errorMsg" placeholder="请输入错误信息" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="费息折扣券编号（0表示不使用折扣券）(两融专用)" prop="discountCouponID">
              <el-input v-model="stpNpSpotOrderForm.discountCouponID" placeholder="请输入费息折扣券编号（0表示不使用折扣券）(两融专用)" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="操作标志" prop="actionFlag">
              <el-input v-model="stpNpSpotOrderForm.actionFlag" placeholder="请输入操作标志" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报单操作引用" prop="orderActionRef">
              <el-input v-model="stpNpSpotOrderForm.orderActionRef" placeholder="请输入报单操作引用" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="系统撤单编号" prop="cancelOrderSysID">
              <el-input v-model="stpNpSpotOrderForm.cancelOrderSysID" placeholder="请输入系统撤单编号" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotOrderName',
  data() {
    return {
      stpNpSpotOrderLoading: true,
      stpNpSpotOrderDialog: false,
      stpNpSpotOrderData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotOrderForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'exchangeID': '',
        'investorID': '',
        'businessUnitID': '',
        'shareholderID': '',
        'securityID': '',
        'direction': '',
        'orderPriceType': '',
        'timeCondition': '',
        'volumeCondition': '',
        'limitPrice': '',
        'volumeTotalOriginal': '',
        'lotType': '',
        'gTDate': '',
        'operway': '',
        'condCheck': '',
        'sInfo': '',
        'iInfo': '',
        'requestID': '',
        'frontID': '',
        'sessionID': '',
        'orderRef': '',
        'orderLocalID': '',
        'orderSysID': '',
        'orderStatus': '',
        'orderSubmitStatus': '',
        'statusMsg': '',
        'volumeTraded': '',
        'volumeCanceled': '',
        'tradingDay': '',
        'insertUser': '',
        'insertDate': '',
        'insertTime': '',
        'acceptTime': '',
        'cancelUser': '',
        'cancelTime': '',
        'departmentID': '',
        'accountNo': '',
        'currencyID': '',
        'pbuID': '',
        'turnover': '',
        'orderType': '',
        'userProductInfo': '',
        'forceCloseReason': '',
        'creditQuotaID': '',
        'creditQuotaType': '',
        'creditDebtID': '',
        'iPAddress': '',
        'macAddress': '',
        'rtnFloatInfo': '',
        'rtnIntInfo': '',
        'errorID': '',
        'errorMsg': '',
        'discountCouponID': '',
        'actionFlag': '',
        'orderActionRef': '',
        'cancelOrderSysID': ''
      },
      searchForm: {
        'accountId': '',
        'brokerID': '',
        'exchangeID': '',
        'investorID': '',
        'businessUnitID': '',
        'shareholderID': '',
        'securityID': '',
        'direction': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotOrderRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者代码不可为空', trigger: 'change' }
        ],
        businessUnitID: [
          { required: true, message: '投资单元代码不可为空', trigger: 'change' }
        ],
        shareholderID: [
          { required: true, message: '股东账户代码不可为空', trigger: 'change' }
        ],
        securityID: [
          { required: true, message: '证券代码不可为空', trigger: 'change' }
        ],
        direction: [
          { required: true, message: '买卖方向不可为空', trigger: 'change' }
        ],
        orderPriceType: [
          { required: true, message: '报单价格条件不可为空', trigger: 'change' }
        ],
        timeCondition: [
          { required: true, message: '有效期类型不可为空', trigger: 'change' }
        ],
        volumeCondition: [
          { required: true, message: '成交量类型不可为空', trigger: 'change' }
        ],
        limitPrice: [
          { required: true, message: '价格不可为空', trigger: 'change' }
        ],
        volumeTotalOriginal: [
          { required: true, message: '数量不可为空', trigger: 'change' }
        ],
        lotType: [
          { required: true, message: '港股通订单数量类型不可为空', trigger: 'change' }
        ],
        gTDate: [
          { required: true, message: '有效日期不可为空', trigger: 'change' }
        ],
        operway: [
          { required: true, message: '委托方式不可为空', trigger: 'change' }
        ],
        condCheck: [
          { required: true, message: '条件检查不可为空', trigger: 'change' }
        ],
        sInfo: [
          { required: true, message: '字符串附加信息不可为空', trigger: 'change' }
        ],
        iInfo: [
          { required: true, message: '整形附加信息不可为空', trigger: 'change' }
        ],
        requestID: [
          { required: true, message: '请求编号不可为空', trigger: 'change' }
        ],
        frontID: [
          { required: true, message: '前置编号不可为空', trigger: 'change' }
        ],
        sessionID: [
          { required: true, message: '会话编号不可为空', trigger: 'change' }
        ],
        orderRef: [
          { required: true, message: '报单引用不可为空', trigger: 'change' }
        ],
        orderLocalID: [
          { required: true, message: '本地报单编号不可为空', trigger: 'change' }
        ],
        orderSysID: [
          { required: true, message: '系统报单编号不可为空', trigger: 'change' }
        ],
        orderStatus: [
          { required: true, message: '报单状态不可为空', trigger: 'change' }
        ],
        orderSubmitStatus: [
          { required: true, message: '报单提交状态不可为空', trigger: 'change' }
        ],
        statusMsg: [
          { required: true, message: '状态信息不可为空', trigger: 'change' }
        ],
        volumeTraded: [
          { required: true, message: '已成交数量不可为空', trigger: 'change' }
        ],
        volumeCanceled: [
          { required: true, message: '已撤销数量不可为空', trigger: 'change' }
        ],
        tradingDay: [
          { required: true, message: '交易日不可为空', trigger: 'change' }
        ],
        insertUser: [
          { required: true, message: '申报用户不可为空', trigger: 'change' }
        ],
        insertDate: [
          { required: true, message: '申报日期不可为空', trigger: 'change' }
        ],
        insertTime: [
          { required: true, message: '申报时间不可为空', trigger: 'change' }
        ],
        acceptTime: [
          { required: true, message: '交易所接收时间不可为空', trigger: 'change' }
        ],
        cancelUser: [
          { required: true, message: '撤销用户不可为空', trigger: 'change' }
        ],
        cancelTime: [
          { required: true, message: '撤销时间不可为空', trigger: 'change' }
        ],
        departmentID: [
          { required: true, message: '经纪公司部门代码不可为空', trigger: 'change' }
        ],
        accountNo: [
          { required: true, message: '资金账户代码(对应AccountID)不可为空', trigger: 'change' }
        ],
        currencyID: [
          { required: true, message: '币种不可为空', trigger: 'change' }
        ],
        pbuID: [
          { required: true, message: '交易单元代码不可为空', trigger: 'change' }
        ],
        turnover: [
          { required: true, message: '成交金额不可为空', trigger: 'change' }
        ],
        orderType: [
          { required: true, message: '报单类型不可为空', trigger: 'change' }
        ],
        userProductInfo: [
          { required: true, message: '用户端产品信息不可为空', trigger: 'change' }
        ],
        forceCloseReason: [
          { required: true, message: '强平原因(两融专用)不可为空', trigger: 'change' }
        ],
        creditQuotaID: [
          { required: true, message: '信用头寸编号(两融专用)不可为空', trigger: 'change' }
        ],
        creditQuotaType: [
          { required: true, message: '头寸类型(两融专用)不可为空', trigger: 'change' }
        ],
        creditDebtID: [
          { required: true, message: '信用负债编号(两融专用)不可为空', trigger: 'change' }
        ],
        iPAddress: [
          { required: true, message: 'IP地址不可为空', trigger: 'change' }
        ],
        macAddress: [
          { required: true, message: 'Mac地址不可为空', trigger: 'change' }
        ],
        rtnFloatInfo: [
          { required: true, message: '回报附加浮点型数据信息不可为空', trigger: 'change' }
        ],
        rtnIntInfo: [
          { required: true, message: '回报附加整型数据不可为空', trigger: 'change' }
        ],
        errorID: [
          { required: true, message: '错误代码不可为空', trigger: 'change' }
        ],
        errorMsg: [
          { required: true, message: '错误信息不可为空', trigger: 'change' }
        ],
        discountCouponID: [
          { required: true, message: '费息折扣券编号（0表示不使用折扣券）(两融专用)不可为空', trigger: 'change' }
        ],
        actionFlag: [
          { required: true, message: '操作标志不可为空', trigger: 'change' }
        ],
        orderActionRef: [
          { required: true, message: '报单操作引用不可为空', trigger: 'change' }
        ],
        cancelOrderSysID: [
          { required: true, message: '系统撤单编号不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotOrder',
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
      this.stpNpSpotOrderLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotOrder/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotOrderData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotOrderLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotOrderForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'exchangeID': '',
        'investorID': '',
        'businessUnitID': '',
        'shareholderID': '',
        'securityID': '',
        'direction': '',
        'orderPriceType': '',
        'timeCondition': '',
        'volumeCondition': '',
        'limitPrice': '',
        'volumeTotalOriginal': '',
        'lotType': '',
        'gTDate': '',
        'operway': '',
        'condCheck': '',
        'sInfo': '',
        'iInfo': '',
        'requestID': '',
        'frontID': '',
        'sessionID': '',
        'orderRef': '',
        'orderLocalID': '',
        'orderSysID': '',
        'orderStatus': '',
        'orderSubmitStatus': '',
        'statusMsg': '',
        'volumeTraded': '',
        'volumeCanceled': '',
        'tradingDay': '',
        'insertUser': '',
        'insertDate': '',
        'insertTime': '',
        'acceptTime': '',
        'cancelUser': '',
        'cancelTime': '',
        'departmentID': '',
        'accountNo': '',
        'currencyID': '',
        'pbuID': '',
        'turnover': '',
        'orderType': '',
        'userProductInfo': '',
        'forceCloseReason': '',
        'creditQuotaID': '',
        'creditQuotaType': '',
        'creditDebtID': '',
        'iPAddress': '',
        'macAddress': '',
        'rtnFloatInfo': '',
        'rtnIntInfo': '',
        'errorID': '',
        'errorMsg': '',
        'discountCouponID': '',
        'actionFlag': '',
        'orderActionRef': '',
        'cancelOrderSysID': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotOrderDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotOrderForm) {
        this.$refs.stpNpSpotOrderForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotOrder/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotOrderForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'exchangeID': res.object.exchangeID,
            'investorID': res.object.investorID,
            'businessUnitID': res.object.businessUnitID,
            'shareholderID': res.object.shareholderID,
            'securityID': res.object.securityID,
            'direction': res.object.direction,
            'orderPriceType': res.object.orderPriceType,
            'timeCondition': res.object.timeCondition,
            'volumeCondition': res.object.volumeCondition,
            'limitPrice': res.object.limitPrice,
            'volumeTotalOriginal': res.object.volumeTotalOriginal,
            'lotType': res.object.lotType,
            'gTDate': res.object.gTDate,
            'operway': res.object.operway,
            'condCheck': res.object.condCheck,
            'sInfo': res.object.sInfo,
            'iInfo': res.object.iInfo,
            'requestID': res.object.requestID,
            'frontID': res.object.frontID,
            'sessionID': res.object.sessionID,
            'orderRef': res.object.orderRef,
            'orderLocalID': res.object.orderLocalID,
            'orderSysID': res.object.orderSysID,
            'orderStatus': res.object.orderStatus,
            'orderSubmitStatus': res.object.orderSubmitStatus,
            'statusMsg': res.object.statusMsg,
            'volumeTraded': res.object.volumeTraded,
            'volumeCanceled': res.object.volumeCanceled,
            'tradingDay': res.object.tradingDay,
            'insertUser': res.object.insertUser,
            'insertDate': res.object.insertDate,
            'insertTime': res.object.insertTime,
            'acceptTime': res.object.acceptTime,
            'cancelUser': res.object.cancelUser,
            'cancelTime': res.object.cancelTime,
            'departmentID': res.object.departmentID,
            'accountNo': res.object.accountNo,
            'currencyID': res.object.currencyID,
            'pbuID': res.object.pbuID,
            'turnover': res.object.turnover,
            'orderType': res.object.orderType,
            'userProductInfo': res.object.userProductInfo,
            'forceCloseReason': res.object.forceCloseReason,
            'creditQuotaID': res.object.creditQuotaID,
            'creditQuotaType': res.object.creditQuotaType,
            'creditDebtID': res.object.creditDebtID,
            'iPAddress': res.object.iPAddress,
            'macAddress': res.object.macAddress,
            'rtnFloatInfo': res.object.rtnFloatInfo,
            'rtnIntInfo': res.object.rtnIntInfo,
            'errorID': res.object.errorID,
            'errorMsg': res.object.errorMsg,
            'discountCouponID': res.object.discountCouponID,
            'actionFlag': res.object.actionFlag,
            'orderActionRef': res.object.orderActionRef,
            'cancelOrderSysID': res.object.cancelOrderSysID
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotOrderDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotOrder/save',
            method: 'post',
            data: this.stpNpSpotOrderForm
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
          this.stpNpSpotOrderDialog = false;
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
          url: '/npspot/stpNpSpotOrder/del',
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
  .stpNpSpotOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
