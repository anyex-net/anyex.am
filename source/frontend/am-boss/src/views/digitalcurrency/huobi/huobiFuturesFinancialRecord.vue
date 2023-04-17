<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiFuturesFinancialRecordLoading" :data="huobiFuturesFinancialRecordData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="recordId" label="财务记录ID"/>
      <el-table-column prop="ts" label="创建时间" :formatter="dateFormat"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="type" label="交易类型"/>
      <el-table-column prop="amount" label="金额"/>
      <el-table-column prop="contractCode" label="合约代码"/>
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
    <el-dialog title="交割合约账户财务记录管理" :visible.sync="huobiFuturesFinancialRecordDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiFuturesFinancialRecordForm" :model="huobiFuturesFinancialRecordForm"
               :rules="huobiFuturesFinancialRecordRules" label-width="150px" class="huobiFuturesFinancialRecordForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiFuturesFinancialRecordForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiFuturesFinancialRecordForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiFuturesFinancialRecordForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="财务记录ID" prop="recordId">
          <el-input v-model="huobiFuturesFinancialRecordForm.recordId" placeholder="请输入财务记录ID"/>
        </el-form-item>
        <el-form-item label="创建时间" prop="ts">
          <el-input v-model="huobiFuturesFinancialRecordForm.ts" placeholder="请输入创建时间"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiFuturesFinancialRecordForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="交易类型" prop="type">
          <el-input v-model="huobiFuturesFinancialRecordForm.type" placeholder="请输入交易类型"/>
        </el-form-item>
        <el-form-item label="金额" prop="amount">
          <el-input v-model="huobiFuturesFinancialRecordForm.amount" placeholder="请输入金额"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiFuturesFinancialRecordForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiFuturesFinancialRecordForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiFuturesFinancialRecordName',
    data() {
      return {
        huobiFuturesFinancialRecordLoading: true,
        huobiFuturesFinancialRecordDialog: false,
        huobiFuturesFinancialRecordData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiFuturesFinancialRecordForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'recordId': '',
          'ts': '',
          'symbol': '',
          'type': '',
          'amount': '',
          'contractCode': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'contractCode': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiFuturesFinancialRecordRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiFuturesFinancialRecord',
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
        this.huobiFuturesFinancialRecordLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesFinancialRecord/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesFinancialRecordData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiFuturesFinancialRecordLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiFuturesFinancialRecordForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'recordId': '',
          'ts': '',
          'symbol': '',
          'type': '',
          'amount': '',
          'contractCode': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiFuturesFinancialRecordDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiFuturesFinancialRecordForm) {
          this.$refs.huobiFuturesFinancialRecordForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiFuturesFinancialRecord/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiFuturesFinancialRecordForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'recordId': res.object.recordId,
              'ts': res.object.ts,
              'symbol': res.object.symbol,
              'type': res.object.type,
              'amount': res.object.amount,
              'contractCode': res.object.contractCode
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiFuturesFinancialRecordDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiFuturesFinancialRecord/save',
              method: 'post',
              data: this.huobiFuturesFinancialRecordForm
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
            this.huobiFuturesFinancialRecordDialog = false;
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
            url: '/digitalcurrency/huobi/huobiFuturesFinancialRecord/del',
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
  .huobiFuturesFinancialRecordForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
