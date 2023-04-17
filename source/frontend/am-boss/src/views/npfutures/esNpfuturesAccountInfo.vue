<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-input v-model="searchForm.brokerNo" clearable placeholder="请输入经纪商编码"></el-input>
      </el-form-item>
      <el-form-item label="资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入资金账号"></el-input>
      </el-form-item>
      <el-form-item label="账号状态">
        <el-select v-model="searchForm.accountState" clearable placeholder="请选择账号状态" value="">
          <el-option v-for="data in dicts.accountState" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="账号简称">
        <el-input v-model="searchForm.accountShortName" clearable placeholder="请输入账号简称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesAccountInfoLoading" :data="esNpfuturesAccountInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码"/>
      <el-table-column prop="accountNo" label="资金账号"/>
      <el-table-column prop="accountState" label="账号状态" :formatter="statusFormat"/>
      <el-table-column prop="accountShortName" label="账号简称"/>
      <el-table-column prop="accountIsDocHolder" label="是否持证者"/>
      <el-table-column prop="isMarketMaker" label="是否是做市商"/>
      <el-table-column prop="accountFamilyType" label="父子账号类型"/>
      <el-table-column prop="accountPassword" label="资金账号密码"/>
      <el-table-column prop="authCode" label="资金账号授权码"/>
      <el-table-column prop="appID" label="程序版本号"/>
      <el-table-column prop="quoteApiAddr" label="行情前置机地址"/>
      <el-table-column prop="tradeApiAddr" label="交易前置机地址"/>
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
    <el-dialog title="内盘期货资金账号表管理" :visible.sync="esNpfuturesAccountInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesAccountInfoForm" :model="esNpfuturesAccountInfoForm" :rules="esNpfuturesAccountInfoRules"
               label-width="150px" class="esNpfuturesAccountInfoForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="esNpfuturesAccountInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-input v-model="esNpfuturesAccountInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
        </el-form-item>
        <el-form-item label="资金账号" prop="accountNo">
          <el-input v-model="esNpfuturesAccountInfoForm.accountNo" placeholder="请输入资金账号"/>
        </el-form-item>
        <el-form-item label="账号状态" prop="accountState">
          <el-select v-model="esNpfuturesAccountInfoForm.accountState" clearable placeholder="请选择账号状态" value="">
            <el-option v-for="data in dicts.accountState" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="账号简称" prop="accountShortName">
          <el-input v-model="esNpfuturesAccountInfoForm.accountShortName" placeholder="请输入账号简称"/>
        </el-form-item>
        <el-form-item label="是否持证者" prop="accountIsDocHolder">
          <el-input v-model="esNpfuturesAccountInfoForm.accountIsDocHolder" placeholder="请输入是否持证者"/>
        </el-form-item>
        <el-form-item label="是否是做市商" prop="isMarketMaker">
          <el-input v-model="esNpfuturesAccountInfoForm.isMarketMaker" placeholder="请输入是否是做市商"/>
        </el-form-item>
        <el-form-item label="父子账号类型" prop="accountFamilyType">
          <el-input v-model="esNpfuturesAccountInfoForm.accountFamilyType" placeholder="请输入父子账号类型"/>
        </el-form-item>
        <el-form-item label="资金账号密码" prop="accountPassword">
          <el-input v-model="esNpfuturesAccountInfoForm.accountPassword" placeholder="请输入资金账号密码"/>
        </el-form-item>
        <el-form-item label="资金账号授权码" prop="authCode">
          <el-input v-model="esNpfuturesAccountInfoForm.authCode" placeholder="请输入资金账号授权码"/>
        </el-form-item>
        <el-form-item label="程序版本号" prop="appID">
          <el-input v-model="esNpfuturesAccountInfoForm.appID" placeholder="请输入程序版本号"/>
        </el-form-item>
        <el-form-item label="行情前置机地址" prop="quoteApiAddr">
          <el-input v-model="esNpfuturesAccountInfoForm.quoteApiAddr" placeholder="请输入行情前置机地址"/>
        </el-form-item>
        <el-form-item label="交易前置机地址" prop="tradeApiAddr">
          <el-input v-model="esNpfuturesAccountInfoForm.tradeApiAddr" placeholder="请输入交易前置机地址"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('esNpfuturesAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesAccountInfoName',
    data() {
      return {
        esNpfuturesAccountInfoLoading: true,
        esNpfuturesAccountInfoDialog: false,
        esNpfuturesAccountInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesAccountInfoForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'accountState': '',
          'accountShortName': '',
          'accountIsDocHolder': '',
          'isMarketMaker': '',
          'accountFamilyType': '',
          'accountPassword': '',
          'authCode': '',
          'appID': '',
          'quoteApiAddr': '',
          'tradeApiAddr': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'accountState': '',
          'accountShortName': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesAccountInfoRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '资金账号不可为空', trigger: 'change' }
          ],
          accountState: [
            { required: true, message: '账号状态不可为空', trigger: 'change' }
          ],
          accountIsDocHolder: [
            { required: true, message: '是否持证者不可为空', trigger: 'change' }
          ],
          isMarketMaker: [
            { required: true, message: '是否是做市商不可为空', trigger: 'change' }
          ],
          accountPassword: [
            { required: true, message: '资金账号密码不可为空', trigger: 'change' }
          ],
          authCode: [
            { required: true, message: '资金账号授权码不可为空', trigger: 'change' }
          ],
          appID: [
            { required: true, message: '程序版本号不可为空', trigger: 'change' }
          ],
          quoteApiAddr: [
            { required: true, message: '行情前置机地址不可为空', trigger: 'change' }
          ],
          tradeApiAddr: [
            { required: true, message: '交易前置机地址不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesAccountInfo',
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
        this.esNpfuturesAccountInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesAccountInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesAccountInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesAccountInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesAccountInfoForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'accountState': '',
          'accountShortName': '',
          'accountIsDocHolder': '',
          'isMarketMaker': '',
          'accountFamilyType': '',
          'accountPassword': '',
          'authCode': '',
          'appID': '',
          'quoteApiAddr': '',
          'tradeApiAddr': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesAccountInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesAccountInfoForm) {
          this.$refs.esNpfuturesAccountInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesAccountInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesAccountInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'accountState': res.object.accountState,
              'accountShortName': res.object.accountShortName,
              'accountIsDocHolder': res.object.accountIsDocHolder,
              'isMarketMaker': res.object.isMarketMaker,
              'accountFamilyType': res.object.accountFamilyType,
              'accountPassword': res.object.accountPassword,
              'authCode': res.object.authCode,
              'appID': res.object.appID,
              'quoteApiAddr': res.object.quoteApiAddr,
              'tradeApiAddr': res.object.tradeApiAddr
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesAccountInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesAccountInfo/save',
              method: 'post',
              data: this.esNpfuturesAccountInfoForm
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
            this.esNpfuturesAccountInfoDialog = false;
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
            url: '/npfutures/esNpfuturesAccountInfo/del',
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
  .esNpfuturesAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
