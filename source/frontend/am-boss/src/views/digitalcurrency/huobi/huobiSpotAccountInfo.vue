<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="account-id">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入account-id"></el-input>
      </el-form-item>
      <el-form-item label="账户状态">
        <el-input v-model="searchForm.state" clearable placeholder="请输入账户状态"></el-input>
      </el-form-item>
      <el-form-item label="账户类型">
        <el-input v-model="searchForm.type" clearable placeholder="请输入账户类型"></el-input>
      </el-form-item>
      <el-form-item label="子账户类型">
        <el-input v-model="searchForm.subtype" clearable placeholder="请输入子账户类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountInfoLoading" :data="huobiSpotAccountInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="account-id"/>
      <el-table-column prop="state" label="账户状态"/>
      <el-table-column prop="type" label="账户类型"/>
      <el-table-column prop="subtype" label="子账户类型"/>
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
    <el-dialog title="现货账户信息管理" :visible.sync="huobiSpotAccountInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiSpotAccountInfoForm" :model="huobiSpotAccountInfoForm" :rules="huobiSpotAccountInfoRules"
               label-width="150px" class="huobiSpotAccountInfoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountInfoForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountInfoForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountInfoForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="account-id" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountInfoForm.huobiAccountId" placeholder="请输入account-id"/>
        </el-form-item>
        <el-form-item label="账户状态" prop="state">
          <el-input v-model="huobiSpotAccountInfoForm.state" placeholder="请输入账户状态"/>
        </el-form-item>
        <el-form-item label="账户类型" prop="type">
          <el-input v-model="huobiSpotAccountInfoForm.type" placeholder="请输入账户类型"/>
        </el-form-item>
        <el-form-item label="子账户类型" prop="subtype">
          <el-input v-model="huobiSpotAccountInfoForm.subtype" placeholder="请输入子账户类型"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountInfoName',
    data() {
      return {
        huobiSpotAccountInfoLoading: true,
        huobiSpotAccountInfoDialog: false,
        huobiSpotAccountInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountInfoForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'state': '',
          'type': '',
          'subtype': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'state': '',
          'type': '',
          'subtype': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountInfoRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountInfo',
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
        this.huobiSpotAccountInfoLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountInfoForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'state': '',
          'type': '',
          'subtype': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountInfoForm) {
          this.$refs.huobiSpotAccountInfoForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'state': res.object.state,
              'type': res.object.type,
              'subtype': res.object.subtype
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountInfo/save',
              method: 'post',
              data: this.huobiSpotAccountInfoForm
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
            this.huobiSpotAccountInfoDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountInfo/del',
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
  .huobiSpotAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
