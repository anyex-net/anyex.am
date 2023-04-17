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
      <el-form-item label="订单状态">
        <el-select v-model="searchForm.state" clearable placeholder="请输入订单状态">
          <el-option v-for="data in stateList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexTradeOrderAlgoLoading"
      :data="okexTradeOrderAlgoData"
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
      <el-table-column prop="algoId" label="策略委托单ID"/>
      <el-table-column prop="sz" label="委托数量"/>
      <el-table-column prop="ordType" label="订单类型" :formatter="statusFormat"/>
      <el-table-column prop="side" label="订单方向"/>
      <el-table-column prop="posSide" label="持仓方向"/>
      <el-table-column prop="tdMode" label="交易模式"/>
      <el-table-column prop="state" label="订单状态" :formatter="statusFormat"/>
      <el-table-column prop="lever" label="杠杆倍数"/>
      <el-table-column prop="tpTriggerPx" label="止盈触发价"/>
      <el-table-column prop="tpOrdPx" label="止盈委托价"/>
      <el-table-column prop="slTriggerPx" label="止损触发价"/>
      <el-table-column prop="slOrdPx" label="止损委托价"/>
      <el-table-column prop="triggerPx" label="计划委托触发价格"/>
      <el-table-column prop="ordPx" label="计划委托委托价格"/>
      <el-table-column prop="actualSz" label="实际委托量"/>
      <el-table-column prop="actualPx" label="实际委托价"/>
      <el-table-column prop="actualSide" label="实际触发方向"/>
      <el-table-column prop="triggerTime" label="策略委托触发时间" :formatter="dateFormat"/>
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
    <el-dialog title="账户策略委托单管理" :visible.sync="okexTradeOrderAlgoDialog" :close-on-click-modal="false" width="60%">
      <el-form
        ref="okexTradeOrderAlgoForm"
        :model="okexTradeOrderAlgoForm"
        :rules="okexTradeOrderAlgoRules"
        label-width="150px"
        class="okexTradeOrderAlgoForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="平台账户ID" prop="accountId">
              <el-input v-model="okexTradeOrderAlgoForm.accountId" placeholder="请输入平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="外部平台apikey" prop="apiKey">
              <el-input v-model="okexTradeOrderAlgoForm.apiKey" placeholder="请输入外部平台apikey"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="instType">
              <el-select v-model="okexTradeOrderAlgoForm.instType" placeholder="请输入产品类型">
                <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="产品ID" prop="instId">
              <el-input v-model="okexTradeOrderAlgoForm.instId" placeholder="请输入产品ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8"><
            <el-form-item label="保证金币种" prop="ccy">
              <el-input v-model="okexTradeOrderAlgoForm.ccy" placeholder="请输入保证金币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单ID" prop="ordId">
              <el-input v-model="okexTradeOrderAlgoForm.ordId" placeholder="请输入订单ID"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="策略委托单ID" prop="algoId">
              <el-input v-model="okexTradeOrderAlgoForm.algoId" placeholder="请输入策略委托单ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托数量" prop="sz">
              <el-input v-model="okexTradeOrderAlgoForm.sz" placeholder="请输入委托数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="订单类型" prop="ordType">
              <el-select v-model="okexTradeOrderAlgoForm.ordType" placeholder="请输入订单类型">
                <el-option v-for="data in ordTypeList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单方向" prop="side">
              <el-input v-model="okexTradeOrderAlgoForm.side" placeholder="请输入订单方向"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓方向" prop="posSide">
              <el-input v-model="okexTradeOrderAlgoForm.posSide" placeholder="请输入持仓方向"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易模式" prop="tdMode">
              <el-input v-model="okexTradeOrderAlgoForm.tdMode" placeholder="请输入交易模式"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单状态" prop="state">
              <el-select v-model="okexTradeOrderAlgoForm.state" placeholder="请输入订单状态">
                <el-option v-for="data in stateList" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="杠杆倍数" prop="lever">
              <el-input v-model="okexTradeOrderAlgoForm.lever" placeholder="请输入杠杆倍数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="止盈触发价" prop="tpTriggerPx">
              <el-input v-model="okexTradeOrderAlgoForm.tpTriggerPx" placeholder="请输入止盈触发价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="止盈委托价" prop="tpOrdPx">
              <el-input v-model="okexTradeOrderAlgoForm.tpOrdPx" placeholder="请输入止盈委托价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="止损触发价" prop="slTriggerPx">
              <el-input v-model="okexTradeOrderAlgoForm.slTriggerPx" placeholder="请输入止损触发价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="止损委托价" prop="slOrdPx">
              <el-input v-model="okexTradeOrderAlgoForm.slOrdPx" placeholder="请输入止损委托价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="计划委托触发价格" prop="triggerPx">
              <el-input v-model="okexTradeOrderAlgoForm.triggerPx" placeholder="请输入计划委托触发价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="计划委托委托价格" prop="ordPx">
              <el-input v-model="okexTradeOrderAlgoForm.ordPx" placeholder="请输入计划委托委托价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="实际委托量" prop="actualSz">
              <el-input v-model="okexTradeOrderAlgoForm.actualSz" placeholder="请输入实际委托量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="实际委托价" prop="actualPx">
              <el-input v-model="okexTradeOrderAlgoForm.actualPx" placeholder="请输入实际委托价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="实际触发方向" prop="actualSide">
              <el-input v-model="okexTradeOrderAlgoForm.actualSide" placeholder="请输入实际触发方向"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="策略委托触发时间" prop="triggerTime">
              <el-input v-model="okexTradeOrderAlgoForm.triggerTime" placeholder="请输入策略委托触发时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单创建时间" prop="cTime">
              <el-input v-model="okexTradeOrderAlgoForm.cTime" placeholder="请输入订单创建时间"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexTradeOrderAlgoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexTradeOrderAlgoName',
    data() {
      return {
        okexTradeOrderAlgoLoading: true,
        okexTradeOrderAlgoDialog: false,
        okexTradeOrderAlgoData: [],
        commodityTypeSelects: [],
        dicts: [],
        instTypeList: [],
        stateList: [],
        ordTypeList: [],
        okexTradeOrderAlgoForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'algoId': '',
          'sz': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': '',
          'state': '',
          'lever': '',
          'tpTriggerPx': '',
          'tpOrdPx': '',
          'slTriggerPx': '',
          'slOrdPx': '',
          'triggerPx': '',
          'ordPx': '',
          'actualSz': '',
          'actualPx': '',
          'actualSide': '',
          'triggerTime': '',
          'cTime': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'algoId': '',
          'sz': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': '',
          'state': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexTradeOrderAlgoRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
          ]
        }
      };
    },
    created: function() {
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
          url: '/digitalcurrency/okex/dict/okexTradeOrderAlgo',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.ordTypeList = res.object.list.ordType.list
            this.instTypeList = res.object.list.instType.list
            this.stateList = res.object.list.state.list
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
        this.okexTradeOrderAlgoLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexTradeOrderAlgo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeOrderAlgoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexTradeOrderAlgoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexTradeOrderAlgoForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'ccy': '',
          'ordId': '',
          'algoId': '',
          'sz': '',
          'ordType': '',
          'side': '',
          'posSide': '',
          'tdMode': '',
          'state': '',
          'lever': '',
          'tpTriggerPx': '',
          'tpOrdPx': '',
          'slTriggerPx': '',
          'slOrdPx': '',
          'triggerPx': '',
          'ordPx': '',
          'actualSz': '',
          'actualPx': '',
          'actualSide': '',
          'triggerTime': '',
          'cTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexTradeOrderAlgoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexTradeOrderAlgoForm) {
          this.$refs.okexTradeOrderAlgoForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexTradeOrderAlgo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeOrderAlgoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'instType': res.object.instType,
              'instId': res.object.instId,
              'ccy': res.object.ccy,
              'ordId': res.object.ordId,
              'algoId': res.object.algoId,
              'sz': res.object.sz,
              'ordType': res.object.ordType,
              'side': res.object.side,
              'posSide': res.object.posSide,
              'tdMode': res.object.tdMode,
              'state': res.object.state,
              'lever': res.object.lever,
              'tpTriggerPx': res.object.tpTriggerPx,
              'tpOrdPx': res.object.tpOrdPx,
              'slTriggerPx': res.object.slTriggerPx,
              'slOrdPx': res.object.slOrdPx,
              'triggerPx': res.object.triggerPx,
              'ordPx': res.object.ordPx,
              'actualSz': res.object.actualSz,
              'actualPx': res.object.actualPx,
              'actualSide': res.object.actualSide,
              'triggerTime': res.object.triggerTime,
              'cTime': res.object.cTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexTradeOrderAlgoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexTradeOrderAlgo/save',
              method: 'post',
              data: this.okexTradeOrderAlgoForm
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
            this.okexTradeOrderAlgoDialog = false;
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
            url: '/digitalcurrency/okex/okexTradeOrderAlgo/del',
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
  .okexTradeOrderAlgoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
