<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="保证金模式">
        <el-input v-model="searchForm.marginMode" clearable placeholder="请输入保证金模式"></el-input>
      </el-form-item>
      <el-form-item label="保证金账户">
        <el-input v-model="searchForm.marginAccount" clearable placeholder="请输入保证金账户"></el-input>
      </el-form-item>
      <el-form-item label="保证金币种">
        <el-input v-model="searchForm.marginAsset" clearable placeholder="请输入保证金币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapUsdtCrossAccountAssetLoading" :data="huobiSwapUsdtCrossAccountAssetData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="marginMode" label="保证金模式"/>
      <el-table-column prop="marginAccount" label="保证金账户"/>
      <el-table-column prop="marginAsset" label="保证金币种"/>
      <el-table-column prop="marginBalance" label="账户权益"/>
      <el-table-column prop="marginStatic" label="静态权益"/>
      <el-table-column prop="marginPosition" label="持仓保证金"/>
      <el-table-column prop="marginFrozen" label="冻结保证金"/>
      <el-table-column prop="profitReal" label="已实现盈亏"/>
      <el-table-column prop="profitUnreal" label="未实现盈亏"/>
      <el-table-column prop="withdrawAvailable" label="可划转数量"/>
      <el-table-column prop="riskRate" label="保证金率"/>
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
    <el-dialog title="永续(U)合约全仓账户信息管理" :visible.sync="huobiSwapUsdtCrossAccountAssetDialog"
               :close-on-click-modal="false" width="600">
      <el-form ref="huobiSwapUsdtCrossAccountAssetForm" :model="huobiSwapUsdtCrossAccountAssetForm"
               :rules="huobiSwapUsdtCrossAccountAssetRules" label-width="150px"
               class="huobiSwapUsdtCrossAccountAssetForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="保证金模式" prop="marginMode">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginMode" placeholder="请输入保证金模式"/>
        </el-form-item>
        <el-form-item label="保证金账户" prop="marginAccount">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginAccount" placeholder="请输入保证金账户"/>
        </el-form-item>
        <el-form-item label="保证金币种" prop="marginAsset">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginAsset" placeholder="请输入保证金币种"/>
        </el-form-item>
        <el-form-item label="账户权益" prop="marginBalance">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginBalance" placeholder="请输入账户权益"/>
        </el-form-item>
        <el-form-item label="静态权益" prop="marginStatic">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginStatic" placeholder="请输入静态权益"/>
        </el-form-item>
        <el-form-item label="持仓保证金" prop="marginPosition">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginPosition" placeholder="请输入持仓保证金"/>
        </el-form-item>
        <el-form-item label="冻结保证金" prop="marginFrozen">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.marginFrozen" placeholder="请输入冻结保证金"/>
        </el-form-item>
        <el-form-item label="已实现盈亏" prop="profitReal">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.profitReal" placeholder="请输入已实现盈亏"/>
        </el-form-item>
        <el-form-item label="未实现盈亏" prop="profitUnreal">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.profitUnreal" placeholder="请输入未实现盈亏"/>
        </el-form-item>
        <el-form-item label="可划转数量" prop="withdrawAvailable">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.withdrawAvailable" placeholder="请输入可划转数量"/>
        </el-form-item>
        <el-form-item label="保证金率" prop="riskRate">
          <el-input v-model="huobiSwapUsdtCrossAccountAssetForm.riskRate" placeholder="请输入保证金率"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapUsdtCrossAccountAssetForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapUsdtCrossAccountAssetName',
    data() {
      return {
        huobiSwapUsdtCrossAccountAssetLoading: true,
        huobiSwapUsdtCrossAccountAssetDialog: false,
        huobiSwapUsdtCrossAccountAssetData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapUsdtCrossAccountAssetForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'marginMode': '',
          'marginAccount': '',
          'marginAsset': '',
          'marginBalance': '',
          'marginStatic': '',
          'marginPosition': '',
          'marginFrozen': '',
          'profitReal': '',
          'profitUnreal': '',
          'withdrawAvailable': '',
          'riskRate': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'marginMode': '',
          'marginAccount': '',
          'marginAsset': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapUsdtCrossAccountAssetRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapUsdtCrossAccountAsset',
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
        this.huobiSwapUsdtCrossAccountAssetLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAsset/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCrossAccountAssetData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapUsdtCrossAccountAssetLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapUsdtCrossAccountAssetForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'marginMode': '',
          'marginAccount': '',
          'marginAsset': '',
          'marginBalance': '',
          'marginStatic': '',
          'marginPosition': '',
          'marginFrozen': '',
          'profitReal': '',
          'profitUnreal': '',
          'withdrawAvailable': '',
          'riskRate': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapUsdtCrossAccountAssetDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapUsdtCrossAccountAssetForm) {
          this.$refs.huobiSwapUsdtCrossAccountAssetForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAsset/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCrossAccountAssetForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'marginMode': res.object.marginMode,
              'marginAccount': res.object.marginAccount,
              'marginAsset': res.object.marginAsset,
              'marginBalance': res.object.marginBalance,
              'marginStatic': res.object.marginStatic,
              'marginPosition': res.object.marginPosition,
              'marginFrozen': res.object.marginFrozen,
              'profitReal': res.object.profitReal,
              'profitUnreal': res.object.profitUnreal,
              'withdrawAvailable': res.object.withdrawAvailable,
              'riskRate': res.object.riskRate
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapUsdtCrossAccountAssetDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAsset/save',
              method: 'post',
              data: this.huobiSwapUsdtCrossAccountAssetForm
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
            this.huobiSwapUsdtCrossAccountAssetDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAsset/del',
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
  .huobiSwapUsdtCrossAccountAssetForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
