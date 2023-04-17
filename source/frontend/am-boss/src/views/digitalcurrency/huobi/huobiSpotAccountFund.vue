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
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountFundLoading" :data="huobiSpotAccountFundData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="账户编号"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="transactAmt" label="变动金额（入账为正 or 出账为负）"/>
      <el-table-column prop="transactType" label="变动类型"/>
      <el-table-column prop="availBalance" label="可用余额"/>
      <el-table-column prop="acctBalance" label="账户余额"/>
      <el-table-column prop="transactTime" label="交易时间（数据库记录时间）" :formatter="dateFormat"/>
      <el-table-column prop="recordId" label="记录ID"/>
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
    <el-dialog title="现货账户流水管理" :visible.sync="huobiSpotAccountFundDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiSpotAccountFundForm" :model="huobiSpotAccountFundForm" :rules="huobiSpotAccountFundRules"
               label-width="150px" class="huobiSpotAccountFundForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountFundForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountFundForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountFundForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户编号" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountFundForm.huobiAccountId" placeholder="请输入账户编号"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiSpotAccountFundForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="变动金额（入账为正 or 出账为负）" prop="transactAmt">
          <el-input v-model="huobiSpotAccountFundForm.transactAmt" placeholder="请输入变动金额（入账为正 or 出账为负）"/>
        </el-form-item>
        <el-form-item label="变动类型" prop="transactType">
          <el-input v-model="huobiSpotAccountFundForm.transactType" placeholder="请输入变动类型"/>
        </el-form-item>
        <el-form-item label="可用余额" prop="availBalance">
          <el-input v-model="huobiSpotAccountFundForm.availBalance" placeholder="请输入可用余额"/>
        </el-form-item>
        <el-form-item label="账户余额" prop="acctBalance">
          <el-input v-model="huobiSpotAccountFundForm.acctBalance" placeholder="请输入账户余额"/>
        </el-form-item>
        <el-form-item label="交易时间（数据库记录时间）" prop="transactTime">
          <el-input v-model="huobiSpotAccountFundForm.transactTime" placeholder="请输入交易时间（数据库记录时间）"/>
        </el-form-item>
        <el-form-item label="记录ID" prop="recordId">
          <el-input v-model="huobiSpotAccountFundForm.recordId" placeholder="请输入记录ID"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountFundForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountFundName',
    data() {
      return {
        huobiSpotAccountFundLoading: true,
        huobiSpotAccountFundDialog: false,
        huobiSpotAccountFundData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountFundForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'transactAmt': '',
          'transactType': '',
          'availBalance': '',
          'acctBalance': '',
          'transactTime': '',
          'recordId': ''
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
        huobiSpotAccountFundRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountFund',
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
        this.huobiSpotAccountFundLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountFund/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountFundData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountFundLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountFundForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'transactAmt': '',
          'transactType': '',
          'availBalance': '',
          'acctBalance': '',
          'transactTime': '',
          'recordId': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountFundDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountFundForm) {
          this.$refs.huobiSpotAccountFundForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountFund/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountFundForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'currency': res.object.currency,
              'transactAmt': res.object.transactAmt,
              'transactType': res.object.transactType,
              'availBalance': res.object.availBalance,
              'acctBalance': res.object.acctBalance,
              'transactTime': res.object.transactTime,
              'recordId': res.object.recordId
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountFundDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountFund/save',
              method: 'post',
              data: this.huobiSpotAccountFundForm
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
            this.huobiSpotAccountFundDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountFund/del',
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
  .huobiSpotAccountFundForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
