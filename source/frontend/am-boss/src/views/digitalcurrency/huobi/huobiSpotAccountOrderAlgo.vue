<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="账户编号">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入账户编号"></el-input>
      </el-form-item>
      <el-form-item label="订单来源">
        <el-input v-model="searchForm.source" clearable placeholder="请输入订单来源"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.orderType" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSpotAccountOrderAlgoLoading" :data="huobiSpotAccountOrderAlgoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="账户编号"/>
      <el-table-column prop="source" label="订单来源"/>
      <el-table-column prop="clientOrderId" label="用户自编订单号"/>
      <el-table-column prop="orderId" label="订单编号"/>
      <el-table-column prop="symbol" label="交易代码"/>
      <el-table-column prop="orderPrice" label="订单价格"/>
      <el-table-column prop="orderSize" label="订单数量"/>
      <el-table-column prop="orderValue" label="订单金额"/>
      <el-table-column prop="orderSide" label="订单方向"/>
      <el-table-column prop="timeInForce" label="订单有效期" :formatter="dateFormat"/>
      <el-table-column prop="orderType" label="订单类型"/>
      <el-table-column prop="stopPrice" label="触发价"/>
      <el-table-column prop="trailingRate" label="回调幅度"/>
      <el-table-column prop="orderOrigTime" label="订单创建时间" :formatter="dateFormat"/>
      <el-table-column prop="lastActTime" label="订单最近更新时间" :formatter="dateFormat"/>
      <el-table-column prop="orderCreateTime" label="订单触发时间" :formatter="dateFormat"/>
      <el-table-column prop="orderStatus" label="订单状态"/>
      <el-table-column prop="errCode" label="订单被拒状态码"/>
      <el-table-column prop="errMessage" label="订单被拒错误消息"/>
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
    <el-dialog title="现货策略委托管理" :visible.sync="huobiSpotAccountOrderAlgoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSpotAccountOrderAlgoForm" :model="huobiSpotAccountOrderAlgoForm"
               :rules="huobiSpotAccountOrderAlgoRules" label-width="150px" class="huobiSpotAccountOrderAlgoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户编号" prop="huobiAccountId">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.huobiAccountId" placeholder="请输入账户编号"/>
        </el-form-item>
        <el-form-item label="订单来源" prop="source">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.source" placeholder="请输入订单来源"/>
        </el-form-item>
        <el-form-item label="用户自编订单号" prop="clientOrderId">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.clientOrderId" placeholder="请输入用户自编订单号"/>
        </el-form-item>
        <el-form-item label="订单编号" prop="orderId">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderId" placeholder="请输入订单编号"/>
        </el-form-item>
        <el-form-item label="交易代码" prop="symbol">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.symbol" placeholder="请输入交易代码"/>
        </el-form-item>
        <el-form-item label="订单价格" prop="orderPrice">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderPrice" placeholder="请输入订单价格"/>
        </el-form-item>
        <el-form-item label="订单数量" prop="orderSize">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderSize" placeholder="请输入订单数量"/>
        </el-form-item>
        <el-form-item label="订单金额" prop="orderValue">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderValue" placeholder="请输入订单金额"/>
        </el-form-item>
        <el-form-item label="订单方向" prop="orderSide">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderSide" placeholder="请输入订单方向"/>
        </el-form-item>
        <el-form-item label="订单有效期" prop="timeInForce">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.timeInForce" placeholder="请输入订单有效期"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderType" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="触发价" prop="stopPrice">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.stopPrice" placeholder="请输入触发价"/>
        </el-form-item>
        <el-form-item label="回调幅度" prop="trailingRate">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.trailingRate" placeholder="请输入回调幅度"/>
        </el-form-item>
        <el-form-item label="订单创建时间" prop="orderOrigTime">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderOrigTime" placeholder="请输入订单创建时间"/>
        </el-form-item>
        <el-form-item label="订单最近更新时间" prop="lastActTime">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.lastActTime" placeholder="请输入订单最近更新时间"/>
        </el-form-item>
        <el-form-item label="订单触发时间" prop="orderCreateTime">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderCreateTime" placeholder="请输入订单触发时间"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="orderStatus">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.orderStatus" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="订单被拒状态码" prop="errCode">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.errCode" placeholder="请输入订单被拒状态码"/>
        </el-form-item>
        <el-form-item label="订单被拒错误消息" prop="errMessage">
          <el-input v-model="huobiSpotAccountOrderAlgoForm.errMessage" placeholder="请输入订单被拒错误消息"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSpotAccountOrderAlgoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSpotAccountOrderAlgoName',
    data() {
      return {
        huobiSpotAccountOrderAlgoLoading: true,
        huobiSpotAccountOrderAlgoDialog: false,
        huobiSpotAccountOrderAlgoData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSpotAccountOrderAlgoForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'source': '',
          'clientOrderId': '',
          'orderId': '',
          'symbol': '',
          'orderPrice': '',
          'orderSize': '',
          'orderValue': '',
          'orderSide': '',
          'timeInForce': '',
          'orderType': '',
          'stopPrice': '',
          'trailingRate': '',
          'orderOrigTime': '',
          'lastActTime': '',
          'orderCreateTime': '',
          'orderStatus': '',
          'errCode': '',
          'errMessage': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'source': '',
          'clientOrderId': '',
          'orderId': '',
          'symbol': '',
          'orderType': '',
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSpotAccountOrderAlgoRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiSpotAccountOrderAlgo',
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
        this.huobiSpotAccountOrderAlgoLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrderAlgo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderAlgoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSpotAccountOrderAlgoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSpotAccountOrderAlgoForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'source': '',
          'clientOrderId': '',
          'orderId': '',
          'symbol': '',
          'orderPrice': '',
          'orderSize': '',
          'orderValue': '',
          'orderSide': '',
          'timeInForce': '',
          'orderType': '',
          'stopPrice': '',
          'trailingRate': '',
          'orderOrigTime': '',
          'lastActTime': '',
          'orderCreateTime': '',
          'orderStatus': '',
          'errCode': '',
          'errMessage': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSpotAccountOrderAlgoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSpotAccountOrderAlgoForm) {
          this.$refs.huobiSpotAccountOrderAlgoForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSpotAccountOrderAlgo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSpotAccountOrderAlgoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'source': res.object.source,
              'clientOrderId': res.object.clientOrderId,
              'orderId': res.object.orderId,
              'symbol': res.object.symbol,
              'orderPrice': res.object.orderPrice,
              'orderSize': res.object.orderSize,
              'orderValue': res.object.orderValue,
              'orderSide': res.object.orderSide,
              'timeInForce': res.object.timeInForce,
              'orderType': res.object.orderType,
              'stopPrice': res.object.stopPrice,
              'trailingRate': res.object.trailingRate,
              'orderOrigTime': res.object.orderOrigTime,
              'lastActTime': res.object.lastActTime,
              'orderCreateTime': res.object.orderCreateTime,
              'orderStatus': res.object.orderStatus,
              'errCode': res.object.errCode,
              'errMessage': res.object.errMessage
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSpotAccountOrderAlgoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSpotAccountOrderAlgo/save',
              method: 'post',
              data: this.huobiSpotAccountOrderAlgoForm
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
            this.huobiSpotAccountOrderAlgoDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSpotAccountOrderAlgo/del',
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
  .huobiSpotAccountOrderAlgoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
