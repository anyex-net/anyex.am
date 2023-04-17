<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-select v-model="searchForm.brokerNo" clearable placeholder="请选择经纪商编码" value="">
          <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入资金账号"></el-input>
      </el-form-item>
      <el-form-item label="账号类型">
        <el-select v-model="searchForm.accountType" clearable placeholder="请选择账号类型" value="">
          <el-option v-for="data in dicts.accountType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="账号状态">
        <el-select v-model="searchForm.accountState" clearable placeholder="请选择账号状态" value="">
          <el-option v-for="data in dicts.accountState" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="交易状态">
        <el-select v-model="searchForm.accountTradeRight" clearable placeholder="请选择交易状态" value="">
          <el-option v-for="data in dicts.accountTradeRight" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="行情资金账号">
        <el-input v-model="searchForm.quoteAccountNo" clearable placeholder="请输入行情资金账号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesAccountInfoLoading" :data="wpfuturesAccountInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="id" label="ID" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat" />
      <el-table-column prop="accountNo" label="资金账号" />
      <el-table-column prop="accountType" label="账号类型" :formatter="statusFormat" />
      <el-table-column prop="accountState" label="账号状态" :formatter="statusFormat" />
      <el-table-column prop="accountTradeRight" label="交易状态" :formatter="statusFormat" />
      <el-table-column prop="commodityGroupNo" label="可交易品种组" />
      <el-table-column prop="accountShortName" label="账号简称" />
      <el-table-column prop="accountEnShortName" label="账号英文简称" />
      <el-table-column prop="accountPassword" label="资金账号密码" />
      <el-table-column prop="accountAuthCode" label="资金账号授权码" :show-overflow-tooltip="true"/>
      <el-table-column prop="quoteAccountNo" label="行情资金账号" />
      <el-table-column prop="quoteAccountPassword" label="行情资金账号密码" />
      <el-table-column prop="quoteAccountAuthCode" label="行情资金账号授权码" :show-overflow-tooltip="true"/>
      <el-table-column prop="quoteApiAddr" label="行情前置机地址" />
      <el-table-column prop="tradeApiAddr" label="交易前置机地址" />
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
    <el-dialog title="期货资金账号管理" :visible.sync="wpfuturesAccountInfoDialog" :close-on-click-modal="false" width="800">
      <el-form
        ref="wpfuturesAccountInfoForm"
        :model="wpfuturesAccountInfoForm"
        :rules="wpfuturesAccountInfoRules"
        label-width="230px"
        class="wpfuturesAccountInfoForm"
      >
        <el-row>
          <el-col :span=12>
            <el-form-item label="AM平台账户ID" prop="accountId">
              <el-input v-model="wpfuturesAccountInfoForm.accountId" placeholder="请输入AM平台账户ID" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="经纪商编码" prop="brokerNo">
              <el-select v-model="wpfuturesAccountInfoForm.brokerNo" clearable placeholder="请选择经纪商编码" value="">
                <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="资金账号" prop="accountNo">
              <el-input v-model="wpfuturesAccountInfoForm.accountNo" placeholder="请输入资金账号" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="账号类型" prop="accountType">
              <el-select v-model="wpfuturesAccountInfoForm.accountType" clearable placeholder="请选择账号类型" value="">
                <el-option v-for="data in dicts.accountType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="账号状态" prop="accountState">
              <el-select v-model="wpfuturesAccountInfoForm.accountState" clearable placeholder="请选择账号状态" value="">
                <el-option v-for="data in dicts.accountState" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="交易状态" prop="accountTradeRight">
              <el-select v-model="wpfuturesAccountInfoForm.accountTradeRight" clearable placeholder="请选择交易状态" value="">
                <el-option
                  v-for="data in dicts.accountTradeRight"
                  :key="data.key"
                  :label="data.value"
                  :value="data.key"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="可交易品种组" prop="commodityGroupNo">
              <el-input v-model="wpfuturesAccountInfoForm.commodityGroupNo" placeholder="请输入可交易品种组" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="账号简称" prop="accountShortName">
              <el-input v-model="wpfuturesAccountInfoForm.accountShortName" placeholder="请输入账号简称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="账号英文简称" prop="accountEnShortName">
              <el-input v-model="wpfuturesAccountInfoForm.accountEnShortName" placeholder="请输入账号英文简称" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="资金账号密码" prop="accountPassword">
              <el-input v-model="wpfuturesAccountInfoForm.accountPassword" placeholder="请输入资金账号密码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="资金账号授权码" prop="accountAuthCode">
              <el-input v-model="wpfuturesAccountInfoForm.accountAuthCode" placeholder="请输入资金账号授权码" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="行情资金账号" prop="quoteAccountNo">
              <el-input v-model="wpfuturesAccountInfoForm.quoteAccountNo" placeholder="请输入行情资金账号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="行情资金账号密码" prop="quoteAccountPassword">
              <el-input v-model="wpfuturesAccountInfoForm.quoteAccountPassword" placeholder="请输入行情资金账号密码" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="行情资金账号授权码" prop="quoteAccountAuthCode">
              <el-input v-model="wpfuturesAccountInfoForm.quoteAccountAuthCode" placeholder="请输入行情资金账号授权码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="行情前置机地址" prop="quoteApiAddr">
              <el-input v-model="wpfuturesAccountInfoForm.quoteApiAddr" placeholder="请输入行情前置机地址" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="交易前置机地址" prop="tradeApiAddr">
              <el-input v-model="wpfuturesAccountInfoForm.tradeApiAddr" placeholder="请输入交易前置机地址" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=24 align="center">
              <el-button type="success" @click="doSubmit('wpfuturesAccountInfoForm')">提交</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpfuturesAccountInfoName',
  data() {
    return {
      wpfuturesAccountInfoLoading: true,
      wpfuturesAccountInfoDialog: false,
      wpfuturesAccountInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpfuturesAccountInfoForm: {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'accountType': '',
        'accountState': '',
        'accountTradeRight': '',
        'commodityGroupNo': '',
        'accountShortName': '',
        'accountEnShortName': '',
        'accountPassword': '',
        'accountAuthCode': '',
        'quoteAccountNo': '',
        'quoteAccountPassword': '',
        'quoteAccountAuthCode': '',
        'quoteApiAddr': '',
        'tradeApiAddr': ''
      },
      searchForm: {
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'accountType': '',
        'accountState': '',
        'accountTradeRight': '',
        'quoteAccountNo': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpfuturesAccountInfoRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerNo: [
          { required: true, message: '经纪商编码不可为空', trigger: 'change' }
        ],
        accountNo: [
          { required: true, message: '资金账号不可为空', trigger: 'change' }
        ],
        accountType: [
          { required: true, message: '账号类型不可为空', trigger: 'change' }
        ],
        accountState: [
          { required: true, message: '账号状态不可为空', trigger: 'change' }
        ],
        accountTradeRight: [
          { required: true, message: '交易状态不可为空', trigger: 'change' }
        ],
        commodityGroupNo: [
          { required: true, message: '可交易品种组不可为空', trigger: 'change' }
        ],
        accountPassword: [
          { required: true, message: '资金账号密码不可为空', trigger: 'change' }
        ],
        accountAuthCode: [
          { required: true, message: '资金账号授权码不可为空', trigger: 'change' }
        ],
        quoteApiAddr: [
          { required: true, message: '行情前置机地址', trigger: 'change' }
        ],
        tradeApiAddr: [
          { required: true, message: '交易前置机地址', trigger: 'change' }
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
        url: '/wpfutures/dict/wpfuturesAccountInfo',
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
      this.wpfuturesAccountInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesAccountInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesAccountInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesAccountInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpfuturesAccountInfoForm = {
        'id': '',
        'accountId': '',
        'brokerNo': '',
        'accountNo': '',
        'accountType': '',
        'accountState': '',
        'accountTradeRight': '',
        'commodityGroupNo': '',
        'accountShortName': '',
        'accountEnShortName': '',
        'accountPassword': '',
        'accountAuthCode': '',
        'quoteAccountNo': '',
        'quoteAccountPassword': '',
        'quoteAccountAuthCode': '',
        'quoteApiAddr': '',
        'tradeApiAddr': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpfuturesAccountInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesAccountInfoForm) {
        this.$refs.wpfuturesAccountInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesAccountInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesAccountInfoForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerNo': res.object.brokerNo,
            'accountNo': res.object.accountNo,
            'accountType': res.object.accountType,
            'accountState': res.object.accountState,
            'accountTradeRight': res.object.accountTradeRight,
            'commodityGroupNo': res.object.commodityGroupNo,
            'accountShortName': res.object.accountShortName,
            'accountEnShortName': res.object.accountEnShortName,
            'accountPassword': res.object.accountPassword,
            'accountAuthCode': res.object.accountAuthCode,
            'quoteAccountNo': res.object.quoteAccountNo,
            'quoteAccountPassword': res.object.quoteAccountPassword,
            'quoteAccountAuthCode': res.object.quoteAccountAuthCode,
            'quoteApiAddr': res.object.quoteApiAddr,
            'tradeApiAddr': res.object.tradeApiAddr
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesAccountInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/wpfuturesAccountInfo/save',
            method: 'post',
            data: this.wpfuturesAccountInfoForm
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
          this.wpfuturesAccountInfoDialog = false;
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
          url: '/wpfutures/wpfuturesAccountInfo/del',
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
.wpfuturesAccountInfoForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
