<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="产品ID">
        <el-input v-model="searchForm.instId" clearable placeholder="请输入产品ID"></el-input>
      </el-form-item>
      <el-form-item label="币种">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item label="持仓模式">
        <el-select v-model="searchForm.mgnMode" clearable placeholder="请输入持仓模式">
        <el-option v-for="data in mgnModeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountInterestLoading"
      :data="okexAccountInterestData"
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
      <el-table-column prop="instId" label="产品ID" />
      <el-table-column prop="ccy" label="币种" />
      <el-table-column prop="mgnMode" label="持仓模式" :formatter="statusFormat"/>
      <el-table-column prop="interestRate" label="利率" />
      <el-table-column prop="liab" label="计息负债" />
      <el-table-column prop="interest" label="利息" />
      <el-table-column prop="ts" label="计息时间" :formatter="dateFormat" />
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
    <el-dialog title="账户计息记录管理" :visible.sync="okexAccountInterestDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountInterestForm"
        :model="okexAccountInterestForm"
        :rules="okexAccountInterestRules"
        label-width="150px"
        class="okexAccountInterestForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountInterestForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountInterestForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountInterestForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="产品ID" prop="instId">
          <el-input v-model="okexAccountInterestForm.instId" placeholder="请输入产品ID" />
        </el-form-item>
        <el-form-item label="币种" prop="ccy">
          <el-input v-model="okexAccountInterestForm.ccy" placeholder="请输入币种" />
        </el-form-item>
        <el-form-item label="持仓模式" prop="mgnMode">
          <el-input v-model="okexAccountInterestForm.mgnMode" placeholder="请输入持仓模式" />
        </el-form-item>
        <el-form-item label="利率" prop="interestRate">
          <el-input v-model="okexAccountInterestForm.interestRate" placeholder="请输入利率" />
        </el-form-item>
        <el-form-item label="计息负债" prop="liab">
          <el-input v-model="okexAccountInterestForm.liab" placeholder="请输入计息负债" />
        </el-form-item>
        <el-form-item label="利息" prop="interest">
          <el-input v-model="okexAccountInterestForm.interest" placeholder="请输入利息" />
        </el-form-item>
        <el-form-item label="计息时间" prop="ts">
          <el-input v-model="okexAccountInterestForm.ts" placeholder="请输入计息时间" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountInterestForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountInterestName',
  data() {
    return {
      okexAccountInterestLoading: true,
      okexAccountInterestDialog: false,
      okexAccountInterestData: [],
      commodityTypeSelects: [],
      dicts: [],
      mgnModeList: [],
      okexAccountInterestForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'instId': '',
        'ccy': '',
        'mgnMode': '',
        'interestRate': '',
        'liab': '',
        'interest': '',
        'ts': ''
      },
      searchForm: {
        'accountId': '',
        'apiKey': '',
        'instId': '',
        'ccy': '',
        'mgnMode': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountInterestRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        instId: [
          { required: true, message: '产品ID不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '币种不可为空', trigger: 'change' }
        ],
        mgnMode: [
          { required: true, message: '持仓模式不可为空', trigger: 'change' }
        ],
        interestRate: [
          { required: true, message: '利率不可为空', trigger: 'change' }
        ],
        liab: [
          { required: true, message: '计息负债不可为空', trigger: 'change' }
        ],
        interest: [
          { required: true, message: '利息不可为空', trigger: 'change' }
        ],
        ts: [
          { required: true, message: '计息时间不可为空', trigger: 'change' }
        ]
      }
    };
  },
  created: function() {
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
      console.log(this.dicts[p])
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
        url: '/digitalcurrency/okex/dict/okexAccountInterest',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.mgnModeList = res.object.list.mgnMode.list
          this.dicts = res.object.list
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
      this.okexAccountInterestLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountInterest/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountInterestData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountInterestLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountInterestForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'instId': '',
        'ccy': '',
        'mgnMode': '',
        'interestRate': '',
        'liab': '',
        'interest': '',
        'ts': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountInterestDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountInterestForm) {
        this.$refs.okexAccountInterestForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountInterest/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountInterestForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'instId': res.object.instId,
            'ccy': res.object.ccy,
            'mgnMode': res.object.mgnMode,
            'interestRate': res.object.interestRate,
            'liab': res.object.liab,
            'interest': res.object.interest,
            'ts': res.object.ts
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountInterestDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountInterest/save',
            method: 'post',
            data: this.okexAccountInterestForm
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
          this.okexAccountInterestDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountInterest/del',
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
  .okexAccountInterestForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
