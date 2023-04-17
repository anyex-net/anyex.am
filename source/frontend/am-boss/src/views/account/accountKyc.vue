<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="accountId">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入账户ID"></el-input>
      </el-form-item>
      <el-form-item label="姓氏">
        <el-input v-model="searchForm.surName" clearable placeholder="请输入姓氏"></el-input>
      </el-form-item>
      <el-form-item label="名字">
        <el-input v-model="searchForm.realName" clearable placeholder="请输入名字"></el-input>
      </el-form-item>
      <el-form-item label="审核状态">
        <el-select v-model="searchForm.status">
          <el-option label="已审核通过" :value="1" />
          <el-option label="审核未通过" :value="2" />
          <el-option label="未审核" :value="0" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="accountKycLoading" :data="accountKycData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="accountId" label="本平台账户ID" width="200px"/>
      <el-table-column prop="surName" label="姓氏" width="100px"/>
      <el-table-column prop="realName" label="名字" width="100px"/>
      <el-table-column prop="region" label="国家地区" width="100px"/>
      <el-table-column prop="passportNo" label="证件号" width="150px"/>
      <el-table-column prop="attachments" label="附件信息" min-width="445px">
        <template slot-scope="scope">
          <span v-html="scope.row.attachments"></span>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.status === '0'">未审核</span>
          <span v-if="scope.row.status === '1'">已审核通过</span>
          <span v-if="scope.row.status === '2'">审核未通过</span>
        </template>
      </el-table-column>
      <el-table-column prop="remark" label="备注" width="150px"/>
      <el-table-column label="操作" width="150px">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">审核</el-button>
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
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="账户管理" :visible.sync="accountKycDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="accountKycForm" :model="accountKycForm" :rules="accountKycRules" label-width="80px" class="accountKycForm">
        <el-form-item label="状态" prop="status">
          <el-select v-model="accountKycForm.status" placeholder="请选择审核状态" value="">
            <el-option key="1" label="待审核" value="0" />
            <el-option key="1" label="审核通过" value="1" />
            <el-option key="2" label="审核未通过" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="accountKycForm.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('accountKycForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'AccountKyc',
  data() {
    return {
      accountKycLoading: '',
      accountKycDialog: false,
      accountKycData: [],
      accountKycForm: {
        'id': '',
        'accountId': '',
        'surName': '',
        'realName': '',
        'region': '',
        'passportNo': '',
        'attachments': '',
        'status': '',
        'remark': ''
      },
      searchForm: {
        'accountId': '',
        'surName': '',
        'realName': '',
        'status': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      accountKycRules: {
        lang: [
          { required: true, message: '请输入状态', trigger: 'status' }
        ]
      }
    };
  },
  mounted: function() {
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
    dialogAdd: function() {
      this.accountKycForm = {
        'id': '',
        'accountId': '',
        'surName': '',
        'realName': '',
        'region': '',
        'passportNo': '',
        'attachments': '',
        'status': '',
        'remark': ''
      };
      if (this.$refs.accountKycForm) {
        this.$refs.accountKycForm.resetFields();
      }
      this.accountKycDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.accountKycForm) {
        this.$refs.accountKycForm.resetFields();
      }
      this.$http({
        url: '/account/accountKyc/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.accountKycForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'surName': res.object.surName,
            'realName': res.object.realName,
            'region': res.object.region,
            'passportNo': res.object.passportNo,
            'attachments': res.object.attachments,
            'status': res.object.status,
            'remark': res.object.remark
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.accountKycDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.accountKycLoading = true;
      this.$http({
        url: '/account/accountKyc/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.accountKycData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.accountKycLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/account/accountKyc/save',
            method: 'post',
            data: this.accountKycForm
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
          this.accountKycDialog = false;
        }
      });
    }
  }
};
</script>

<style lang="scss" scoped>

</style>
