<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="用户代码">
        <el-input v-model="searchForm.userID" clearable placeholder="请输入用户代码"></el-input>
      </el-form-item>
      <el-form-item label="投资者帐号">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者帐号"></el-input>
      </el-form-item>
      <el-form-item label="投资者名称">
        <el-input v-model="searchForm.investorName" clearable placeholder="请输入投资者名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="stpNpSpotAccountInfoLoading" :data="stpNpSpotAccountInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerID" label="经纪公司代码"/>
      <el-table-column prop="userID" label="用户代码"/>
      <el-table-column prop="investorID" label="投资者帐号"/>
      <el-table-column prop="password" label="密码"/>
      <el-table-column prop="investorName" label="投资者名称"/>
      <el-table-column prop="idCardType" label="证件类型" :formatter="statusFormat"/>
      <el-table-column prop="idCardNo" label="证件号码"/>
      <el-table-column prop="openDate" label="开户日期"/>
      <el-table-column prop="closeDate" label="销户日期"/>
      <el-table-column prop="tradingStatus" label="交易状态" :formatter="statusFormat"/>
      <el-table-column prop="operways" label="委托方式"/>
      <el-table-column prop="mobile" label="手机"/>
      <el-table-column prop="telephone" label="联系电话"/>
      <el-table-column prop="email" label="电子邮件"/>
      <el-table-column prop="fax" label="传真"/>
      <el-table-column prop="address" label="通讯地址"/>
      <el-table-column prop="zipCode" label="邮政编码"/>
      <el-table-column prop="profInvestorType" label="专业投资者类别" :formatter="statusFormat"/>
      <el-table-column prop="planType" label="套餐类型(两融专用)" :formatter="statusFormat"/>
      <el-table-column prop="allowSelfSwitchPlan" label="是否允许投资者自切套餐(两融专用)"/>
      <el-table-column prop="remark" label="备注"/>
      <el-table-column prop="mdFrontAddr" label="行情前置机地址"/>
      <el-table-column prop="tradeFrontAddr" label="交易前置机地址"/>
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
    <el-dialog title="内盘现货投资者帐号" :visible.sync="stpNpSpotAccountInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="stpNpSpotAccountInfoForm" :model="stpNpSpotAccountInfoForm" :rules="stpNpSpotAccountInfoRules"
               label-width="150px" class="stpNpSpotAccountInfoForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="stpNpSpotAccountInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="stpNpSpotAccountInfoForm.brokerID" placeholder="请输入经纪公司代码"/>
        </el-form-item>
        <el-form-item label="用户代码" prop="userID">
          <el-input v-model="stpNpSpotAccountInfoForm.userID" placeholder="请输入用户代码"/>
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="stpNpSpotAccountInfoForm.investorID" placeholder="请输入投资者帐号"/>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="stpNpSpotAccountInfoForm.password" placeholder="请输入密码"/>
        </el-form-item>
        <el-form-item label="投资者名称" prop="investorName">
          <el-input v-model="stpNpSpotAccountInfoForm.investorName" placeholder="请输入投资者名称"/>
        </el-form-item>
        <el-form-item label="证件类型" prop="idCardType">
          <el-input v-model="stpNpSpotAccountInfoForm.idCardType" placeholder="请输入证件类型"/>
        </el-form-item>
        <el-form-item label="证件号码" prop="idCardNo">
          <el-input v-model="stpNpSpotAccountInfoForm.idCardNo" placeholder="请输入证件号码"/>
        </el-form-item>
        <el-form-item label="开户日期" prop="openDate">
          <el-input v-model="stpNpSpotAccountInfoForm.openDate" placeholder="请输入开户日期"/>
        </el-form-item>
        <el-form-item label="销户日期" prop="closeDate">
          <el-input v-model="stpNpSpotAccountInfoForm.closeDate" placeholder="请输入销户日期"/>
        </el-form-item>
        <el-form-item label="交易状态" prop="tradingStatus">
          <el-input v-model="stpNpSpotAccountInfoForm.tradingStatus" placeholder="请输入交易状态"/>
        </el-form-item>
        <el-form-item label="委托方式" prop="operways">
          <el-input v-model="stpNpSpotAccountInfoForm.operways" placeholder="请输入委托方式"/>
        </el-form-item>
        <el-form-item label="手机" prop="mobile">
          <el-input v-model="stpNpSpotAccountInfoForm.mobile" placeholder="请输入手机"/>
        </el-form-item>
        <el-form-item label="联系电话" prop="telephone">
          <el-input v-model="stpNpSpotAccountInfoForm.telephone" placeholder="请输入联系电话"/>
        </el-form-item>
        <el-form-item label="电子邮件" prop="email">
          <el-input v-model="stpNpSpotAccountInfoForm.email" placeholder="请输入电子邮件"/>
        </el-form-item>
        <el-form-item label="传真" prop="fax">
          <el-input v-model="stpNpSpotAccountInfoForm.fax" placeholder="请输入传真"/>
        </el-form-item>
        <el-form-item label="通讯地址" prop="address">
          <el-input v-model="stpNpSpotAccountInfoForm.address" placeholder="请输入通讯地址"/>
        </el-form-item>
        <el-form-item label="邮政编码" prop="zipCode">
          <el-input v-model="stpNpSpotAccountInfoForm.zipCode" placeholder="请输入邮政编码"/>
        </el-form-item>
        <el-form-item label="专业投资者类别" prop="profInvestorType">
          <el-input v-model="stpNpSpotAccountInfoForm.profInvestorType" placeholder="请输入专业投资者类别"/>
        </el-form-item>
        <el-form-item label="套餐类型(两融专用)" prop="planType">
          <el-input v-model="stpNpSpotAccountInfoForm.planType" placeholder="请输入套餐类型(两融专用)"/>
        </el-form-item>
        <el-form-item label="是否允许投资者自切套餐(两融专用)" prop="allowSelfSwitchPlan">
          <el-input v-model="stpNpSpotAccountInfoForm.allowSelfSwitchPlan" placeholder="请输入是否允许投资者自切套餐(两融专用)"/>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="stpNpSpotAccountInfoForm.remark" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item label="行情前置机地址" prop="mdFrontAddr">
          <el-input v-model="stpNpSpotAccountInfoForm.mdFrontAddr" placeholder="请输入行情前置机地址"/>
        </el-form-item>
        <el-form-item label="交易前置机地址" prop="tradeFrontAddr">
          <el-input v-model="stpNpSpotAccountInfoForm.tradeFrontAddr" placeholder="请输入交易前置机地址"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('stpNpSpotAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'StpNpSpotAccountInfoName',
    data() {
      return {
        stpNpSpotAccountInfoLoading: true,
        stpNpSpotAccountInfoDialog: false,
        stpNpSpotAccountInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        stpNpSpotAccountInfoForm: {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'userID': '',
          'investorID': '',
          'password': '',
          'investorName': '',
          'idCardType': '',
          'idCardNo': '',
          'openDate': '',
          'closeDate': '',
          'tradingStatus': '',
          'operways': '',
          'mobile': '',
          'telephone': '',
          'email': '',
          'fax': '',
          'address': '',
          'zipCode': '',
          'profInvestorType': '',
          'planType': '',
          'allowSelfSwitchPlan': '',
          'remark': '',
          'mdFrontAddr': '',
          'tradeFrontAddr': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'userID': '',
          'investorID': '',
          'investorName': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        stpNpSpotAccountInfoRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerID: [
            { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
          ],
          userID: [
            { required: true, message: '用户代码不可为空', trigger: 'change' }
          ],
          investorID: [
            { required: true, message: '投资者帐号不可为空', trigger: 'change' }
          ],
          password: [
            { required: true, message: '密码不可为空', trigger: 'change' }
          ],
          investorName: [
            { required: true, message: '投资者名称不可为空', trigger: 'change' }
          ],
          idCardType: [
            { required: true, message: '证件类型不可为空', trigger: 'change' }
          ],
          idCardNo: [
            { required: true, message: '证件号码不可为空', trigger: 'change' }
          ],
          openDate: [
            { required: true, message: '开户日期不可为空', trigger: 'change' }
          ],
          closeDate: [
            { required: true, message: '销户日期不可为空', trigger: 'change' }
          ],
          tradingStatus: [
            { required: true, message: '交易状态不可为空', trigger: 'change' }
          ],
          operways: [
            { required: true, message: '委托方式不可为空', trigger: 'change' }
          ],
          mobile: [
            { required: true, message: '手机不可为空', trigger: 'change' }
          ],
          telephone: [
            { required: true, message: '联系电话不可为空', trigger: 'change' }
          ],
          email: [
            { required: true, message: '电子邮件不可为空', trigger: 'change' }
          ],
          fax: [
            { required: true, message: '传真不可为空', trigger: 'change' }
          ],
          address: [
            { required: true, message: '通讯地址不可为空', trigger: 'change' }
          ],
          zipCode: [
            { required: true, message: '邮政编码不可为空', trigger: 'change' }
          ],
          profInvestorType: [
            { required: true, message: '专业投资者类别不可为空', trigger: 'change' }
          ],
          planType: [
            { required: true, message: '套餐类型(两融专用)不可为空', trigger: 'change' }
          ],
          allowSelfSwitchPlan: [
            { required: true, message: '是否允许投资者自切套餐(两融专用)不可为空', trigger: 'change' }
          ],
          remark: [
            { required: true, message: '备注不可为空', trigger: 'change' }
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
          url: '/npspot/dict/stpNpSpotAccountInfo',
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
        this.stpNpSpotAccountInfoLoading = true;
        this.$http({
          url: '/npspot/stpNpSpotAccountInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotAccountInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.stpNpSpotAccountInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.stpNpSpotAccountInfoForm = {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'userID': '',
          'investorID': '',
          'password': '',
          'investorName': '',
          'idCardType': '',
          'idCardNo': '',
          'openDate': '',
          'closeDate': '',
          'tradingStatus': '',
          'operways': '',
          'mobile': '',
          'telephone': '',
          'email': '',
          'fax': '',
          'address': '',
          'zipCode': '',
          'profInvestorType': '',
          'planType': '',
          'allowSelfSwitchPlan': '',
          'remark': '',
          'mdFrontAddr': '',
          'tradeFrontAddr': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.stpNpSpotAccountInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.stpNpSpotAccountInfoForm) {
          this.$refs.stpNpSpotAccountInfoForm.resetFields();
        }
        this.$http({
          url: '/npspot/stpNpSpotAccountInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotAccountInfoForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerID': res.object.brokerID,
              'userID': res.object.userID,
              'investorID': res.object.investorID,
              'password': res.object.password,
              'investorName': res.object.investorName,
              'idCardType': res.object.idCardType,
              'idCardNo': res.object.idCardNo,
              'openDate': res.object.openDate,
              'closeDate': res.object.closeDate,
              'tradingStatus': res.object.tradingStatus,
              'operways': res.object.operways,
              'mobile': res.object.mobile,
              'telephone': res.object.telephone,
              'email': res.object.email,
              'fax': res.object.fax,
              'address': res.object.address,
              'zipCode': res.object.zipCode,
              'profInvestorType': res.object.profInvestorType,
              'planType': res.object.planType,
              'allowSelfSwitchPlan': res.object.allowSelfSwitchPlan,
              'remark': res.object.remark,
              'mdFrontAddr': res.object.mdFrontAddr,
              'tradeFrontAddr': res.object.tradeFrontAddr
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.stpNpSpotAccountInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npspot/stpNpSpotAccountInfo/save',
              method: 'post',
              data: this.stpNpSpotAccountInfoForm
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
            this.stpNpSpotAccountInfoDialog = false;
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
            url: '/npspot/stpNpSpotAccountInfo/del',
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
  .stpNpSpotAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
