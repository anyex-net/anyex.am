<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="产品代码">
        <el-input v-model="searchForm.productID" clearable placeholder="请输入产品代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="searchForm.productName" clearable placeholder="请输入产品名称"></el-input>
      </el-form-item>
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.productClass" clearable placeholder="请输入产品类型">
          <el-option v-for="data in productClass" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="启用状态" prop="enableStatus">
        <el-select v-model="searchForm.enableStatus" placeholder="请选择启用状态">
          <el-option key="enable" label="是" value="enable" />
          <el-option key="disable" label="否" value="disable" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="npfuturesExchangeProductLoading"
      :data="npfuturesExchangeProductData"
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
      <el-table-column prop="productID" label="产品代码" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="productName" label="产品名称" />
      <el-table-column prop="productClass" label="产品类型" :formatter="statusFormat" />
      <el-table-column prop="volumeMultiple" label="合约数量乘数" />
      <el-table-column prop="priceTick" label="最小变动价位" />
      <el-table-column prop="maxMarketOrderVolume" label="市价单最大下单量" />
      <el-table-column prop="minMarketOrderVolume" label="市价单最小下单量" />
      <el-table-column prop="maxLimitOrderVolume" label="限价单最大下单量" />
      <el-table-column prop="minLimitOrderVolume" label="限价单最小下单量" />
      <el-table-column prop="positionType" label="持仓类型" :formatter="statusFormat" />
      <el-table-column prop="positionDateType" label="持仓日期类型" :formatter="statusFormat" />
      <el-table-column prop="closeDealType" label="平仓处理类型" :formatter="statusFormat" />
      <el-table-column prop="tradeCurrencyID" label="交易币种类型" />
      <el-table-column prop="mortgageFundUseRange" label="质押资金可用范围" :formatter="statusFormat" />
      <el-table-column prop="exchangeProductID" label="交易所产品代码" />
      <el-table-column prop="underlyingMultiple" label="合约基础商品乘数" />
      <el-table-column prop="enableStatus" label="启用状态">
        <template scope="scope">
          <p v-if="scope.row.enableStatus=='disable'">否</p>
          <p v-if="scope.row.enableStatus=='enable'">是</p>
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
    <el-dialog
      title="内盘期货交易所期货产品表管理"
      :visible.sync="npfuturesExchangeProductDialog"
      :close-on-click-modal="false"
      width="75%"
    >
      <el-form
        ref="npfuturesExchangeProductForm"
        :model="npfuturesExchangeProductForm"
        :rules="npfuturesExchangeProductRules"
        label-width="150px"
        class="npfuturesExchangeProductForm"
      >
        <el-form-item label="产品代码" prop="productID">
          <el-input v-model="npfuturesExchangeProductForm.productID" placeholder="请输入产品代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="npfuturesExchangeProductForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="产品名称" prop="productName">
          <el-input v-model="npfuturesExchangeProductForm.productName" placeholder="请输入产品名称" />
        </el-form-item>
        <el-form-item label="产品类型" prop="productClass">
          <el-select v-model="npfuturesExchangeProductForm.productClass" placeholder="请输入产品类型">
            <el-option v-for="data in productClass" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="合约数量乘数" prop="volumeMultiple">
          <el-input v-model="npfuturesExchangeProductForm.volumeMultiple" placeholder="请输入合约数量乘数" />
        </el-form-item>
        <el-form-item label="最小变动价位" prop="priceTick">
          <el-input v-model="npfuturesExchangeProductForm.priceTick" placeholder="请输入最小变动价位" />
        </el-form-item>
        <el-form-item label="市价单最大下单量" prop="maxMarketOrderVolume">
          <el-input v-model="npfuturesExchangeProductForm.maxMarketOrderVolume" placeholder="请输入市价单最大下单量" />
        </el-form-item>
        <el-form-item label="市价单最小下单量" prop="minMarketOrderVolume">
          <el-input v-model="npfuturesExchangeProductForm.minMarketOrderVolume" placeholder="请输入市价单最小下单量" />
        </el-form-item>
        <el-form-item label="限价单最大下单量" prop="maxLimitOrderVolume">
          <el-input v-model="npfuturesExchangeProductForm.maxLimitOrderVolume" placeholder="请输入限价单最大下单量" />
        </el-form-item>
        <el-form-item label="限价单最小下单量" prop="minLimitOrderVolume">
          <el-input v-model="npfuturesExchangeProductForm.minLimitOrderVolume" placeholder="请输入限价单最小下单量" />
        </el-form-item>
        <el-form-item label="持仓类型" prop="positionType">
          <el-select v-model="npfuturesExchangeProductForm.positionType" placeholder="请输入持仓类型">
            <el-option v-for="data in positionType" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="持仓日期类型" prop="positionDateType">
          <el-select v-model="npfuturesExchangeProductForm.positionDateType" placeholder="请输入持仓日期类型">
            <el-option v-for="data in positionDateType" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="平仓处理类型" prop="closeDealType">
          <el-select v-model="npfuturesExchangeProductForm.closeDealType" placeholder="请输入平仓处理类型">
            <el-option v-for="data in closeDealType" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="交易币种类型" prop="tradeCurrencyID">
          <el-input v-model="npfuturesExchangeProductForm.tradeCurrencyID" placeholder="请输入交易币种类型">
          </el-input>
        </el-form-item>
        <el-form-item label="质押资金可用范围" prop="mortgageFundUseRange">
          <el-select
            v-model="npfuturesExchangeProductForm.mortgageFundUseRange"
            placeholder="请输入质押资金可用范围"
          >
            <el-option v-for="data in mortgageFundUseRange" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="交易所产品代码" prop="exchangeProductID">
          <el-input v-model="npfuturesExchangeProductForm.exchangeProductID" placeholder="请输入交易所产品代码" />
        </el-form-item>
        <el-form-item label="合约基础商品乘数" prop="underlyingMultiple">
          <el-input v-model="npfuturesExchangeProductForm.underlyingMultiple" placeholder="请输入合约基础商品乘数" />
        </el-form-item>
        <el-form-item label="启用状态" prop="enableStatus">
          <el-select v-model="npfuturesExchangeProductForm.enableStatus" placeholder="请选择启用状态">
            <el-option key="enable" label="是" value="enable" />
            <el-option key="disable" label="否" value="disable" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('npfuturesExchangeProductForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NpfuturesExchangeProductName',
  data() {
    return {
      npfuturesExchangeProductLoading: true,
      npfuturesExchangeProductDialog: false,
      npfuturesExchangeProductData: [],
      productClass: [],
      positionType: [],
      positionDateType: [],
      closeDealType: [],
      tradeCurrencyID: [],
      mortgageFundUseRange: [],
      dicts: [],
      npfuturesExchangeProductForm: {
        'id': '',
        'productID': '',
        'exchangeID': '',
        'productName': '',
        'productClass': '',
        'volumeMultiple': '',
        'priceTick': '',
        'maxMarketOrderVolume': '',
        'minMarketOrderVolume': '',
        'maxLimitOrderVolume': '',
        'minLimitOrderVolume': '',
        'positionType': '',
        'positionDateType': '',
        'closeDealType': '',
        'tradeCurrencyID': '',
        'mortgageFundUseRange': '',
        'exchangeProductID': '',
        'underlyingMultiple': '',
        'enableStatus': ''
      },
      searchForm: {
        'productID': '',
        'exchangeID': '',
        'productName': '',
        'productClass': '',
        'enableStatus': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      npfuturesExchangeProductRules: {
        productID: [
          { required: true, message: '产品代码不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        productName: [
          { required: true, message: '产品名称不可为空', trigger: 'change' }
        ],
        productClass: [
          { required: true, message: '产品类型不可为空', trigger: 'change' }
        ],
        volumeMultiple: [
          { required: true, message: '合约数量乘数不可为空', trigger: 'change' }
        ],
        priceTick: [
          { required: true, message: '最小变动价位不可为空', trigger: 'change' }
        ],
        maxMarketOrderVolume: [
          { required: true, message: '市价单最大下单量不可为空', trigger: 'change' }
        ],
        minMarketOrderVolume: [
          { required: true, message: '市价单最小下单量不可为空', trigger: 'change' }
        ],
        maxLimitOrderVolume: [
          { required: true, message: '限价单最大下单量不可为空', trigger: 'change' }
        ],
        minLimitOrderVolume: [
          { required: true, message: '限价单最小下单量不可为空', trigger: 'change' }
        ],
        positionType: [
          { required: true, message: '持仓类型不可为空', trigger: 'change' }
        ],
        positionDateType: [
          { required: true, message: '持仓日期类型不可为空', trigger: 'change' }
        ],
        closeDealType: [
          { required: true, message: '平仓处理类型不可为空', trigger: 'change' }
        ],
        tradeCurrencyID: [
          { required: true, message: '交易币种类型不可为空', trigger: 'change' }
        ],
        mortgageFundUseRange: [
          { required: true, message: '质押资金可用范围不可为空', trigger: 'change' }
        ],
        underlyingMultiple: [
          { required: true, message: '合约基础商品乘数不可为空', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '启用状态不可为空', trigger: 'change' }
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
        url: '/npfutures/dict/npfuturesExchangeProduct',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          this.productClass = res.object.productClass.list;
          this.positionType = res.object.positionType.list;
          this.positionDateType = res.object.positionDateType.list;
          this.closeDealType = res.object.closeDealType.list;
          this.tradeCurrencyID = res.object.tradeCurrencyID.list;
          this.mortgageFundUseRange = res.object.mortgageFundUseRange.list;
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
      this.npfuturesExchangeProductLoading = true;
      this.$http({
        url: '/npfutures/npfuturesExchangeProduct/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeProductData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.npfuturesExchangeProductLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.npfuturesExchangeProductForm = {
        'id': '',
        'productID': '',
        'exchangeID': '',
        'productName': '',
        'productClass': '',
        'volumeMultiple': '',
        'priceTick': '',
        'maxMarketOrderVolume': '',
        'minMarketOrderVolume': '',
        'maxLimitOrderVolume': '',
        'minLimitOrderVolume': '',
        'positionType': '',
        'positionDateType': '',
        'closeDealType': '',
        'tradeCurrencyID': '',
        'mortgageFundUseRange': '',
        'exchangeProductID': '',
        'underlyingMultiple': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.npfuturesExchangeProductDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.npfuturesExchangeProductForm) {
        this.$refs.npfuturesExchangeProductForm.resetFields();
      }
      this.$http({
        url: '/npfutures/npfuturesExchangeProduct/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeProductForm = {
            'id': res.object.id,
            'productID': res.object.productID,
            'exchangeID': res.object.exchangeID,
            'productName': res.object.productName,
            'productClass': res.object.productClass,
            'volumeMultiple': res.object.volumeMultiple,
            'priceTick': res.object.priceTick,
            'maxMarketOrderVolume': res.object.maxMarketOrderVolume,
            'minMarketOrderVolume': res.object.minMarketOrderVolume,
            'maxLimitOrderVolume': res.object.maxLimitOrderVolume,
            'minLimitOrderVolume': res.object.minLimitOrderVolume,
            'positionType': res.object.positionType,
            'positionDateType': res.object.positionDateType,
            'closeDealType': res.object.closeDealType,
            'tradeCurrencyID': res.object.tradeCurrencyID,
            'mortgageFundUseRange': res.object.mortgageFundUseRange,
            'exchangeProductID': res.object.exchangeProductID,
            'underlyingMultiple': res.object.underlyingMultiple,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.npfuturesExchangeProductDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npfutures/npfuturesExchangeProduct/save',
            method: 'post',
            data: this.npfuturesExchangeProductForm
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
          this.npfuturesExchangeProductDialog = false;
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
          url: '/npfutures/npfuturesExchangeProduct/del',
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
  .npfuturesExchangeProductForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
