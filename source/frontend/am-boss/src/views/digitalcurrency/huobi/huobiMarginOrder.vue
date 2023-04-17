<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="订单号">
        <el-input v-model="searchForm.orderId" clearable placeholder="请输入订单号"></el-input>
      </el-form-item>
      <el-form-item label="用户ID">
        <el-input v-model="searchForm.userId" clearable placeholder="请输入用户ID"></el-input>
      </el-form-item>
      <el-form-item label="账户ID">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入账户ID"></el-input>
      </el-form-item>
      <el-form-item label="交易对">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入交易对"></el-input>
      </el-form-item>
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiMarginOrderLoading" :data="huobiMarginOrderData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="orderId" label="订单号"/>
      <el-table-column prop="userId" label="用户ID"/>
      <el-table-column prop="huobiAccountId" label="账户ID"/>
      <el-table-column prop="symbol" label="交易对"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="loanAmount" label="借币本金总额"/>
      <el-table-column prop="loanBalance" label="未还本金"/>
      <el-table-column prop="interestRate" label="币息率"/>
      <el-table-column prop="interestAmount" label="币息总额"/>
      <el-table-column prop="interestBalance" label="未还币息"/>
      <el-table-column prop="createdAt" label="借币发起时间"/>
      <el-table-column prop="accruedAt" label="最近一次计息时间"/>
      <el-table-column prop="state" label="订单状态"/>
      <el-table-column prop="paidPoint" label="已支付点卡金额（用于还息）"/>
      <el-table-column prop="paidCoin" label="已支付原币金额（用于还息）"/>
      <el-table-column prop="deductRate" label="抵扣率（用于还息）"/>
      <el-table-column prop="deductCurrency" label="抵扣币种（用于还息）"/>
      <el-table-column prop="deductAmount" label="抵扣金额（用于还息）"/>
      <el-table-column prop="updatedAt" label="更新时间"/>
      <el-table-column prop="hourInterestRate" label="时息率"/>
      <el-table-column prop="dayInterestRate" label="日息率"/>
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
    <el-dialog title="借币订单(逐仓)管理" :visible.sync="huobiMarginOrderDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiMarginOrderForm" :model="huobiMarginOrderForm" :rules="huobiMarginOrderRules"
               label-width="150px" class="huobiMarginOrderForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiMarginOrderForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiMarginOrderForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiMarginOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="订单号" prop="orderId">
          <el-input v-model="huobiMarginOrderForm.orderId" placeholder="请输入订单号"/>
        </el-form-item>
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="huobiMarginOrderForm.userId" placeholder="请输入用户ID"/>
        </el-form-item>
        <el-form-item label="账户ID" prop="huobiAccountId">
          <el-input v-model="huobiMarginOrderForm.huobiAccountId" placeholder="请输入账户ID"/>
        </el-form-item>
        <el-form-item label="交易对" prop="symbol">
          <el-input v-model="huobiMarginOrderForm.symbol" placeholder="请输入交易对"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiMarginOrderForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="借币本金总额" prop="loanAmount">
          <el-input v-model="huobiMarginOrderForm.loanAmount" placeholder="请输入借币本金总额"/>
        </el-form-item>
        <el-form-item label="未还本金" prop="loanBalance">
          <el-input v-model="huobiMarginOrderForm.loanBalance" placeholder="请输入未还本金"/>
        </el-form-item>
        <el-form-item label="币息率" prop="interestRate">
          <el-input v-model="huobiMarginOrderForm.interestRate" placeholder="请输入币息率"/>
        </el-form-item>
        <el-form-item label="币息总额" prop="interestAmount">
          <el-input v-model="huobiMarginOrderForm.interestAmount" placeholder="请输入币息总额"/>
        </el-form-item>
        <el-form-item label="未还币息" prop="interestBalance">
          <el-input v-model="huobiMarginOrderForm.interestBalance" placeholder="请输入未还币息"/>
        </el-form-item>
        <el-form-item label="借币发起时间" prop="createdAt">
          <el-input v-model="huobiMarginOrderForm.createdAt" placeholder="请输入借币发起时间"/>
        </el-form-item>
        <el-form-item label="最近一次计息时间" prop="accruedAt">
          <el-input v-model="huobiMarginOrderForm.accruedAt" placeholder="请输入最近一次计息时间"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="state">
          <el-input v-model="huobiMarginOrderForm.state" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="已支付点卡金额（用于还息）" prop="paidPoint">
          <el-input v-model="huobiMarginOrderForm.paidPoint" placeholder="请输入已支付点卡金额（用于还息）"/>
        </el-form-item>
        <el-form-item label="已支付原币金额（用于还息）" prop="paidCoin">
          <el-input v-model="huobiMarginOrderForm.paidCoin" placeholder="请输入已支付原币金额（用于还息）"/>
        </el-form-item>
        <el-form-item label="抵扣率（用于还息）" prop="deductRate">
          <el-input v-model="huobiMarginOrderForm.deductRate" placeholder="请输入抵扣率（用于还息）"/>
        </el-form-item>
        <el-form-item label="抵扣币种（用于还息）" prop="deductCurrency">
          <el-input v-model="huobiMarginOrderForm.deductCurrency" placeholder="请输入抵扣币种（用于还息）"/>
        </el-form-item>
        <el-form-item label="抵扣金额（用于还息）" prop="deductAmount">
          <el-input v-model="huobiMarginOrderForm.deductAmount" placeholder="请输入抵扣金额（用于还息）"/>
        </el-form-item>
        <el-form-item label="更新时间" prop="updatedAt">
          <el-input v-model="huobiMarginOrderForm.updatedAt" placeholder="请输入更新时间"/>
        </el-form-item>
        <el-form-item label="时息率" prop="hourInterestRate">
          <el-input v-model="huobiMarginOrderForm.hourInterestRate" placeholder="请输入时息率"/>
        </el-form-item>
        <el-form-item label="日息率" prop="dayInterestRate">
          <el-input v-model="huobiMarginOrderForm.dayInterestRate" placeholder="请输入日息率"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiMarginOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiMarginOrderName',
    data() {
      return {
        huobiMarginOrderLoading: true,
        huobiMarginOrderDialog: false,
        huobiMarginOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiMarginOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'symbol': '',
          'currency': '',
          'loanAmount': '',
          'loanBalance': '',
          'interestRate': '',
          'interestAmount': '',
          'interestBalance': '',
          'createdAt': '',
          'accruedAt': '',
          'state': '',
          'paidPoint': '',
          'paidCoin': '',
          'deductRate': '',
          'deductCurrency': '',
          'deductAmount': '',
          'updatedAt': '',
          'hourInterestRate': '',
          'dayInterestRate': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'symbol': '',
          'currency': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiMarginOrderRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiMarginOrder',
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
        this.huobiMarginOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiMarginOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiMarginOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'symbol': '',
          'currency': '',
          'loanAmount': '',
          'loanBalance': '',
          'interestRate': '',
          'interestAmount': '',
          'interestBalance': '',
          'createdAt': '',
          'accruedAt': '',
          'state': '',
          'paidPoint': '',
          'paidCoin': '',
          'deductRate': '',
          'deductCurrency': '',
          'deductAmount': '',
          'updatedAt': '',
          'hourInterestRate': '',
          'dayInterestRate': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiMarginOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiMarginOrderForm) {
          this.$refs.huobiMarginOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'orderId': res.object.orderId,
              'userId': res.object.userId,
              'huobiAccountId': res.object.huobiAccountId,
              'symbol': res.object.symbol,
              'currency': res.object.currency,
              'loanAmount': res.object.loanAmount,
              'loanBalance': res.object.loanBalance,
              'interestRate': res.object.interestRate,
              'interestAmount': res.object.interestAmount,
              'interestBalance': res.object.interestBalance,
              'createdAt': res.object.createdAt,
              'accruedAt': res.object.accruedAt,
              'state': res.object.state,
              'paidPoint': res.object.paidPoint,
              'paidCoin': res.object.paidCoin,
              'deductRate': res.object.deductRate,
              'deductCurrency': res.object.deductCurrency,
              'deductAmount': res.object.deductAmount,
              'updatedAt': res.object.updatedAt,
              'hourInterestRate': res.object.hourInterestRate,
              'dayInterestRate': res.object.dayInterestRate
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiMarginOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiMarginOrder/save',
              method: 'post',
              data: this.huobiMarginOrderForm
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
            this.huobiMarginOrderDialog = false;
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
            url: '/digitalcurrency/huobi/huobiMarginOrder/del',
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
  .huobiMarginOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
