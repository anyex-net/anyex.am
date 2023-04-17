<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="充值地址">
        <el-input v-model="searchForm.addr" clearable placeholder="请输入充值地址"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountDepositAddrLoading"
      :data="okexAccountDepositAddrData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column type="index" label="" />
      <el-table-column prop="accountId" label="平台账户ID" />
      <el-table-column prop="apiKey" label="外部平台apikey" />
      <el-table-column prop="addr" label="充值地址" />
      <el-table-column prop="tag" label="部分币种充值需要标签" />
      <el-table-column prop="memo" label="部分币种充值需要标签" />
      <el-table-column prop="pmtId" label="部分币种充值需要此字段" />
      <el-table-column prop="ccy" label="币种" />
      <el-table-column prop="toAccount" label="转入账户" :formatter="statusFormat"/>
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
    <el-dialog title="账户充值地址管理" :visible.sync="okexAccountDepositAddrDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountDepositAddrForm"
        :model="okexAccountDepositAddrForm"
        :rules="okexAccountDepositAddrRules"
        label-width="150px"
        class="okexAccountDepositAddrForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountDepositAddrForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountDepositAddrForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountDepositAddrForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="充值地址" prop="addr">
          <el-input v-model="okexAccountDepositAddrForm.addr" placeholder="请输入充值地址" />
        </el-form-item>
        <el-form-item label="部分币种充值需要标签" prop="tag">
          <el-input v-model="okexAccountDepositAddrForm.tag" placeholder="请输入部分币种充值需要标签" />
        </el-form-item>
        <el-form-item label="部分币种充值需要标签" prop="memo">
          <el-input v-model="okexAccountDepositAddrForm.memo" placeholder="请输入部分币种充值需要标签" />
        </el-form-item>
        <el-form-item label="部分币种充值需要此字段" prop="pmtId">
          <el-input v-model="okexAccountDepositAddrForm.pmtId" placeholder="请输入部分币种充值需要此字段" />
        </el-form-item>
        <el-form-item label="币种" prop="ccy">
          <el-input v-model="okexAccountDepositAddrForm.ccy" placeholder="请输入币种" />
        </el-form-item>
        <el-form-item label="转入账户" prop="toAccount">
          <el-input v-model="okexAccountDepositAddrForm.toAccount" placeholder="请输入转入账户" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountDepositAddrForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountDepositAddrName',
  data() {
    return {
      okexAccountDepositAddrLoading: true,
      okexAccountDepositAddrDialog: false,
      okexAccountDepositAddrData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountDepositAddrForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'addr': '',
        'tag': '',
        'memo': '',
        'pmtId': '',
        'ccy': '',
        'toAccount': ''
      },
      searchForm: {
        'accountId': '',
        'apiKey': '',
        'addr': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountDepositAddrRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        addr: [
          { required: true, message: '充值地址不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '币种不可为空', trigger: 'change' }
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
        url: '/digitalcurrency/okex/dict/okexAccountDepositAddr',
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
      this.okexAccountDepositAddrLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountDepositAddr/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountDepositAddrData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountDepositAddrLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountDepositAddrForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'addr': '',
        'tag': '',
        'memo': '',
        'pmtId': '',
        'ccy': '',
        'toAccount': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountDepositAddrDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountDepositAddrForm) {
        this.$refs.okexAccountDepositAddrForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountDepositAddr/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountDepositAddrForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'addr': res.object.addr,
            'tag': res.object.tag,
            'memo': res.object.memo,
            'pmtId': res.object.pmtId,
            'ccy': res.object.ccy,
            'toAccount': res.object.toAccount
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountDepositAddrDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountDepositAddr/save',
            method: 'post',
            data: this.okexAccountDepositAddrForm
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
          this.okexAccountDepositAddrDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountDepositAddr/del',
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
  .okexAccountDepositAddrForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
