<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="订单来源">
        <el-input v-model="searchForm.source" clearable placeholder="请输入订单来源"></el-input>
      </el-form-item>
      <el-form-item label="交易对">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入交易对"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.type" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountOrderDetailLoading" :data="huobiSpotAccountOrderDetailData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="createdAt" label="该成交记录创建的时间戳"/>
      <el-table-column prop="filledAmount" label="成交数量"/>
      <el-table-column prop="filledFees" label="交易手续费"/>
      <el-table-column prop="feeCurrency" label="交易手续费或交易返佣币种"/>
      <el-table-column prop="detailId" label="订单成交记录ID"/>
      <el-table-column prop="matchId" label="撮合ID"/>
      <el-table-column prop="orderId" label="订单ID"/>
      <el-table-column prop="tradeId" label="Unique trade ID"/>
      <el-table-column prop="price" label="成交价格"/>
      <el-table-column prop="source" label="订单来源"/>
      <el-table-column prop="symbol" label="交易对"/>
      <el-table-column prop="type" label="订单类型"/>
      <el-table-column prop="role" label="成交角色"/>
      <el-table-column prop="filledPoints" label="抵扣数量"/>
      <el-table-column prop="feeDeductCurrency" label="抵扣类型"/>
      <el-table-column prop="feeDeductState" label="抵扣状态"/>
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
    <el-dialog title="现货成交明细管理" :visible.sync="huobiSpotAccountOrderDetailDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSpotAccountOrderDetailForm" :model="huobiSpotAccountOrderDetailForm"
               :rules="huobiSpotAccountOrderDetailRules" label-width="150px" class="huobiSpotAccountOrderDetailForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountOrderDetailForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountOrderDetailForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountOrderDetailForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="该成交记录创建的时间戳" prop="createdAt">
          <el-input v-model="huobiSpotAccountOrderDetailForm.createdAt" placeholder="请输入该成交记录创建的时间戳"/>
        </el-form-item>
        <el-form-item label="成交数量" prop="filledAmount">
          <el-input v-model="huobiSpotAccountOrderDetailForm.filledAmount" placeholder="请输入成交数量"/>
        </el-form-item>
        <el-form-item label="交易手续费" prop="filledFees">
          <el-input v-model="huobiSpotAccountOrderDetailForm.filledFees" placeholder="请输入交易手续费"/>
        </el-form-item>
        <el-form-item label="交易手续费或交易返佣币种" prop="feeCurrency">
          <el-input v-model="huobiSpotAccountOrderDetailForm.feeCurrency" placeholder="请输入交易手续费或交易返佣币种"/>
        </el-form-item>
        <el-form-item label="订单成交记录ID" prop="detailId">
          <el-input v-model="huobiSpotAccountOrderDetailForm.detailId" placeholder="请输入订单成交记录ID"/>
        </el-form-item>
        <el-form-item label="撮合ID" prop="matchId">
          <el-input v-model="huobiSpotAccountOrderDetailForm.matchId" placeholder="请输入撮合ID"/>
        </el-form-item>
        <el-form-item label="订单ID" prop="orderId">
          <el-input v-model="huobiSpotAccountOrderDetailForm.orderId" placeholder="请输入订单ID"/>
        </el-form-item>
        <el-form-item label="Unique trade ID" prop="tradeId">
          <el-input v-model="huobiSpotAccountOrderDetailForm.tradeId" placeholder="请输入Unique trade ID"/>
        </el-form-item>
        <el-form-item label="成交价格" prop="price">
          <el-input v-model="huobiSpotAccountOrderDetailForm.price" placeholder="请输入成交价格"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="source">
          <el-input v-model="huobiSpotAccountOrderDetailForm.source" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="交易对" prop="symbol">
          <el-input v-model="huobiSpotAccountOrderDetailForm.symbol" placeholder="请输入交易对"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="type">
          <el-input v-model="huobiSpotAccountOrderDetailForm.type" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="成交角色" prop="role">
          <el-input v-model="huobiSpotAccountOrderDetailForm.role" placeholder="请输入成交角色"/>
        </el-form-item>
        <el-form-item label="抵扣数量" prop="filledPoints">
          <el-input v-model="huobiSpotAccountOrderDetailForm.filledPoints" placeholder="请输入抵扣数量"/>
        </el-form-item>
        <el-form-item label="抵扣类型" prop="feeDeductCurrency">
          <el-input v-model="huobiSpotAccountOrderDetailForm.feeDeductCurrency" placeholder="请输入抵扣类型"/>
        </el-form-item>
        <el-form-item label="抵扣状态" prop="feeDeductState">
          <el-input v-model="huobiSpotAccountOrderDetailForm.feeDeductState" placeholder="请输入抵扣状态"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountOrderDetailForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountOrderDetailName',
    data() {
      return {
        huobiSpotAccountOrderDetailLoading: true,
        huobiSpotAccountOrderDetailDialog: false,
        huobiSpotAccountOrderDetailData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountOrderDetailForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'createdAt': '',
          'filledAmount': '',
          'filledFees': '',
          'feeCurrency': '',
          'detailId': '',
          'matchId': '',
          'orderId': '',
          'tradeId': '',
          'price': '',
          'source': '',
          'symbol': '',
          'type': '',
          'role': '',
          'filledPoints': '',
          'feeDeductCurrency': '',
          'feeDeductState': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'source': '',
          'symbol': '',
          'type': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountOrderDetailRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountOrderDetail',
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
        this.huobiSpotAccountOrderDetailLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrderDetail/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderDetailData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountOrderDetailLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountOrderDetailForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'createdAt': '',
          'filledAmount': '',
          'filledFees': '',
          'feeCurrency': '',
          'detailId': '',
          'matchId': '',
          'orderId': '',
          'tradeId': '',
          'price': '',
          'source': '',
          'symbol': '',
          'type': '',
          'role': '',
          'filledPoints': '',
          'feeDeductCurrency': '',
          'feeDeductState': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountOrderDetailDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountOrderDetailForm) {
          this.$refs.huobiSpotAccountOrderDetailForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrderDetail/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderDetailForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'createdAt': res.object.createdAt,
              'filledAmount': res.object.filledAmount,
              'filledFees': res.object.filledFees,
              'feeCurrency': res.object.feeCurrency,
              'detailId': res.object.detailId,
              'matchId': res.object.matchId,
              'orderId': res.object.orderId,
              'tradeId': res.object.tradeId,
              'price': res.object.price,
              'source': res.object.source,
              'symbol': res.object.symbol,
              'type': res.object.type,
              'role': res.object.role,
              'filledPoints': res.object.filledPoints,
              'feeDeductCurrency': res.object.feeDeductCurrency,
              'feeDeductState': res.object.feeDeductState
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountOrderDetailDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountOrderDetail/save',
              method: 'post',
              data: this.huobiSpotAccountOrderDetailForm
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
            this.huobiSpotAccountOrderDetailDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountOrderDetail/del',
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
  .huobiSpotAccountOrderDetailForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
