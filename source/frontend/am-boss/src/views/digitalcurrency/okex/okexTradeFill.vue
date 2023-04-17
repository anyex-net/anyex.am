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
      <el-form-item label="订单 ID">
        <el-input v-model="searchForm.ordId" clearable placeholder="请输入订单 ID"></el-input>
      </el-form-item>
      <el-form-item label="订单方向">
        <el-select v-model="searchForm.side" clearable placeholder="请输入订单方向">
          <el-option v-for="data in sideList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="持仓方向">
        <el-select v-model="searchForm.posSide" clearable placeholder="请输入持仓方向">
          <el-option v-for="data in posSideList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="流动性方向">
        <el-input v-model="searchForm.execType" clearable placeholder="请输入流动性方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexTradeFillLoading"
      :data="okexTradeFillData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="instType" label="产品类型" :formatter="statusFormat"/>
      <el-table-column prop="instId" label="产品 ID"/>
      <el-table-column prop="tradeId" label="最新成交 ID"/>
      <el-table-column prop="ordId" label="订单 ID"/>
      <el-table-column prop="billId" label="账单 ID"/>
      <el-table-column prop="tag" label="订单标签"/>
      <el-table-column prop="fillPx" label="最新成交价格"/>
      <el-table-column prop="fillSz" label="最新成交数量"/>
      <el-table-column prop="side" label="订单方向" :formatter="statusFormat"/>
      <el-table-column prop="posSide" label="持仓方向" :formatter="statusFormat"/>
      <el-table-column prop="execType" label="流动性方向"/>
      <el-table-column prop="feeCcy" label="交易手续费币种或者返佣金币种"/>
      <el-table-column prop="fee" label="手续费金额或者返佣金额"/>
      <el-table-column prop="ts" label="成交明细产生时间" :formatter="dateFormat"/>
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
    <el-dialog title="账户成交明细管理" :visible.sync="okexTradeFillDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexTradeFillForm"
        :model="okexTradeFillForm"
        :rules="okexTradeFillRules"
        label-width="150px"
        class="okexTradeFillForm"
      >
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexTradeFillForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexTradeFillForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="产品类型" prop="instType">
          <el-input v-model="okexTradeFillForm.instType" placeholder="请输入产品类型"/>
        </el-form-item>
        <el-form-item label="产品 ID" prop="instId">
          <el-input v-model="okexTradeFillForm.instId" placeholder="请输入产品 ID"/>
        </el-form-item>
        <el-form-item label="最新成交 ID" prop="tradeId">
          <el-input v-model="okexTradeFillForm.tradeId" placeholder="请输入最新成交 ID"/>
        </el-form-item>
        <el-form-item label="订单 ID" prop="ordId">
          <el-input v-model="okexTradeFillForm.ordId" placeholder="请输入订单 ID"/>
        </el-form-item>
        <el-form-item label="账单 ID" prop="billId">
          <el-input v-model="okexTradeFillForm.billId" placeholder="请输入账单 ID"/>
        </el-form-item>
        <el-form-item label="订单标签" prop="tag">
          <el-input v-model="okexTradeFillForm.tag" placeholder="请输入订单标签"/>
        </el-form-item>
        <el-form-item label="最新成交价格" prop="fillPx">
          <el-input v-model="okexTradeFillForm.fillPx" placeholder="请输入最新成交价格"/>
        </el-form-item>
        <el-form-item label="最新成交数量" prop="fillSz">
          <el-input v-model="okexTradeFillForm.fillSz" placeholder="请输入最新成交数量"/>
        </el-form-item>
        <el-form-item label="订单方向" prop="side">
          <el-input v-model="okexTradeFillForm.side" placeholder="请输入订单方向"/>
        </el-form-item>
        <el-form-item label="持仓方向" prop="posSide">
          <el-input v-model="okexTradeFillForm.posSide" placeholder="请输入持仓方向"/>
        </el-form-item>
        <el-form-item label="流动性方向" prop="execType">
          <el-input v-model="okexTradeFillForm.execType" placeholder="请输入流动性方向"/>
        </el-form-item>
        <el-form-item label="交易手续费币种或者返佣金币种" prop="feeCcy">
          <el-input v-model="okexTradeFillForm.feeCcy" placeholder="请输入交易手续费币种或者返佣金币种"/>
        </el-form-item>
        <el-form-item label="手续费金额或者返佣金额" prop="fee">
          <el-input v-model="okexTradeFillForm.fee" placeholder="请输入手续费金额或者返佣金额"/>
        </el-form-item>
        <el-form-item label="成交明细产生时间" prop="ts">
          <el-input v-model="okexTradeFillForm.ts" placeholder="请输入成交明细产生时间"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexTradeFillName',
    data() {
      return {
        okexTradeFillLoading: true,
        okexTradeFillDialog: false,
        okexTradeFillData: [],
        commodityTypeSelects: [],
        dicts: [],
        instTypeList: [],
        sideList: [],
        posSideList: [],
        okexTradeFillForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'tradeId': '',
          'ordId': '',
          'billId': '',
          'tag': '',
          'fillPx': '',
          'fillSz': '',
          'side': '',
          'posSide': '',
          'execType': '',
          'feeCcy': '',
          'fee': '',
          'ts': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'tradeId': '',
          'ordId': '',
          'billId': '',
          'tag': '',
          'fillPx': '',
          'fillSz': '',
          'side': '',
          'posSide': '',
          'execType': '',
          'feeCcy': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexTradeFillRules: {
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
          url: '/digitalcurrency/okex/dict/okexTradeFill',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.posSideList = res.object.list.posSide.list
            this.instTypeList = res.object.list.instType.list
            this.sideList = res.object.list.side.list
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
        this.okexTradeFillLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexTradeFill/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeFillData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexTradeFillLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexTradeFillForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'instId': '',
          'tradeId': '',
          'ordId': '',
          'billId': '',
          'tag': '',
          'fillPx': '',
          'fillSz': '',
          'side': '',
          'posSide': '',
          'execType': '',
          'feeCcy': '',
          'fee': '',
          'ts': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexTradeFillDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexTradeFillForm) {
          this.$refs.okexTradeFillForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexTradeFill/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexTradeFillForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'instType': res.object.instType,
              'instId': res.object.instId,
              'tradeId': res.object.tradeId,
              'ordId': res.object.ordId,
              'billId': res.object.billId,
              'tag': res.object.tag,
              'fillPx': res.object.fillPx,
              'fillSz': res.object.fillSz,
              'side': res.object.side,
              'posSide': res.object.posSide,
              'execType': res.object.execType,
              'feeCcy': res.object.feeCcy,
              'fee': res.object.fee,
              'ts': res.object.ts
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexTradeFillDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexTradeFill/save',
              method: 'post',
              data: this.okexTradeFillForm
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
            this.okexTradeFillDialog = false;
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
            url: '/digitalcurrency/okex/okexTradeFill/del',
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
  .okexTradeFillForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
