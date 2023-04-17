<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="投资者代码">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者代码"></el-input>
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
      </el-form-item>
    </el-form>
    <el-table
      v-loading="stpNpSpotTradeLoading"
      :data="stpNpSpotTradeData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat" />
      <el-table-column prop="departmentID" label="经纪公司部门代码" />
      <el-table-column prop="businessUnitID" label="投资单元代码" />
      <el-table-column prop="shareholderID" label="股东账户代码" />
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="tradeID" label="成交编号" />
      <el-table-column prop="direction" label="买卖方向" :formatter="statusFormat" />
      <el-table-column prop="orderSysID" label="系统报单编号" />
      <el-table-column prop="orderLocalID" label="本地报单编号" />
      <el-table-column prop="price" label="成交价格" />
      <el-table-column prop="volume" label="成交数量" />
      <el-table-column prop="tradeDate" label="成交日期" />
      <el-table-column prop="tradeTime" label="成交时间" />
      <el-table-column prop="tradingDay" label="交易日" />
      <el-table-column prop="pbuID" label="交易单元代码" />
      <el-table-column prop="orderRef" label="报单引用" />
      <el-table-column prop="accountNo" label="资金账户代码(对应AccountID)" />
      <el-table-column prop="currencyID" label="币种" :formatter="statusFormat" />
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
    <el-dialog title="内盘现货成交表管理" :visible.sync="stpNpSpotTradeDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="stpNpSpotTradeForm"
        :model="stpNpSpotTradeForm"
        label-width="150px"
        class="stpNpSpotTradeForm"
      >
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="stpNpSpotTradeForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="stpNpSpotTradeForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="投资者代码" prop="investorID">
          <el-input v-model="stpNpSpotTradeForm.investorID" placeholder="请输入投资者代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="stpNpSpotTradeForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="经纪公司部门代码" prop="departmentID">
          <el-input v-model="stpNpSpotTradeForm.departmentID" placeholder="请输入经纪公司部门代码" />
        </el-form-item>
        <el-form-item label="投资单元代码" prop="businessUnitID">
          <el-input v-model="stpNpSpotTradeForm.businessUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
        <el-form-item label="股东账户代码" prop="shareholderID">
          <el-input v-model="stpNpSpotTradeForm.shareholderID" placeholder="请输入股东账户代码" />
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="stpNpSpotTradeForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="成交编号" prop="tradeID">
          <el-input v-model="stpNpSpotTradeForm.tradeID" placeholder="请输入成交编号" />
        </el-form-item>
        <el-form-item label="买卖方向" prop="direction">
          <el-input v-model="stpNpSpotTradeForm.direction" placeholder="请输入买卖方向" />
        </el-form-item>
        <el-form-item label="系统报单编号" prop="orderSysID">
          <el-input v-model="stpNpSpotTradeForm.orderSysID" placeholder="请输入系统报单编号" />
        </el-form-item>
        <el-form-item label="本地报单编号" prop="orderLocalID">
          <el-input v-model="stpNpSpotTradeForm.orderLocalID" placeholder="请输入本地报单编号" />
        </el-form-item>
        <el-form-item label="成交价格" prop="price">
          <el-input v-model="stpNpSpotTradeForm.price" placeholder="请输入成交价格" />
        </el-form-item>
        <el-form-item label="成交数量" prop="volume">
          <el-input v-model="stpNpSpotTradeForm.volume" placeholder="请输入成交数量" />
        </el-form-item>
        <el-form-item label="成交日期" prop="tradeDate">
          <el-input v-model="stpNpSpotTradeForm.tradeDate" placeholder="请输入成交日期" />
        </el-form-item>
        <el-form-item label="成交时间" prop="tradeTime">
          <el-input v-model="stpNpSpotTradeForm.tradeTime" placeholder="请输入成交时间" />
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="stpNpSpotTradeForm.tradingDay" placeholder="请输入交易日" />
        </el-form-item>
        <el-form-item label="交易单元代码" prop="pbuID">
          <el-input v-model="stpNpSpotTradeForm.pbuID" placeholder="请输入交易单元代码" />
        </el-form-item>
        <el-form-item label="报单引用" prop="orderRef">
          <el-input v-model="stpNpSpotTradeForm.orderRef" placeholder="请输入报单引用" />
        </el-form-item>
        <el-form-item label="资金账户代码(对应AccountID)" prop="accountNo">
          <el-input v-model="stpNpSpotTradeForm.accountNo" placeholder="请输入资金账户代码(对应AccountID)" />
        </el-form-item>
        <el-form-item label="币种" prop="currencyID">
          <el-input v-model="stpNpSpotTradeForm.currencyID" placeholder="请输入币种" />
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('stpNpSpotTradeForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotTradeName',
  data() {
    return {
      stpNpSpotTradeLoading: true,
      stpNpSpotTradeDialog: false,
      stpNpSpotTradeData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotTradeForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'departmentID': '',
        'businessUnitID': '',
        'shareholderID': '',
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
        'accountNo': '',
        'currencyID': ''
      },
      searchForm: {
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'securityID': '',
        'currencyID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotTradeRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者代码不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        departmentID: [
          { required: true, message: '经纪公司部门代码不可为空', trigger: 'change' }
        ],
        businessUnitID: [
          { required: true, message: '投资单元代码不可为空', trigger: 'change' }
        ],
        shareholderID: [
          { required: true, message: '股东账户代码不可为空', trigger: 'change' }
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
        accountNo: [
          { required: true, message: '资金账户代码(对应AccountID)不可为空', trigger: 'change' }
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
      this.stpNpSpotTradeLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotTrade/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotTradeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotTradeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotTradeForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'departmentID': '',
        'businessUnitID': '',
        'shareholderID': '',
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
        'accountNo': '',
        'currencyID': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotTradeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotTradeForm) {
        this.$refs.stpNpSpotTradeForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotTrade/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotTradeForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'exchangeID': res.object.exchangeID,
            'departmentID': res.object.departmentID,
            'businessUnitID': res.object.businessUnitID,
            'shareholderID': res.object.shareholderID,
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
            'accountNo': res.object.accountNo,
            'currencyID': res.object.currencyID
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotTradeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotTrade/save',
            method: 'post',
            data: this.stpNpSpotTradeForm
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
          this.stpNpSpotTradeDialog = false;
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
          url: '/npspot/stpNpSpotTrade/del',
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
  .stpNpSpotTradeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
