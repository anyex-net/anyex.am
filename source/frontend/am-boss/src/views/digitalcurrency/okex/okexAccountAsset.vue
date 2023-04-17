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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountAssetLoading"
      :data="okexAccountAssetData"
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
      <el-table-column prop="totalEq" label="美金层面权益" />
      <el-table-column prop="isoEq" label="美金层面逐仓仓位权益" />
      <el-table-column prop="adjEq" label="美金层面有效保证金" />
      <el-table-column prop="imr" label="美金层面占用保证金" />
      <el-table-column prop="mmr" label="美金层面维持保证金" />
      <el-table-column prop="mgnRatio" label="美金层面保证金率" />
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
    <el-dialog title="账户余额汇总管理" :visible.sync="okexAccountAssetDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountAssetForm"
        :model="okexAccountAssetForm"
        :rules="okexAccountAssetRules"
        label-width="150px"
        class="okexAccountAssetForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountAssetForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountAssetForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountAssetForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="账户信息的更新时间" prop="uTime">
          <el-input v-model="okexAccountAssetForm.uTime" placeholder="请输入账户信息的更新时间" />
        </el-form-item>
        <el-form-item label="美金层面权益" prop="totalEq">
          <el-input v-model="okexAccountAssetForm.totalEq" placeholder="请输入美金层面权益" />
        </el-form-item>
        <el-form-item label="美金层面逐仓仓位权益" prop="isoEq">
          <el-input v-model="okexAccountAssetForm.isoEq" placeholder="请输入美金层面逐仓仓位权益" />
        </el-form-item>
        <el-form-item label="美金层面有效保证金" prop="adjEq">
          <el-input v-model="okexAccountAssetForm.adjEq" placeholder="请输入美金层面有效保证金" />
        </el-form-item>
        <el-form-item label="美金层面占用保证金" prop="imr">
          <el-input v-model="okexAccountAssetForm.imr" placeholder="请输入美金层面占用保证金" />
        </el-form-item>
        <el-form-item label="美金层面维持保证金" prop="mmr">
          <el-input v-model="okexAccountAssetForm.mmr" placeholder="请输入美金层面维持保证金" />
        </el-form-item>
        <el-form-item label="美金层面保证金率" prop="mgnRatio">
          <el-input v-model="okexAccountAssetForm.mgnRatio" placeholder="请输入美金层面保证金率" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountAssetForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountAssetName',
  data() {
    return {
      okexAccountAssetLoading: true,
      okexAccountAssetDialog: false,
      okexAccountAssetData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountAssetForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'uTime': '',
        'totalEq': '',
        'isoEq': '',
        'adjEq': '',
        'imr': '',
        'mmr': '',
        'mgnRatio': ''
      },
      searchForm: {
        'accountId': '',
        'apiKey': '',
        'uTime': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountAssetRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        uTime: [
          { required: true, message: '账户信息的更新时间不可为空', trigger: 'change' }
        ],
        totalEq: [
          { required: true, message: '美金层面权益不可为空', trigger: 'change' }
        ],
        isoEq: [
          { required: true, message: '美金层面逐仓仓位权益不可为空', trigger: 'change' }
        ],
        adjEq: [
          { required: true, message: '美金层面有效保证金不可为空', trigger: 'change' }
        ],
        imr: [
          { required: true, message: '美金层面占用保证金不可为空', trigger: 'change' }
        ],
        mmr: [
          { required: true, message: '美金层面维持保证金不可为空', trigger: 'change' }
        ],
        mgnRatio: [
          { required: true, message: '美金层面保证金率不可为空', trigger: 'change' }
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
        url: '/digitalcurrency/okex/dict/okexAccountAsset',
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
      this.okexAccountAssetLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAsset/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountAssetLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountAssetForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'uTime': '',
        'totalEq': '',
        'isoEq': '',
        'adjEq': '',
        'imr': '',
        'mmr': '',
        'mgnRatio': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountAssetDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountAssetForm) {
        this.$refs.okexAccountAssetForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAsset/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'uTime': res.object.uTime,
            'totalEq': res.object.totalEq,
            'isoEq': res.object.isoEq,
            'adjEq': res.object.adjEq,
            'imr': res.object.imr,
            'mmr': res.object.mmr,
            'mgnRatio': res.object.mgnRatio
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountAssetDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountAsset/save',
            method: 'post',
            data: this.okexAccountAssetForm
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
          this.okexAccountAssetDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountAsset/del',
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
  .okexAccountAssetForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
