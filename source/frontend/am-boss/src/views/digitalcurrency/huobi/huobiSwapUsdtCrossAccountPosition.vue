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
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="保证金模式">
        <el-input v-model="searchForm.marginMode" clearable placeholder="请输入保证金模式"></el-input>
      </el-form-item>
      <el-form-item label="保证金账户">
        <el-input v-model="searchForm.marginAccount" clearable placeholder="请输入保证金账户"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapUsdtCrossAccountPositionLoading" :data="huobiSwapUsdtCrossAccountPositionData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="marginMode" label="保证金模式"/>
      <el-table-column prop="marginAccount" label="保证金账户"/>
      <el-table-column prop="volume" label="持仓量（张）"/>
      <el-table-column prop="available" label="可平仓数量（张）"/>
      <el-table-column prop="frozen" label="冻结数量（张）"/>
      <el-table-column prop="costOpen" label="开仓均价"/>
      <el-table-column prop="costHold" label="持仓均价"/>
      <el-table-column prop="profitUnreal" label="未实现盈亏"/>
      <el-table-column prop="profitRate" label="收益率"/>
      <el-table-column prop="profit" label="收益"/>
      <el-table-column prop="marginAsset" label="保证金币种"/>
      <el-table-column prop="positionMargin" label="持仓保证金"/>
      <el-table-column prop="leverRate" label="杠杠倍数"/>
      <el-table-column prop="direction" label="买卖方向"/>
      <el-table-column prop="lastPrice" label="最新价"/>
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
    <el-dialog title="永续(U)合约账户全仓持仓信息管理" :visible.sync="huobiSwapUsdtCrossAccountPositionDialog"
               :close-on-click-modal="false" width="600">
      <el-form ref="huobiSwapUsdtCrossAccountPositionForm" :model="huobiSwapUsdtCrossAccountPositionForm"
               :rules="huobiSwapUsdtCrossAccountPositionRules" label-width="150px"
               class="huobiSwapUsdtCrossAccountPositionForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="保证金模式" prop="marginMode">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.marginMode" placeholder="请输入保证金模式"/>
        </el-form-item>
        <el-form-item label="保证金账户" prop="marginAccount">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.marginAccount" placeholder="请输入保证金账户"/>
        </el-form-item>
        <el-form-item label="持仓量（张）" prop="volume">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.volume" placeholder="请输入持仓量（张）"/>
        </el-form-item>
        <el-form-item label="可平仓数量（张）" prop="available">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.available" placeholder="请输入可平仓数量（张）"/>
        </el-form-item>
        <el-form-item label="冻结数量（张）" prop="frozen">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.frozen" placeholder="请输入冻结数量（张）"/>
        </el-form-item>
        <el-form-item label="开仓均价" prop="costOpen">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.costOpen" placeholder="请输入开仓均价"/>
        </el-form-item>
        <el-form-item label="持仓均价" prop="costHold">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.costHold" placeholder="请输入持仓均价"/>
        </el-form-item>
        <el-form-item label="未实现盈亏" prop="profitUnreal">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.profitUnreal" placeholder="请输入未实现盈亏"/>
        </el-form-item>
        <el-form-item label="收益率" prop="profitRate">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.profitRate" placeholder="请输入收益率"/>
        </el-form-item>
        <el-form-item label="收益" prop="profit">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.profit" placeholder="请输入收益"/>
        </el-form-item>
        <el-form-item label="保证金币种" prop="marginAsset">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.marginAsset" placeholder="请输入保证金币种"/>
        </el-form-item>
        <el-form-item label="持仓保证金" prop="positionMargin">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.positionMargin" placeholder="请输入持仓保证金"/>
        </el-form-item>
        <el-form-item label="杠杠倍数" prop="leverRate">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.leverRate" placeholder="请输入杠杠倍数"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.direction" placeholder="请输入买卖方向"/>
        </el-form-item>
        <el-form-item label="最新价" prop="lastPrice">
          <el-input v-model="huobiSwapUsdtCrossAccountPositionForm.lastPrice" placeholder="请输入最新价"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapUsdtCrossAccountPositionForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapUsdtCrossAccountPositionName',
    data() {
      return {
        huobiSwapUsdtCrossAccountPositionLoading: true,
        huobiSwapUsdtCrossAccountPositionDialog: false,
        huobiSwapUsdtCrossAccountPositionData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapUsdtCrossAccountPositionForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'marginMode': '',
          'marginAccount': '',
          'volume': '',
          'available': '',
          'frozen': '',
          'costOpen': '',
          'costHold': '',
          'profitUnreal': '',
          'profitRate': '',
          'profit': '',
          'marginAsset': '',
          'positionMargin': '',
          'leverRate': '',
          'direction': '',
          'lastPrice': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'marginMode': '',
          'marginAccount': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapUsdtCrossAccountPositionRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapUsdtCrossAccountPosition',
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
        this.huobiSwapUsdtCrossAccountPositionLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountPosition/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCrossAccountPositionData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapUsdtCrossAccountPositionLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapUsdtCrossAccountPositionForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'marginMode': '',
          'marginAccount': '',
          'volume': '',
          'available': '',
          'frozen': '',
          'costOpen': '',
          'costHold': '',
          'profitUnreal': '',
          'profitRate': '',
          'profit': '',
          'marginAsset': '',
          'positionMargin': '',
          'leverRate': '',
          'direction': '',
          'lastPrice': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapUsdtCrossAccountPositionDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapUsdtCrossAccountPositionForm) {
          this.$refs.huobiSwapUsdtCrossAccountPositionForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountPosition/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCrossAccountPositionForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'contractCode': res.object.contractCode,
              'marginMode': res.object.marginMode,
              'marginAccount': res.object.marginAccount,
              'volume': res.object.volume,
              'available': res.object.available,
              'frozen': res.object.frozen,
              'costOpen': res.object.costOpen,
              'costHold': res.object.costHold,
              'profitUnreal': res.object.profitUnreal,
              'profitRate': res.object.profitRate,
              'profit': res.object.profit,
              'marginAsset': res.object.marginAsset,
              'positionMargin': res.object.positionMargin,
              'leverRate': res.object.leverRate,
              'direction': res.object.direction,
              'lastPrice': res.object.lastPrice
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapUsdtCrossAccountPositionDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountPosition/save',
              method: 'post',
              data: this.huobiSwapUsdtCrossAccountPositionForm
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
            this.huobiSwapUsdtCrossAccountPositionDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapUsdtCrossAccountPosition/del',
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
  .huobiSwapUsdtCrossAccountPositionForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
