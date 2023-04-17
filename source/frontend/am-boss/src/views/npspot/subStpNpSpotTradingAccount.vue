<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="subStpNpSpotTradingAccountLoading"
      :data="subStpNpSpotTradingAccountData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" width="150"/>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" width="150"/>
      <el-table-column prop="currencyID" label="币种代码" :formatter="statusFormat"/>
      <el-table-column prop="preDeposit" label="上日结存" />
      <el-table-column prop="usefulMoney" label="可用资金" />
      <el-table-column prop="fetchLimit" label="可取资金" />
      <el-table-column prop="preUnDeliveredMoney" label="上日未交收金额(港股通专用字段)" />
      <el-table-column prop="unDeliveredMoney" label="可用未交收金额(港股通专用字段)" />
      <el-table-column prop="deposit" label="当日入金金额" />
      <el-table-column prop="withdraw" label="当日出金金额" />
      <el-table-column prop="frozenCash" label="冻结的资金(港股通该字段不包括未交收部分冻结资金)" />
      <el-table-column prop="unDeliveredFrozenCash" label="冻结未交收金额(港股通专用)" />
      <el-table-column prop="frozenCommission" label="冻结的手续费(港股通该字段不包括未交收部分冻结手续费)" />
      <el-table-column prop="unDeliveredFrozenCommission" label="冻结未交收手续费(港股通专用)" />
      <el-table-column prop="commission" label="手续费(港股通该字段不包括未交收部分手续费)" />
      <el-table-column prop="unDeliveredCommission" label="占用未交收手续费(港股通专用)" />
      <el-table-column prop="accountType" label="资金账户类型" :formatter="statusFormat"/>
      <el-table-column prop="bankID" label="银行代码" :formatter="statusFormat"/>
      <el-table-column prop="bankAccountID" label="银行账户" />
      <el-table-column prop="royaltyIn" label="权利金收入(两融专用)" />
      <el-table-column prop="royaltyOut" label="权利金支出(两融专用)" />
      <el-table-column prop="creditSellAmount" label="融券卖出金额(两融专用)" />
      <el-table-column prop="creditSellUseAmount" label="融券卖出使用金额(用于偿还融资负债或买特殊品种的金额)(两融专用)" />
      <el-table-column prop="virtualAssets" label="虚拟资产(两融专用)" />
      <el-table-column prop="creditSellFrozenAmount" label="融券卖出金额冻结(用于偿还融资负债或买特殊品种的未成交冻结金额)(两融专用)" />
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
      title="子账户资金账户息表管理"
      :visible.sync="subStpNpSpotTradingAccountDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="subStpNpSpotTradingAccountForm"
        :model="subStpNpSpotTradingAccountForm"
        :rules="subStpNpSpotTradingAccountRules"
        label-width="200px"
        class="subStpNpSpotTradingAccountForm"
      >
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="subStpNpSpotTradingAccountForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subStpNpSpotTradingAccountForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
        </el-form-item>
        <el-form-item label="币种代码" prop="currencyID">
          <el-select v-model="subStpNpSpotTradingAccountForm.currencyID" clearable placeholder="请输入币种代码">
            <el-option v-for="data in dicts['currencyID']" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="上日结存" prop="preDeposit">
          <el-input v-model="subStpNpSpotTradingAccountForm.preDeposit" placeholder="请输入上日结存" />
        </el-form-item>
        <el-form-item label="可用资金" prop="usefulMoney">
          <el-input v-model="subStpNpSpotTradingAccountForm.usefulMoney" placeholder="请输入可用资金" />
        </el-form-item>
        <el-form-item label="可取资金" prop="fetchLimit">
          <el-input v-model="subStpNpSpotTradingAccountForm.fetchLimit" placeholder="请输入可取资金" />
        </el-form-item>
        <el-form-item label="上日未交收金额(港股通专用字段)" prop="preUnDeliveredMoney">
          <el-input v-model="subStpNpSpotTradingAccountForm.preUnDeliveredMoney" placeholder="请输入上日未交收金额(港股通专用字段)" />
        </el-form-item>
        <el-form-item label="可用未交收金额(港股通专用字段)" prop="unDeliveredMoney">
          <el-input v-model="subStpNpSpotTradingAccountForm.unDeliveredMoney" placeholder="请输入可用未交收金额(港股通专用字段)" />
        </el-form-item>
        <el-form-item label="当日入金金额" prop="deposit">
          <el-input v-model="subStpNpSpotTradingAccountForm.deposit" placeholder="请输入当日入金金额" />
        </el-form-item>
        <el-form-item label="当日出金金额" prop="withdraw">
          <el-input v-model="subStpNpSpotTradingAccountForm.withdraw" placeholder="请输入当日出金金额" />
        </el-form-item>
        <el-form-item label="冻结的资金(港股通该字段不包括未交收部分冻结资金)" prop="frozenCash">
          <el-input v-model="subStpNpSpotTradingAccountForm.frozenCash" placeholder="请输入冻结的资金(港股通该字段不包括未交收部分冻结资金)" />
        </el-form-item>
        <el-form-item label="冻结未交收金额(港股通专用)" prop="unDeliveredFrozenCash">
          <el-input v-model="subStpNpSpotTradingAccountForm.unDeliveredFrozenCash" placeholder="请输入冻结未交收金额(港股通专用)" />
        </el-form-item>
        <el-form-item label="冻结的手续费(港股通该字段不包括未交收部分冻结手续费)" prop="frozenCommission">
          <el-input
            v-model="subStpNpSpotTradingAccountForm.frozenCommission"
            placeholder="请输入冻结的手续费(港股通该字段不包括未交收部分冻结手续费)"
          />
        </el-form-item>
        <el-form-item label="冻结未交收手续费(港股通专用)" prop="unDeliveredFrozenCommission">
          <el-input
            v-model="subStpNpSpotTradingAccountForm.unDeliveredFrozenCommission"
            placeholder="请输入冻结未交收手续费(港股通专用)"
          />
        </el-form-item>
        <el-form-item label="手续费(港股通该字段不包括未交收部分手续费)" prop="commission">
          <el-input v-model="subStpNpSpotTradingAccountForm.commission" placeholder="请输入手续费(港股通该字段不包括未交收部分手续费)" />
        </el-form-item>
        <el-form-item label="占用未交收手续费(港股通专用)" prop="unDeliveredCommission">
          <el-input v-model="subStpNpSpotTradingAccountForm.unDeliveredCommission" placeholder="请输入占用未交收手续费(港股通专用)" />
        </el-form-item>
        <el-form-item label="资金账户类型" prop="accountType">
          <el-select v-model="subStpNpSpotTradingAccountForm.accountType" clearable placeholder="请输入资金账户类型">
            <el-option v-for="data in dicts['accountType']" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="银行代码" prop="bankID">
          <el-select v-model="subStpNpSpotTradingAccountForm.bankID" clearable placeholder="请输入银行代码">
            <el-option v-for="data in dicts['bankID']" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="银行账户" prop="bankAccountID">
          <el-input v-model="subStpNpSpotTradingAccountForm.bankAccountID" placeholder="请输入银行账户" />
        </el-form-item>
        <el-form-item label="权利金收入(两融专用)" prop="royaltyIn">
          <el-input v-model="subStpNpSpotTradingAccountForm.royaltyIn" placeholder="请输入权利金收入(两融专用)" />
        </el-form-item>
        <el-form-item label="权利金支出(两融专用)" prop="royaltyOut">
          <el-input v-model="subStpNpSpotTradingAccountForm.royaltyOut" placeholder="请输入权利金支出(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出金额(两融专用)" prop="creditSellAmount">
          <el-input v-model="subStpNpSpotTradingAccountForm.creditSellAmount" placeholder="请输入融券卖出金额(两融专用)" />
        </el-form-item>
        <el-form-item label="融券卖出使用金额(两融专用)" prop="creditSellUseAmount">
          <el-input
            v-model="subStpNpSpotTradingAccountForm.creditSellUseAmount"
            placeholder="请输入融券卖出使用金额(两融专用)"
          />
        </el-form-item>
        <el-form-item label="虚拟资产(两融专用)" prop="virtualAssets">
          <el-input v-model="subStpNpSpotTradingAccountForm.virtualAssets" placeholder="请输入虚拟资产(两融专用)"/>
        </el-form-item>
        <el-form-item label="融券卖出金额冻结(两融专用)" prop="creditSellFrozenAmount">
          <el-input
            v-model="subStpNpSpotTradingAccountForm.creditSellFrozenAmount"
            placeholder="请输入融券卖出金额冻结(两融专用)"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('subStpNpSpotTradingAccountForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubStpNpSpotTradingAccountName',
  data() {
    return {
      subStpNpSpotTradingAccountLoading: true,
      subStpNpSpotTradingAccountDialog: false,
      subStpNpSpotTradingAccountData: [],
      commodityTypeSelects: [],
      dicts: [],
      subStpNpSpotTradingAccountForm: {
        'id': '',
        'subAccountId': '',
        'currencyID': '',
        'preDeposit': '',
        'usefulMoney': '',
        'fetchLimit': '',
        'preUnDeliveredMoney': '',
        'unDeliveredMoney': '',
        'deposit': '',
        'withdraw': '',
        'frozenCash': '',
        'unDeliveredFrozenCash': '',
        'frozenCommission': '',
        'unDeliveredFrozenCommission': '',
        'commission': '',
        'unDeliveredCommission': '',
        'accountType': '',
        'bankID': '',
        'bankAccountID': '',
        'royaltyIn': '',
        'royaltyOut': '',
        'creditSellAmount': '',
        'creditSellUseAmount': '',
        'virtualAssets': '',
        'creditSellFrozenAmount': ''
      },
      searchForm: {
        'id': '',
        'subAccountId': '',
        'currencyID': '',
        'preDeposit': '',
        'usefulMoney': '',
        'fetchLimit': '',
        'preUnDeliveredMoney': '',
        'unDeliveredMoney': '',
        'deposit': '',
        'withdraw': '',
        'frozenCash': '',
        'unDeliveredFrozenCash': '',
        'frozenCommission': '',
        'unDeliveredFrozenCommission': '',
        'commission': '',
        'unDeliveredCommission': '',
        'accountType': '',
        'bankID': '',
        'bankAccountID': '',
        'royaltyIn': '',
        'royaltyOut': '',
        'creditSellAmount': '',
        'creditSellUseAmount': '',
        'virtualAssets': '',
        'creditSellFrozenAmount': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subStpNpSpotTradingAccountRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
        ],
        currencyID: [
          { required: true, message: '币种代码不可为空', trigger: 'change' }
        ],
        preDeposit: [
          { required: true, message: '上日结存不可为空', trigger: 'change' }
        ],
        usefulMoney: [
          { required: true, message: '可用资金不可为空', trigger: 'change' }
        ],
        fetchLimit: [
          { required: true, message: '可取资金不可为空', trigger: 'change' }
        ],
        preUnDeliveredMoney: [
          { required: true, message: '上日未交收金额(港股通专用字段)不可为空', trigger: 'change' }
        ],
        unDeliveredMoney: [
          { required: true, message: '可用未交收金额(港股通专用字段)不可为空', trigger: 'change' }
        ],
        deposit: [
          { required: true, message: '当日入金金额不可为空', trigger: 'change' }
        ],
        withdraw: [
          { required: true, message: '当日出金金额不可为空', trigger: 'change' }
        ],
        frozenCash: [
          { required: true, message: '冻结的资金(港股通该字段不包括未交收部分冻结资金)不可为空', trigger: 'change' }
        ],
        unDeliveredFrozenCash: [
          { required: true, message: '冻结未交收金额(港股通专用)不可为空', trigger: 'change' }
        ],
        frozenCommission: [
          { required: true, message: '冻结的手续费(港股通该字段不包括未交收部分冻结手续费)不可为空', trigger: 'change' }
        ],
        unDeliveredFrozenCommission: [
          { required: true, message: '冻结未交收手续费(港股通专用)不可为空', trigger: 'change' }
        ],
        commission: [
          { required: true, message: '手续费(港股通该字段不包括未交收部分手续费)不可为空', trigger: 'change' }
        ],
        unDeliveredCommission: [
          { required: true, message: '占用未交收手续费(港股通专用)不可为空', trigger: 'change' }
        ],
        accountType: [
          { required: true, message: '资金账户类型不可为空', trigger: 'change' }
        ],
        bankID: [
          { required: true, message: '银行代码不可为空', trigger: 'change' }
        ],
        bankAccountID: [
          { required: true, message: '银行账户不可为空', trigger: 'change' }
        ],
        royaltyIn: [
          { required: true, message: '权利金收入(两融专用)不可为空', trigger: 'change' }
        ],
        royaltyOut: [
          { required: true, message: '权利金支出(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellAmount: [
          { required: true, message: '融券卖出金额(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellUseAmount: [
          { required: true, message: '融券卖出使用金额(用于偿还融资负债或买特殊品种的金额)(两融专用)不可为空', trigger: 'change' }
        ],
        virtualAssets: [
          { required: true, message: '虚拟资产(两融专用)不可为空', trigger: 'change' }
        ],
        creditSellFrozenAmount: [
          { required: true, message: '融券卖出金额冻结(用于偿还融资负债或买特殊品种的未成交冻结金额)(两融专用)不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotTradingAccount',
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
      this.subStpNpSpotTradingAccountLoading = true;
      this.$http({
        url: '/npspot/subStpNpSpotTradingAccount/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotTradingAccountData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subStpNpSpotTradingAccountLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subStpNpSpotTradingAccountForm = {
        'id': '',
        'subAccountId': '',
        'currencyID': '',
        'preDeposit': '',
        'usefulMoney': '',
        'fetchLimit': '',
        'preUnDeliveredMoney': '',
        'unDeliveredMoney': '',
        'deposit': '',
        'withdraw': '',
        'frozenCash': '',
        'unDeliveredFrozenCash': '',
        'frozenCommission': '',
        'unDeliveredFrozenCommission': '',
        'commission': '',
        'unDeliveredCommission': '',
        'accountType': '',
        'bankID': '',
        'bankAccountID': '',
        'royaltyIn': '',
        'royaltyOut': '',
        'creditSellAmount': '',
        'creditSellUseAmount': '',
        'virtualAssets': '',
        'creditSellFrozenAmount': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subStpNpSpotTradingAccountDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subStpNpSpotTradingAccountForm) {
        this.$refs.subStpNpSpotTradingAccountForm.resetFields();
      }
      this.$http({
        url: '/npspot/subStpNpSpotTradingAccount/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotTradingAccountForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
            'currencyID': res.object.currencyID,
            'preDeposit': res.object.preDeposit,
            'usefulMoney': res.object.usefulMoney,
            'fetchLimit': res.object.fetchLimit,
            'preUnDeliveredMoney': res.object.preUnDeliveredMoney,
            'unDeliveredMoney': res.object.unDeliveredMoney,
            'deposit': res.object.deposit,
            'withdraw': res.object.withdraw,
            'frozenCash': res.object.frozenCash,
            'unDeliveredFrozenCash': res.object.unDeliveredFrozenCash,
            'frozenCommission': res.object.frozenCommission,
            'unDeliveredFrozenCommission': res.object.unDeliveredFrozenCommission,
            'commission': res.object.commission,
            'unDeliveredCommission': res.object.unDeliveredCommission,
            'accountType': res.object.accountType,
            'bankID': res.object.bankID,
            'bankAccountID': res.object.bankAccountID,
            'royaltyIn': res.object.royaltyIn,
            'royaltyOut': res.object.royaltyOut,
            'creditSellAmount': res.object.creditSellAmount,
            'creditSellUseAmount': res.object.creditSellUseAmount,
            'virtualAssets': res.object.virtualAssets,
            'creditSellFrozenAmount': res.object.creditSellFrozenAmount
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subStpNpSpotTradingAccountDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/subStpNpSpotTradingAccount/save',
            method: 'post',
            data: this.subStpNpSpotTradingAccountForm
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
          this.subStpNpSpotTradingAccountDialog = false;
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
          url: '/npspot/subStpNpSpotTradingAccount/del',
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
  .subStpNpSpotTradingAccountForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
