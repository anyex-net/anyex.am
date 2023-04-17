<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="币种名称">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入币种名称，如 BTC"></el-input>
      </el-form-item>
      <el-form-item label="充值地址">
        <el-input v-model="searchForm.fromAccount" clearable placeholder="请输入充值地址"></el-input>
      </el-form-item>
      <el-form-item label="到账地址">
        <el-input v-model="searchForm.toAccount" clearable placeholder="请输入到账地址"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountDepositHistoryLoading"
      :data="okexAccountDepositHistoryData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="" />
      <el-table-column prop="accountId" label="平台账户ID" />
      <el-table-column prop="apiKey" label="外部平台apikey" />
      <el-table-column prop="ccy" label="币种名称，如 BTC" />
      <el-table-column prop="amt" label="充值数量" />
      <el-table-column prop="fromAccount" label="充值地址" />
      <el-table-column prop="toAccount" label="到账地址" />
      <el-table-column prop="txId" label="区块转账哈希记录" />
      <el-table-column prop="ts" label="充值到账时间" :formatter="dateFormat" />
      <el-table-column prop="state" label="充值状态" :formatter="statusFormat"/>
      <el-table-column prop="depId" label="充值记录 ID" />
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
    <el-dialog
      title="账户充值记录管理"
      :visible.sync="okexAccountDepositHistoryDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="okexAccountDepositHistoryForm"
        :model="okexAccountDepositHistoryForm"
        :rules="okexAccountDepositHistoryRules"
        label-width="150px"
        class="okexAccountDepositHistoryForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountDepositHistoryForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountDepositHistoryForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountDepositHistoryForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="币种名称，如 BTC" prop="ccy">
          <el-input v-model="okexAccountDepositHistoryForm.ccy" placeholder="请输入币种名称，如 BTC" />
        </el-form-item>
        <el-form-item label="充值数量" prop="amt">
          <el-input v-model="okexAccountDepositHistoryForm.amt" placeholder="请输入充值数量" />
        </el-form-item>
        <el-form-item label="充值地址" prop="fromAccount">
          <el-input v-model="okexAccountDepositHistoryForm.fromAccount" placeholder="请输入充值地址" />
        </el-form-item>
        <el-form-item label="到账地址" prop="toAccount">
          <el-input v-model="okexAccountDepositHistoryForm.toAccount" placeholder="请输入到账地址" />
        </el-form-item>
        <el-form-item label="区块转账哈希记录" prop="txId">
          <el-input v-model="okexAccountDepositHistoryForm.txId" placeholder="请输入区块转账哈希记录" />
        </el-form-item>
        <el-form-item label="充值到账时间" prop="ts">
          <el-input v-model="okexAccountDepositHistoryForm.ts" placeholder="请输入充值到账时间" />
        </el-form-item>
        <el-form-item label="充值状态" prop="state">
          <el-input v-model="okexAccountDepositHistoryForm.state" placeholder="请输入充值状态" />
        </el-form-item>
        <el-form-item label="充值记录 ID" prop="depId">
          <el-input v-model="okexAccountDepositHistoryForm.depId" placeholder="请输入充值记录 ID" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountDepositHistoryForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountDepositHistoryName',
  data() {
    return {
      okexAccountDepositHistoryLoading: true,
      okexAccountDepositHistoryDialog: false,
      okexAccountDepositHistoryData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountDepositHistoryForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'ccy': '',
        'amt': '',
        'fromAccount': '',
        'toAccount': '',
        'txId': '',
        'ts': '',
        'state': '',
        'depId': ''
      },
      searchForm: {
        'accountId': '',
        'apiKey': '',
        'ccy': '',
        'amt': '',
        'fromAccount': '',
        'toAccount': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountDepositHistoryRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '币种名称，如 BTC不可为空', trigger: 'change' }
        ],
        amt: [
          { required: true, message: '充值数量不可为空', trigger: 'change' }
        ],
        toAccount: [
          { required: true, message: '到账地址不可为空', trigger: 'change' }
        ],
        txId: [
          { required: true, message: '区块转账哈希记录不可为空', trigger: 'change' }
        ],
        ts: [
          { required: true, message: '充值到账时间不可为空', trigger: 'change' }
        ],
        state: [
          { required: true, message: '充值状态不可为空', trigger: 'change' }
        ],
        depId: [
          { required: true, message: '充值记录 ID不可为空', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    this.doInitData();
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
      if(this.dicts[p] === undefined){
        return ''
      }
      const obj = this.dicts[p].list;
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
        url: '/digitalcurrency/okex/dict/okexAccountDepositHistory',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object.list;
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
      this.okexAccountDepositHistoryLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountDepositHistory/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountDepositHistoryData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountDepositHistoryLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountDepositHistoryForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'ccy': '',
        'amt': '',
        'fromAccount': '',
        'toAccount': '',
        'txId': '',
        'ts': '',
        'state': '',
        'depId': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountDepositHistoryDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountDepositHistoryForm) {
        this.$refs.okexAccountDepositHistoryForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountDepositHistory/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountDepositHistoryForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'ccy': res.object.ccy,
            'amt': res.object.amt,
            'fromAccount': res.object.fromAccount,
            'toAccount': res.object.toAccount,
            'txId': res.object.txId,
            'ts': res.object.ts,
            'state': res.object.state,
            'depId': res.object.depId
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountDepositHistoryDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountDepositHistory/save',
            method: 'post',
            data: this.okexAccountDepositHistoryForm
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
          this.okexAccountDepositHistoryDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountDepositHistory/del',
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
  .okexAccountDepositHistoryForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
