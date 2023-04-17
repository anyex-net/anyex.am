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
      <el-form-item label="市场代码">
        <el-select v-model="searchForm.marketID" clearable placeholder="请输入市场代码">
          <el-option v-for="data in dicts['marketID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="stpNpSpotShareHolderAccountLoading"
      :data="stpNpSpotShareHolderAccountData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者代码" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat" />
      <el-table-column prop="shareholderID" label="股东账户" />
      <el-table-column prop="shareholderIDType" label="股东账户类型" :formatter="statusFormat" />
      <el-table-column prop="marketID" label="市场代码" :formatter="statusFormat" />
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
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
    <el-dialog
      title="内盘现货股东账户表管理"
      :visible.sync="stpNpSpotShareHolderAccountDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="stpNpSpotShareHolderAccountForm"
        :model="stpNpSpotShareHolderAccountForm"
        label-width="150px"
        class="stpNpSpotShareHolderAccountForm"
      >
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="stpNpSpotShareHolderAccountForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="stpNpSpotShareHolderAccountForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="投资者代码" prop="investorID">
          <el-input v-model="stpNpSpotShareHolderAccountForm.investorID" placeholder="请输入投资者代码" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="stpNpSpotShareHolderAccountForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="股东账户" prop="shareholderID">
          <el-input v-model="stpNpSpotShareHolderAccountForm.shareholderID" placeholder="请输入股东账户" />
        </el-form-item>
        <el-form-item label="股东账户类型" prop="shareholderIDType">
          <el-input v-model="stpNpSpotShareHolderAccountForm.shareholderIDType" placeholder="请输入股东账户类型" />
        </el-form-item>
        <el-form-item label="市场代码" prop="marketID">
          <el-input v-model="stpNpSpotShareHolderAccountForm.marketID" placeholder="请输入市场代码"/>
        </el-form-item>
        <el-form-item label="普通买卖白名单控制标志(两融专用)" prop="bSWhiteListCtl">
          <el-input v-model="stpNpSpotShareHolderAccountForm.bSWhiteListCtl" placeholder="请输入普通买卖白名单控制标志(两融专用)" />
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('stpNpSpotShareHolderAccountForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotShareHolderAccountName',
  data() {
    return {
      stpNpSpotShareHolderAccountLoading: true,
      stpNpSpotShareHolderAccountDialog: false,
      stpNpSpotShareHolderAccountData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotShareHolderAccountForm: {
        'accountId': '',
        'investorID': '',
        'exchangeID': '',
        'marketID': ''
      },
      searchForm: {
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'shareholderID': '',
        'marketID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotShareHolderAccountRules: {
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
        shareholderID: [
          { required: true, message: '股东账户不可为空', trigger: 'change' }
        ],
        shareholderIDType: [
          { required: true, message: '股东账户类型不可为空', trigger: 'change' }
        ],
        marketID: [
          { required: true, message: '市场代码不可为空', trigger: 'change' }
        ],
        bSWhiteListCtl: [
          { required: true, message: '普通买卖白名单控制标志(两融专用)不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotShareHolderAccount',
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
      this.stpNpSpotShareHolderAccountLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotShareHolderAccount/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotShareHolderAccountData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotShareHolderAccountLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotShareHolderAccountForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'shareholderID': '',
        'shareholderIDType': '',
        'marketID': '',
        'bSWhiteListCtl': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotShareHolderAccountDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotShareHolderAccountForm) {
        this.$refs.stpNpSpotShareHolderAccountForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotShareHolderAccount/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotShareHolderAccountForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'exchangeID': res.object.exchangeID,
            'shareholderID': res.object.shareholderID,
            'shareholderIDType': res.object.shareholderIDType,
            'marketID': res.object.marketID,
            'bSWhiteListCtl': res.object.bSWhiteListCtl
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotShareHolderAccountDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotShareHolderAccount/save',
            method: 'post',
            data: this.stpNpSpotShareHolderAccountForm
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
          this.stpNpSpotShareHolderAccountDialog = false;
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
          url: '/npspot/stpNpSpotShareHolderAccount/del',
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
  .stpNpSpotShareHolderAccountForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
