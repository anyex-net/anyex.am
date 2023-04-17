<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="huobi帐户ID">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountBalanceLoading" :data="huobiSpotAccountBalanceData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键"/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="huobi帐户ID"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="trade" label="交易余额"/>
      <el-table-column prop="frozen" label="冻结余额"/>
      <el-table-column prop="loan" label="待还借贷本金"/>
      <el-table-column prop="interest" label="待还借贷利息"/>
      <el-table-column prop="lockAmount" label="锁仓"/>
      <el-table-column prop="bank" label="储蓄"/>
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
    <el-dialog title="现货账户余额管理" :visible.sync="huobiSpotAccountBalanceDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiSpotAccountBalanceForm" :model="huobiSpotAccountBalanceForm"
               :rules="huobiSpotAccountBalanceRules" label-width="150px" class="huobiSpotAccountBalanceForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountBalanceForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountBalanceForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountBalanceForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="币种" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountBalanceForm.huobiAccountId" placeholder="请输入huobi帐户ID"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiSpotAccountBalanceForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="交易余额" prop="trade">
          <el-input v-model="huobiSpotAccountBalanceForm.trade" placeholder="请输入交易余额"/>
        </el-form-item>
        <el-form-item label="冻结余额" prop="frozen">
          <el-input v-model="huobiSpotAccountBalanceForm.frozen" placeholder="请输入冻结余额"/>
        </el-form-item>
        <el-form-item label="待还借贷本金" prop="loan">
          <el-input v-model="huobiSpotAccountBalanceForm.loan" placeholder="请输入待还借贷本金"/>
        </el-form-item>
        <el-form-item label="待还借贷利息" prop="interest">
          <el-input v-model="huobiSpotAccountBalanceForm.interest" placeholder="请输入待还借贷利息"/>
        </el-form-item>
        <el-form-item label="锁仓" prop="lockAmount">
          <el-input v-model="huobiSpotAccountBalanceForm.lockAmount" placeholder="请输入锁仓"/>
        </el-form-item>
        <el-form-item label="储蓄" prop="bank">
          <el-input v-model="huobiSpotAccountBalanceForm.bank" placeholder="请输入储蓄"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountBalanceForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountBalanceName',
    data() {
      return {
        huobiSpotAccountBalanceLoading: true,
        huobiSpotAccountBalanceDialog: false,
        huobiSpotAccountBalanceData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountBalanceForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'trade': '',
          'frozen': '',
          'loan': '',
          'interest': '',
          'lockAmount': '',
          'bank': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountBalanceRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountBalance',
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
        this.huobiSpotAccountBalanceLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountBalance/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountBalanceData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountBalanceLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountBalanceForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'trade': '',
          'frozen': '',
          'loan': '',
          'interest': '',
          'lockAmount': '',
          'bank': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountBalanceDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountBalanceForm) {
          this.$refs.huobiSpotAccountBalanceForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountBalance/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountBalanceForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'currency': res.object.currency,
              'trade': res.object.trade,
              'frozen': res.object.frozen,
              'loan': res.object.loan,
              'interest': res.object.interest,
              'lockAmount': res.object.lockAmount,
              'bank': res.object.bank
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountBalanceDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountBalance/save',
              method: 'post',
              data: this.huobiSpotAccountBalanceForm
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
            this.huobiSpotAccountBalanceDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountBalance/del',
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
  .huobiSpotAccountBalanceForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
