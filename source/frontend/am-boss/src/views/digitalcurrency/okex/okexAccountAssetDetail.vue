<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="账户信息的更新时间">
        <el-input v-model="searchForm.uTime" clearable placeholder="请输入账户信息的更新时间"></el-input>
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
      v-loading="okexAccountAssetDetailLoading"
      :data="okexAccountAssetDetailData"
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
      <el-table-column prop="uTime" label="账户信息的更新时间" :formatter="dateFormat" />
      <el-table-column prop="ccy" label="币种" />
      <el-table-column prop="eq" label="币种总权益" />
      <el-table-column prop="isoEq" label="币种逐仓仓位权益" />
      <el-table-column prop="availEq" label="可用保证金" />
      <el-table-column prop="disEq" label="美金层面币种折算权益" />
      <el-table-column prop="availBal" label="可用余额" />
      <el-table-column prop="frozenBal" label="币种占用金额" />
      <el-table-column prop="ordFrozen" label="挂单冻结数量" />
      <el-table-column prop="liab" label="币种负债额" />
      <el-table-column prop="upl" label="未实现盈亏" />
      <el-table-column prop="uplLiab" label="由于仓位未实现亏损导致的负债" />
      <el-table-column prop="crossLiab" label="币种全仓负债额" />
      <el-table-column prop="isoLiab" label="币种逐仓负债额" />
      <el-table-column prop="mgnRatio" label="保证金率" />
      <el-table-column prop="interest" label="计息" />
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
    <el-dialog title="账户余额明细管理" :visible.sync="okexAccountAssetDetailDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountAssetDetailForm"
        :model="okexAccountAssetDetailForm"
        :rules="okexAccountAssetDetailRules"
        label-width="150px"
        class="okexAccountAssetDetailForm"
      >
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountAssetDetailForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountAssetDetailForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="账户信息的更新时间" prop="uTime">
          <el-input v-model="okexAccountAssetDetailForm.uTime" placeholder="请输入账户信息的更新时间" />
        </el-form-item>
        <el-form-item label="币种" prop="ccy">
          <el-input v-model="okexAccountAssetDetailForm.ccy" placeholder="请输入币种" />
        </el-form-item>
        <el-form-item label="币种总权益" prop="eq">
          <el-input v-model="okexAccountAssetDetailForm.eq" placeholder="请输入币种总权益" />
        </el-form-item>
        <el-form-item label="币种逐仓仓位权益" prop="isoEq">
          <el-input v-model="okexAccountAssetDetailForm.isoEq" placeholder="请输入币种逐仓仓位权益" />
        </el-form-item>
        <el-form-item label="可用保证金" prop="availEq">
          <el-input v-model="okexAccountAssetDetailForm.availEq" placeholder="请输入可用保证金" />
        </el-form-item>
        <el-form-item label="美金层面币种折算权益" prop="disEq">
          <el-input v-model="okexAccountAssetDetailForm.disEq" placeholder="请输入美金层面币种折算权益" />
        </el-form-item>
        <el-form-item label="可用余额" prop="availBal">
          <el-input v-model="okexAccountAssetDetailForm.availBal" placeholder="请输入可用余额" />
        </el-form-item>
        <el-form-item label="币种占用金额" prop="frozenBal">
          <el-input v-model="okexAccountAssetDetailForm.frozenBal" placeholder="请输入币种占用金额" />
        </el-form-item>
        <el-form-item label="挂单冻结数量" prop="ordFrozen">
          <el-input v-model="okexAccountAssetDetailForm.ordFrozen" placeholder="请输入挂单冻结数量" />
        </el-form-item>
        <el-form-item label="币种负债额" prop="liab">
          <el-input v-model="okexAccountAssetDetailForm.liab" placeholder="请输入币种负债额" />
        </el-form-item>
        <el-form-item label="未实现盈亏" prop="upl">
          <el-input v-model="okexAccountAssetDetailForm.upl" placeholder="请输入未实现盈亏" />
        </el-form-item>
        <el-form-item label="由于仓位未实现亏损导致的负债" prop="uplLiab">
          <el-input v-model="okexAccountAssetDetailForm.uplLiab" placeholder="请输入由于仓位未实现亏损导致的负债" />
        </el-form-item>
        <el-form-item label="币种全仓负债额" prop="crossLiab">
          <el-input v-model="okexAccountAssetDetailForm.crossLiab" placeholder="请输入币种全仓负债额" />
        </el-form-item>
        <el-form-item label="币种逐仓负债额" prop="isoLiab">
          <el-input v-model="okexAccountAssetDetailForm.isoLiab" placeholder="请输入币种逐仓负债额" />
        </el-form-item>
        <el-form-item label="保证金率" prop="mgnRatio">
          <el-input v-model="okexAccountAssetDetailForm.mgnRatio" placeholder="请输入保证金率" />
        </el-form-item>
        <el-form-item label="计息" prop="interest">
          <el-input v-model="okexAccountAssetDetailForm.interest" placeholder="请输入计息" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountAssetDetailForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountAssetDetailName',
  data() {
    return {
      okexAccountAssetDetailLoading: true,
      okexAccountAssetDetailDialog: false,
      okexAccountAssetDetailData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountAssetDetailForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'uTime': '',
        'ccy': '',
        'eq': '',
        'isoEq': '',
        'availEq': '',
        'disEq': '',
        'availBal': '',
        'frozenBal': '',
        'ordFrozen': '',
        'liab': '',
        'upl': '',
        'uplLiab': '',
        'crossLiab': '',
        'isoLiab': '',
        'mgnRatio': '',
        'interest': ''
      },
      searchForm: {
        'accountId': '',
        'apiKey': '',
        'uTime': '',
        'ccy': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountAssetDetailRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        uTime: [
          { required: true, message: '账户信息的更新时间不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '币种不可为空', trigger: 'change' }
        ],
        eq: [
          { required: true, message: '币种总权益不可为空', trigger: 'change' }
        ],
        isoEq: [
          { required: true, message: '币种逐仓仓位权益不可为空', trigger: 'change' }
        ],
        availEq: [
          { required: true, message: '可用保证金不可为空', trigger: 'change' }
        ],
        disEq: [
          { required: true, message: '美金层面币种折算权益不可为空', trigger: 'change' }
        ],
        availBal: [
          { required: true, message: '可用余额不可为空', trigger: 'change' }
        ],
        frozenBal: [
          { required: true, message: '币种占用金额不可为空', trigger: 'change' }
        ],
        ordFrozen: [
          { required: true, message: '挂单冻结数量不可为空', trigger: 'change' }
        ],
        liab: [
          { required: true, message: '币种负债额不可为空', trigger: 'change' }
        ],
        upl: [
          { required: true, message: '未实现盈亏不可为空', trigger: 'change' }
        ],
        uplLiab: [
          { required: true, message: '由于仓位未实现亏损导致的负债不可为空', trigger: 'change' }
        ],
        crossLiab: [
          { required: true, message: '币种全仓负债额不可为空', trigger: 'change' }
        ],
        isoLiab: [
          { required: true, message: '币种逐仓负债额不可为空', trigger: 'change' }
        ],
        mgnRatio: [
          { required: true, message: '保证金率不可为空', trigger: 'change' }
        ],
        interest: [
          { required: true, message: '计息不可为空', trigger: 'change' }
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
      if(this.dicts[p] === undefined){
        return ''
      }
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
        url: '/digitalcurrency/okex/dict/okexAccountAssetDetail',
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
      this.okexAccountAssetDetailLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAssetDetail/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetDetailData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountAssetDetailLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountAssetDetailForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'uTime': '',
        'ccy': '',
        'eq': '',
        'isoEq': '',
        'availEq': '',
        'disEq': '',
        'availBal': '',
        'frozenBal': '',
        'ordFrozen': '',
        'liab': '',
        'upl': '',
        'uplLiab': '',
        'crossLiab': '',
        'isoLiab': '',
        'mgnRatio': '',
        'interest': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountAssetDetailDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountAssetDetailForm) {
        this.$refs.okexAccountAssetDetailForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAssetDetail/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetDetailForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'uTime': res.object.uTime,
            'ccy': res.object.ccy,
            'eq': res.object.eq,
            'isoEq': res.object.isoEq,
            'availEq': res.object.availEq,
            'disEq': res.object.disEq,
            'availBal': res.object.availBal,
            'frozenBal': res.object.frozenBal,
            'ordFrozen': res.object.ordFrozen,
            'liab': res.object.liab,
            'upl': res.object.upl,
            'uplLiab': res.object.uplLiab,
            'crossLiab': res.object.crossLiab,
            'isoLiab': res.object.isoLiab,
            'mgnRatio': res.object.mgnRatio,
            'interest': res.object.interest
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountAssetDetailDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountAssetDetail/save',
            method: 'post',
            data: this.okexAccountAssetDetailForm
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
          this.okexAccountAssetDetailDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountAssetDetail/del',
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
  .okexAccountAssetDetailForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
