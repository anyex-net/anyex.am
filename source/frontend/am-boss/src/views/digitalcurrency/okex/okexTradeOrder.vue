<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.instType" clearable placeholder="请输入产品类型">
          <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="保证金币种">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入保证金币种"></el-input>
      </el-form-item>
      <el-form-item label="订单ID">
        <el-input v-model="searchForm.ordId" clearable placeholder="请输入订单ID"></el-input>
      </el-form-item>
      <el-form-item label="订单类型">
        <el-select v-model="searchForm.ordType" clearable placeholder="请输入订单类型">
          <el-option v-for="data in ordTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="订单方向">
        <el-input v-model="searchForm.side" clearable placeholder="请输入订单方向"></el-input>
      </el-form-item>
      <el-form-item label="持仓方向">
        <el-input v-model="searchForm.posSide" clearable placeholder="请输入持仓方向"></el-input>
      </el-form-item>
      <el-form-item label="交易模式">
        <el-input v-model="searchForm.tdMode" clearable placeholder="请输入交易模式"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexTradeOrderLoading"
      :data="okexTradeOrderData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="instType" label="产品类型" :formatter="statusFormat"/>
      <el-table-column prop="instId" label="产品ID"/>
      <el-table-column prop="ccy" label="保证金币种"/>
      <el-table-column prop="ordId" label="订单ID"/>
      <el-table-column prop="clOrdId" label="客户自定义订单ID"/>
      <el-table-column prop="tag" label="订单标签"/>
      <el-table-column prop="px" label="委托价格"/>
      <el-table-column prop="sz" label="委托数量"/>
      <el-table-column prop="pnl" label="收益"/>
      <el-table-column prop="ordType" label="订单类型" :formatter="statusFormat"/>
      <el-table-column prop="side" label="订单方向"/>
      <el-table-column prop="posSide" label="持仓方向"/>
      <el-table-column prop="tdMode" label="交易模式"/>
      <el-table-column prop="accFillSz" label="累计成交数量"/>
      <el-table-column prop="fillPx" label="最新成交价格"/>
      <el-table-column prop="tradeId" label="最新成交ID"/>
      <el-table-column prop="fillSz" label="最新成交数量"/>
      <el-table-column prop="fillTime" label="最新成交时间" :formatter="dateFormat"/>
      <el-table-column prop="avgPx" label="成交均价"/>
      <el-table-column prop="state" label="订单状态" :formatter="statusFormat"/>
      <el-table-column prop="lever" label="杠杆倍数"/>
      <el-table-column prop="tpTriggerPx" label="止盈触发价"/>
      <el-table-column prop="tpOrdPx" label="止盈委托价"/>
      <el-table-column prop="slTriggerPx" label="止损触发价"/>
      <el-table-column prop="slOrdPx" label="止损委托价"/>
      <el-table-column prop="feeCcy" label="交易手续费币种"/>
      <el-table-column prop="fee" label="订单交易手续费"/>
      <el-table-column prop="rebateCcy" label="返佣金币种"/>
      <el-table-column prop="rebate" label="返佣金额"/>
      <el-table-column prop="category" label="订单种类" :formatter="statusFormat"/>
      <el-table-column prop="uTime" label="订单状态更新时间" :formatter="dateFormat"/>
      <el-table-column prop="cTime" label="订单创建时间" :formatter="dateFormat"/>
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
    <el-dialog title="账户订单信息管理" :visible.sync="okexTradeOrderDialog" :close-on-click-modal="false" width="70%">
      <el-form
        ref="okexTradeOrderForm"
        :model="okexTradeOrderForm"
        :rules="okexTradeOrderRules"
        label-width="150px"
        class="okexTradeOrderForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="主键" prop="id">
              <el-input v-model="okexTradeOrderForm.id" placeholder="请输入主键"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平台账户ID" prop="accountId">
              <el-input v-model="okexTradeOrderForm.accountId" placeholder="请输入平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="外部平台apikey" prop="apiKey">
              <el-input v-model="okexTradeOrderForm.apiKey" placeholder="请输入外部平台apikey"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="instType">
              <el-select v-model="okexTradeOrderForm.instType" placeholder="请输入产品类型">
                <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品ID" prop="instId">
              <el-input v-model="okexTradeOrderForm.instId" placeholder="请输入产品ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金币种" prop="ccy">
              <el-input v-model="okexTradeOrderForm.ccy" placeholder="请输入保证金币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单ID" prop="ordId">
              <el-input v-model="okexTradeOrderForm.ordId" placeholder="请输入订单ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户自定义订单ID" prop="clOrdId">
              <el-input v-model="okexTradeOrderForm.clOrdId" placeholder="请输入客户自定义订单ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单标签" prop="tag">
              <el-input v-model="okexTradeOrderForm.tag" placeholder="请输入订单标签"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="委托价格" prop="px">
              <el-input v-model="okexTradeOrderForm.px" placeholder="请输入委托价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托数量" prop="sz">
              <el-input v-model="okexTradeOrderForm.sz" placeholder="请输入委托数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收益" prop="pnl">
              <el-input v-model="okexTradeOrderForm.pnl" placeholder="请输入收益"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单类型" prop="ordType">
              <el-select v-model="okexTradeOrderForm.ordType" placeholder="请输入订单类型">
                <el-option v-for="data in ordTypeList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单方向" prop="side">
              <el-input v-model="okexTradeOrderForm.side" placeholder="请输入订单方向"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓方向" prop="posSide">
              <el-input v-model="okexTradeOrderForm.posSide" placeholder="请输入持仓方向"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易模式" prop="tdMode">
              <el-input v-model="okexTradeOrderForm.tdMode" placeholder="请输入交易模式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="累计成交数量" prop="accFillSz">
              <el-input v-model="okexTradeOrderForm.accFillSz" placeholder="请输入累计成交数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新成交价格" prop="fillPx">
              <el-input v-model="okexTradeOrderForm.fillPx" placeholder="请输入最新成交价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最新成交ID" prop="tradeId">
              <el-input v-model="okexTradeOrderForm.tradeId" placeholder="请输入最新成交ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新成交数量" prop="fillSz">
              <el-input v-model="okexTradeOrderForm.fillSz" placeholder="请输入最新成交数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新成交时间" prop="fillTime">
              <el-input v-model="okexTradeOrderForm.fillTime" placeholder="请输入最新成交时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="成交均价" prop="avgPx">
              <el-input v-model="okexTradeOrderForm.avgPx" placeholder="请输入成交均价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单状态" prop="state">
              <el-select v-model="okexTradeOrderForm.state" placeholder="请输入订单状态">
              <el-option v-for="data in stateList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="杠杆倍数" prop="lever">
              <el-input v-model="okexTradeOrderForm.lever" placeholder="请输入杠杆倍数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="止盈触发价" prop="tpTriggerPx">
              <el-input v-model="okexTradeOrderForm.tpTriggerPx" placeholder="请输入止盈触发价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="止盈委托价" prop="tpOrdPx">
              <el-input v-model="okexTradeOrderForm.tpOrdPx" placeholder="请输入止盈委托价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="止损触发价" prop="slTriggerPx">
              <el-input v-model="okexTradeOrderForm.slTriggerPx" placeholder="请输入止损触发价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="止损委托价" prop="slOrdPx">
              <el-input v-model="okexTradeOrderForm.slOrdPx" placeholder="请输入止损委托价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易手续费币种" prop="feeCcy">
              <el-input v-model="okexTradeOrderForm.feeCcy" placeholder="请输入交易手续费币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单交易手续费" prop="fee">
              <el-input v-model="okexTradeOrderForm.fee" placeholder="请输入订单交易手续费"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="返佣金币种" prop="rebateCcy">
              <el-input v-model="okexTradeOrderForm.rebateCcy" placeholder="请输入返佣金币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="返佣金额" prop="rebate">
              <el-input v-model="okexTradeOrderForm.rebate" placeholder="请输入返佣金额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单种类" prop="category">
              <el-select v-model="okexTradeOrderForm.category" placeholder="请输入订单种类">
              <el-option v-for="data in categoryList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单状态更新时间" prop="uTime" >
              <el-input v-model="okexTradeOrderForm.uTime" placeholder="请输入订单状态更新时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单创建时间" prop="cTime">
              <el-input v-model="okexTradeOrderForm.cTime" placeholder="请输入订单创建时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexTradeOrderForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexTradeOrderName',
    data() {
      return {
        okexTradeOrderLoading: true,
        okexTradeOrderDialog: false,
        okexTradeOrderData: [],
        commodityTypeSelects: [],
        dicts: [],
        instTypeList: [],
        ordTypeList: [],
        stateList: [],
        categoryList: [],
        okexTradeOrderForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'clOrdId': '',
          'tag': '',
          'px': '',
          'sz': '',
          'pnl': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': '',
          'accFillSz': '',
          'fillPx': '',
          'tradeId': '',
          'fillSz': '',
          'fillTime': '',
          'avgPx': '',
          'state': '',
          'lever': '',
          'tpTriggerPx': '',
          'tpOrdPx': '',
          'slTriggerPx': '',
          'slOrdPx': '',
          'feeCcy': '',
          'fee': '',
          'rebateCcy': '',
          'rebate': '',
          'category': '',
          'uTime': '',
          'cTime': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexTradeOrderRules: {
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
        if(this.dicts[p] === undefined){
          return ''
        }
        const obj = this.dicts[p].list;
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
          url: '/digitalcurrency/okex/dict/okexTradeOrder',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.ordTypeList = res.object.list.ordType.list
            this.instTypeList = res.object.list.instType.list
            this.stateList = res.object.list.state.list
            this.categoryList = res.object.list.category.list
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
        this.okexTradeOrderLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexTradeOrder/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeOrderData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexTradeOrderLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexTradeOrderForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'clOrdId': '',
          'tag': '',
          'px': '',
          'sz': '',
          'pnl': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': '',
          'accFillSz': '',
          'fillPx': '',
          'tradeId': '',
          'fillSz': '',
          'fillTime': '',
          'avgPx': '',
          'state': '',
          'lever': '',
          'tpTriggerPx': '',
          'tpOrdPx': '',
          'slTriggerPx': '',
          'slOrdPx': '',
          'feeCcy': '',
          'fee': '',
          'rebateCcy': '',
          'rebate': '',
          'category': '',
          'uTime': '',
          'cTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexTradeOrderDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexTradeOrderForm) {
          this.$refs.okexTradeOrderForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexTradeOrder/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeOrderForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'instType': res.object.instType,
              'instId': res.object.instId,
              'ccy': res.object.ccy,
              'ordId': res.object.ordId,
              'clOrdId': res.object.clOrdId,
              'tag': res.object.tag,
              'px': res.object.px,
              'sz': res.object.sz,
              'pnl': res.object.pnl,
              'ordType': res.object.ordType,
              'side': res.object.side,
              'posSide': res.object.posSide,
              'tdMode': res.object.tdMode,
              'accFillSz': res.object.accFillSz,
              'fillPx': res.object.fillPx,
              'tradeId': res.object.tradeId,
              'fillSz': res.object.fillSz,
              'fillTime': res.object.fillTime,
              'avgPx': res.object.avgPx,
              'state': res.object.state,
              'lever': res.object.lever,
              'tpTriggerPx': res.object.tpTriggerPx,
              'tpOrdPx': res.object.tpOrdPx,
              'slTriggerPx': res.object.slTriggerPx,
              'slOrdPx': res.object.slOrdPx,
              'feeCcy': res.object.feeCcy,
              'fee': res.object.fee,
              'rebateCcy': res.object.rebateCcy,
              'rebate': res.object.rebate,
              'category': res.object.category,
              'uTime': res.object.uTime,
              'cTime': res.object.cTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexTradeOrderDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexTradeOrder/save',
              method: 'post',
              data: this.okexTradeOrderForm
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
            this.okexTradeOrderDialog = false;
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
            url: '/digitalcurrency/okex/okexTradeOrder/del',
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
  .okexTradeOrderForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
