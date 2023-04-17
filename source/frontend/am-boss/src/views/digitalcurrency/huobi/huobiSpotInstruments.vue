<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易对中的基础币种">
        <el-input v-model="searchForm.baseCurrency" clearable placeholder="请输入交易对中的基础币种"></el-input>
      </el-form-item>
      <el-form-item label="交易对中的报价币种">
        <el-input v-model="searchForm.quoteCurrency" clearable placeholder="请输入交易对中的报价币种"></el-input>
      </el-form-item>
      <el-form-item label="交易区">
        <el-input v-model="searchForm.symbolPartition" clearable placeholder="请输入交易区"></el-input>
      </el-form-item>
      <el-form-item label="交易对">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入交易对"></el-input>
      </el-form-item>
      <el-form-item label="交易对状态">
        <el-input v-model="searchForm.state" clearable placeholder="请输入交易对状态"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotInstrumentsLoading" :data="huobiSpotInstrumentsData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="baseCurrency" label="交易对中的基础币种"/>
      <el-table-column prop="quoteCurrency" label="交易对中的报价币种"/>
      <el-table-column prop="pricePrecision" label="交易对报价的精度"/>
      <el-table-column prop="amountPrecision" label="交易对基础币种计数精度"/>
      <el-table-column prop="symbolPartition" label="交易区"/>
      <el-table-column prop="symbol" label="交易对"/>
      <el-table-column prop="state" label="交易对状态"/>
      <el-table-column prop="valuePrecision" label="交易对交易金额的精度"/>
      <el-table-column prop="minOrderAmt" label="交易对限价单最小下单量"/>
      <el-table-column prop="maxOrderAmt" label="交易对限价单最大下单量 "/>
      <el-table-column prop="limitOrderMinOrderAmt" label="交易对限价单最小下单量 "/>
      <el-table-column prop="limitOrderMaxOrderAmt" label="交易对限价单最大下单量"/>
      <el-table-column prop="sellMarketMinOrderAmt" label="交易对市价卖单最小下单量"/>
      <el-table-column prop="sellMarketMaxOrderAmt" label="交易对市价卖单最大下单量"/>
      <el-table-column prop="buyMarketMaxOrderValue" label="交易对市价买单最大下单金额"/>
      <el-table-column prop="minOrderValue" label="交易对限价单和市价买单最小下单金额"/>
      <el-table-column prop="maxOrderValue" label="交易对限价单和市价买单最大下单金额 "/>
      <el-table-column prop="leverageRatio" label="交易对杠杆最大倍数"/>
      <el-table-column prop="underlying" label="标的交易代码 "/>
      <el-table-column prop="mgmtFeeRate" label="持仓管理费费率 "/>
      <el-table-column prop="chargeTime" label="持仓管理费收取时间" :formatter="dateFormat"/>
      <el-table-column prop="rebalTime" label="每日调仓时间"/>
      <el-table-column prop="rebalThreshold" label="临时调仓阈值"/>
      <el-table-column prop="initNav" label="初始净值"/>
      <el-table-column prop="apiTrading" label="API交易使能标记"/>
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
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
    <el-dialog title="现货交易对管理" :visible.sync="huobiSpotInstrumentsDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiSpotInstrumentsForm" :model="huobiSpotInstrumentsForm" :rules="huobiSpotInstrumentsRules"
               label-width="150px" class="huobiSpotInstrumentsForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotInstrumentsForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="交易对中的基础币种" prop="baseCurrency">
          <el-input v-model="huobiSpotInstrumentsForm.baseCurrency" placeholder="请输入交易对中的基础币种"/>
        </el-form-item>
        <el-form-item label="交易对中的报价币种" prop="quoteCurrency">
          <el-input v-model="huobiSpotInstrumentsForm.quoteCurrency" placeholder="请输入交易对中的报价币种"/>
        </el-form-item>
        <el-form-item label="交易对报价的精度" prop="pricePrecision">
          <el-input v-model="huobiSpotInstrumentsForm.pricePrecision" placeholder="请输入交易对报价的精度"/>
        </el-form-item>
        <el-form-item label="交易对基础币种计数精度" prop="amountPrecision">
          <el-input v-model="huobiSpotInstrumentsForm.amountPrecision" placeholder="请输入交易对基础币种计数精度"/>
        </el-form-item>
        <el-form-item label="交易区" prop="symbolPartition">
          <el-input v-model="huobiSpotInstrumentsForm.symbolPartition" placeholder="请输入交易区"/>
        </el-form-item>
        <el-form-item label="交易对" prop="symbol">
          <el-input v-model="huobiSpotInstrumentsForm.symbol" placeholder="请输入交易对"/>
        </el-form-item>
        <el-form-item label="交易对状态" prop="state">
          <el-input v-model="huobiSpotInstrumentsForm.state" placeholder="请输入交易对状态"/>
        </el-form-item>
        <el-form-item label="交易对交易金额的精度" prop="valuePrecision">
          <el-input v-model="huobiSpotInstrumentsForm.valuePrecision" placeholder="请输入交易对交易金额的精度"/>
        </el-form-item>
        <el-form-item label="交易对限价单最小下单量" prop="minOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.minOrderAmt" placeholder="请输入交易对限价单最小下单量"/>
        </el-form-item>
        <el-form-item label="交易对限价单最大下单量 " prop="maxOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.maxOrderAmt" placeholder="请输入交易对限价单最大下单量 "/>
        </el-form-item>
        <el-form-item label="交易对限价单最小下单量 " prop="limitOrderMinOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.limitOrderMinOrderAmt" placeholder="请输入交易对限价单最小下单量 "/>
        </el-form-item>
        <el-form-item label="交易对限价单最大下单量" prop="limitOrderMaxOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.limitOrderMaxOrderAmt" placeholder="请输入交易对限价单最大下单量"/>
        </el-form-item>
        <el-form-item label="交易对市价卖单最小下单量" prop="sellMarketMinOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.sellMarketMinOrderAmt" placeholder="请输入交易对市价卖单最小下单量"/>
        </el-form-item>
        <el-form-item label="交易对市价卖单最大下单量" prop="sellMarketMaxOrderAmt">
          <el-input v-model="huobiSpotInstrumentsForm.sellMarketMaxOrderAmt" placeholder="请输入交易对市价卖单最大下单量"/>
        </el-form-item>
        <el-form-item label="交易对市价买单最大下单金额" prop="buyMarketMaxOrderValue">
          <el-input v-model="huobiSpotInstrumentsForm.buyMarketMaxOrderValue" placeholder="请输入交易对市价买单最大下单金额"/>
        </el-form-item>
        <el-form-item label="交易对限价单和市价买单最小下单金额" prop="minOrderValue">
          <el-input v-model="huobiSpotInstrumentsForm.minOrderValue" placeholder="请输入交易对限价单和市价买单最小下单金额"/>
        </el-form-item>
        <el-form-item label="交易对限价单和市价买单最大下单金额 " prop="maxOrderValue">
          <el-input v-model="huobiSpotInstrumentsForm.maxOrderValue" placeholder="请输入交易对限价单和市价买单最大下单金额 "/>
        </el-form-item>
        <el-form-item label="交易对杠杆最大倍数" prop="leverageRatio">
          <el-input v-model="huobiSpotInstrumentsForm.leverageRatio" placeholder="请输入交易对杠杆最大倍数"/>
        </el-form-item>
        <el-form-item label="标的交易代码 " prop="underlying">
          <el-input v-model="huobiSpotInstrumentsForm.underlying" placeholder="请输入标的交易代码 "/>
        </el-form-item>
        <el-form-item label="持仓管理费费率 " prop="mgmtFeeRate">
          <el-input v-model="huobiSpotInstrumentsForm.mgmtFeeRate" placeholder="请输入持仓管理费费率 "/>
        </el-form-item>
        <el-form-item label="持仓管理费收取时间" prop="chargeTime">
          <el-input v-model="huobiSpotInstrumentsForm.chargeTime" placeholder="请输入持仓管理费收取时间"/>
        </el-form-item>
        <el-form-item label="每日调仓时间" prop="rebalTime">
          <el-input v-model="huobiSpotInstrumentsForm.rebalTime" placeholder="请输入每日调仓时间"/>
        </el-form-item>
        <el-form-item label="临时调仓阈值" prop="rebalThreshold">
          <el-input v-model="huobiSpotInstrumentsForm.rebalThreshold" placeholder="请输入临时调仓阈值"/>
        </el-form-item>
        <el-form-item label="初始净值" prop="initNav">
          <el-input v-model="huobiSpotInstrumentsForm.initNav" placeholder="请输入初始净值"/>
        </el-form-item>
        <el-form-item label="API交易使能标记" prop="apiTrading">
          <el-input v-model="huobiSpotInstrumentsForm.apiTrading" placeholder="请输入API交易使能标记"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotInstrumentsForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotInstrumentsName',
    data() {
      return {
        huobiSpotInstrumentsLoading: true,
        huobiSpotInstrumentsDialog: false,
        huobiSpotInstrumentsData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotInstrumentsForm: {
          'id': '',
          'baseCurrency': '',
          'quoteCurrency': '',
          'pricePrecision': '',
          'amountPrecision': '',
          'symbolPartition': '',
          'symbol': '',
          'state': '',
          'valuePrecision': '',
          'minOrderAmt': '',
          'maxOrderAmt': '',
          'limitOrderMinOrderAmt': '',
          'limitOrderMaxOrderAmt': '',
          'sellMarketMinOrderAmt': '',
          'sellMarketMaxOrderAmt': '',
          'buyMarketMaxOrderValue': '',
          'minOrderValue': '',
          'maxOrderValue': '',
          'leverageRatio': '',
          'underlying': '',
          'mgmtFeeRate': '',
          'chargeTime': '',
          'rebalTime': '',
          'rebalThreshold': '',
          'initNav': '',
          'apiTrading': ''
        },
        searchForm: {
          'baseCurrency': '',
          'quoteCurrency': '',
          'pricePrecision': '',
          'amountPrecision': '',
          'symbolPartition': '',
          'symbol': '',
          'state': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotInstrumentsRules: {}
      };
    },
    mounted: function() {
      // this.doInitData();
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
          url: '/digitalcurrency/huobi/dict/huobiSpotInstruments',
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
        this.huobiSpotInstrumentsLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotInstruments/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotInstrumentsData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotInstrumentsLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotInstrumentsForm = {
          'id': '',
          'baseCurrency': '',
          'quoteCurrency': '',
          'pricePrecision': '',
          'amountPrecision': '',
          'symbolPartition': '',
          'symbol': '',
          'state': '',
          'valuePrecision': '',
          'minOrderAmt': '',
          'maxOrderAmt': '',
          'limitOrderMinOrderAmt': '',
          'limitOrderMaxOrderAmt': '',
          'sellMarketMinOrderAmt': '',
          'sellMarketMaxOrderAmt': '',
          'buyMarketMaxOrderValue': '',
          'minOrderValue': '',
          'maxOrderValue': '',
          'leverageRatio': '',
          'underlying': '',
          'mgmtFeeRate': '',
          'chargeTime': '',
          'rebalTime': '',
          'rebalThreshold': '',
          'initNav': '',
          'apiTrading': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotInstrumentsDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotInstrumentsForm) {
          this.$refs.huobiSpotInstrumentsForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotInstruments/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotInstrumentsForm = {
              'id': res.object.id,
              'baseCurrency': res.object.baseCurrency,
              'quoteCurrency': res.object.quoteCurrency,
              'pricePrecision': res.object.pricePrecision,
              'amountPrecision': res.object.amountPrecision,
              'symbolPartition': res.object.symbolPartition,
              'symbol': res.object.symbol,
              'state': res.object.state,
              'valuePrecision': res.object.valuePrecision,
              'minOrderAmt': res.object.minOrderAmt,
              'maxOrderAmt': res.object.maxOrderAmt,
              'limitOrderMinOrderAmt': res.object.limitOrderMinOrderAmt,
              'limitOrderMaxOrderAmt': res.object.limitOrderMaxOrderAmt,
              'sellMarketMinOrderAmt': res.object.sellMarketMinOrderAmt,
              'sellMarketMaxOrderAmt': res.object.sellMarketMaxOrderAmt,
              'buyMarketMaxOrderValue': res.object.buyMarketMaxOrderValue,
              'minOrderValue': res.object.minOrderValue,
              'maxOrderValue': res.object.maxOrderValue,
              'leverageRatio': res.object.leverageRatio,
              'underlying': res.object.underlying,
              'mgmtFeeRate': res.object.mgmtFeeRate,
              'chargeTime': res.object.chargeTime,
              'rebalTime': res.object.rebalTime,
              'rebalThreshold': res.object.rebalThreshold,
              'initNav': res.object.initNav,
              'apiTrading': res.object.apiTrading
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotInstrumentsDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotInstruments/save',
              method: 'post',
              data: this.huobiSpotInstrumentsForm
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
            this.huobiSpotInstrumentsDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotInstruments/del',
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
  .huobiSpotInstrumentsForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
