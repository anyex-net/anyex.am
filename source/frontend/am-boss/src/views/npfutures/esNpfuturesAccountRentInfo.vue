<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
<!--      <el-form-item label="经纪商编码">-->
<!--        <el-input v-model="searchForm.brokerNo" clearable placeholder="请输入经纪商编码"></el-input>-->
<!--      </el-form-item>-->
      <el-form-item label="客户资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金账号"></el-input>
      </el-form-item>
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请输入品种类型">
          <el-option v-for="data in dicts" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
<!--        <el-input v-model="searchForm.commodityType" clearable placeholder="请输入品种类型"></el-input>-->
      </el-form-item>
      <el-form-item label="品种编号">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编号"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesAccountRentInfoLoading" :data="esNpfuturesAccountRentInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
          <!--          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>-->
          <!--          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>-->
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerNo" label="经纪商编码" />
      <el-table-column prop="accountNo" label="客户资金账号" />
      <el-table-column prop="exchangeNo" label="交易所编码" />
      <el-table-column prop="commodityType" label="品种类型" />
      <el-table-column prop="commodityNo" label="品种编号" />
      <el-table-column prop="contractNo" label="合约代码" />
      <el-table-column prop="matchSource" label="成交来源" />
      <el-table-column prop="currencyNo" label="币种编号" />
      <el-table-column prop="feeMode" label="手续费计算">
        <template scope="scope">
          <div v-if="scope.row.feeMode == '1'">比例</div>
          <div v-else-if="scope.row.feeMode == '2'">定额</div>
          <div v-else-if="scope.row.feeMode == '7'">绝对方式</div>
        </template>
      </el-table-column>
      <el-table-column prop="openTurnover" label="开仓手续费按金额" />
      <el-table-column prop="closedTurnover" label="平仓手续费按金额" />
      <el-table-column prop="closeNewTurnover" label="平今手续费按金额" />
      <el-table-column prop="openVolume" label="开仓手续费按手数" />
      <el-table-column prop="closedVolume" label="平仓手续费按手数" />
      <el-table-column prop="closeNewVolume" label="平今手续费按手数" />
      <el-table-column prop="marginMode" label="保证金计算方式">
        <template scope="scope">
          <div v-if="scope.row.marginMode == '1'">比例</div>
          <div v-else-if="scope.row.marginMode == '2'">定额</div>
          <div v-else-if="scope.row.marginMode == '7'">绝对方式</div>
        </template>
      </el-table-column>
      <el-table-column prop="buyTInitMargin" label="买投机初始保证金" />
      <el-table-column prop="sellTInitMargin" label="卖投机初始保证金" />
      <el-table-column prop="buyBInitMargin" label="买保值初始保证金" />
      <el-table-column prop="sellBInitMargin" label="卖保值初始保证金" />
      <el-table-column prop="buyLInitMargin" label="买套利初始保证金" />
      <el-table-column prop="sellLInitMargin" label="卖套利初始保证金" />
      <el-table-column prop="buyMInitMargin" label="买做市商初始保证金" />
      <el-table-column prop="sellMInitMargin" label="卖做市商初始保证金" />
      <el-table-column prop="buyTMaintMargin" label="买投机维持保证金" />
      <el-table-column prop="sellTMaintMargin" label="卖投机维持保证金" />
      <el-table-column prop="buyBMaintMargin" label="买保值维持保证金" />
      <el-table-column prop="sellBMaintMargin" label="卖保值维持保证金" />
      <el-table-column prop="buyLMaintMargin" label="买套利维持保证金" />
      <el-table-column prop="sellLMaintMargin" label="卖套利维持保证金" />
      <el-table-column prop="buyMMaintMargin" label="买做市商维持保证金" />
      <el-table-column prop="sellMMaintMargin" label="卖做市商维持保证金" />
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
    <el-dialog title="内盘期货客户最终费率表管理" :visible.sync="esNpfuturesAccountRentInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="esNpfuturesAccountRentInfoForm" :model="esNpfuturesAccountRentInfoForm" :rules="esNpfuturesAccountRentInfoRules" label-width="150px" class="esNpfuturesAccountRentInfoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="esNpfuturesAccountRentInfoForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="esNpfuturesAccountRentInfoForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.brokerNo" placeholder="请输入经纪商编码" />
        </el-form-item>
        <el-form-item label="客户资金账号" prop="accountNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.accountNo" placeholder="请输入客户资金账号" />
        </el-form-item>
        <el-form-item label="交易所编码" prop="exchangeNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.exchangeNo" placeholder="请输入交易所编码" />
        </el-form-item>
        <el-form-item label="品种类型" prop="commodityType">
          <el-input v-model="esNpfuturesAccountRentInfoForm.commodityType" placeholder="请输入品种类型" />
        </el-form-item>
        <el-form-item label="品种编号" prop="commodityNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.commodityNo" placeholder="请输入品种编号" />
        </el-form-item>
        <el-form-item label="合约代码" prop="contractNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.contractNo" placeholder="请输入合约代码" />
        </el-form-item>
        <el-form-item label="成交来源" prop="matchSource">
          <el-input v-model="esNpfuturesAccountRentInfoForm.matchSource" placeholder="请输入成交来源" />
        </el-form-item>
        <el-form-item label="币种编号" prop="currencyNo">
          <el-input v-model="esNpfuturesAccountRentInfoForm.currencyNo" placeholder="请输入币种编号" />
        </el-form-item>
        <el-form-item label="手续费计算" prop="feeMode">
          <el-select v-model="esNpfuturesAccountRentInfoForm.feeMode" clearable placeholder="请输入手续费计算">
            <el-option key="1" label="比例" value="1" />
            <el-option key="2" label="定额" value="2" />
            <el-option key="7" label="绝对方式" value="7" />
          </el-select>
        </el-form-item>
        <el-form-item label="开仓手续费按金额" prop="openTurnover">
          <el-input v-model="esNpfuturesAccountRentInfoForm.openTurnover" placeholder="请输入开仓手续费按金额" />
        </el-form-item>
        <el-form-item label="平仓手续费按金额" prop="closedTurnover">
          <el-input v-model="esNpfuturesAccountRentInfoForm.closedTurnover" placeholder="请输入平仓手续费按金额" />
        </el-form-item>
        <el-form-item label="平今手续费按金额" prop="closeNewTurnover">
          <el-input v-model="esNpfuturesAccountRentInfoForm.closeNewTurnover" placeholder="请输入平今手续费按金额" />
        </el-form-item>
        <el-form-item label="开仓手续费按手数" prop="openVolume">
          <el-input v-model="esNpfuturesAccountRentInfoForm.openVolume" placeholder="请输入开仓手续费按手数" />
        </el-form-item>
        <el-form-item label="平仓手续费按手数" prop="closedVolume">
          <el-input v-model="esNpfuturesAccountRentInfoForm.closedVolume" placeholder="请输入平仓手续费按手数" />
        </el-form-item>
        <el-form-item label="平今手续费按手数" prop="closeNewVolume">
          <el-input v-model="esNpfuturesAccountRentInfoForm.closeNewVolume" placeholder="请输入平今手续费按手数" />
        </el-form-item>
        <el-form-item label="保证金计算方式" prop="marginMode">
          <el-select v-model="esNpfuturesAccountRentInfoForm.marginMode" clearable placeholder="请输入保证金计算方式">
            <el-option key="1" label="比例" value="1" />
            <el-option key="2" label="定额" value="2" />
            <el-option key="7" label="绝对方式" value="7" />
          </el-select>
        </el-form-item>
        <el-form-item label="买投机初始保证金" prop="buyTInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyTInitMargin" placeholder="请输入买投机初始保证金" />
        </el-form-item>
        <el-form-item label="卖投机初始保证金" prop="sellTInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellTInitMargin" placeholder="请输入卖投机初始保证金" />
        </el-form-item>
        <el-form-item label="买保值初始保证金" prop="buyBInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyBInitMargin" placeholder="请输入买保值初始保证金" />
        </el-form-item>
        <el-form-item label="卖保值初始保证金" prop="sellBInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellBInitMargin" placeholder="请输入卖保值初始保证金" />
        </el-form-item>
        <el-form-item label="买套利初始保证金" prop="buyLInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyLInitMargin" placeholder="请输入买套利初始保证金" />
        </el-form-item>
        <el-form-item label="卖套利初始保证金" prop="sellLInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellLInitMargin" placeholder="请输入卖套利初始保证金" />
        </el-form-item>
        <el-form-item label="买做市商初始保证金" prop="buyMInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyMInitMargin" placeholder="请输入买做市商初始保证金" />
        </el-form-item>
        <el-form-item label="卖做市商初始保证金" prop="sellMInitMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellMInitMargin" placeholder="请输入卖做市商初始保证金" />
        </el-form-item>
        <el-form-item label="买投机维持保证金" prop="buyTMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyTMaintMargin" placeholder="请输入买投机维持保证金" />
        </el-form-item>
        <el-form-item label="卖投机维持保证金" prop="sellTMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellTMaintMargin" placeholder="请输入卖投机维持保证金" />
        </el-form-item>
        <el-form-item label="买保值维持保证金" prop="buyBMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyBMaintMargin" placeholder="请输入买保值维持保证金" />
        </el-form-item>
        <el-form-item label="卖保值维持保证金" prop="sellBMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellBMaintMargin" placeholder="请输入卖保值维持保证金" />
        </el-form-item>
        <el-form-item label="买套利维持保证金" prop="buyLMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyLMaintMargin" placeholder="请输入买套利维持保证金" />
        </el-form-item>
        <el-form-item label="卖套利维持保证金" prop="sellLMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellLMaintMargin" placeholder="请输入卖套利维持保证金" />
        </el-form-item>
        <el-form-item label="买做市商维持保证金" prop="buyMMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.buyMMaintMargin" placeholder="请输入买做市商维持保证金" />
        </el-form-item>
        <el-form-item label="卖做市商维持保证金" prop="sellMMaintMargin">
          <el-input v-model="esNpfuturesAccountRentInfoForm.sellMMaintMargin" placeholder="请输入卖做市商维持保证金" />
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('esNpfuturesAccountRentInfoForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'EsNpfuturesAccountRentInfoName',
  data() {
    return {
      esNpfuturesAccountRentInfoLoading: true,
      esNpfuturesAccountRentInfoDialog: false,
      esNpfuturesAccountRentInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      esNpfuturesAccountRentInfoForm: {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo': '',
        'matchSource': '',
        'currencyNo': '',
        'feeMode': '',
        'openTurnover': '',
        'closedTurnover': '',
        'closeNewTurnover': '',
        'openVolume': '',
        'closedVolume': '',
        'closeNewVolume': '',
        'marginMode': '',
        'buyTInitMargin': '',
        'sellTInitMargin': '',
        'buyBInitMargin': '',
        'sellBInitMargin': '',
        'buyLInitMargin': '',
        'sellLInitMargin': '',
        'buyMInitMargin': '',
        'sellMInitMargin': '',
        'buyTMaintMargin': '',
        'sellTMaintMargin': '',
        'buyBMaintMargin': '',
        'sellBMaintMargin': '',
        'buyLMaintMargin': '',
        'sellLMaintMargin': '',
        'buyMMaintMargin': '',
        'sellMMaintMargin': ''
      },
      searchForm: {
        'id': '',
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
      esNpfuturesAccountRentInfoRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerNo: [
          { required: true, message: '经纪商编码不可为空', trigger: 'change' }
        ],
        accountNo: [
          { required: true, message: '客户资金账号不可为空', trigger: 'change' }
        ],
        exchangeNo: [
          { required: true, message: '交易所编码不可为空', trigger: 'change' }
        ],
        commodityType: [
          { required: true, message: '品种类型不可为空', trigger: 'change' }
        ],
        commodityNo: [
          { required: true, message: '品种编号不可为空', trigger: 'change' }
        ],
        contractNo: [
          { required: true, message: '合约代码不可为空', trigger: 'change' }
        ],
        matchSource: [
          { required: true, message: '成交来源不可为空', trigger: 'change' }
        ],
        currencyNo: [
          { required: true, message: '币种编号不可为空', trigger: 'change' }
        ],
        feeMode: [
          { required: true, message: '手续费计算不可为空', trigger: 'change' }
        ],
        openTurnover: [
          { required: true, message: '开仓手续费按金额不可为空', trigger: 'change' }
        ],
        closedTurnover: [
          { required: true, message: '平仓手续费按金额不可为空', trigger: 'change' }
        ],
        closeNewTurnover: [
          { required: true, message: '平今手续费按金额不可为空', trigger: 'change' }
        ],
        openVolume: [
          { required: true, message: '开仓手续费按手数不可为空', trigger: 'change' }
        ],
        closedVolume: [
          { required: true, message: '平仓手续费按手数不可为空', trigger: 'change' }
        ],
        closeNewVolume: [
          { required: true, message: '平今手续费按手数不可为空', trigger: 'change' }
        ],
        marginMode: [
          { required: true, message: '保证金计算方式不可为空', trigger: 'change' }
        ],
        buyTInitMargin: [
          { required: true, message: '买投机初始保证金不可为空', trigger: 'change' }
        ],
        sellTInitMargin: [
          { required: true, message: '卖投机初始保证金不可为空', trigger: 'change' }
        ],
        buyBInitMargin: [
          { required: true, message: '买保值初始保证金不可为空', trigger: 'change' }
        ],
        sellBInitMargin: [
          { required: true, message: '卖保值初始保证金不可为空', trigger: 'change' }
        ],
        buyLInitMargin: [
          { required: true, message: '买套利初始保证金不可为空', trigger: 'change' }
        ],
        sellLInitMargin: [
          { required: true, message: '卖套利初始保证金不可为空', trigger: 'change' }
        ],
        buyMInitMargin: [
          { required: true, message: '买做市商初始保证金不可为空', trigger: 'change' }
        ],
        sellMInitMargin: [
          { required: true, message: '卖做市商初始保证金不可为空', trigger: 'change' }
        ],
        buyTMaintMargin: [
          { required: true, message: '买投机维持保证金不可为空', trigger: 'change' }
        ],
        sellTMaintMargin: [
          { required: true, message: '卖投机维持保证金不可为空', trigger: 'change' }
        ],
        buyBMaintMargin: [
          { required: true, message: '买保值维持保证金不可为空', trigger: 'change' }
        ],
        sellBMaintMargin: [
          { required: true, message: '卖保值维持保证金不可为空', trigger: 'change' }
        ],
        buyLMaintMargin: [
          { required: true, message: '买套利维持保证金不可为空', trigger: 'change' }
        ],
        sellLMaintMargin: [
          { required: true, message: '卖套利维持保证金不可为空', trigger: 'change' }
        ],
        buyMMaintMargin: [
          { required: true, message: '买做市商维持保证金不可为空', trigger: 'change' }
        ],
        sellMMaintMargin: [
          { required: true, message: '卖做市商维持保证金不可为空', trigger: 'change' }
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
        url: '/npfutures/dict/esNpfuturesCommodityType',
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
      this.esNpfuturesAccountRentInfoLoading = true;
      this.$http({
        url: '/npfutures/esNpfuturesAccountRentInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.esNpfuturesAccountRentInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.esNpfuturesAccountRentInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.esNpfuturesAccountRentInfoForm = {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo': '',
        'matchSource': '',
        'currencyNo': '',
        'feeMode': '',
        'openTurnover': '',
        'closedTurnover': '',
        'closeNewTurnover': '',
        'openVolume': '',
        'closedVolume': '',
        'closeNewVolume': '',
        'marginMode': '',
        'buyTInitMargin': '',
        'sellTInitMargin': '',
        'buyBInitMargin': '',
        'sellBInitMargin': '',
        'buyLInitMargin': '',
        'sellLInitMargin': '',
        'buyMInitMargin': '',
        'sellMInitMargin': '',
        'buyTMaintMargin': '',
        'sellTMaintMargin': '',
        'buyBMaintMargin': '',
        'sellBMaintMargin': '',
        'buyLMaintMargin': '',
        'sellLMaintMargin': '',
        'buyMMaintMargin': '',
        'sellMMaintMargin': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.esNpfuturesAccountRentInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.esNpfuturesAccountRentInfoForm) {
        this.$refs.esNpfuturesAccountRentInfoForm.resetFields();
      }
      this.$http({
        url: '/npfutures/esNpfuturesAccountRentInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.esNpfuturesAccountRentInfoForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerNo': res.object.brokerNo,
            'accountNo': res.object.accountNo,
            'exchangeNo': res.object.exchangeNo,
            'commodityType': res.object.commodityType,
            'commodityNo': res.object.commodityNo,
            'contractNo': res.object.contractNo,
            'matchSource': res.object.matchSource,
            'currencyNo': res.object.currencyNo,
            'feeMode': res.object.feeMode,
            'openTurnover': res.object.openTurnover,
            'closedTurnover': res.object.closedTurnover,
            'closeNewTurnover': res.object.closeNewTurnover,
            'openVolume': res.object.openVolume,
            'closedVolume': res.object.closedVolume,
            'closeNewVolume': res.object.closeNewVolume,
            'marginMode': res.object.marginMode,
            'buyTInitMargin': res.object.buyTInitMargin,
            'sellTInitMargin': res.object.sellTInitMargin,
            'buyBInitMargin': res.object.buyBInitMargin,
            'sellBInitMargin': res.object.sellBInitMargin,
            'buyLInitMargin': res.object.buyLInitMargin,
            'sellLInitMargin': res.object.sellLInitMargin,
            'buyMInitMargin': res.object.buyMInitMargin,
            'sellMInitMargin': res.object.sellMInitMargin,
            'buyTMaintMargin': res.object.buyTMaintMargin,
            'sellTMaintMargin': res.object.sellTMaintMargin,
            'buyBMaintMargin': res.object.buyBMaintMargin,
            'sellBMaintMargin': res.object.sellBMaintMargin,
            'buyLMaintMargin': res.object.buyLMaintMargin,
            'sellLMaintMargin': res.object.sellLMaintMargin,
            'buyMMaintMargin': res.object.buyMMaintMargin,
            'sellMMaintMargin': res.object.sellMMaintMargin
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.esNpfuturesAccountRentInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npfutures/esNpfuturesAccountRentInfo/save',
            method: 'post',
            data: this.esNpfuturesAccountRentInfoForm
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
          this.esNpfuturesAccountRentInfoDialog = false;
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
          url: '/npfutures/esNpfuturesAccountRentInfo/del',
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
		.esNpfuturesAccountRentInfoForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
