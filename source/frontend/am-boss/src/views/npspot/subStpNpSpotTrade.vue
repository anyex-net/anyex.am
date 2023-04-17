<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-select v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码">
          <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="买卖方向">
        <el-select v-model="searchForm.direction" clearable placeholder="请选择买卖方向">
          <el-option v-for="data in dicts['direction']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table
      v-loading="subStpNpSpotTradeLoading"
      :data="subStpNpSpotTradeData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="150">
      <template slot-scope="scope">
        <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
<!--        <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>-->
        <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
      </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" width="150"/>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" width="150"/>
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="businessUnitID" label="投资单元代码" />
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="tradeID" label="成交编号" />
      <el-table-column prop="direction" label="买卖方向" :formatter="statusFormat"/>
      <el-table-column prop="orderSysID" label="系统报单编号" />
      <el-table-column prop="orderLocalID" label="本地报单编号" />
      <el-table-column prop="price" label="成交价格" />
      <el-table-column prop="volume" label="成交数量" />
      <el-table-column prop="tradeDate" label="成交日期" />
      <el-table-column prop="tradeTime" label="成交时间" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="pbuID" label="交易单元代码" />
      <el-table-column prop="orderRef" label="报单引用" />
      <el-table-column prop="currencyID" label="币种" :formatter="statusFormat"/>
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
    <el-dialog title="子账户成交表管理" :visible.sync="subStpNpSpotTradeDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="subStpNpSpotTradeForm"
        :model="subStpNpSpotTradeForm"
        :rules="subStpNpSpotTradeRules"
        label-width="150px"
        class="subStpNpSpotTradeForm"
      >
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="subStpNpSpotTradeForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subStpNpSpotTradeForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-select v-model="subStpNpSpotTradeForm.exchangeID" clearable placeholder="请输入交易所代码">
            <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="投资单元代码" prop="businessUnitID">
          <el-input v-model="subStpNpSpotTradeForm.businessUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="subStpNpSpotTradeForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="成交编号" prop="tradeID">
          <el-input v-model="subStpNpSpotTradeForm.tradeID" placeholder="请输入成交编号" />
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-select v-model="subStpNpSpotTradeForm.direction" clearable placeholder="请输入买卖方向">
            <el-option v-for="data in dicts['direction']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="系统报单编号" prop="orderSysID">
          <el-input v-model="subStpNpSpotTradeForm.orderSysID" placeholder="请输入系统报单编号" />
        </el-form-item>
        <el-form-item label="本地报单编号" prop="orderLocalID">
          <el-input v-model="subStpNpSpotTradeForm.orderLocalID" placeholder="请输入本地报单编号" />
        </el-form-item>
        <el-form-item label="成交价格" prop="price">
          <el-input v-model="subStpNpSpotTradeForm.price" placeholder="请输入成交价格" />
        </el-form-item>
        <el-form-item label="成交数量" prop="volume">
          <el-input v-model="subStpNpSpotTradeForm.volume" placeholder="请输入成交数量" />
        </el-form-item>
        <el-form-item label="成交日期" prop="tradeDate">
          <el-input v-model="subStpNpSpotTradeForm.tradeDate" placeholder="请输入成交日期" />
        </el-form-item>
        <el-form-item label="成交时间" prop="tradeTime">
          <el-input v-model="subStpNpSpotTradeForm.tradeTime" placeholder="请输入成交时间" />
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="subStpNpSpotTradeForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="交易单元代码" prop="pbuID">
          <el-input v-model="subStpNpSpotTradeForm.pbuID" placeholder="请输入交易单元代码" />
        </el-form-item>
        <el-form-item label="报单引用" prop="orderRef">
          <el-input v-model="subStpNpSpotTradeForm.orderRef" placeholder="请输入报单引用" />
        </el-form-item>
        <el-form-item label="币种" prop="currencyID">
          <el-select v-model="subStpNpSpotTradeForm.currencyID" clearable placeholder="请输入币种">
            <el-option v-for="data in dicts['currencyID']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('subStpNpSpotTradeForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubStpNpSpotTradeName',
  data() {
    return {
      subStpNpSpotTradeLoading: true,
      subStpNpSpotTradeDialog: false,
      subStpNpSpotTradeData: [],
      commodityTypeSelects: [],
      dicts: [],
      subStpNpSpotTradeForm: {
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'businessUnitID': '',
        'securityID': '',
        'tradeID': '',
        'direction': '',
        'orderSysID': '',
        'orderLocalID': '',
        'price': '',
        'volume': '',
        'tradeDate': '',
        'tradeTime': '',
        'tradingDay': '',
        'pbuID': '',
        'orderRef': '',
        'currencyID': ''
      },
      searchForm: {
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'securityID': '',
        'tradeID': '',
        'direction': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subStpNpSpotTradeRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        businessUnitID: [
          { required: true, message: '投资单元代码不可为空', trigger: 'change' }
        ],
        securityID: [
          { required: true, message: '证券代码不可为空', trigger: 'change' }
        ],
        tradeID: [
          { required: true, message: '成交编号不可为空', trigger: 'change' }
        ],
        direction: [
          { required: true, message: '买卖方向不可为空', trigger: 'change' }
        ],
        orderSysID: [
          { required: true, message: '系统报单编号不可为空', trigger: 'change' }
        ],
        orderLocalID: [
          { required: true, message: '本地报单编号不可为空', trigger: 'change' }
        ],
        price: [
          { required: true, message: '成交价格不可为空', trigger: 'change' }
        ],
        volume: [
          { required: true, message: '成交数量不可为空', trigger: 'change' }
        ],
        tradeDate: [
          { required: true, message: '成交日期不可为空', trigger: 'change' }
        ],
        tradeTime: [
          { required: true, message: '成交时间不可为空', trigger: 'change' }
        ],
        tradingDay: [
          { required: true, message: '交易日不可为空', trigger: 'change' }
        ],
        pbuID: [
          { required: true, message: '交易单元代码不可为空', trigger: 'change' }
        ],
        orderRef: [
          { required: true, message: '报单引用不可为空', trigger: 'change' }
        ],
        currencyID: [
          { required: true, message: '币种不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotTrade',
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
      this.subStpNpSpotTradeLoading = true;
      this.$http({
        url: '/npspot/subStpNpSpotTrade/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotTradeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subStpNpSpotTradeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subStpNpSpotTradeForm = {
        'id': '',
        'subAccountId': '',
        'exchangeID': '',
        'businessUnitID': '',
        'securityID': '',
        'tradeID': '',
        'direction': '',
        'orderSysID': '',
        'orderLocalID': '',
        'price': '',
        'volume': '',
        'tradeDate': '',
        'tradeTime': '',
        'tradingDay': '',
        'pbuID': '',
        'orderRef': '',
        'currencyID': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subStpNpSpotTradeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subStpNpSpotTradeForm) {
        this.$refs.subStpNpSpotTradeForm.resetFields();
      }
      this.$http({
        url: '/npspot/subStpNpSpotTrade/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotTradeForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
            'exchangeID': res.object.exchangeID,
            'businessUnitID': res.object.businessUnitID,
            'securityID': res.object.securityID,
            'tradeID': res.object.tradeID,
            'direction': res.object.direction,
            'orderSysID': res.object.orderSysID,
            'orderLocalID': res.object.orderLocalID,
            'price': res.object.price,
            'volume': res.object.volume,
            'tradeDate': res.object.tradeDate,
            'tradeTime': res.object.tradeTime,
            'tradingDay': res.object.tradingDay,
            'pbuID': res.object.pbuID,
            'orderRef': res.object.orderRef,
            'currencyID': res.object.currencyID
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subStpNpSpotTradeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/subStpNpSpotTrade/save',
            method: 'post',
            data: this.subStpNpSpotTradeForm
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
          this.subStpNpSpotTradeDialog = false;
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
          url: '/npspot/subStpNpSpotTrade/del',
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
  .subStpNpSpotTradeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
