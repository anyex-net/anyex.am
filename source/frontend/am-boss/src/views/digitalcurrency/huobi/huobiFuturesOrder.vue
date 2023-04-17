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
      <el-form-item label="合约类型">
        <el-input v-model="searchForm.contractType" clearable placeholder="请输入合约类型"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="订单报价类型">
        <el-input v-model="searchForm.orderPriceType" clearable placeholder="请输入订单报价类型"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-input v-model="searchForm.direction" clearable placeholder="请输入买卖方向"></el-input>
      </el-form-item>
      <el-form-item label="开平方向">
        <el-input v-model="searchForm.offset" clearable placeholder="请输入开平方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiFuturesOrderLoading" :data="huobiFuturesOrderData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="contractType" label="合约类型"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="volume" label="委托数量"/>
      <el-table-column prop="price" label="委托价格"/>
      <el-table-column prop="orderPriceType" label="订单报价类型"/>
      <el-table-column prop="direction" label="买卖方向"/>
      <el-table-column prop="offset" label="开平方向"/>
      <el-table-column prop="leverRate" label="杠杆倍数"/>
      <el-table-column prop="orderId" label="订单ID"/>
      <el-table-column prop="orderIdStr" label="订单ID"/>
      <el-table-column prop="clientOrderId" label="客户订单ID"/>
      <el-table-column prop="createdAt" label="创建时间" :formatter="dateFormat"/>
      <el-table-column prop="canceledAt" label="撤单时间"/>
      <el-table-column prop="tradeVolume" label="成交数量"/>
      <el-table-column prop="tradeTurnover" label="成交总金额"/>
      <el-table-column prop="fee" label="手续费"/>
      <el-table-column prop="tradeAvgPrice" label="成交均价"/>
      <el-table-column prop="marginFrozen" label="冻结保证金"/>
      <el-table-column prop="profit" label="平仓盈亏"/>
      <el-table-column prop="status" label="订单状态"/>
      <el-table-column prop="orderType" label="订单类型"/>
      <el-table-column prop="orderSource" label="订单来源"/>
      <el-table-column prop="feeAsset" label="手续费币种"/>
      <el-table-column prop="liquidationType" label="强平类型"/>
      <el-table-column prop="isTpsl" label="是否设置止盈止损"/>
      <el-table-column prop="realProfit" label="真实收益"/>
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
    <el-dialog title="交割合约账户订单信息管理" :visible.sync="huobiFuturesOrderDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiFuturesOrderForm" :model="huobiFuturesOrderForm" :rules="huobiFuturesOrderRules"
               label-width="150px" class="huobiFuturesOrderForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiFuturesOrderForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiFuturesOrderForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiFuturesOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiFuturesOrderForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="合约类型" prop="contractType">
          <el-input v-model="huobiFuturesOrderForm.contractType" placeholder="请输入合约类型"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiFuturesOrderForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="委托数量" prop="volume">
          <el-input v-model="huobiFuturesOrderForm.volume" placeholder="请输入委托数量"/>
        </el-form-item>
        <el-form-item label="委托价格" prop="price">
          <el-input v-model="huobiFuturesOrderForm.price" placeholder="请输入委托价格"/>
        </el-form-item>
        <el-form-item label="订单报价类型" prop="orderPriceType">
          <el-input v-model="huobiFuturesOrderForm.orderPriceType" placeholder="请输入订单报价类型"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="huobiFuturesOrderForm.direction" placeholder="请输入买卖方向"/>
        </el-form-item>
        <el-form-item label="开平方向" prop="offset">
          <el-input v-model="huobiFuturesOrderForm.offset" placeholder="请输入开平方向"/>
        </el-form-item>
        <el-form-item label="杠杆倍数" prop="leverRate">
          <el-input v-model="huobiFuturesOrderForm.leverRate" placeholder="请输入杠杆倍数"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderId">
          <el-input v-model="huobiFuturesOrderForm.orderId" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderIdStr">
          <el-input v-model="huobiFuturesOrderForm.orderIdStr" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="客户订单ID" prop="clientOrderId">
          <el-input v-model="huobiFuturesOrderForm.clientOrderId" placeholder="请输入客户订单ID"/>
        </el-form-item>
        <el-form-item label="创建时间" prop="createdAt">
          <el-input v-model="huobiFuturesOrderForm.createdAt" placeholder="请输入创建时间"/>
        </el-form-item>
        <el-form-item label="撤单时间" prop="canceledAt">
          <el-input v-model="huobiFuturesOrderForm.canceledAt" placeholder="请输入撤单时间"/>
        </el-form-item>
        <el-form-item label="成交数量" prop="tradeVolume">
          <el-input v-model="huobiFuturesOrderForm.tradeVolume" placeholder="请输入成交数量"/>
        </el-form-item>
        <el-form-item label="成交总金额" prop="tradeTurnover">
          <el-input v-model="huobiFuturesOrderForm.tradeTurnover" placeholder="请输入成交总金额"/>
        </el-form-item>
        <el-form-item label="手续费" prop="fee">
          <el-input v-model="huobiFuturesOrderForm.fee" placeholder="请输入手续费"/>
        </el-form-item>
        <el-form-item label="成交均价" prop="tradeAvgPrice">
          <el-input v-model="huobiFuturesOrderForm.tradeAvgPrice" placeholder="请输入成交均价"/>
        </el-form-item>
        <el-form-item label="冻结保证金" prop="marginFrozen">
          <el-input v-model="huobiFuturesOrderForm.marginFrozen" placeholder="请输入冻结保证金"/>
        </el-form-item>
        <el-form-item label="平仓盈亏" prop="profit">
          <el-input v-model="huobiFuturesOrderForm.profit" placeholder="请输入平仓盈亏"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-input v-model="huobiFuturesOrderForm.status" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-input v-model="huobiFuturesOrderForm.orderType" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="orderSource">
          <el-input v-model="huobiFuturesOrderForm.orderSource" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="手续费币种" prop="feeAsset">
          <el-input v-model="huobiFuturesOrderForm.feeAsset" placeholder="请输入手续费币种"/>
        </el-form-item>
        <el-form-item label="强平类型" prop="liquidationType">
          <el-input v-model="huobiFuturesOrderForm.liquidationType" placeholder="请输入强平类型"/>
        </el-form-item>
        <el-form-item label="是否设置止盈止损" prop="isTpsl">
          <el-input v-model="huobiFuturesOrderForm.isTpsl" placeholder="请输入是否设置止盈止损"/>
        </el-form-item>
        <el-form-item label="真实收益" prop="realProfit">
          <el-input v-model="huobiFuturesOrderForm.realProfit" placeholder="请输入真实收益"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiFuturesOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiFuturesOrderName',
    data() {
      return {
        huobiFuturesOrderLoading: true,
        huobiFuturesOrderDialog: false,
        huobiFuturesOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiFuturesOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
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
          'canceledAt': '',
          'tradeVolume': '',
          'tradeTurnover': '',
          'fee': '',
          'tradeAvgPrice': '',
          'marginFrozen': '',
          'profit': '',
          'status': '',
          'orderType': '',
          'orderSource': '',
          'feeAsset': '',
          'liquidationType': '',
          'isTpsl': '',
          'realProfit': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
          'contractCode': '',
          'volume': '',
          'price': '',
          'orderPriceType': '',
          'direction': '',
          'offset': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiFuturesOrderRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiFuturesOrder',
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
        this.huobiFuturesOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiFuturesOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiFuturesOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
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
          'canceledAt': '',
          'tradeVolume': '',
          'tradeTurnover': '',
          'fee': '',
          'tradeAvgPrice': '',
          'marginFrozen': '',
          'profit': '',
          'status': '',
          'orderType': '',
          'orderSource': '',
          'feeAsset': '',
          'liquidationType': '',
          'isTpsl': '',
          'realProfit': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiFuturesOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiFuturesOrderForm) {
          this.$refs.huobiFuturesOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'contractType': res.object.contractType,
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
              'canceledAt': res.object.canceledAt,
              'tradeVolume': res.object.tradeVolume,
              'tradeTurnover': res.object.tradeTurnover,
              'fee': res.object.fee,
              'tradeAvgPrice': res.object.tradeAvgPrice,
              'marginFrozen': res.object.marginFrozen,
              'profit': res.object.profit,
              'status': res.object.status,
              'orderType': res.object.orderType,
              'orderSource': res.object.orderSource,
              'feeAsset': res.object.feeAsset,
              'liquidationType': res.object.liquidationType,
              'isTpsl': res.object.isTpsl,
              'realProfit': res.object.realProfit
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiFuturesOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiFuturesOrder/save',
              method: 'post',
              data: this.huobiFuturesOrderForm
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
            this.huobiFuturesOrderDialog = false;
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
            url: '/digitalcurrency/huobi/huobiFuturesOrder/del',
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
  .huobiFuturesOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
