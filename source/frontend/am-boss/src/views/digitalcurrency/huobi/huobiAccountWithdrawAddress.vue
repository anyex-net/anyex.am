<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="链名称">
        <el-input v-model="searchForm.chain" clearable placeholder="请输入链名称"></el-input>
      </el-form-item>
      <el-form-item label="地址备注">
        <el-input v-model="searchForm.note" clearable placeholder="请输入地址备注"></el-input>
      </el-form-item>
      <el-form-item label="地址标签，如有">
        <el-input v-model="searchForm.addressTag" clearable placeholder="请输入地址标签，如有"></el-input>
      </el-form-item>
      <el-form-item label="地址">
        <el-input v-model="searchForm.address" clearable placeholder="请输入地址"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiAccountWithdrawAddressLoading" :data="huobiAccountWithdrawAddressData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="chain" label="链名称"/>
      <el-table-column prop="note" label="地址备注"/>
      <el-table-column prop="addressTag" label="地址标签，如有"/>
      <el-table-column prop="address" label="地址"/>
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
    <el-dialog title="现货提币地址管理" :visible.sync="huobiAccountWithdrawAddressDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiAccountWithdrawAddressForm" :model="huobiAccountWithdrawAddressForm"
               :rules="huobiAccountWithdrawAddressRules" label-width="150px" class="huobiAccountWithdrawAddressForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiAccountWithdrawAddressForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiAccountWithdrawAddressForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiAccountWithdrawAddressForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="链名称" prop="chain">
          <el-input v-model="huobiAccountWithdrawAddressForm.chain" placeholder="请输入链名称"/>
        </el-form-item>
        <el-form-item label="地址备注" prop="note">
          <el-input v-model="huobiAccountWithdrawAddressForm.note" placeholder="请输入地址备注"/>
        </el-form-item>
        <el-form-item label="地址标签，如有" prop="addressTag">
          <el-input v-model="huobiAccountWithdrawAddressForm.addressTag" placeholder="请输入地址标签，如有"/>
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="huobiAccountWithdrawAddressForm.address" placeholder="请输入地址"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiAccountWithdrawAddressForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiAccountWithdrawAddressName',
    data() {
      return {
        huobiAccountWithdrawAddressLoading: true,
        huobiAccountWithdrawAddressDialog: false,
        huobiAccountWithdrawAddressData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiAccountWithdrawAddressForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'chain': '',
          'note': '',
          'addressTag': '',
          'address': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'chain': '',
          'note': '',
          'addressTag': '',
          'address': ''
          ,
          'sort': 'id',
          'order': 'asc'
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiAccountWithdrawAddressRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiAccountWithdrawAddress',
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
        this.huobiAccountWithdrawAddressLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiAccountWithdrawAddress/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiAccountWithdrawAddressData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiAccountWithdrawAddressLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiAccountWithdrawAddressForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'chain': '',
          'note': '',
          'addressTag': '',
          'address': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiAccountWithdrawAddressDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiAccountWithdrawAddressForm) {
          this.$refs.huobiAccountWithdrawAddressForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiAccountWithdrawAddress/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiAccountWithdrawAddressForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'chain': res.object.chain,
              'note': res.object.note,
              'addressTag': res.object.addressTag,
              'address': res.object.address
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiAccountWithdrawAddressDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiAccountWithdrawAddress/save',
              method: 'post',
              data: this.huobiAccountWithdrawAddressForm
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
            this.huobiAccountWithdrawAddressDialog = false;
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
            url: '/digitalcurrency/huobi/huobiAccountWithdrawAddress/del',
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
  .huobiAccountWithdrawAddressForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
