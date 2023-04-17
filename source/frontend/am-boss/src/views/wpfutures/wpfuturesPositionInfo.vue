<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-select v-model="searchForm.brokerNo" clearable placeholder="请选择经纪商名称" value="">
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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesPositionInfoLoading" :data="wpfuturesPositionInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerNo" label="经纪商编号"/>
      <el-table-column prop="brokerNo" label="经纪商名称" :formatter="statusFormat" />
      <el-table-column prop="accountNo" label="客户资金帐号" />
      <el-table-column prop="exchangeNo" label="交易所编号" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat" />
      <el-table-column prop="commodityNo" label="品种编码类型" />
      <el-table-column prop="contractNo" label="合约1" />
      <el-table-column prop="strikePrice" label="执行价格" />
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat" />
      <el-table-column prop="matchSide" label="买入卖出" :formatter="statusFormat" />
      <el-table-column prop="hedgeFlag" label="投机保值" :formatter="statusFormat" />
      <el-table-column prop="positionNo" label="本地持仓号，服务器编写" />
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat" />
      <el-table-column prop="orderNo" label="委托编码" />
      <el-table-column prop="matchNo" label="本地成交号" />
      <el-table-column prop="upperNo" label="上手号" />
      <el-table-column prop="positionPrice" label="持仓价" />
      <el-table-column prop="positionQty" label="持仓量" />
      <el-table-column prop="positionStreamId" label="持仓流号" />
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组" />
      <el-table-column prop="commodityCurrency" label="品种币种" />
      <el-table-column prop="calculatePrice" label="当前计算价格" />
      <el-table-column prop="accountInitialMargin" label="客户初始保证金" />
      <el-table-column prop="accountMaintenanceMargin" label="客户维持保证金" />
      <el-table-column prop="upperInitialMargin" label="上手初始保证金" />
      <el-table-column prop="upperMaintenanceMargin" label="上手维持保证金" />
      <el-table-column prop="positionProfit" label="持仓盈亏" />
      <el-table-column prop="lMEPositionProfit" label="LME持仓盈亏" />
      <el-table-column prop="optionMarketValue" label="期权市值" />
      <el-table-column prop="isHistory" label="是否为昨仓" :formatter="statusFormat" />
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
    <el-dialog title="期货持仓信息" :visible.sync="wpfuturesPositionInfoDialog" :close-on-click-modal="false" width="1800">
      <el-form
        ref="wpfuturesPositionInfoForm"
        :model="wpfuturesPositionInfoForm"
        label-width="120px"
        class="wpfuturesPositionInfoForm"
      >
        <el-row>
          <el-col :span=8>
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="wpfuturesPositionInfoForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-select v-model="wpfuturesPositionInfoForm.brokerNo" clearable placeholder="请选择经纪商" value="">
                <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="wpfuturesPositionInfoForm.accountNo" placeholder="请输入客户资金帐号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="wpfuturesPositionInfoForm.exchangeNo" placeholder="请输入交易所编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="wpfuturesPositionInfoForm.commodityType" clearable placeholder="请选择品种类型" value="">
                <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="wpfuturesPositionInfoForm.commodityNo" placeholder="请输入品种编码类型" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="wpfuturesPositionInfoForm.contractNo" placeholder="请输入合约1" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="wpfuturesPositionInfoForm.strikePrice" placeholder="请输入执行价格" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-select v-model="wpfuturesPositionInfoForm.callOrPutFlag" clearable placeholder="请输入看张看跌" value="">
                <el-option v-for="data in dicts.callOrPutFlag" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="买入卖出" prop="matchSide">
              <el-select v-model="wpfuturesPositionInfoForm.matchSide" clearable placeholder="请输入买入卖出" value="">
                <el-option v-for="data in dicts.matchSide" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-select v-model="wpfuturesPositionInfoForm.hedgeFlag" clearable placeholder="请输入投机保值" value="">
                <el-option v-for="data in dicts.hedgeFlag" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="本地持仓号" prop="positionNo">
              <el-input v-model="wpfuturesPositionInfoForm.positionNo" placeholder="请输入本地持仓号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="wpfuturesPositionInfoForm.serverFlag" placeholder="请输入服务器标识" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="wpfuturesPositionInfoForm.orderNo" placeholder="请输入委托编码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="本地成交号" prop="matchNo">
              <el-input v-model="wpfuturesPositionInfoForm.matchNo" placeholder="请输入本地成交号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="wpfuturesPositionInfoForm.upperNo" placeholder="请输入上手号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="持仓价" prop="positionPrice">
              <el-input v-model="wpfuturesPositionInfoForm.positionPrice" placeholder="请输入持仓价" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="持仓量" prop="positionQty">
              <el-input v-model="wpfuturesPositionInfoForm.positionQty" placeholder="请输入持仓量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="持仓流号" prop="positionStreamId">
              <el-input v-model="wpfuturesPositionInfoForm.positionStreamId" placeholder="请输入持仓流号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="wpfuturesPositionInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="wpfuturesPositionInfoForm.commodityCurrency" placeholder="请输入品种币种" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="当前计算价格" prop="calculatePrice">
              <el-input v-model="wpfuturesPositionInfoForm.calculatePrice" placeholder="请输入当前计算价格" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户初始保证金" prop="accountInitialMargin">
              <el-input v-model="wpfuturesPositionInfoForm.accountInitialMargin" placeholder="请输入客户初始保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="wpfuturesPositionInfoForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="上手初始保证金" prop="upperInitialMargin">
              <el-input v-model="wpfuturesPositionInfoForm.upperInitialMargin" placeholder="请输入上手初始保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
              <el-input v-model="wpfuturesPositionInfoForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="持仓盈亏" prop="positionProfit">
              <el-input v-model="wpfuturesPositionInfoForm.positionProfit" placeholder="请输入持仓盈亏" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="LME持仓盈亏" prop="lMEPositionProfit">
              <el-input v-model="wpfuturesPositionInfoForm.lMEPositionProfit" placeholder="请输入LME持仓盈亏" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="wpfuturesPositionInfoForm.optionMarketValue" placeholder="请输入期权市值" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="是否为昨仓" prop="isHistory">
              <el-select v-model="wpfuturesPositionInfoForm.isHistory" clearable placeholder="请输入是否为昨仓" value="">
                <el-option v-for="data in dicts.isHistory" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpfuturesPositionInfoName',
  data() {
    return {
      wpfuturesPositionInfoLoading: true,
      wpfuturesPositionInfoDialog: false,
      wpfuturesPositionInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      searchForm: {
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
        'matchSide': '',
        'hedgeFlag': '',
        'positionNo': '',
        'serverFlag': '',
        'orderNo': '',
        'matchNo': '',
        'upperNo': '',
        'positionPrice': '',
        'positionQty': '',
        'positionStreamId': '',
        'commodityCurrencyGroup': '',
        'commodityCurrency': '',
        'calculatePrice': '',
        'accountInitialMargin': '',
        'accountMaintenanceMargin': '',
        'upperInitialMargin': '',
        'upperMaintenanceMargin': '',
        'positionProfit': '',
        'lMEPositionProfit': '',
        'optionMarketValue': '',
        'isHistory': '',
        'sort': 'id',
        'order': 'asc'
      },
      wpfuturesPositionInfoForm: {
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
        'matchSide': '',
        'hedgeFlag': '',
        'positionNo': '',
        'serverFlag': '',
        'orderNo': '',
        'matchNo': '',
        'upperNo': '',
        'positionPrice': '',
        'positionQty': '',
        'positionStreamId': '',
        'commodityCurrencyGroup': '',
        'commodityCurrency': '',
        'calculatePrice': '',
        'accountInitialMargin': '',
        'accountMaintenanceMargin': '',
        'upperInitialMargin': '',
        'upperMaintenanceMargin': '',
        'positionProfit': '',
        'lMEPositionProfit': '',
        'optionMarketValue': '',
        'isHistory': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
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
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesPositionInfoForm) {
        this.$refs.wpfuturesPositionInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesPositionInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesPositionInfoForm = {
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
            'matchSide': res.object.matchSide,
            'hedgeFlag': res.object.hedgeFlag,
            'positionNo': res.object.positionNo,
            'serverFlag': res.object.serverFlag,
            'orderNo': res.object.orderNo,
            'matchNo': res.object.matchNo,
            'upperNo': res.object.upperNo,
            'positionPrice': res.object.positionPrice,
            'positionQty': res.object.positionQty,
            'positionStreamId': res.object.positionStreamId,
            'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
            'commodityCurrency': res.object.commodityCurrency,
            'calculatePrice': res.object.calculatePrice,
            'accountInitialMargin': res.object.accountInitialMargin,
            'accountMaintenanceMargin': res.object.accountMaintenanceMargin,
            'upperInitialMargin': res.object.upperInitialMargin,
            'upperMaintenanceMargin': res.object.upperMaintenanceMargin,
            'positionProfit': res.object.positionProfit,
            'lMEPositionProfit': res.object.lMEPositionProfit,
            'optionMarketValue': res.object.optionMarketValue,
            'isHistory': res.object.isHistory
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesPositionInfoDialog = true;
    },
    doInitData() {
      this.$http({
        url: '/wpfutures/dict/wpfuturesPositionInfo',
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
      this.wpfuturesPositionInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesPositionInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesPositionInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesPositionInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.wpfuturesPositionInfoForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
