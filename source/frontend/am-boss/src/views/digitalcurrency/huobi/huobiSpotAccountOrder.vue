<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="账户编号">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入账户编号"></el-input>
      </el-form-item>
      <el-form-item label="订单ID">
        <el-input v-model="searchForm.orderId" clearable placeholder="请输入订单ID"></el-input>
      </el-form-item>
      <el-form-item label="订单来源">
        <el-input v-model="searchForm.source" clearable placeholder="请输入订单来源"></el-input>
      </el-form-item>
      <el-form-item label="订单状态">
        <el-input v-model="searchForm.state" clearable placeholder="请输入订单状态"></el-input>
      </el-form-item>
      <el-form-item label="交易对">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入交易对"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.type" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountOrderLoading" :data="huobiSpotAccountOrderData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="账户编号"/>
      <el-table-column prop="amount" label="订单数量"/>
      <el-table-column prop="canceledAt" label="订单撤销时间" :formatter="dateFormat"/>
      <el-table-column prop="createdAt" label="订单创建时间" :formatter="dateFormat"/>
      <el-table-column prop="fieldAmount" label="已成交数量"/>
      <el-table-column prop="fieldCashAmount" label="已成交总金额"/>
      <el-table-column prop="fieldFees" label="已成交手续费"/>
      <el-table-column prop="finishedAt" label="订单变为终结态的时间" :formatter="dateFormat"/>
      <el-table-column prop="orderId" label="订单ID"/>
      <el-table-column prop="clientOrderId" label="用户自编订单号"/>
      <el-table-column prop="price" label="订单价格"/>
      <el-table-column prop="source" label="订单来源"/>
      <el-table-column prop="state" label="订单状态"/>
      <el-table-column prop="symbol" label="交易对"/>
      <el-table-column prop="type" label="订单类型"/>
      <el-table-column prop="stopPrice" label="止盈止损订单触发价格"/>
      <el-table-column prop="operator" label="止盈止损订单触发价运算符"/>
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
    <el-dialog title="现货订单管理" :visible.sync="huobiSpotAccountOrderDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiSpotAccountOrderForm" :model="huobiSpotAccountOrderForm" :rules="huobiSpotAccountOrderRules"
               label-width="150px" class="huobiSpotAccountOrderForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountOrderForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountOrderForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户编号" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountOrderForm.huobiAccountId" placeholder="请输入账户编号"/>
        </el-form-item>
        <el-form-item label="订单数量" prop="amount">
          <el-input v-model="huobiSpotAccountOrderForm.amount" placeholder="请输入订单数量"/>
        </el-form-item>
        <el-form-item label="订单撤销时间" prop="canceledAt">
          <el-input v-model="huobiSpotAccountOrderForm.canceledAt" placeholder="请输入订单撤销时间"/>
        </el-form-item>
        <el-form-item label="订单创建时间" prop="createdAt">
          <el-input v-model="huobiSpotAccountOrderForm.createdAt" placeholder="请输入订单创建时间"/>
        </el-form-item>
        <el-form-item label="已成交数量" prop="fieldAmount">
          <el-input v-model="huobiSpotAccountOrderForm.fieldAmount" placeholder="请输入已成交数量"/>
        </el-form-item>
        <el-form-item label="已成交总金额" prop="fieldCashAmount">
          <el-input v-model="huobiSpotAccountOrderForm.fieldCashAmount" placeholder="请输入已成交总金额"/>
        </el-form-item>
        <el-form-item label="已成交手续费" prop="fieldFees">
          <el-input v-model="huobiSpotAccountOrderForm.fieldFees" placeholder="请输入已成交手续费"/>
        </el-form-item>
        <el-form-item label="订单变为终结态的时间" prop="finishedAt">
          <el-input v-model="huobiSpotAccountOrderForm.finishedAt" placeholder="请输入订单变为终结态的时间"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderId">
          <el-input v-model="huobiSpotAccountOrderForm.orderId" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="用户自编订单号" prop="clientOrderId">
          <el-input v-model="huobiSpotAccountOrderForm.clientOrderId" placeholder="请输入用户自编订单号"/>
        </el-form-item>
        <el-form-item label="订单价格" prop="price">
          <el-input v-model="huobiSpotAccountOrderForm.price" placeholder="请输入订单价格"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="source">
          <el-input v-model="huobiSpotAccountOrderForm.source" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="state">
          <el-input v-model="huobiSpotAccountOrderForm.state" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="交易对" prop="symbol">
          <el-input v-model="huobiSpotAccountOrderForm.symbol" placeholder="请输入交易对"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="type">
          <el-input v-model="huobiSpotAccountOrderForm.type" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="止盈止损订单触发价格" prop="stopPrice">
          <el-input v-model="huobiSpotAccountOrderForm.stopPrice" placeholder="请输入止盈止损订单触发价格"/>
        </el-form-item>
        <el-form-item label="止盈止损订单触发价运算符" prop="operator">
          <el-input v-model="huobiSpotAccountOrderForm.operator" placeholder="请输入止盈止损订单触发价运算符"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountOrderName',
    data() {
      return {
        huobiSpotAccountOrderLoading: true,
        huobiSpotAccountOrderDialog: false,
        huobiSpotAccountOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'amount': '',
          'canceledAt': '',
          'createdAt': '',
          'fieldAmount': '',
          'fieldCashAmount': '',
          'fieldFees': '',
          'finishedAt': '',
          'orderId': '',
          'clientOrderId': '',
          'price': '',
          'source': '',
          'state': '',
          'symbol': '',
          'type': '',
          'stopPrice': '',
          'operator': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'orderId': '',
          'clientOrderId': '',
          'price': '',
          'source': '',
          'state': '',
          'symbol': '',
          'type': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountOrderRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountOrder',
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
        this.huobiSpotAccountOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'amount': '',
          'canceledAt': '',
          'createdAt': '',
          'fieldAmount': '',
          'fieldCashAmount': '',
          'fieldFees': '',
          'finishedAt': '',
          'orderId': '',
          'clientOrderId': '',
          'price': '',
          'source': '',
          'state': '',
          'symbol': '',
          'type': '',
          'stopPrice': '',
          'operator': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountOrderForm) {
          this.$refs.huobiSpotAccountOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'amount': res.object.amount,
              'canceledAt': res.object.canceledAt,
              'createdAt': res.object.createdAt,
              'fieldAmount': res.object.fieldAmount,
              'fieldCashAmount': res.object.fieldCashAmount,
              'fieldFees': res.object.fieldFees,
              'finishedAt': res.object.finishedAt,
              'orderId': res.object.orderId,
              'clientOrderId': res.object.clientOrderId,
              'price': res.object.price,
              'source': res.object.source,
              'state': res.object.state,
              'symbol': res.object.symbol,
              'type': res.object.type,
              'stopPrice': res.object.stopPrice,
              'operator': res.object.operator
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountOrder/save',
              method: 'post',
              data: this.huobiSpotAccountOrderForm
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
            this.huobiSpotAccountOrderDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountOrder/del',
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
  .huobiSpotAccountOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
