<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiMarginAccountInfoLoading" :data="huobiMarginAccountInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="trade" label="交易余额"/>
      <el-table-column prop="frozen" label="冻结余额"/>
      <el-table-column prop="loan" label="待还借贷本金"/>
      <el-table-column prop="interest" label="待还借贷利息"/>
      <el-table-column prop="transferOutAvailable" label="可划转额"/>
      <el-table-column prop="loanAvailable" label="可借额"/>
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
    <el-dialog title="借币账户信息(逐仓)管理" :visible.sync="huobiMarginAccountInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiMarginAccountInfoForm" :model="huobiMarginAccountInfoForm" :rules="huobiMarginAccountInfoRules"
               label-width="150px" class="huobiMarginAccountInfoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiMarginAccountInfoForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiMarginAccountInfoForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiMarginAccountInfoForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiMarginAccountInfoForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="交易余额" prop="trade">
          <el-input v-model="huobiMarginAccountInfoForm.trade" placeholder="请输入交易余额"/>
        </el-form-item>
        <el-form-item label="冻结余额" prop="frozen">
          <el-input v-model="huobiMarginAccountInfoForm.frozen" placeholder="请输入冻结余额"/>
        </el-form-item>
        <el-form-item label="待还借贷本金" prop="loan">
          <el-input v-model="huobiMarginAccountInfoForm.loan" placeholder="请输入待还借贷本金"/>
        </el-form-item>
        <el-form-item label="待还借贷利息" prop="interest">
          <el-input v-model="huobiMarginAccountInfoForm.interest" placeholder="请输入待还借贷利息"/>
        </el-form-item>
        <el-form-item label="可划转额" prop="transferOutAvailable">
          <el-input v-model="huobiMarginAccountInfoForm.transferOutAvailable" placeholder="请输入可划转额"/>
        </el-form-item>
        <el-form-item label="可借额" prop="loanAvailable">
          <el-input v-model="huobiMarginAccountInfoForm.loanAvailable" placeholder="请输入可借额"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiMarginAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiMarginAccountInfoName',
    data() {
      return {
        huobiMarginAccountInfoLoading: true,
        huobiMarginAccountInfoDialog: false,
        huobiMarginAccountInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiMarginAccountInfoForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'currency': '',
          'trade': '',
          'frozen': '',
          'loan': '',
          'interest': '',
          'transferOutAvailable': '',
          'loanAvailable': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'currency': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiMarginAccountInfoRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiMarginAccountInfo',
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
        this.huobiMarginAccountInfoLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginAccountInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginAccountInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiMarginAccountInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiMarginAccountInfoForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'currency': '',
          'trade': '',
          'frozen': '',
          'loan': '',
          'interest': '',
          'transferOutAvailable': '',
          'loanAvailable': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiMarginAccountInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiMarginAccountInfoForm) {
          this.$refs.huobiMarginAccountInfoForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginAccountInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginAccountInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'currency': res.object.currency,
              'trade': res.object.trade,
              'frozen': res.object.frozen,
              'loan': res.object.loan,
              'interest': res.object.interest,
              'transferOutAvailable': res.object.transferOutAvailable,
              'loanAvailable': res.object.loanAvailable
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiMarginAccountInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiMarginAccountInfo/save',
              method: 'post',
              data: this.huobiMarginAccountInfoForm
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
            this.huobiMarginAccountInfoDialog = false;
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
            url: '/digitalcurrency/huobi/huobiMarginAccountInfo/del',
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
  .huobiMarginAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
