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
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiMarginCrossOrderLoading" :data="huobiMarginCrossOrderData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="orderId" label="订单号"/>
      <el-table-column prop="userId" label="用户ID"/>
      <el-table-column prop="huobiAccountId" label="账户ID"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="loanAmount" label="借币本金总额"/>
      <el-table-column prop="loanBalance" label="未还本金"/>
      <el-table-column prop="interestAmount" label="币息总额"/>
      <el-table-column prop="interestBalance" label="未还币息"/>
      <el-table-column prop="filledPoints" label="点卡抵扣数量"/>
      <el-table-column prop="filledHt" label="HT抵扣数量"/>
      <el-table-column prop="createdAt" label="借币发起时间" :formatter="dateFormat"/>
      <el-table-column prop="accruedAt" label="最近一次计息时间" :formatter="dateFormat"/>
      <el-table-column prop="state" label="订单状态"/>
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
    <el-dialog title="借币订单(全仓)管理" :visible.sync="huobiMarginCrossOrderDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiMarginCrossOrderForm" :model="huobiMarginCrossOrderForm" :rules="huobiMarginCrossOrderRules"
               label-width="150px" class="huobiMarginCrossOrderForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiMarginCrossOrderForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiMarginCrossOrderForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiMarginCrossOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="订单号" prop="orderId">
          <el-input v-model="huobiMarginCrossOrderForm.orderId" placeholder="请输入订单号"/>
        </el-form-item>
        <el-form-item label="用户ID" prop="userId">
          <el-input v-model="huobiMarginCrossOrderForm.userId" placeholder="请输入用户ID"/>
        </el-form-item>
        <el-form-item label="账户ID" prop="huobiAccountId">
          <el-input v-model="huobiMarginCrossOrderForm.huobiAccountId" placeholder="请输入账户ID"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiMarginCrossOrderForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="借币本金总额" prop="loanAmount">
          <el-input v-model="huobiMarginCrossOrderForm.loanAmount" placeholder="请输入借币本金总额"/>
        </el-form-item>
        <el-form-item label="未还本金" prop="loanBalance">
          <el-input v-model="huobiMarginCrossOrderForm.loanBalance" placeholder="请输入未还本金"/>
        </el-form-item>
        <el-form-item label="币息总额" prop="interestAmount">
          <el-input v-model="huobiMarginCrossOrderForm.interestAmount" placeholder="请输入币息总额"/>
        </el-form-item>
        <el-form-item label="未还币息" prop="interestBalance">
          <el-input v-model="huobiMarginCrossOrderForm.interestBalance" placeholder="请输入未还币息"/>
        </el-form-item>
        <el-form-item label="点卡抵扣数量" prop="filledPoints">
          <el-input v-model="huobiMarginCrossOrderForm.filledPoints" placeholder="请输入点卡抵扣数量"/>
        </el-form-item>
        <el-form-item label="HT抵扣数量" prop="filledHt">
          <el-input v-model="huobiMarginCrossOrderForm.filledHt" placeholder="请输入HT抵扣数量"/>
        </el-form-item>
        <el-form-item label="借币发起时间" prop="createdAt">
          <el-input v-model="huobiMarginCrossOrderForm.createdAt" placeholder="请输入借币发起时间"/>
        </el-form-item>
        <el-form-item label="最近一次计息时间" prop="accruedAt">
          <el-input v-model="huobiMarginCrossOrderForm.accruedAt" placeholder="请输入最近一次计息时间"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="state">
          <el-input v-model="huobiMarginCrossOrderForm.state" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiMarginCrossOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiMarginCrossOrderName',
    data() {
      return {
        huobiMarginCrossOrderLoading: true,
        huobiMarginCrossOrderDialog: false,
        huobiMarginCrossOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiMarginCrossOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'currency': '',
          'loanAmount': '',
          'loanBalance': '',
          'interestAmount': '',
          'interestBalance': '',
          'filledPoints': '',
          'filledHt': '',
          'createdAt': '',
          'accruedAt': '',
          'state': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'currency': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiMarginCrossOrderRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiMarginCrossOrder',
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
        this.huobiMarginCrossOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginCrossOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginCrossOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiMarginCrossOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiMarginCrossOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'orderId': '',
          'userId': '',
          'huobiAccountId': '',
          'currency': '',
          'loanAmount': '',
          'loanBalance': '',
          'interestAmount': '',
          'interestBalance': '',
          'filledPoints': '',
          'filledHt': '',
          'createdAt': '',
          'accruedAt': '',
          'state': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiMarginCrossOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiMarginCrossOrderForm) {
          this.$refs.huobiMarginCrossOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginCrossOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginCrossOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'orderId': res.object.orderId,
              'userId': res.object.userId,
              'huobiAccountId': res.object.huobiAccountId,
              'currency': res.object.currency,
              'loanAmount': res.object.loanAmount,
              'loanBalance': res.object.loanBalance,
              'interestAmount': res.object.interestAmount,
              'interestBalance': res.object.interestBalance,
              'filledPoints': res.object.filledPoints,
              'filledHt': res.object.filledHt,
              'createdAt': res.object.createdAt,
              'accruedAt': res.object.accruedAt,
              'state': res.object.state
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiMarginCrossOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiMarginCrossOrder/save',
              method: 'post',
              data: this.huobiMarginCrossOrderForm
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
            this.huobiMarginCrossOrderDialog = false;
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
            url: '/digitalcurrency/huobi/huobiMarginCrossOrder/del',
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
  .huobiMarginCrossOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
