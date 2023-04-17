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
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item label="充币地址">
        <el-input v-model="searchForm.address" clearable placeholder="请输入充币地址"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiAccountDepositAddressLoading" :data="huobiAccountDepositAddressData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="address" label="充币地址"/>
      <el-table-column prop="addressTag" label="充币地址标签"/>
      <el-table-column prop="chain" label="链名称"/>
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
    <el-dialog title="现货充值地址管理" :visible.sync="huobiAccountDepositAddressDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiAccountDepositAddressForm" :model="huobiAccountDepositAddressForm"
               :rules="huobiAccountDepositAddressRules" label-width="150px" class="huobiAccountDepositAddressForm">
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiAccountDepositAddressForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiAccountDepositAddressForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiAccountDepositAddressForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="充币地址" prop="address">
          <el-input v-model="huobiAccountDepositAddressForm.address" placeholder="请输入充币地址"/>
        </el-form-item>
        <el-form-item label="充币地址标签" prop="addressTag">
          <el-input v-model="huobiAccountDepositAddressForm.addressTag" placeholder="请输入充币地址标签"/>
        </el-form-item>
        <el-form-item label="链名称" prop="chain">
          <el-input v-model="huobiAccountDepositAddressForm.chain" placeholder="请输入链名称"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiAccountDepositAddressForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiAccountDepositAddressName',
    data() {
      return {
        huobiAccountDepositAddressLoading: true,
        huobiAccountDepositAddressDialog: false,
        huobiAccountDepositAddressData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiAccountDepositAddressForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'currency': '',
          'address': '',
          'addressTag': '',
          'chain': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'currency': '',
          'address': '',
          'addressTag': '',
          'chain': '',
          'sort': 'id',
          'order': 'asc'
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiAccountDepositAddressRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiAccountDepositAddress',
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
        this.huobiAccountDepositAddressLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiAccountDepositAddress/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiAccountDepositAddressData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiAccountDepositAddressLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiAccountDepositAddressForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'currency': '',
          'address': '',
          'addressTag': '',
          'chain': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiAccountDepositAddressDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiAccountDepositAddressForm) {
          this.$refs.huobiAccountDepositAddressForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiAccountDepositAddress/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiAccountDepositAddressForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'currency': res.object.currency,
              'address': res.object.address,
              'addressTag': res.object.addressTag,
              'chain': res.object.chain
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiAccountDepositAddressDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiAccountDepositAddress/save',
              method: 'post',
              data: this.huobiAccountDepositAddressForm
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
            this.huobiAccountDepositAddressDialog = false;
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
            url: '/digitalcurrency/huobi/huobiAccountDepositAddress/del',
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
  .huobiAccountDepositAddressForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
