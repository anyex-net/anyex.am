<!--suppress ALL -->
<template>
  <div class="app-container">

    <el-button style="margin-bottom:10px;" type="success" size="mini" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>

    <el-table v-loading="userLoading" :data="userData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="userName" label="登录名" />
      <el-table-column prop="trueName" label="姓名" />
      <el-table-column prop="idCard" label="身份证" />
      <el-table-column label="性别">
        <template slot-scope="scope">
          <span v-if="scope.row.gender === true">男</span>
          <span v-if="scope.row.gender === false">女</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span v-if="scope.row.active === true">启用</span>
          <span v-if="scope.row.active === false">禁用</span>
        </template>
      </el-table-column>
      <el-table-column prop="orgName" label="所属机构" width="200" />
      <el-table-column width="200" label="所属角色">
        <template slot-scope="scope">
          <span v-for="data in scope.row.roleList" :key="data.id">{{ data.roleName }}&nbsp;</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <!--<el-button size="mini" type="primary" @click="doResetPwd(scope.$index, scope.row)">重置密码</el-button>-->
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
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="用户信息" :visible.sync="userDialog" :close-on-click-modal="false" width="620px">
      <el-form ref="userForm" :inline="true" :model="userForm" :rules="userRules" label-width="80px" class="userForm">
        <el-form-item label="登录名" prop="userName">
          <el-input v-model="userForm.userName" placeholder="请输入登录名" />
        </el-form-item>
        <el-form-item label="姓名" prop="trueName">
          <el-input v-model="userForm.trueName" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="角色" prop="roleIds">
          <el-select v-model="userForm.roleIds" multiple placeholder="请选择角色" value="">
            <el-option v-for="data in roleData" :key="data.id" :label="data.roleName" :value="data.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="机构" prop="orgId">
          <select-tree
            :value="userForm.orgId"
            :options="orgData"
            :clearable="true"
            :accordion="true"
            :multiple="false"
            :props="{value:'id',label:'orgName',children:'children'}"
            @getValue="getValue($event)"
          />
        </el-form-item>
        <el-form-item label="密码" prop="passWord">
          <el-input v-model="userForm.passWord" :placeholder="tips" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="userForm.gender" placeholder="请选择性别" value="">
            <el-option :key="true" label="男" :value="true" />
            <el-option :key="false" label="女" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item label="身份证" prop="idCard">
          <el-input v-model="userForm.idCard" placeholder="请输入身份证" />
        </el-form-item>
        <el-form-item label="状态" prop="active">
          <el-select v-model="userForm.active" placeholder="请选择状态" value="">
            <el-option :key="true" label="启用" :value="true" />
            <el-option :key="false" label="禁用" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item style="display:block;" label="用户描述" prop="dest">
          <el-input v-model="userForm.dest" style="width:485px;" type="textarea" placeholder="请输入用户描述" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button style="margin-left:80px;" type="primary" @click="doSubmit('userForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
import selectTree from '@/components/selectTree';

export default {
  name: 'User',
  components: {
    selectTree
  },
  data() {
    return {
      userLoading: '',
      userDialog: false,
      userData: [],
      roleData: [],
      orgData: [],
      tips: '',
      userForm: {
        'id': '',
        'userName': '',
        'trueName': '',
        'orgId': '',
        'roleIds': '',
        'gender': '',
        'idCard': '',
        'active': '',
        'dest': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      userRules: {
        userName: [
          { required: true, message: '请输入登录名', trigger: 'blur' }
        ],
        trueName: [
          { required: true, message: '请选择姓名', trigger: 'blur' }
        ],
        orgId: [
          { required: false, message: '请选择所属机构', trigger: 'change' }
        ],
        roleIds: [
          { required: false, message: '请选择所属角色', trigger: 'change' }
        ],
        gender: [
          { required: true, message: '请选择性别', trigger: 'change' }
        ],
        idCard: [
          { required: true, message: '请输入身份证', trigger: 'blur' }
        ],
        active: [
          { required: true, message: '请选择状态', trigger: 'change' }
        ],
        dest: [
          { required: false }
        ]
      }
    };
  },
  mounted: function() {
    this.doSearch();
    this.doInitData();
  },
  methods: {
    dateFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      return this.$moment(date).format('YYYY-MM-DD HH:mm:ss');
    },
    getValue(value) {
      this.userForm.orgId = value;
    },
    dialogAdd: function(row, column) {
      this.tips = '请输入密码';
      this.userForm = {
        'id': '',
        'userName': '',
        'trueName': '',
        'orgId': '',
        'roleIds': '',
        'passWord': '',
        'gender': '',
        'idCard': '',
        'active': '',
        'dest': ''
      };
      if (this.$refs.userForm) {
        this.$refs.userForm.resetFields();
      }
      this.userDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.userForm) {
        this.$refs.userForm.resetFields();
      }
      this.tips = '若无需修改，请忽略';
      this.$http({
        url: '/system/user/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          const roleIds = [];
          for (const i in res.object.roleList) {
            roleIds.push(res.object.roleList[i].id);
          }
          this.userForm = {
            'id': res.object.id,
            'userName': res.object.userName,
            'trueName': res.object.trueName,
            'orgId': res.object.orgId,
            'roleIds': roleIds,
            'passWord': '',
            'gender': res.object.gender,
            'idCard': res.object.idCard,
            'active': res.object.active,
            'dest': res.object.dest
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.userDialog = true;
    },
    doInitData: function() {
      this.$http({
        url: '/system/role/data',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.roleData = res.rows;
        }
      }).catch(error => {
        console.log(error);
      });
      this.$http({
        url: '/system/organiz/tree',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.orgData = res.object;
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
      this.userLoading = true;
      this.$http({
        url: '/system/user/data',
        method: 'post',
        data: this.pageParams
      }).then(res => {
        if (res.code === 200) {
          this.userData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.userLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.userForm.orgId = this.userForm.orgId + '';
      this.userForm.roleIds = this.userForm.roleIds + '';
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/system/user/save',
            method: 'post',
            data: this.userForm
          }).then(res => {
            if (res.code === 200) {
              this.$message.success(res.message);
              this.doInitData();
              this.doSearch();
            } else {
              this.$message.error(res.message || 'Has Error');
            }
          }).catch(error => {
            this.$message.error(error);
          });
          this.userDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该用户, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/system/user/del',
          method: 'post',
          data: {
            ids: column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doInitData();
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
    doResetPwd: function(row, column) {
      this.$confirm('确认要重置密码, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/system/user/resetPwd',
          method: 'post',
          data: {
            id: column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doInitData();
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
          message: '已取消重置'
        });
      });
    }
  }
};
</script>

<style lang="scss">
  .userForm.el-form--inline .el-form-item__content {
    width: 196px;
  }
</style>
