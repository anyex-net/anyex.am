<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="参数名称">
        <el-input v-model="searchForm.systemName" clearable placeholder="请输入参数名称"></el-input>
      </el-form-item>
      <el-form-item label="参数描述">
        <el-input v-model="searchForm.describe" clearable placeholder="请输入参数描述"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="paramsLoading" :data="paramsData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="systemName" label="系统名称" />
      <el-table-column prop="parameterName" label="参数名称" />
      <el-table-column prop="describe" label="参数描述" />
      <el-table-column prop="division" label="参数大类" />
      <el-table-column prop="type" label="参数类型" />
      <el-table-column prop="valueBound" label="参数值值域" />
      <el-table-column prop="value" label="参数值" />
      <el-table-column prop="remark" label="备注" />
      <el-table-column prop="createDate" :formatter="dateFormat" label="创建时间" />
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
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

    <el-dialog title="系统参数" :visible.sync="paramsDialog" :close-on-click-modal="false" width="600px">
      <el-form ref="paramsForm" :inline="true" :model="paramsForm" :rules="paramsRules" label-width="80px" class="paramsForm">
        <el-form-item label="系统名称" prop="systemName">
          <el-input v-model="paramsForm.systemName" />
        </el-form-item>
        <el-form-item label="参数名称" prop="parameterName">
          <el-input v-model="paramsForm.parameterName" />
        </el-form-item>
        <el-form-item label="参数描述" prop="describe">
          <el-input v-model="paramsForm.describe" />
        </el-form-item>
        <el-form-item label="参数大类" prop="division">
          <el-input v-model="paramsForm.division" />
        </el-form-item>
        <el-form-item label="参数类型" prop="type">
          <el-input v-model="paramsForm.type" />
        </el-form-item>
        <el-form-item label="参数值" prop="value">
          <el-input v-model="paramsForm.value" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="paramsForm.remark" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button style="margin-left:80px;" type="primary" @click="doSubmit('paramsForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'Parameter',
  data() {
    return {
      paramsLoading: '',
      paramsDialog: false,
      paramsData: [],
      paramsForm: {
        'id': '',
        'systemName': '',
        'parameterName': '',
        'describe': '',
        'division': '',
        'type': '',
        'value': '',
        'remark': ''
      },
      searchForm: {
        'systemName': '',
        'describe': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      paramsRules: {
        systemName: [
          { required: true, message: '请输入系统名称', trigger: 'blur' }
        ],
        parameterName: [
          { required: true, message: '请输入参数名称', trigger: 'blur' }
        ],
        describe: [
          { required: true, message: '请输入参数描述', trigger: 'blur' }
        ],
        division: [
          { required: true, message: '请输入参数大类', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请输入参数类型', trigger: 'blur' }
        ],
        value: [
          { required: true, message: '请输入参数值', trigger: 'blur' }
        ],
        remark: [
          { required: true, message: '请输入备注', trigger: 'blur' }
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
      this.paramsForm = {
        'id': '',
        'systemName': '',
        'parameterName': '',
        'describe': '',
        'division': '',
        'type': '',
        'value': '',
        'remark': ''
      };
      if (this.$refs.paramsForm) {
        this.$refs.paramsForm.resetFields();
      }
      this.paramsDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.paramsForm) {
        this.$refs.paramsForm.resetFields();
      }
      this.$http({
        url: '/common/parameter/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.paramsForm = {
            'id': res.object.id,
            'systemName': res.object.systemName,
            'parameterName': res.object.parameterName,
            'describe': res.object.describe,
            'division': res.object.division,
            'type': res.object.type,
            'value': res.object.value,
            'remark': res.object.remark
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.paramsDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.paramsLoading = true;
      this.$http({
        url: '/common/parameter/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.paramsData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.paramsLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/common/parameter/save',
            method: 'post',
            data: this.paramsForm
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
          this.paramsDialog = false;
        }
      });
    }
  }
};
</script>

<style lang="scss" scoped>

</style>
