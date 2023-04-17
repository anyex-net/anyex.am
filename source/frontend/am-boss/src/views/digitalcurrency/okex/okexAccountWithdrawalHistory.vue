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
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountWithdrawalHistoryLoading"
      :data="okexAccountWithdrawalHistoryData"
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
      <el-table-column prop="ccy" label="币种" />
      <el-table-column prop="amt" label="数量" />
      <el-table-column prop="ts" label="提币申请时间" :formatter="dateFormat"/>
      <el-table-column prop="fromAccount" label="提币地址" />
      <el-table-column prop="toAccount" label="收币地址" />
      <el-table-column prop="tag" label="部分币种提币需要标签" />
      <el-table-column prop="pmtId" label="部分币种提币需要此字段" />
      <el-table-column prop="memo" label="部分币种提币需要此字段" />
      <el-table-column prop="txId" label="提币哈希记录" />
      <el-table-column prop="fee" label="提币手续费" />
      <el-table-column prop="state" label="提币状态 " :formatter="statusFormat"/>
      <el-table-column prop="wdId" label="提币申请 ID" />
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
      title="账户提币记录管理"
      :visible.sync="okexAccountWithdrawalHistoryDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="okexAccountWithdrawalHistoryForm"
        :model="okexAccountWithdrawalHistoryForm"
        :rules="okexAccountWithdrawalHistoryRules"
        label-width="150px"
        class="okexAccountWithdrawalHistoryForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountWithdrawalHistoryForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountWithdrawalHistoryForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountWithdrawalHistoryForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="币种" prop="ccy">
          <el-input v-model="okexAccountWithdrawalHistoryForm.ccy" placeholder="请输入币种" />
        </el-form-item>
        <el-form-item label="数量" prop="amt">
          <el-input v-model="okexAccountWithdrawalHistoryForm.amt" placeholder="请输入数量" />
        </el-form-item>
        <el-form-item label="提币申请时间" prop="ts">
          <el-input v-model="okexAccountWithdrawalHistoryForm.ts" placeholder="请输入提币申请时间" />
        </el-form-item>
        <el-form-item label="提币地址" prop="fromAccount">
          <el-input v-model="okexAccountWithdrawalHistoryForm.fromAccount" placeholder="请输入提币地址" />
        </el-form-item>
        <el-form-item label="收币地址" prop="toAccount">
          <el-input v-model="okexAccountWithdrawalHistoryForm.toAccount" placeholder="请输入收币地址" />
        </el-form-item>
        <el-form-item label="部分币种提币需要标签" prop="tag">
          <el-input v-model="okexAccountWithdrawalHistoryForm.tag" placeholder="请输入部分币种提币需要标签" />
        </el-form-item>
        <el-form-item label="部分币种提币需要此字段" prop="pmtId">
          <el-input v-model="okexAccountWithdrawalHistoryForm.pmtId" placeholder="请输入部分币种提币需要此字段" />
        </el-form-item>
        <el-form-item label="部分币种提币需要此字段" prop="memo">
          <el-input v-model="okexAccountWithdrawalHistoryForm.memo" placeholder="请输入部分币种提币需要此字段" />
        </el-form-item>
        <el-form-item label="提币哈希记录" prop="txId">
          <el-input v-model="okexAccountWithdrawalHistoryForm.txId" placeholder="请输入提币哈希记录" />
        </el-form-item>
        <el-form-item label="提币手续费" prop="fee">
          <el-input v-model="okexAccountWithdrawalHistoryForm.fee" placeholder="请输入提币手续费" />
        </el-form-item>
        <el-form-item label="提币状态 " prop="state">
          <el-input v-model="okexAccountWithdrawalHistoryForm.state" placeholder="请输入提币状态 " />
        </el-form-item>
        <el-form-item label="提币申请 ID" prop="wdId">
          <el-input v-model="okexAccountWithdrawalHistoryForm.wdId" placeholder="请输入提币申请 ID" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountWithdrawalHistoryForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountWithdrawalHistoryName',
  data() {
    return {
      okexAccountWithdrawalHistoryLoading: true,
      okexAccountWithdrawalHistoryDialog: false,
      okexAccountWithdrawalHistoryData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountWithdrawalHistoryForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'ccy': '',
        'amt': '',
        'ts': '',
        'fromAccount': '',
        'toAccount': '',
        'tag': '',
        'pmtId': '',
        'memo': '',
        'txId': '',
        'fee': '',
        'state': '',
        'wdId': ''
      },
      searchForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'ccy': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountWithdrawalHistoryRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '币种不可为空', trigger: 'change' }
        ],
        amt: [
          { required: true, message: '数量不可为空', trigger: 'change' }
        ],
        ts: [
          { required: true, message: '提币申请时间不可为空', trigger: 'change' }
        ],
        toAccount: [
          { required: true, message: '收币地址不可为空', trigger: 'change' }
        ],
        fee: [
          { required: true, message: '提币手续费不可为空', trigger: 'change' }
        ],
        state: [
          { required: true, message: '提币状态 不可为空', trigger: 'change' }
        ],
        wdId: [
          { required: true, message: '提币申请 ID不可为空', trigger: 'change' }
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
        url: '/digitalcurrency/okex/dict/okexAccountWithdrawalHistory',
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
      this.okexAccountWithdrawalHistoryLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountWithdrawalHistory/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountWithdrawalHistoryData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountWithdrawalHistoryLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountWithdrawalHistoryForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'ccy': '',
        'amt': '',
        'ts': '',
        'fromAccount': '',
        'toAccount': '',
        'tag': '',
        'pmtId': '',
        'memo': '',
        'txId': '',
        'fee': '',
        'state': '',
        'wdId': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountWithdrawalHistoryDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountWithdrawalHistoryForm) {
        this.$refs.okexAccountWithdrawalHistoryForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountWithdrawalHistory/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountWithdrawalHistoryForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'ccy': res.object.ccy,
            'amt': res.object.amt,
            'ts': res.object.ts,
            'fromAccount': res.object.fromAccount,
            'toAccount': res.object.toAccount,
            'tag': res.object.tag,
            'pmtId': res.object.pmtId,
            'memo': res.object.memo,
            'txId': res.object.txId,
            'fee': res.object.fee,
            'state': res.object.state,
            'wdId': res.object.wdId
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountWithdrawalHistoryDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountWithdrawalHistory/save',
            method: 'post',
            data: this.okexAccountWithdrawalHistoryForm
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
          this.okexAccountWithdrawalHistoryDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountWithdrawalHistory/del',
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
  .okexAccountWithdrawalHistoryForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
