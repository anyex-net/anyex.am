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
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.orderType" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item label="止盈止损类型">
        <el-input v-model="searchForm.tpslOrderType" clearable placeholder="请输入止盈止损类型"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-input v-model="searchForm.direction" clearable placeholder="请输入买卖方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapCoinOrderTpslLoading" :data="huobiSwapCoinOrderTpslData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="contractType" label="合约类型"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="volume" label="委托数量"/>
      <el-table-column prop="orderType" label="订单类型"/>
      <el-table-column prop="tpslOrderType" label="止盈止损类型"/>
      <el-table-column prop="direction" label="买卖方向"/>
      <el-table-column prop="orderId" label="止盈止损订单ID"/>
      <el-table-column prop="orderIdStr" label="字符串类型的止盈止损订单ID"/>
      <el-table-column prop="orderSource" label="来源"/>
      <el-table-column prop="orderPrice" label="委托价"/>
      <el-table-column prop="triggerType" label="触发类型"/>
      <el-table-column prop="triggerPrice" label="触发价"/>
      <el-table-column prop="createdAt" label="订单创建时间" :formatter="dateFormat"/>
      <el-table-column prop="orderPriceType" label="订单报价类型"/>
      <el-table-column prop="status" label="订单状态："/>
      <el-table-column prop="sourceOrderId" label="源限价单的订单id"/>
      <el-table-column prop="relationTpslOrderId" label="关联的止盈止损单id"/>
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
    <el-dialog title="永续合约止盈止损委托管理" :visible.sync="huobiSwapCoinOrderTpslDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapCoinOrderTpslForm" :model="huobiSwapCoinOrderTpslForm" :rules="huobiSwapCoinOrderTpslRules"
               label-width="150px" class="huobiSwapCoinOrderTpslForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapCoinOrderTpslForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapCoinOrderTpslForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapCoinOrderTpslForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapCoinOrderTpslForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="合约类型" prop="contractType">
          <el-input v-model="huobiSwapCoinOrderTpslForm.contractType" placeholder="请输入合约类型"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapCoinOrderTpslForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="委托数量" prop="volume">
          <el-input v-model="huobiSwapCoinOrderTpslForm.volume" placeholder="请输入委托数量"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderType" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="止盈止损类型" prop="tpslOrderType">
          <el-input v-model="huobiSwapCoinOrderTpslForm.tpslOrderType" placeholder="请输入止盈止损类型"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="huobiSwapCoinOrderTpslForm.direction" placeholder="请输入买卖方向"/>
        </el-form-item>
        <el-form-item label="止盈止损订单ID" prop="orderId">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderId" placeholder="请输入止盈止损订单ID"/>
        </el-form-item>
        <el-form-item label="字符串类型的止盈止损订单ID" prop="orderIdStr">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderIdStr" placeholder="请输入字符串类型的止盈止损订单ID"/>
        </el-form-item>
        <el-form-item label="来源" prop="orderSource">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderSource" placeholder="请输入来源"/>
        </el-form-item>
        <el-form-item label="委托价" prop="orderPrice">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderPrice" placeholder="请输入委托价"/>
        </el-form-item>
        <el-form-item label="触发类型" prop="triggerType">
          <el-input v-model="huobiSwapCoinOrderTpslForm.triggerType" placeholder="请输入触发类型"/>
        </el-form-item>
        <el-form-item label="触发价" prop="triggerPrice">
          <el-input v-model="huobiSwapCoinOrderTpslForm.triggerPrice" placeholder="请输入触发价"/>
        </el-form-item>
        <el-form-item label="订单创建时间" prop="createdAt">
          <el-input v-model="huobiSwapCoinOrderTpslForm.createdAt" placeholder="请输入订单创建时间"/>
        </el-form-item>
        <el-form-item label="订单报价类型" prop="orderPriceType">
          <el-input v-model="huobiSwapCoinOrderTpslForm.orderPriceType" placeholder="请输入订单报价类型"/>
        </el-form-item>
        <el-form-item label="订单状态：" prop="status">
          <el-input v-model="huobiSwapCoinOrderTpslForm.status" placeholder="请输入订单状态："/>
        </el-form-item>
        <el-form-item label="源限价单的订单id" prop="sourceOrderId">
          <el-input v-model="huobiSwapCoinOrderTpslForm.sourceOrderId" placeholder="请输入源限价单的订单id"/>
        </el-form-item>
        <el-form-item label="关联的止盈止损单id" prop="relationTpslOrderId">
          <el-input v-model="huobiSwapCoinOrderTpslForm.relationTpslOrderId" placeholder="请输入关联的止盈止损单id"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapCoinOrderTpslForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapCoinOrderTpslName',
    data() {
      return {
        huobiSwapCoinOrderTpslLoading: true,
        huobiSwapCoinOrderTpslDialog: false,
        huobiSwapCoinOrderTpslData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapCoinOrderTpslForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
          'contractCode': '',
          'volume': '',
          'orderType': '',
          'tpslOrderType': '',
          'direction': '',
          'orderId': '',
          'orderIdStr': '',
          'orderSource': '',
          'orderPrice': '',
          'triggerType': '',
          'triggerPrice': '',
          'createdAt': '',
          'orderPriceType': '',
          'status': '',
          'sourceOrderId': '',
          'relationTpslOrderId': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
          'contractCode': '',
          'volume': '',
          'orderType': '',
          'tpslOrderType': '',
          'direction': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapCoinOrderTpslRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapCoinOrderTpsl',
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
        this.huobiSwapCoinOrderTpslLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinOrderTpsl/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinOrderTpslData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapCoinOrderTpslLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapCoinOrderTpslForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractType': '',
          'contractCode': '',
          'volume': '',
          'orderType': '',
          'tpslOrderType': '',
          'direction': '',
          'orderId': '',
          'orderIdStr': '',
          'orderSource': '',
          'orderPrice': '',
          'triggerType': '',
          'triggerPrice': '',
          'createdAt': '',
          'orderPriceType': '',
          'status': '',
          'sourceOrderId': '',
          'relationTpslOrderId': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapCoinOrderTpslDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapCoinOrderTpslForm) {
          this.$refs.huobiSwapCoinOrderTpslForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinOrderTpsl/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinOrderTpslForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'contractType': res.object.contractType,
              'contractCode': res.object.contractCode,
              'volume': res.object.volume,
              'orderType': res.object.orderType,
              'tpslOrderType': res.object.tpslOrderType,
              'direction': res.object.direction,
              'orderId': res.object.orderId,
              'orderIdStr': res.object.orderIdStr,
              'orderSource': res.object.orderSource,
              'orderPrice': res.object.orderPrice,
              'triggerType': res.object.triggerType,
              'triggerPrice': res.object.triggerPrice,
              'createdAt': res.object.createdAt,
              'orderPriceType': res.object.orderPriceType,
              'status': res.object.status,
              'sourceOrderId': res.object.sourceOrderId,
              'relationTpslOrderId': res.object.relationTpslOrderId
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapCoinOrderTpslDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapCoinOrderTpsl/save',
              method: 'post',
              data: this.huobiSwapCoinOrderTpslForm
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
            this.huobiSwapCoinOrderTpslDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapCoinOrderTpsl/del',
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
  .huobiSwapCoinOrderTpslForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
