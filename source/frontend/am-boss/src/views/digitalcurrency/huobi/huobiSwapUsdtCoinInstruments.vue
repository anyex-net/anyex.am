<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="品种代码">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入品种代码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="合约类型">
        <el-input v-model="searchForm.contractType" clearable placeholder="请输入合约类型"></el-input>
      </el-form-item>
      <el-form-item label="合约状态">
        <el-input v-model="searchForm.contractStatus" clearable placeholder="请输入合约状态"></el-input>
      </el-form-item>
      <el-form-item label="合约支持的保证金模式">
        <el-input v-model="searchForm.supportMarginMode" clearable placeholder="请输入合约支持的保证金模式"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapUsdtCoinInstrumentsLoading" :data="huobiSwapUsdtCoinInstrumentsData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="contractType" label="合约类型"/>
      <el-table-column prop="contractSize" label="合约面值"/>
      <el-table-column prop="priceTick" label="合约价格最小变动精度"/>
      <el-table-column prop="deliveryDate" label="合约永续(U)日期" :formatter="dateFormat"/>
      <el-table-column prop="createDate" label="合约上市日期" :formatter="dateFormat"/>
      <el-table-column prop="settlementTime" label="下次结算时间" :formatter="dateFormat"/>
      <el-table-column prop="deliveryTime" label="永续(U)时间" :formatter="dateFormat"/>
      <el-table-column prop="contractStatus" label="合约状态"/>
      <el-table-column prop="supportMarginMode" label="合约支持的保证金模式"/>
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
    <el-dialog title="现货交易对管理" :visible.sync="huobiSwapUsdtCoinInstrumentsDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapUsdtCoinInstrumentsForm" :model="huobiSwapUsdtCoinInstrumentsForm"
               :rules="huobiSwapUsdtCoinInstrumentsRules" label-width="150px" class="huobiSwapUsdtCoinInstrumentsForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="合约类型" prop="contractType">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.contractType" placeholder="请输入合约类型"/>
        </el-form-item>
        <el-form-item label="合约面值" prop="contractSize">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.contractSize" placeholder="请输入合约面值"/>
        </el-form-item>
        <el-form-item label="合约价格最小变动精度" prop="priceTick">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.priceTick" placeholder="请输入合约价格最小变动精度"/>
        </el-form-item>
        <el-form-item label="合约永续(U)日期" prop="deliveryDate">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.deliveryDate" placeholder="请输入合约永续(U)日期"/>
        </el-form-item>
        <el-form-item label="合约上市日期" prop="createDate">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.createDate" placeholder="请输入合约上市日期"/>
        </el-form-item>
        <el-form-item label="下次结算时间" prop="settlementTime">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.settlementTime" placeholder="请输入下次结算时间"/>
        </el-form-item>
        <el-form-item label="永续(U)时间" prop="deliveryTime">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.deliveryTime" placeholder="请输入永续(U)时间"/>
        </el-form-item>
        <el-form-item label="合约状态" prop="contractStatus">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.contractStatus" placeholder="请输入合约状态"/>
        </el-form-item>
        <el-form-item label="合约支持的保证金模式" prop="supportMarginMode">
          <el-input v-model="huobiSwapUsdtCoinInstrumentsForm.supportMarginMode" placeholder="请输入合约支持的保证金模式"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapUsdtCoinInstrumentsForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapUsdtCoinInstrumentsName',
    data() {
      return {
        huobiSwapUsdtCoinInstrumentsLoading: true,
        huobiSwapUsdtCoinInstrumentsDialog: false,
        huobiSwapUsdtCoinInstrumentsData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapUsdtCoinInstrumentsForm: {
          'id': '',
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'contractSize': '',
          'priceTick': '',
          'deliveryDate': '',
          'createDate': '',
          'settlementTime': '',
          'deliveryTime': '',
          'contractStatus': '',
          'supportMarginMode': ''
        },
        searchForm: {
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'contractStatus': '',
          'supportMarginMode': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapUsdtCoinInstrumentsRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSwapUsdtCoinInstruments',
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
        this.huobiSwapUsdtCoinInstrumentsLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCoinInstruments/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCoinInstrumentsData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapUsdtCoinInstrumentsLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapUsdtCoinInstrumentsForm = {
          'id': '',
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'contractSize': '',
          'priceTick': '',
          'deliveryDate': '',
          'createDate': '',
          'settlementTime': '',
          'deliveryTime': '',
          'contractStatus': '',
          'supportMarginMode': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapUsdtCoinInstrumentsDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapUsdtCoinInstrumentsForm) {
          this.$refs.huobiSwapUsdtCoinInstrumentsForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtCoinInstruments/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtCoinInstrumentsForm = {
              'id': res.object.id,
              'symbol': res.object.symbol,
              'contractCode': res.object.contractCode,
              'contractType': res.object.contractType,
              'contractSize': res.object.contractSize,
              'priceTick': res.object.priceTick,
              'deliveryDate': res.object.deliveryDate,
              'createDate': res.object.createDate,
              'settlementTime': res.object.settlementTime,
              'deliveryTime': res.object.deliveryTime,
              'contractStatus': res.object.contractStatus,
              'supportMarginMode': res.object.supportMarginMode
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapUsdtCoinInstrumentsDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapUsdtCoinInstruments/save',
              method: 'post',
              data: this.huobiSwapUsdtCoinInstrumentsForm
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
            this.huobiSwapUsdtCoinInstrumentsDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapUsdtCoinInstruments/del',
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
  .huobiSwapUsdtCoinInstrumentsForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
