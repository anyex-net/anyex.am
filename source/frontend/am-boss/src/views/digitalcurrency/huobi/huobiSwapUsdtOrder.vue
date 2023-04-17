<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="品种代码">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入品种代码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="订单状态">
        <el-input v-model="searchForm.status" clearable placeholder="请输入订单状态"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.orderType" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item label="订单来源">
        <el-input v-model="searchForm.orderSource" clearable placeholder="请输入订单来源"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapUsdtOrderLoading" :data="huobiSwapUsdtOrderData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="volume" label="委托数量"/>
      <el-table-column prop="price" label="委托价格"/>
      <el-table-column prop="orderPriceType" label="订单报价类型"/>
      <el-table-column prop="direction" label="买卖方向"/>
      <el-table-column prop="offset" label="开平方向"/>
      <el-table-column prop="leverRate" label="杠杆倍数"/>
      <el-table-column prop="orderId" label="订单ID"/>
      <el-table-column prop="orderIdStr" label="String类型订单ID"/>
      <el-table-column prop="clientOrderId" label="客户订单ID"/>
      <el-table-column prop="createdAt" label="创建时间"/>
      <el-table-column prop="tradeVolume" label="成交数量"/>
      <el-table-column prop="tradeTurnover" label="成交总金额"/>
      <el-table-column prop="fee" label="手续费"/>
      <el-table-column prop="tradeAvgPrice" label="成交均价"/>
      <el-table-column prop="marginAsset" label="保证金币种"/>
      <el-table-column prop="marginFrozen" label="冻结保证金"/>
      <el-table-column prop="profit" label="平仓盈亏"/>
      <el-table-column prop="status" label="订单状态"/>
      <el-table-column prop="orderType" label="订单类型"/>
      <el-table-column prop="orderSource" label="订单来源"/>
      <el-table-column prop="feeAsset" label="手续费币种"/>
      <el-table-column prop="liquidationType" label="结算类型"/>
      <el-table-column prop="canceledAt" label="撤单时间"/>
      <el-table-column prop="marginAccount" label="保证金账户"/>
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
    <el-dialog title="永续(U)合约账户订单信息管理" :visible.sync="huobiSwapUsdtOrderDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapUsdtOrderForm" :model="huobiSwapUsdtOrderForm" :rules="huobiSwapUsdtOrderRules"
               label-width="150px" class="huobiSwapUsdtOrderForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapUsdtOrderForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapUsdtOrderForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapUsdtOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapUsdtOrderForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapUsdtOrderForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="委托数量" prop="volume">
          <el-input v-model="huobiSwapUsdtOrderForm.volume" placeholder="请输入委托数量"/>
        </el-form-item>
        <el-form-item label="委托价格" prop="price">
          <el-input v-model="huobiSwapUsdtOrderForm.price" placeholder="请输入委托价格"/>
        </el-form-item>
        <el-form-item label="订单报价类型" prop="orderPriceType">
          <el-input v-model="huobiSwapUsdtOrderForm.orderPriceType" placeholder="请输入订单报价类型"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="huobiSwapUsdtOrderForm.direction" placeholder="请输入买卖方向"/>
        </el-form-item>
        <el-form-item label="开平方向" prop="offset">
          <el-input v-model="huobiSwapUsdtOrderForm.offset" placeholder="请输入开平方向"/>
        </el-form-item>
        <el-form-item label="杠杆倍数" prop="leverRate">
          <el-input v-model="huobiSwapUsdtOrderForm.leverRate" placeholder="请输入杠杆倍数"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderId">
          <el-input v-model="huobiSwapUsdtOrderForm.orderId" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="String类型订单ID" prop="orderIdStr">
          <el-input v-model="huobiSwapUsdtOrderForm.orderIdStr" placeholder="请输入String类型订单ID"/>
        </el-form-item>
        <el-form-item label="客户订单ID" prop="clientOrderId">
          <el-input v-model="huobiSwapUsdtOrderForm.clientOrderId" placeholder="请输入客户订单ID"/>
        </el-form-item>
        <el-form-item label="创建时间" prop="createdAt">
          <el-input v-model="huobiSwapUsdtOrderForm.createdAt" placeholder="请输入创建时间"/>
        </el-form-item>
        <el-form-item label="成交数量" prop="tradeVolume">
          <el-input v-model="huobiSwapUsdtOrderForm.tradeVolume" placeholder="请输入成交数量"/>
        </el-form-item>
        <el-form-item label="成交总金额" prop="tradeTurnover">
          <el-input v-model="huobiSwapUsdtOrderForm.tradeTurnover" placeholder="请输入成交总金额"/>
        </el-form-item>
        <el-form-item label="手续费" prop="fee">
          <el-input v-model="huobiSwapUsdtOrderForm.fee" placeholder="请输入手续费"/>
        </el-form-item>
        <el-form-item label="成交均价" prop="tradeAvgPrice">
          <el-input v-model="huobiSwapUsdtOrderForm.tradeAvgPrice" placeholder="请输入成交均价"/>
        </el-form-item>
        <el-form-item label="保证金币种" prop="marginAsset">
          <el-input v-model="huobiSwapUsdtOrderForm.marginAsset" placeholder="请输入保证金币种"/>
        </el-form-item>
        <el-form-item label="冻结保证金" prop="marginFrozen">
          <el-input v-model="huobiSwapUsdtOrderForm.marginFrozen" placeholder="请输入冻结保证金"/>
        </el-form-item>
        <el-form-item label="平仓盈亏" prop="profit">
          <el-input v-model="huobiSwapUsdtOrderForm.profit" placeholder="请输入平仓盈亏"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-input v-model="huobiSwapUsdtOrderForm.status" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-input v-model="huobiSwapUsdtOrderForm.orderType" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="orderSource">
          <el-input v-model="huobiSwapUsdtOrderForm.orderSource" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="手续费币种" prop="feeAsset">
          <el-input v-model="huobiSwapUsdtOrderForm.feeAsset" placeholder="请输入手续费币种"/>
        </el-form-item>
        <el-form-item label="结算类型" prop="liquidationType">
          <el-input v-model="huobiSwapUsdtOrderForm.liquidationType" placeholder="请输入结算类型"/>
        </el-form-item>
        <el-form-item label="撤单时间" prop="canceledAt">
          <el-input v-model="huobiSwapUsdtOrderForm.canceledAt" placeholder="请输入撤单时间"/>
        </el-form-item>
        <el-form-item label="保证金账户" prop="marginAccount">
          <el-input v-model="huobiSwapUsdtOrderForm.marginAccount" placeholder="请输入保证金账户"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapUsdtOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapUsdtOrderName',
    data() {
      return {
        huobiSwapUsdtOrderLoading: true,
        huobiSwapUsdtOrderDialog: false,
        huobiSwapUsdtOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapUsdtOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'volume': '',
          'price': '',
          'orderPriceType': '',
          'direction': '',
          'offset': '',
          'leverRate': '',
          'orderId': '',
          'orderIdStr': '',
          'clientOrderId': '',
          'createdAt': '',
          'tradeVolume': '',
          'tradeTurnover': '',
          'fee': '',
          'tradeAvgPrice': '',
          'marginAsset': '',
          'marginFrozen': '',
          'profit': '',
          'status': '',
          'orderType': '',
          'orderSource': '',
          'feeAsset': '',
          'liquidationType': '',
          'canceledAt': '',
          'marginAccount': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'status': '',
          'orderType': '',
          'orderSource': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapUsdtOrderRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
          ]
        }
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
          url: '/digitalcurrency/huobi/dict/huobiSwapUsdtOrder',
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
        this.huobiSwapUsdtOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapUsdtOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapUsdtOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'volume': '',
          'price': '',
          'orderPriceType': '',
          'direction': '',
          'offset': '',
          'leverRate': '',
          'orderId': '',
          'orderIdStr': '',
          'clientOrderId': '',
          'createdAt': '',
          'tradeVolume': '',
          'tradeTurnover': '',
          'fee': '',
          'tradeAvgPrice': '',
          'marginAsset': '',
          'marginFrozen': '',
          'profit': '',
          'status': '',
          'orderType': '',
          'orderSource': '',
          'feeAsset': '',
          'liquidationType': '',
          'canceledAt': '',
          'marginAccount': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapUsdtOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapUsdtOrderForm) {
          this.$refs.huobiSwapUsdtOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'contractCode': res.object.contractCode,
              'volume': res.object.volume,
              'price': res.object.price,
              'orderPriceType': res.object.orderPriceType,
              'direction': res.object.direction,
              'offset': res.object.offset,
              'leverRate': res.object.leverRate,
              'orderId': res.object.orderId,
              'orderIdStr': res.object.orderIdStr,
              'clientOrderId': res.object.clientOrderId,
              'createdAt': res.object.createdAt,
              'tradeVolume': res.object.tradeVolume,
              'tradeTurnover': res.object.tradeTurnover,
              'fee': res.object.fee,
              'tradeAvgPrice': res.object.tradeAvgPrice,
              'marginAsset': res.object.marginAsset,
              'marginFrozen': res.object.marginFrozen,
              'profit': res.object.profit,
              'status': res.object.status,
              'orderType': res.object.orderType,
              'orderSource': res.object.orderSource,
              'feeAsset': res.object.feeAsset,
              'liquidationType': res.object.liquidationType,
              'canceledAt': res.object.canceledAt,
              'marginAccount': res.object.marginAccount
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapUsdtOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapUsdtOrder/save',
              method: 'post',
              data: this.huobiSwapUsdtOrderForm
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
            this.huobiSwapUsdtOrderDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapUsdtOrder/del',
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
  .huobiSwapUsdtOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
