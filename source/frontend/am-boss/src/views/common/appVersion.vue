<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="版本号">
        <el-input v-model="searchForm.appVersion" clearable placeholder="请输入版本号"></el-input>
      </el-form-item>
      <el-form-item label="设备类型" prop="deviceType">
        <el-select v-model="searchForm.deviceType" placeholder="请选择设备类型" value="">
          <el-option key="ios" label="ios" value="ios" />
          <el-option key="android" label="android" value="android" />
          <el-option key="client" label="client" value="client" />
        </el-select>
      </el-form-item>
      <el-form-item label="是否支持" prop="canSupport">
        <el-select v-model="searchForm.canSupport" placeholder="请选择是否支持" value="">
          <el-option key="yes" label="yes" value="yes" />
          <el-option key="no" label="no" value="no" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="appVersionLoading" :data="appVersionData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="appVersion" label="版本号" />
      <el-table-column prop="buildVersion" label="build版本号" />
      <el-table-column prop="deviceType" label="设备类型" />
      <el-table-column prop="canSupport" label="是否支持" />
      <el-table-column prop="checkStatus" label="审核状态" />
      <el-table-column prop="remark" label="备注" />
      <el-table-column prop="username" label="创建者" />
      <el-table-column prop="createDate" :formatter="dateFormat" width="200" label="创建时间" />
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
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="app版本" :visible.sync="appVersionDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="appVersionForm" :model="appVersionForm" :rules="appVersionRules" label-width="80px" class="appVersionForm">
        <el-form-item label="设备类型" prop="deviceType">
          <el-select v-model="appVersionForm.deviceType" placeholder="请选择设备类型" value="">
            <el-option key="ios" label="ios" value="ios" />
            <el-option key="android" label="android" value="android" />
            <el-option key="client" label="client" value="client" />
          </el-select>
        </el-form-item>
        <el-form-item label="版本号" prop="appVersion">
          <el-input v-model="appVersionForm.appVersion" placeholder="请输入版本号" />
        </el-form-item>
        <el-form-item label="build版本号" prop="buildVersion">
          <el-input v-model="appVersionForm.buildVersion" placeholder="请输build入版本号" />
        </el-form-item>
        <el-form-item label="是否支持" prop="canSupport">
        <el-select v-model="appVersionForm.canSupport" placeholder="请选择是否支持" value="">
          <el-option key="yes" label="yes" value="yes" />
          <el-option key="no" label="no" value="no" />
        </el-select>
      </el-form-item>
        <el-form-item label="审核状态" prop="checkStatus">
          <el-select v-model="appVersionForm.checkStatus" placeholder="请选择审核状态" value="">
            <el-option key="yes" label="yes" value="yes" />
            <el-option key="no" label="no" value="no" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="appVersionForm.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('appVersionForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'AppVersion',
  data() {
    return {
      appVersionLoading: '',
      appVersionDialog: false,
      appVersionData: [],
      appVersionForm: {
        'id': '',
        'appVersion': '',
        'buildVersion': '',
        'deviceType': '',
        'canSupport': '',
        'checkStatus': '',
        'remark': ''
      },
      searchForm: {
        'appVersion': '',
        'deviceType': '',
        'canSupport': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      appVersionRules: {
        appVersion: [
          { required: true, message: '请输入版本号', trigger: 'blur' }
        ],
        buildVersion: [
          { required: true, message: '请输入build版本号', trigger: 'blur' }
        ],
        deviceType: [
          { required: true, message: '请输入设备类型', trigger: 'blur' }
        ],
        canSupport: [
          { required: true, message: '请选择是否支持', trigger: 'change' }
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
      this.appVersionForm = {
        'id': '',
        'appVersion': '',
        'buildVersion': '',
        'deviceType': '',
        'canSupport': '',
        'checkStatus': '',
        'remark': ''
      };
      if (this.$refs.appVersionForm) {
        this.$refs.appVersionForm.resetFields();
      }
      this.appVersionDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.appVersionForm) {
        this.$refs.appVersionForm.resetFields();
      }
      this.$http({
        url: '/common/appversion/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.appVersionForm = {
            'id': res.object.id,
            'appVersion': res.object.appVersion,
            'buildVersion': res.object.buildVersion,
            'deviceType': res.object.deviceType,
            'canSupport': res.object.canSupport,
            'checkStatus': res.object.checkStatus,
            'remark': res.object.remark
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.appVersionDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.appVersionLoading = true;
      this.$http({
        url: '/common/appversion/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.appVersionData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.appVersionLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/common/appversion/save',
            method: 'post',
            data: this.appVersionForm
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
          this.appVersionDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该app版本, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/appversion/del',
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

</style>
