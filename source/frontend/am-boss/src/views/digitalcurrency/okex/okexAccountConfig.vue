<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="持仓方式">
        <el-select v-model="searchForm.posMode" clearable placeholder="请输入持仓方式">
          <el-option v-for="data in posModeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="是否自动借币">
        <el-input v-model="searchForm.autoLoan" clearable placeholder="请输入是否自动借币"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountConfigLoading"
      :data="okexAccountConfigData"
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
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="uid" label="账户ID"/>
      <el-table-column prop="acctLv" label="账户层级" :formatter="statusFormat"/>
      <el-table-column prop="posMode" label="持仓方式" :formatter="statusFormat"/>
      <el-table-column prop="autoLoan" label="是否自动借币"/>
      <el-table-column prop="greeksType" label="展示方式" :formatter="statusFormat"/>
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
    <el-dialog title="账户配置管理" :visible.sync="okexAccountConfigDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountConfigForm"
        :model="okexAccountConfigForm"
        :rules="okexAccountConfigRules"
        label-width="150px"
        class="okexAccountConfigForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountConfigForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountConfigForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountConfigForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户ID" prop="uid">
          <el-input v-model="okexAccountConfigForm.uid" placeholder="请输入账户ID"/>
        </el-form-item>
        <el-form-item label="账户层级" prop="acctLv">
          <el-input v-model="okexAccountConfigForm.acctLv" placeholder="请输入账户层级"/>
        </el-form-item>
        <el-form-item label="持仓方式" prop="posMode">
          <el-input v-model="okexAccountConfigForm.posMode" placeholder="请输入持仓方式"/>
        </el-form-item>
        <el-form-item label="是否自动借币" prop="autoLoan">
          <el-input v-model="okexAccountConfigForm.autoLoan" placeholder="请输入是否自动借币"/>
        </el-form-item>
        <el-form-item label="展示方式" prop="greeksType">
          <el-input v-model="okexAccountConfigForm.greeksType" placeholder="请输入展示方式"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountConfigForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexAccountConfigName',
    data() {
      return {
        okexAccountConfigLoading: true,
        okexAccountConfigDialog: false,
        okexAccountConfigData: [],
        commodityTypeSelects: [],
        dicts: [],
        posModeList: [],
        okexAccountConfigForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'uid': '',
          'acctLv': '',
          'posMode': '',
          'autoLoan': '',
          'greeksType': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'acctLv': '',
          'posMode': '',
          'autoLoan': '',
          'greeksType': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexAccountConfigRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
          ],
          uid: [
            { required: true, message: '账户ID不可为空', trigger: 'change' }
          ],
          acctLv: [
            { required: true, message: '账户层级不可为空', trigger: 'change' }
          ],
          posMode: [
            { required: true, message: '持仓方式不可为空', trigger: 'change' }
          ],
          autoLoan: [
            { required: true, message: '是否自动借币不可为空', trigger: 'change' }
          ],
          greeksType: [
            { required: true, message: '展示方式不可为空', trigger: 'change' }
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
          url: '/digitalcurrency/okex/dict/okexAccountConfig',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.posModeList = res.object.list.posMode.list
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
        this.okexAccountConfigLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexAccountConfig/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountConfigData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexAccountConfigLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexAccountConfigForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'uid': '',
          'acctLv': '',
          'posMode': '',
          'autoLoan': '',
          'greeksType': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexAccountConfigDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexAccountConfigForm) {
          this.$refs.okexAccountConfigForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexAccountConfig/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountConfigForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'uid': res.object.uid,
              'acctLv': res.object.acctLv,
              'posMode': res.object.posMode,
              'autoLoan': res.object.autoLoan,
              'greeksType': res.object.greeksType
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexAccountConfigDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexAccountConfig/save',
              method: 'post',
              data: this.okexAccountConfigForm
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
            this.okexAccountConfigDialog = false;
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
            url: '/digitalcurrency/okex/okexAccountConfig/del',
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
  .okexAccountConfigForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
