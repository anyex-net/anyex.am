<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="合约品种">
        <el-input v-model="searchForm.symbol" clearable placeholder="请输入合约品种"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="合约类型">
        <el-input v-model="searchForm.contractType" clearable placeholder="请输入合约类型"></el-input>
      </el-form-item>
      <el-form-item label="触发类型">
        <el-input v-model="searchForm.triggerType" clearable placeholder="请输入触发类型"></el-input>
      </el-form-item>
      <el-form-item label="委托数量">
        <el-input v-model="searchForm.volume" clearable placeholder="请输入委托数量"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-input v-model="searchForm.orderType" clearable placeholder="请输入订单类型"></el-input>
      </el-form-item>
      <el-form-item label="订单方向">
        <el-input v-model="searchForm.direction" clearable placeholder="请输入订单方向"></el-input>
      </el-form-item>
      <el-form-item label="订单报价类型">
        <el-input v-model="searchForm.orderPriceType" clearable placeholder="请输入订单报价类型"></el-input>
      </el-form-item>
      <el-form-item label="订单状态">
        <el-input v-model="searchForm.status" clearable placeholder="请输入订单状态"></el-input>
      </el-form-item>
      <el-form-item label="来源">
        <el-input v-model="searchForm.orderSource" clearable placeholder="请输入来源"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiSwapCoinOrderPlanLoading" :data="huobiSwapCoinOrderPlanData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="symbol" label="合约品种"/>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="contractType" label="合约类型"/>
      <el-table-column prop="triggerType" label="触发类型"/>
      <el-table-column prop="volume" label="委托数量"/>
      <el-table-column prop="orderType" label="订单类型"/>
      <el-table-column prop="direction" label="订单方向"/>
      <el-table-column prop="offset" label="开平标志"/>
      <el-table-column prop="leverRate" label="杠杆倍数"/>
      <el-table-column prop="orderId" label="计划委托单订单ID"/>
      <el-table-column prop="orderIdStr" label="字符串类型的订单ID"/>
      <el-table-column prop="relationOrderId" label="订单id"/>
      <el-table-column prop="orderPriceType" label="订单报价类型"/>
      <el-table-column prop="status" label="订单状态"/>
      <el-table-column prop="orderSource" label="来源"/>
      <el-table-column prop="triggerPrice" label="触发价"/>
      <el-table-column prop="triggeredPrice" label="被触发时的价格"/>
      <el-table-column prop="orderPrice" label="委托价"/>
      <el-table-column prop="createdAt" label="订单创建时间" :formatter="dateFormat"/>
      <el-table-column prop="triggeredAt" label="触发时间" :formatter="dateFormat"/>
      <el-table-column prop="orderInsertAt" label="下order单时间" :formatter="dateFormat"/>
      <el-table-column prop="canceledAt" label="撤单时间" :formatter="dateFormat"/>
      <el-table-column prop="updateTime" label="订单更新时间" :formatter="dateFormat"/>
      <el-table-column prop="failCode" label="被触发时下order单失败错误码"/>
      <el-table-column prop="failReason" label="被触发时下order单失败原因"/>
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
    <el-dialog title="永续合约计划委托管理" :visible.sync="huobiSwapCoinOrderPlanDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiSwapCoinOrderPlanForm" :model="huobiSwapCoinOrderPlanForm" :rules="huobiSwapCoinOrderPlanRules"
               label-width="150px" class="huobiSwapCoinOrderPlanForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiSwapCoinOrderPlanForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiSwapCoinOrderPlanForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiSwapCoinOrderPlanForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="合约品种" prop="symbol">
          <el-input v-model="huobiSwapCoinOrderPlanForm.symbol" placeholder="请输入合约品种"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="huobiSwapCoinOrderPlanForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="合约类型" prop="contractType">
          <el-input v-model="huobiSwapCoinOrderPlanForm.contractType" placeholder="请输入合约类型"/>
        </el-form-item>
        <el-form-item label="触发类型" prop="triggerType">
          <el-input v-model="huobiSwapCoinOrderPlanForm.triggerType" placeholder="请输入触发类型"/>
        </el-form-item>
        <el-form-item label="委托数量" prop="volume">
          <el-input v-model="huobiSwapCoinOrderPlanForm.volume" placeholder="请输入委托数量"/>
        </el-form-item>
        <el-form-item label="订单类型" prop="orderType">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderType" placeholder="请输入订单类型"/>
        </el-form-item>
        <el-form-item label="订单方向" prop="direction">
          <el-input v-model="huobiSwapCoinOrderPlanForm.direction" placeholder="请输入订单方向"/>
        </el-form-item>
        <el-form-item label="开平标志" prop="offset">
          <el-input v-model="huobiSwapCoinOrderPlanForm.offset" placeholder="请输入开平标志"/>
        </el-form-item>
        <el-form-item label="杠杆倍数" prop="leverRate">
          <el-input v-model="huobiSwapCoinOrderPlanForm.leverRate" placeholder="请输入杠杆倍数"/>
        </el-form-item>
        <el-form-item label="计划委托单订单ID" prop="orderId">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderId" placeholder="请输入计划委托单订单ID"/>
        </el-form-item>
        <el-form-item label="字符串类型的订单ID" prop="orderIdStr">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderIdStr" placeholder="请输入字符串类型的订单ID"/>
        </el-form-item>
        <el-form-item label="订单id" prop="relationOrderId">
          <el-input v-model="huobiSwapCoinOrderPlanForm.relationOrderId" placeholder="请输入订单id"/>
        </el-form-item>
        <el-form-item label="订单报价类型" prop="orderPriceType">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderPriceType" placeholder="请输入订单报价类型"/>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-input v-model="huobiSwapCoinOrderPlanForm.status" placeholder="请输入订单状态"/>
        </el-form-item>
        <el-form-item label="来源" prop="orderSource">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderSource" placeholder="请输入来源"/>
        </el-form-item>
        <el-form-item label="触发价" prop="triggerPrice">
          <el-input v-model="huobiSwapCoinOrderPlanForm.triggerPrice" placeholder="请输入触发价"/>
        </el-form-item>
        <el-form-item label="被触发时的价格" prop="triggeredPrice">
          <el-input v-model="huobiSwapCoinOrderPlanForm.triggeredPrice" placeholder="请输入被触发时的价格"/>
        </el-form-item>
        <el-form-item label="委托价" prop="orderPrice">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderPrice" placeholder="请输入委托价"/>
        </el-form-item>
        <el-form-item label="订单创建时间" prop="createdAt">
          <el-input v-model="huobiSwapCoinOrderPlanForm.createdAt" placeholder="请输入订单创建时间"/>
        </el-form-item>
        <el-form-item label="触发时间" prop="triggeredAt">
          <el-input v-model="huobiSwapCoinOrderPlanForm.triggeredAt" placeholder="请输入触发时间"/>
        </el-form-item>
        <el-form-item label="下order单时间" prop="orderInsertAt">
          <el-input v-model="huobiSwapCoinOrderPlanForm.orderInsertAt" placeholder="请输入下order单时间"/>
        </el-form-item>
        <el-form-item label="撤单时间" prop="canceledAt">
          <el-input v-model="huobiSwapCoinOrderPlanForm.canceledAt" placeholder="请输入撤单时间"/>
        </el-form-item>
        <el-form-item label="订单更新时间" prop="updateTime">
          <el-input v-model="huobiSwapCoinOrderPlanForm.updateTime" placeholder="请输入订单更新时间"/>
        </el-form-item>
        <el-form-item label="被触发时下order单失败错误码" prop="failCode">
          <el-input v-model="huobiSwapCoinOrderPlanForm.failCode" placeholder="请输入被触发时下order单失败错误码"/>
        </el-form-item>
        <el-form-item label="被触发时下order单失败原因" prop="failReason">
          <el-input v-model="huobiSwapCoinOrderPlanForm.failReason" placeholder="请输入被触发时下order单失败原因"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiSwapCoinOrderPlanForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiSwapCoinOrderPlanName',
    data() {
      return {
        huobiSwapCoinOrderPlanLoading: true,
        huobiSwapCoinOrderPlanDialog: false,
        huobiSwapCoinOrderPlanData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiSwapCoinOrderPlanForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'triggerType': '',
          'volume': '',
          'orderType': '',
          'direction': '',
          'offset': '',
          'leverRate': '',
          'orderId': '',
          'orderIdStr': '',
          'relationOrderId': '',
          'orderPriceType': '',
          'status': '',
          'orderSource': '',
          'triggerPrice': '',
          'triggeredPrice': '',
          'orderPrice': '',
          'createdAt': '',
          'triggeredAt': '',
          'orderInsertAt': '',
          'canceledAt': '',
          'updateTime': '',
          'failCode': '',
          'failReason': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'triggerType': '',
          'volume': '',
          'orderType': '',
          'direction': '',
          'offset': '',
          'leverRate': '',
          'orderId': '',
          'orderIdStr': '',
          'relationOrderId': '',
          'orderPriceType': '',
          'status': '',
          'orderSource': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiSwapCoinOrderPlanRules: {
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
          url: '/digitalcurrency/huobi/dict/huobiSwapCoinOrderPlan',
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
        this.huobiSwapCoinOrderPlanLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinOrderPlan/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinOrderPlanData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiSwapCoinOrderPlanLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiSwapCoinOrderPlanForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'symbol': '',
          'contractCode': '',
          'contractType': '',
          'triggerType': '',
          'volume': '',
          'orderType': '',
          'direction': '',
          'offset': '',
          'leverRate': '',
          'orderId': '',
          'orderIdStr': '',
          'relationOrderId': '',
          'orderPriceType': '',
          'status': '',
          'orderSource': '',
          'triggerPrice': '',
          'triggeredPrice': '',
          'orderPrice': '',
          'createdAt': '',
          'triggeredAt': '',
          'orderInsertAt': '',
          'canceledAt': '',
          'updateTime': '',
          'failCode': '',
          'failReason': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiSwapCoinOrderPlanDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiSwapCoinOrderPlanForm) {
          this.$refs.huobiSwapCoinOrderPlanForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiSwapCoinOrderPlan/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiSwapCoinOrderPlanForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'symbol': res.object.symbol,
              'contractCode': res.object.contractCode,
              'contractType': res.object.contractType,
              'triggerType': res.object.triggerType,
              'volume': res.object.volume,
              'orderType': res.object.orderType,
              'direction': res.object.direction,
              'offset': res.object.offset,
              'leverRate': res.object.leverRate,
              'orderId': res.object.orderId,
              'orderIdStr': res.object.orderIdStr,
              'relationOrderId': res.object.relationOrderId,
              'orderPriceType': res.object.orderPriceType,
              'status': res.object.status,
              'orderSource': res.object.orderSource,
              'triggerPrice': res.object.triggerPrice,
              'triggeredPrice': res.object.triggeredPrice,
              'orderPrice': res.object.orderPrice,
              'createdAt': res.object.createdAt,
              'triggeredAt': res.object.triggeredAt,
              'orderInsertAt': res.object.orderInsertAt,
              'canceledAt': res.object.canceledAt,
              'updateTime': res.object.updateTime,
              'failCode': res.object.failCode,
              'failReason': res.object.failReason
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiSwapCoinOrderPlanDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiSwapCoinOrderPlan/save',
              method: 'post',
              data: this.huobiSwapCoinOrderPlanForm
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
            this.huobiSwapCoinOrderPlanDialog = false;
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
            url: '/digitalcurrency/huobi/huobiSwapCoinOrderPlan/del',
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
  .huobiSwapCoinOrderPlanForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
