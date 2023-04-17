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
        <el-select v-model="searchForm.exchangeNo" clearable placeholder="请选择交易所编号" value="">
          <el-option v-for="data in dicts.exchangeNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
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
    <el-table v-loading="wpfuturesFillInfoLoading" :data="wpfuturesFillInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="ID" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat" />
      <el-table-column prop="accountNo" label="客户资金帐号" />
      <el-table-column prop="exchangeNo" label="交易所编号" :formatter="statusFormat" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat" />
      <el-table-column prop="commodityNo" label="品种编码类型" />
      <el-table-column prop="contractNo" label="合约1" />
      <el-table-column prop="strikePrice" label="执行价格" />
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat" />
      <el-table-column prop="matchSource" label="委托来源" :formatter="statusFormat" />
      <el-table-column prop="matchSide" label="买入卖出" :formatter="statusFormat" />
      <el-table-column prop="positionEffect" label="开平标志1" :formatter="statusFormat" />
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat" />
      <el-table-column prop="orderNo" label="委托编码" />
      <el-table-column prop="orderSystemNo" label="系统号" />
      <el-table-column prop="matchNo" label="本地成交号" />
      <el-table-column prop="upperMatchNo" label="上手成交号" />
      <el-table-column prop="exchangeMatchNo" label="交易所成交号" />
      <el-table-column prop="matchDateTime" label="成交时间" />
      <el-table-column prop="upperMatchDateTime" label="上手成交时间" />
      <el-table-column prop="upperNo" label="上手号" />
      <el-table-column prop="matchPrice" label="成交价" />
      <el-table-column prop="matchQty" label="成交量" />
      <el-table-column prop="isDeleted" label="委托成交删除标" :formatter="statusFormat" />
      <el-table-column prop="isAddOne" label="是否为T+1单" :formatter="statusFormat" />
      <el-table-column prop="feeCurrencyGroup" label="客户手续费币种组" />
      <el-table-column prop="feeCurrency" label="客户手续费币种" />
      <el-table-column prop="feeValue" label="手续费" />
      <el-table-column prop="isManualFee" label="人工客户手续费标记" :formatter="statusFormat" />
      <el-table-column prop="closePrositionPrice" label="指定价格平仓" />
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
    <el-dialog title="期货成交信息" :visible.sync="wpfuturesFillInfoDialog" :close-on-click-modal="false" width="1800">
      <el-form
        ref="wpfuturesFillInfoForm"
        :model="wpfuturesFillInfoForm"
        :rules="wpfuturesFillInfoRules"
        label-width="130px"
        class="wpfuturesFillInfoForm"
      >
        <el-row>
          <el-col :span=8>
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="wpfuturesFillInfoForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-select v-model="wpfuturesFillInfoForm.brokerNo" clearable placeholder="请输入经纪商" value="">
                <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户资金帐号" prop="accountNo">
              <el-input v-model="wpfuturesFillInfoForm.accountNo" placeholder="请输入客户资金帐号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="交易所编号" prop="exchangeNo">
              <el-input v-model="wpfuturesFillInfoForm.exchangeNo" placeholder="请输入交易所编号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="wpfuturesFillInfoForm.commodityType" clearable placeholder="请输入品种类型" value="">
                <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="wpfuturesFillInfoForm.commodityNo" placeholder="请输入品种编码类型" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="wpfuturesFillInfoForm.contractNo" placeholder="请输入合约1" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="wpfuturesFillInfoForm.strikePrice" placeholder="请输入执行价格" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-select v-model="wpfuturesFillInfoForm.callOrPutFlag" clearable placeholder="请输入看张看跌" value="">
                <el-option v-for="data in dicts.callOrPutFlag" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="委托来源" prop="matchSource">
              <el-select v-model="wpfuturesFillInfoForm.matchSource" clearable placeholder="请输入委托来源" value="">
                <el-option v-for="data in dicts.matchSource" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="买入卖出" prop="matchSide">
              <el-select v-model="wpfuturesFillInfoForm.matchSide" clearable placeholder="请输入买入卖出" value="">
                <el-option v-for="data in dicts.matchSide" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="开平标志1" prop="positionEffect">
              <el-select v-model="wpfuturesFillInfoForm.positionEffect" clearable placeholder="请输入开平标志1" value="">
                <el-option v-for="data in dicts.positionEffect" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="wpfuturesFillInfoForm.serverFlag" placeholder="请输入服务器标识" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="wpfuturesFillInfoForm.orderNo" placeholder="请输入委托编码" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="系统号" prop="orderSystemNo">
              <el-input v-model="wpfuturesFillInfoForm.orderSystemNo" placeholder="请输入系统号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="本地成交号" prop="matchNo">
              <el-input v-model="wpfuturesFillInfoForm.matchNo" placeholder="请输入本地成交号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手成交号" prop="upperMatchNo">
              <el-input v-model="wpfuturesFillInfoForm.upperMatchNo" placeholder="请输入上手成交号" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="交易所成交号" prop="exchangeMatchNo">
              <el-input v-model="wpfuturesFillInfoForm.exchangeMatchNo" placeholder="请输入交易所成交号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="成交时间" prop="matchDateTime">
              <el-input v-model="wpfuturesFillInfoForm.matchDateTime" placeholder="请输入成交时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手成交时间" prop="upperMatchDateTime">
              <el-input v-model="wpfuturesFillInfoForm.upperMatchDateTime" placeholder="请输入上手成交时间" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="wpfuturesFillInfoForm.upperNo" placeholder="请输入上手号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="成交价" prop="matchPrice">
              <el-input v-model="wpfuturesFillInfoForm.matchPrice" placeholder="请输入成交价" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="成交量" prop="matchQty">
              <el-input v-model="wpfuturesFillInfoForm.matchQty" placeholder="请输入成交量" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="委托成交删除标" prop="isDeleted">
              <el-select v-model="wpfuturesFillInfoForm.isDeleted" clearable placeholder="请输入委托成交删除标" value="">
                <el-option v-for="data in dicts.isDeleted" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="是否为T+1单" prop="isAddOne">
              <el-select v-model="wpfuturesFillInfoForm.isAddOne" clearable placeholder="请输入是否为T+1单" value="">
                <el-option v-for="data in dicts.isAddOne" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户手续费币种组" prop="feeCurrencyGroup">
              <el-input v-model="wpfuturesFillInfoForm.feeCurrencyGroup" placeholder="请输入客户手续费币种组" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="客户手续费币种" prop="feeCurrency">
              <el-input v-model="wpfuturesFillInfoForm.feeCurrency" placeholder="请输入客户手续费币种" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=8>
            <el-form-item label="手续费" prop="feeValue">
              <el-input v-model="wpfuturesFillInfoForm.feeValue" placeholder="请输入手续费" />
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="人工客户手续费标记" prop="isManualFee">
              <el-select v-model="wpfuturesFillInfoForm.isManualFee" clearable placeholder="请输入人工客户手续费标记" value="">
                <el-option v-for="data in dicts.isManualFee" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=8>
            <el-form-item label="指定价格平仓" prop="closePrositionPrice">
              <el-input v-model="wpfuturesFillInfoForm.closePrositionPrice" placeholder="请输入指定价格平仓" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpfuturesFillInfoName',
  data() {
    return {
      wpfuturesFillInfoLoading: true,
      wpfuturesFillInfoDialog: false,
      wpfuturesFillInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      searchForm: {
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo': '',
        'isManualFee': '',
        'sort': 'id',
        'order': 'asc'
      },
      wpfuturesFillInfoForm: {
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
        'matchSource': '',
        'matchSide': '',
        'positionEffect': '',
        'serverFlag': '',
        'orderNo': '',
        'orderSystemNo': '',
        'matchNo': '',
        'upperMatchNo': '',
        'exchangeMatchNo': '',
        'matchDateTime': '',
        'upperMatchDateTime': '',
        'upperNo': '',
        'matchPrice': '',
        'matchQty': '',
        'isDeleted': '',
        'isAddOne': '',
        'feeCurrencyGroup': '',
        'feeCurrency': '',
        'feeValue': '',
        'isManualFee': '',
        'closePrositionPrice': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpfuturesFillInfoRules: {
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
      if (this.$refs.wpfuturesFillInfoForm) {
        this.$refs.wpfuturesFillInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesFillInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesFillInfoForm = {
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
            'matchSource': res.object.matchSource,
            'matchSide': res.object.matchSide,
            'positionEffect': res.object.positionEffect,
            'serverFlag': res.object.serverFlag,
            'orderNo': res.object.orderNo,
            'orderSystemNo': res.object.orderSystemNo,
            'matchNo': res.object.matchNo,
            'upperMatchNo': res.object.upperMatchNo,
            'exchangeMatchNo': res.object.exchangeMatchNo,
            'matchDateTime': res.object.matchDateTime,
            'upperMatchDateTime': res.object.upperMatchDateTime,
            'upperNo': res.object.upperNo,
            'matchPrice': res.object.matchPrice,
            'matchQty': res.object.matchQty,
            'isDeleted': res.object.isDeleted,
            'isAddOne': res.object.isAddOne,
            'feeCurrencyGroup': res.object.feeCurrencyGroup,
            'feeCurrency': res.object.feeCurrency,
            'feeValue': res.object.feeValue,
            'isManualFee': res.object.isManualFee,
            'closePrositionPrice': res.object.closePrositionPrice
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesFillInfoDialog = true;
    },
    doInitData() {
      this.$http({
        url: '/wpfutures/dict/wpfuturesFillInfo',
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
      this.wpfuturesFillInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesFillInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesFillInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesFillInfoLoading = false;
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
.wpfuturesFillInfoForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
