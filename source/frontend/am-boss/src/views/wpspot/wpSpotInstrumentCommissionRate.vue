<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="投资者帐号">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者帐号"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="wpSpotInstrumentCommissionRateLoading" :data="wpSpotInstrumentCommissionRateData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
<!--          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>-->
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者帐号" />
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="investorRange" label="投资者范围" />
      <el-table-column prop="openRatioByMoney" label="开仓手续费率" />
      <el-table-column prop="openRatioByVolume" label="开仓手续费" />
      <el-table-column prop="closeRatioByMoney" label="平仓手续费率" />
      <el-table-column prop="closeRatioByVolume" label="平仓手续费" />
      <el-table-column prop="closeTodayRatioByMoney" label="平今手续费率" />
      <el-table-column prop="closeTodayRatioByVolume" label="平今手续费" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="bizType" label="业务类型" />
      <el-table-column prop="investUnitID" label="投资单元代码" />
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
    <el-dialog title="外盘现货合约手续费率表管理" :visible.sync="wpSpotInstrumentCommissionRateDialog" :close-on-click-modal="false" width="600">
      <el-form ref="wpSpotInstrumentCommissionRateForm" :model="wpSpotInstrumentCommissionRateForm" :rules="wpSpotInstrumentCommissionRateRules" label-width="150px" class="wpSpotInstrumentCommissionRateForm">
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="wpSpotInstrumentCommissionRateForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.investorID" placeholder="请输入投资者帐号" />
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.instrumentID" placeholder="请输入合约代码" />
        </el-form-item>
        <el-form-item label="投资者范围" prop="investorRange">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.investorRange" placeholder="请输入投资者范围" />
        </el-form-item>
        <el-form-item label="开仓手续费率" prop="openRatioByMoney">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.openRatioByMoney" placeholder="请输入开仓手续费率" />
        </el-form-item>
        <el-form-item label="开仓手续费" prop="openRatioByVolume">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.openRatioByVolume" placeholder="请输入开仓手续费" />
        </el-form-item>
        <el-form-item label="平仓手续费率" prop="closeRatioByMoney">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.closeRatioByMoney" placeholder="请输入平仓手续费率" />
        </el-form-item>
        <el-form-item label="平仓手续费" prop="closeRatioByVolume">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.closeRatioByVolume" placeholder="请输入平仓手续费" />
        </el-form-item>
        <el-form-item label="平今手续费率" prop="closeTodayRatioByMoney">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.closeTodayRatioByMoney" placeholder="请输入平今手续费率" />
        </el-form-item>
        <el-form-item label="平今手续费" prop="closeTodayRatioByVolume">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.closeTodayRatioByVolume" placeholder="请输入平今手续费" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="业务类型" prop="bizType">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.bizType" placeholder="请输入业务类型" />
        </el-form-item>
        <el-form-item label="投资单元代码" prop="investUnitID">
          <el-input v-model="wpSpotInstrumentCommissionRateForm.investUnitID" placeholder="请输入投资单元代码" />
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpSpotInstrumentCommissionRateName',
  data() {
    return {
      wpSpotInstrumentCommissionRateLoading: true,
      wpSpotInstrumentCommissionRateDialog: false,
      wpSpotInstrumentCommissionRateData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpSpotInstrumentCommissionRateForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'instrumentID': '',
        'investorRange': '',
        'openRatioByMoney': '',
        'openRatioByVolume': '',
        'closeRatioByMoney': '',
        'closeRatioByVolume': '',
        'closeTodayRatioByMoney': '',
        'closeTodayRatioByVolume': '',
        'exchangeID': '',
        'bizType': '',
        'investUnitID': ''
      },
      searchForm: {
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'instrumentID': '',
        'exchangeID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpSpotInstrumentCommissionRateRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者帐号不可为空', trigger: 'change' }
        ],
        openRatioByMoney: [
          { required: true, message: '开仓手续费率不可为空', trigger: 'change' }
        ],
        openRatioByVolume: [
          { required: true, message: '开仓手续费不可为空', trigger: 'change' }
        ],
        closeRatioByMoney: [
          { required: true, message: '平仓手续费率不可为空', trigger: 'change' }
        ],
        closeRatioByVolume: [
          { required: true, message: '平仓手续费不可为空', trigger: 'change' }
        ],
        closeTodayRatioByMoney: [
          { required: true, message: '平今手续费率不可为空', trigger: 'change' }
        ],
        closeTodayRatioByVolume: [
          { required: true, message: '平今手续费不可为空', trigger: 'change' }
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
        url: '/wpspot/dict/wpSpotInstrumentCommissionRate',
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
      this.wpSpotInstrumentCommissionRateLoading = true;
      this.$http({
        url: '/wpspot/wpSpotInstrumentCommissionRate/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotInstrumentCommissionRateData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpSpotInstrumentCommissionRateLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpSpotInstrumentCommissionRateForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'instrumentID': '',
        'investorRange': '',
        'openRatioByMoney': '',
        'openRatioByVolume': '',
        'closeRatioByMoney': '',
        'closeRatioByVolume': '',
        'closeTodayRatioByMoney': '',
        'closeTodayRatioByVolume': '',
        'exchangeID': '',
        'bizType': '',
        'investUnitID': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpSpotInstrumentCommissionRateDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpSpotInstrumentCommissionRateForm) {
        this.$refs.wpSpotInstrumentCommissionRateForm.resetFields();
      }
      this.$http({
        url: '/wpspot/wpSpotInstrumentCommissionRate/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotInstrumentCommissionRateForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'instrumentID': res.object.instrumentID,
            'investorRange': res.object.investorRange,
            'openRatioByMoney': res.object.openRatioByMoney,
            'openRatioByVolume': res.object.openRatioByVolume,
            'closeRatioByMoney': res.object.closeRatioByMoney,
            'closeRatioByVolume': res.object.closeRatioByVolume,
            'closeTodayRatioByMoney': res.object.closeTodayRatioByMoney,
            'closeTodayRatioByVolume': res.object.closeTodayRatioByVolume,
            'exchangeID': res.object.exchangeID,
            'bizType': res.object.bizType,
            'investUnitID': res.object.investUnitID
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpSpotInstrumentCommissionRateDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/wpSpotInstrumentCommissionRate/save',
            method: 'post',
            data: this.wpSpotInstrumentCommissionRateForm
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
          this.wpSpotInstrumentCommissionRateDialog = false;
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
          url: '/wpspot/wpSpotInstrumentCommissionRate/del',
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
		.wpSpotInstrumentCommissionRateForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
