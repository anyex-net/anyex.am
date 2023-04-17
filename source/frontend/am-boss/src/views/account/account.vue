<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="UID">
        <el-input v-model="searchForm.uid" clearable placeholder="请输入UID"></el-input>
      </el-form-item>
      <el-form-item label="账户名">
        <el-input v-model="searchForm.accountName" clearable placeholder="请输入账户名"></el-input>
      </el-form-item>
      <el-form-item label="手机">
        <el-input v-model="searchForm.mobNo" clearable placeholder="请输入手机号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="accountLoading" :data="accountData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="账户ID"/>
      <el-table-column prop="uid" label="UID" />
      <el-table-column prop="accountName" label="账户名" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column prop="country" label="国家地区" />
      <el-table-column prop="mobNo" label="手机" />
      <el-table-column label="语言">
        <template slot-scope="scope">
          <span v-if="scope.row.lang === 'zh_CN'">简体中文</span>
          <span v-if="scope.row.lang === 'zh_HK'">繁体中文</span>
          <span v-if="scope.row.lang === 'en_US'">English</span>
        </template>
      </el-table-column>
      <el-table-column prop="location" label="注册所在地或IP" />
      <el-table-column prop="authKey" label="是否绑定GA">
        <template slot-scope="scope">
          <span v-if="scope.row.gaauthKey !== ''" style="color: green">已绑定</span>
          <span v-else style="color: red">未绑定</span>
        </template>
      </el-table-column>
      <el-table-column prop="securityPolicy" label="安全策略">
        <template slot-scope="scope">
          <span v-if="scope.row.securityPolicy === 0">密码</span>
          <span v-else-if="scope.row.securityPolicy === 1">手机</span>
          <span v-else-if="scope.row.securityPolicy === 2">GA</span>
          <span v-else-if="scope.row.securityPolicy === 3">手机或GA</span>
          <span v-else-if="scope.row.securityPolicy === 4">手机和GA</span>
          <span v-else>{{ scope.row.securityPolicy }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span v-if="scope.row.status === '0'">正常</span>
          <span v-if="scope.row.status === '1'">冻结</span>
          <span v-if="scope.row.status === '2'">注销</span>
        </template>
      </el-table-column>
      <el-table-column prop="remark" label="备注" />
      <el-table-column prop="createDate" label="创建时间" :formatter="dateFormat" width="200" />
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button v-if="scope.row.status === '0'" size="mini" type="success" @click="freeze(scope.$index, scope.row)">冻结</el-button>
          <el-button v-if="scope.row.status === '1'" size="mini" type="danger" @click="thaw(scope.$index, scope.row)">解冻</el-button>
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
  </div>
</template>

<script>
export default {
  name: 'Account',
  data() {
    return {
      accountLoading: '',
      accountDialog: false,
      accountData: [],
      accountForm: {
        'id': '',
        'uid': '',
        'accountName': '',
        'email': '',
        'country': '',
        'mobNo': '',
        'lang': '',
        'location': '',
        'gaauthKey': '',
        'securityPolicy': '',
        'status': '',
        'remark': '',
        'createDate': '',
        'updateDate': ''
      },
      searchForm: {
        'accountName': ''
      },
      gaForm: {
        'id': '',
        'gaCode': '',
        'accountName': '',
        'mobNo': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      accountRules: {
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
      this.accountForm = {
        'id': '',
        'title': '',
        'tplKey': '',
        'type': '',
        'lang': '',
        'content': ''
      };
      if (this.$refs.accountForm) {
        this.$refs.accountForm.resetFields();
      }
      this.accountDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.accountForm) {
        this.$refs.accountForm.resetFields();
      }
      this.$http({
        url: '/account/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.accountForm = {
            'id': res.object.id,
            'title': res.object.title,
            'tplKey': res.object.tplKey,
            'type': res.object.type,
            'lang': res.object.lang,
            'content': res.object.content
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.accountDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.accountLoading = true;
      this.$http({
        url: '/account/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.accountData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.accountLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/common/msgtemplate/save',
            method: 'post',
            data: this.accountForm
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
          this.accountDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该消息模版, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/msgtemplate/del',
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
    },
    freeze(row, column) {
      this.$prompt('你是否要冻结当前账户吗?如果确定，请输入GA验证码：', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPlaceholder: '请输入GA验证码',
        inputValidator: (value) => {
          var reg = /^\d{6}$/;
          if (value === '' || value === null) {
            return '请输入GA验证码';
          } else if (value.match(reg) === null) {
            return '请填写6位数字';
          } else {
            return true;
          }
        }
      }).then((value) => {
        this.gaForm.id = column.id;
        this.gaForm.gaCode = value.value;
        this.$http({
          url: '/account/freeze',
          method: 'post',
          data: this.gaForm
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doSearch();
          } else {
            this.$message.error(res.message || 'Has Error');
          }
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消提交'
        });
      });
    },
    thaw(row, column) {
      this.$prompt('你是否要解冻当前账户吗?如果确定，请输入GA验证码：', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPlaceholder: '请输入GA验证码',
        inputValidator: (value) => {
          var reg = /^\d{6}$/;
          if (value === '' || value === null) {
            return '请输入GA验证码';
          } else if (value.match(reg) === null) {
            return '请填写6位数字';
          } else {
            return true;
          }
        }
      }).then((value) => {
        this.gaForm.id = column.id;
        this.gaForm.gaCode = value.value;
        this.$http({
          url: '/account/thaw',
          method: 'post',
          data: this.gaForm
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doSearch();
          } else {
            this.$message.error(res.message || 'Has Error');
          }
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消提交'
        });
      });
    }
  }
};
</script>

<style lang="scss" scoped>

</style>
