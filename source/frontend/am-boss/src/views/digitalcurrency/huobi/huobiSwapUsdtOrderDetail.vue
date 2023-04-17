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
      <el-form-item label="订单来源">
        <el-input v-model="searchForm.orderSource" clearable placeholder="请输入订单来源"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-input v-model="searchForm.direction" clearable placeholder="请输入买卖方向"></el-input>
      </el-form-item>
      <el-form-item label="开平方向">
        <el-input v-model="searchForm.offset" clearable placeholder="请输入开平方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapUsdtOrderDetailLoading" :data="huobiSwapUsdtOrderDetailData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="detailId" label="全局唯一的交易标识"/>
      <el-table-column prop="matchId" label="撮合结果id"/>
      <el-table-column prop="orderId" label="订单ID"/>
      <el-table-column prop="orderIdStr" label="订单ID"/>
      <el-table-column prop="symbol" label="品种代码"/>
      <el-table-column prop="orderSource" label="订单来源"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="direction" label="买卖方向"/>
      <el-table-column prop="offset" label="开平方向"/>
      <el-table-column prop="tradeVolume" label="成交数量"/>
      <el-table-column prop="tradePrice" label="成交价格"/>
      <el-table-column prop="tradeTurnover" label="成交金额"/>
      <el-table-column prop="createDate" label="成交时间" :formatter="dateFormat"/>
      <el-table-column prop="offsetProfitloss" label="平仓盈亏"/>
      <el-table-column prop="tradeFee" label="成交手续费"/>
      <el-table-column prop="role" label="taker或maker"/>
      <el-table-column prop="feeAsset" label="手续费币种"/>
      <el-table-column prop="marginMode" label="保证金模式"/>
      <el-table-column prop="marginAccount" label="保证金账户"/>
      <el-table-column prop="realProfit" label="真实收益"/>
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
    <el-dialog title="永续(U)合约账户成交明细管理" :visible.sync="huobiSwapUsdtOrderDetailDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapUsdtOrderDetailForm" :model="huobiSwapUsdtOrderDetailForm"
               :rules="huobiSwapUsdtOrderDetailRules" label-width="150px" class="huobiSwapUsdtOrderDetailForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="全局唯一的交易标识" prop="detailId">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.detailId" placeholder="请输入全局唯一的交易标识"/>
        </el-form-item>
        <el-form-item label="撮合结果id" prop="matchId">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.matchId" placeholder="请输入撮合结果id"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderId">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.orderId" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderIdStr">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.orderIdStr" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="品种代码" prop="symbol">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.symbol" placeholder="请输入品种代码"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="orderSource">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.orderSource" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.direction" placeholder="请输入买卖方向"/>
        </el-form-item>
        <el-form-item label="开平方向" prop="offset">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.offset" placeholder="请输入开平方向"/>
        </el-form-item>
        <el-form-item label="成交数量" prop="tradeVolume">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.tradeVolume" placeholder="请输入成交数量"/>
        </el-form-item>
        <el-form-item label="成交价格" prop="tradePrice">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.tradePrice" placeholder="请输入成交价格"/>
        </el-form-item>
        <el-form-item label="成交金额" prop="tradeTurnover">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.tradeTurnover" placeholder="请输入成交金额"/>
        </el-form-item>
        <el-form-item label="成交时间" prop="createDate">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.createDate" placeholder="请输入成交时间"/>
        </el-form-item>
        <el-form-item label="平仓盈亏" prop="offsetProfitloss">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.offsetProfitloss" placeholder="请输入平仓盈亏"/>
        </el-form-item>
        <el-form-item label="成交手续费" prop="tradeFee">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.tradeFee" placeholder="请输入成交手续费"/>
        </el-form-item>
        <el-form-item label="taker或maker" prop="role">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.role" placeholder="请输入taker或maker"/>
        </el-form-item>
        <el-form-item label="手续费币种" prop="feeAsset">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.feeAsset" placeholder="请输入手续费币种"/>
        </el-form-item>
        <el-form-item label="保证金模式" prop="marginMode">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.marginMode" placeholder="请输入保证金模式"/>
        </el-form-item>
        <el-form-item label="保证金账户" prop="marginAccount">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.marginAccount" placeholder="请输入保证金账户"/>
        </el-form-item>
        <el-form-item label="真实收益" prop="realProfit">
          <el-input v-model="huobiSwapUsdtOrderDetailForm.realProfit" placeholder="请输入真实收益"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapUsdtOrderDetailForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapUsdtOrderDetailName',
    data() {
      return {
        huobiSwapUsdtOrderDetailLoading: true,
        huobiSwapUsdtOrderDetailDialog: false,
        huobiSwapUsdtOrderDetailData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapUsdtOrderDetailForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'detailId': '',
          'matchId': '',
          'orderId': '',
          'orderIdStr': '',
          'symbol': '',
          'orderSource': '',
          'contractCode': '',
          'direction': '',
          'offset': '',
          'tradeVolume': '',
          'tradePrice': '',
          'tradeTurnover': '',
          'createDate': '',
          'offsetProfitloss': '',
          'tradeFee': '',
          'role': '',
          'feeAsset': '',
          'marginMode': '',
          'marginAccount': '',
          'realProfit': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'detailId': '',
          'matchId': '',
          'orderId': '',
          'orderIdStr': '',
          'symbol': '',
          'orderSource': '',
          'contractCode': '',
          'direction': '',
          'offset': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapUsdtOrderDetailRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapUsdtOrderDetail',
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
        this.huobiSwapUsdtOrderDetailLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtOrderDetail/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtOrderDetailData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapUsdtOrderDetailLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapUsdtOrderDetailForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'detailId': '',
          'matchId': '',
          'orderId': '',
          'orderIdStr': '',
          'symbol': '',
          'orderSource': '',
          'contractCode': '',
          'direction': '',
          'offset': '',
          'tradeVolume': '',
          'tradePrice': '',
          'tradeTurnover': '',
          'createDate': '',
          'offsetProfitloss': '',
          'tradeFee': '',
          'role': '',
          'feeAsset': '',
          'marginMode': '',
          'marginAccount': '',
          'realProfit': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapUsdtOrderDetailDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapUsdtOrderDetailForm) {
          this.$refs.huobiSwapUsdtOrderDetailForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapUsdtOrderDetail/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapUsdtOrderDetailForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'detailId': res.object.detailId,
              'matchId': res.object.matchId,
              'orderId': res.object.orderId,
              'orderIdStr': res.object.orderIdStr,
              'symbol': res.object.symbol,
              'orderSource': res.object.orderSource,
              'contractCode': res.object.contractCode,
              'direction': res.object.direction,
              'offset': res.object.offset,
              'tradeVolume': res.object.tradeVolume,
              'tradePrice': res.object.tradePrice,
              'tradeTurnover': res.object.tradeTurnover,
              'createDate': res.object.createDate,
              'offsetProfitloss': res.object.offsetProfitloss,
              'tradeFee': res.object.tradeFee,
              'role': res.object.role,
              'feeAsset': res.object.feeAsset,
              'marginMode': res.object.marginMode,
              'marginAccount': res.object.marginAccount,
              'realProfit': res.object.realProfit
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapUsdtOrderDetailDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapUsdtOrderDetail/save',
              method: 'post',
              data: this.huobiSwapUsdtOrderDetailForm
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
            this.huobiSwapUsdtOrderDetailDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapUsdtOrderDetail/del',
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
  .huobiSwapUsdtOrderDetailForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
