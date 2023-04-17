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
      <el-form-item label="变动类型">
        <el-input v-model="searchForm.transactType" clearable placeholder="请输入变动类型"></el-input>
      </el-form-item>
      <el-form-item label="划转类型">
        <el-input v-model="searchForm.transferType" clearable placeholder="请输入划转类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountLedgerLoading" :data="huobiSpotAccountLedgerData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="账户编号"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="transactAmt" label="变动金额"/>
      <el-table-column prop="transactType" label="变动类型"/>
      <el-table-column prop="transferType" label="划转类型"/>
      <el-table-column prop="transactId" label="交易流水号"/>
      <el-table-column prop="transactTime" label="交易时间" :formatter="dateFormat"/>
      <el-table-column prop="transferer" label="付款方账户ID"/>
      <el-table-column prop="transferee" label="收款方账户ID"/>
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
    <el-dialog title="现货账户财务流水管理" :visible.sync="huobiSpotAccountLedgerDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSpotAccountLedgerForm" :model="huobiSpotAccountLedgerForm" :rules="huobiSpotAccountLedgerRules"
               label-width="150px" class="huobiSpotAccountLedgerForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountLedgerForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountLedgerForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountLedgerForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户编号" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountLedgerForm.huobiAccountId" placeholder="请输入账户编号"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiSpotAccountLedgerForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="变动金额" prop="transactAmt">
          <el-input v-model="huobiSpotAccountLedgerForm.transactAmt" placeholder="请输入变动金额"/>
        </el-form-item>
        <el-form-item label="变动类型" prop="transactType">
          <el-input v-model="huobiSpotAccountLedgerForm.transactType" placeholder="请输入变动类型"/>
        </el-form-item>
        <el-form-item label="划转类型" prop="transferType">
          <el-input v-model="huobiSpotAccountLedgerForm.transferType" placeholder="请输入划转类型"/>
        </el-form-item>
        <el-form-item label="交易流水号" prop="transactId">
          <el-input v-model="huobiSpotAccountLedgerForm.transactId" placeholder="请输入交易流水号"/>
        </el-form-item>
        <el-form-item label="交易时间" prop="transactTime">
          <el-input v-model="huobiSpotAccountLedgerForm.transactTime" placeholder="请输入交易时间"/>
        </el-form-item>
        <el-form-item label="付款方账户ID" prop="transferer">
          <el-input v-model="huobiSpotAccountLedgerForm.transferer" placeholder="请输入付款方账户ID"/>
        </el-form-item>
        <el-form-item label="收款方账户ID" prop="transferee">
          <el-input v-model="huobiSpotAccountLedgerForm.transferee" placeholder="请输入收款方账户ID"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountLedgerForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountLedgerName',
    data() {
      return {
        huobiSpotAccountLedgerLoading: true,
        huobiSpotAccountLedgerDialog: false,
        huobiSpotAccountLedgerData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountLedgerForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'transactAmt': '',
          'transactType': '',
          'transferType': '',
          'transactId': '',
          'transactTime': '',
          'transferer': '',
          'transferee': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'transactAmt': '',
          'transactType': '',
          'transferType': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountLedgerRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountLedger',
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
        this.huobiSpotAccountLedgerLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountLedger/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountLedgerData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountLedgerLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountLedgerForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'currency': '',
          'transactAmt': '',
          'transactType': '',
          'transferType': '',
          'transactId': '',
          'transactTime': '',
          'transferer': '',
          'transferee': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountLedgerDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountLedgerForm) {
          this.$refs.huobiSpotAccountLedgerForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountLedger/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountLedgerForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'currency': res.object.currency,
              'transactAmt': res.object.transactAmt,
              'transactType': res.object.transactType,
              'transferType': res.object.transferType,
              'transactId': res.object.transactId,
              'transactTime': res.object.transactTime,
              'transferer': res.object.transferer,
              'transferee': res.object.transferee
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountLedgerDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountLedger/save',
              method: 'post',
              data: this.huobiSpotAccountLedgerForm
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
            this.huobiSpotAccountLedgerDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountLedger/del',
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
  .huobiSpotAccountLedgerForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
