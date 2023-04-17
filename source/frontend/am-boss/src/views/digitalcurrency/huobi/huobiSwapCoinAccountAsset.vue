<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="品种代码">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入品种代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapCoinAccountAssetLoading" :data="huobiSwapCoinAccountAssetData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="marginBalance" label="账户权益"/>
      <el-table-column prop="marginPosition" label="持仓保证金"/>
      <el-table-column prop="marginFrozen" label="冻结保证金"/>
      <el-table-column prop="marginAvailable" label="可用保证金"/>
      <el-table-column prop="profitReal" label="已实现盈亏"/>
      <el-table-column prop="profitUnreal" label="未实现盈亏"/>
      <el-table-column prop="riskRate" label="保证金率"/>
      <el-table-column prop="liquidationPrice" label="预估强平价"/>
      <el-table-column prop="withdrawAvailable" label="可划转数量"/>
      <el-table-column prop="leverRate" label="杠杠倍数"/>
      <el-table-column prop="adjustFactor" label="调整系数"/>
      <el-table-column prop="marginStatic" label="静态权益"/>
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
    <el-dialog title="永续合约账户信息管理" :visible.sync="huobiSwapCoinAccountAssetDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapCoinAccountAssetForm" :model="huobiSwapCoinAccountAssetForm"
               :rules="huobiSwapCoinAccountAssetRules" label-width="150px" class="huobiSwapCoinAccountAssetForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapCoinAccountAssetForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapCoinAccountAssetForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapCoinAccountAssetForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapCoinAccountAssetForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="账户权益" prop="marginBalance">
          <el-input v-model="huobiSwapCoinAccountAssetForm.marginBalance" placeholder="请输入账户权益"/>
        </el-form-item>
        <el-form-item label="持仓保证金" prop="marginPosition">
          <el-input v-model="huobiSwapCoinAccountAssetForm.marginPosition" placeholder="请输入持仓保证金"/>
        </el-form-item>
        <el-form-item label="冻结保证金" prop="marginFrozen">
          <el-input v-model="huobiSwapCoinAccountAssetForm.marginFrozen" placeholder="请输入冻结保证金"/>
        </el-form-item>
        <el-form-item label="可用保证金" prop="marginAvailable">
          <el-input v-model="huobiSwapCoinAccountAssetForm.marginAvailable" placeholder="请输入可用保证金"/>
        </el-form-item>
        <el-form-item label="已实现盈亏" prop="profitReal">
          <el-input v-model="huobiSwapCoinAccountAssetForm.profitReal" placeholder="请输入已实现盈亏"/>
        </el-form-item>
        <el-form-item label="未实现盈亏" prop="profitUnreal">
          <el-input v-model="huobiSwapCoinAccountAssetForm.profitUnreal" placeholder="请输入未实现盈亏"/>
        </el-form-item>
        <el-form-item label="保证金率" prop="riskRate">
          <el-input v-model="huobiSwapCoinAccountAssetForm.riskRate" placeholder="请输入保证金率"/>
        </el-form-item>
        <el-form-item label="预估强平价" prop="liquidationPrice">
          <el-input v-model="huobiSwapCoinAccountAssetForm.liquidationPrice" placeholder="请输入预估强平价"/>
        </el-form-item>
        <el-form-item label="可划转数量" prop="withdrawAvailable">
          <el-input v-model="huobiSwapCoinAccountAssetForm.withdrawAvailable" placeholder="请输入可划转数量"/>
        </el-form-item>
        <el-form-item label="杠杠倍数" prop="leverRate">
          <el-input v-model="huobiSwapCoinAccountAssetForm.leverRate" placeholder="请输入杠杠倍数"/>
        </el-form-item>
        <el-form-item label="调整系数" prop="adjustFactor">
          <el-input v-model="huobiSwapCoinAccountAssetForm.adjustFactor" placeholder="请输入调整系数"/>
        </el-form-item>
        <el-form-item label="静态权益" prop="marginStatic">
          <el-input v-model="huobiSwapCoinAccountAssetForm.marginStatic" placeholder="请输入静态权益"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapCoinAccountAssetForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapCoinAccountAssetName',
    data() {
      return {
        huobiSwapCoinAccountAssetLoading: true,
        huobiSwapCoinAccountAssetDialog: false,
        huobiSwapCoinAccountAssetData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapCoinAccountAssetForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'marginBalance': '',
          'marginPosition': '',
          'marginFrozen': '',
          'marginAvailable': '',
          'profitReal': '',
          'profitUnreal': '',
          'riskRate': '',
          'liquidationPrice': '',
          'withdrawAvailable': '',
          'leverRate': '',
          'adjustFactor': '',
          'marginStatic': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapCoinAccountAssetRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapCoinAccountAsset',
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
        this.huobiSwapCoinAccountAssetLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinAccountAsset/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinAccountAssetData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapCoinAccountAssetLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapCoinAccountAssetForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'marginBalance': '',
          'marginPosition': '',
          'marginFrozen': '',
          'marginAvailable': '',
          'profitReal': '',
          'profitUnreal': '',
          'riskRate': '',
          'liquidationPrice': '',
          'withdrawAvailable': '',
          'leverRate': '',
          'adjustFactor': '',
          'marginStatic': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapCoinAccountAssetDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapCoinAccountAssetForm) {
          this.$refs.huobiSwapCoinAccountAssetForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinAccountAsset/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinAccountAssetForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'marginBalance': res.object.marginBalance,
              'marginPosition': res.object.marginPosition,
              'marginFrozen': res.object.marginFrozen,
              'marginAvailable': res.object.marginAvailable,
              'profitReal': res.object.profitReal,
              'profitUnreal': res.object.profitUnreal,
              'riskRate': res.object.riskRate,
              'liquidationPrice': res.object.liquidationPrice,
              'withdrawAvailable': res.object.withdrawAvailable,
              'leverRate': res.object.leverRate,
              'adjustFactor': res.object.adjustFactor,
              'marginStatic': res.object.marginStatic
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapCoinAccountAssetDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapCoinAccountAsset/save',
              method: 'post',
              data: this.huobiSwapCoinAccountAssetForm
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
            this.huobiSwapCoinAccountAssetDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapCoinAccountAsset/del',
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
  .huobiSwapCoinAccountAssetForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
