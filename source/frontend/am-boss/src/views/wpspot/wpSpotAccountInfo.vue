<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="投资者帐号">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者帐号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpSpotAccountInfoLoading" :data="wpSpotAccountInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者帐号" />
      <el-table-column prop="investorPassword" label="投资者密码" />
      <el-table-column prop="authCode" label="认证码(可随意填写)" />
      <el-table-column prop="appID" label="App代码(可随意填写)" />
      <el-table-column prop="mdFrontAddr" label="行情前置机地址" />
      <el-table-column prop="tradeFrontAddr" label="交易前置机地址" />
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
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
    <el-dialog title="外盘现货投资者帐号表管理" :visible.sync="wpSpotAccountInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="wpSpotAccountInfoForm" :model="wpSpotAccountInfoForm" :rules="wpSpotAccountInfoRules" label-width="150px" class="wpSpotAccountInfoForm">
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="wpSpotAccountInfoForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="wpSpotAccountInfoForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="wpSpotAccountInfoForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="wpSpotAccountInfoForm.investorID" placeholder="请输入投资者帐号" />
        </el-form-item>
        <el-form-item label="投资者密码" prop="investorPassword">
          <el-input v-model="wpSpotAccountInfoForm.investorPassword" placeholder="请输入投资者密码" />
        </el-form-item>
        <el-form-item label="认证码(可随意填写)" prop="authCode">
          <el-input v-model="wpSpotAccountInfoForm.authCode" placeholder="请输入认证码" />
        </el-form-item>
        <el-form-item label="App代码(可随意填写)" prop="appID">
          <el-input v-model="wpSpotAccountInfoForm.appID" placeholder="请输入App代码" />
        </el-form-item>
        <el-form-item label="行情前置机地址" prop="mdFrontAddr">
          <el-input v-model="wpSpotAccountInfoForm.mdFrontAddr" placeholder="请输入行情前置机地址" />
        </el-form-item>
        <el-form-item label="交易前置机地址" prop="tradeFrontAddr">
          <el-input v-model="wpSpotAccountInfoForm.tradeFrontAddr" placeholder="请输入交易前置机地址" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('wpSpotAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpSpotAccountInfoName',
  data() {
    return {
      wpSpotAccountInfoLoading: true,
      wpSpotAccountInfoDialog: false,
      wpSpotAccountInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpSpotAccountInfoForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'investorPassword': '',
        'authCode': '',
        'appID': '',
        'mdFrontAddr': '',
        'tradeFrontAddr': ''
      },
      searchForm: {
        'investorID': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpSpotAccountInfoRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者帐号不可为空', trigger: 'change' }
        ],
        investorPassword: [
          { required: true, message: '投资者密码不可为空', trigger: 'change' }
        ],
        authCode: [
          { required: true, message: '认证码不可为空', trigger: 'change' }
        ],
        appID: [
          { required: true, message: 'App代码不可为空', trigger: 'change' }
        ],
        mdFrontAddr: [
          { required: true, message: '行情前置机地址不可为空', trigger: 'change' }
        ],
        tradeFrontAddr: [
          { required: true, message: '交易前置机地址不可为空', trigger: 'change' }
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
        url: '/wpspot/dict/wpSpotAccountInfo',
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
      this.wpSpotAccountInfoLoading = true;
      this.$http({
        url: '/wpspot/wpSpotAccountInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotAccountInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpSpotAccountInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpSpotAccountInfoForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'investorPassword': '',
        'authCode': '',
        'appID': '',
        'mdFrontAddr': '',
        'tradeFrontAddr': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpSpotAccountInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpSpotAccountInfoForm) {
        this.$refs.wpSpotAccountInfoForm.resetFields();
      }
      this.$http({
        url: '/wpspot/wpSpotAccountInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotAccountInfoForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'investorPassword': res.object.investorPassword,
            'authCode': res.object.authCode,
            'appID': res.object.appID,
            'mdFrontAddr': res.object.mdFrontAddr,
            'tradeFrontAddr': res.object.tradeFrontAddr
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpSpotAccountInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/wpSpotAccountInfo/save',
            method: 'post',
            data: this.wpSpotAccountInfoForm
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
          this.wpSpotAccountInfoDialog = false;
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
          url: '/wpspot/wpSpotAccountInfo/del',
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
		.wpSpotAccountInfoForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
