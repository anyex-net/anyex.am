<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="国际代码">
        <el-input v-model="searchForm.lCode" clearable placeholder="请输入国际代码"></el-input>
      </el-form-item>
      <el-form-item label="中文名称">
        <el-input v-model="searchForm.cnName" clearable placeholder="请输入中文名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="regionLoading" :data="regionData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" width="50" />
      <el-table-column prop="sCode" label="国际编码" />
      <el-table-column prop="lCode" label="国际代码" />
      <el-table-column prop="enName" label="英文名称" />
      <el-table-column prop="cnName" label="中文名称" />
      <el-table-column prop="area" label="区域" />
      <el-table-column label="操作" width="150">
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

    <el-dialog title="区域代码" :visible.sync="regionDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="regionForm" :model="regionForm" :rules="regionRules" label-width="80px" class="regionForm">
        <el-form-item label="国际编码" prop="sCode">
          <el-input v-model="regionForm.sCode" placeholder="请输入国际编码" />
        </el-form-item>
        <el-form-item label="国际代码" prop="lCode">
          <el-input v-model="regionForm.lCode" placeholder="请输入国际代码" />
        </el-form-item>
        <el-form-item label="英文名称" prop="enName">
          <el-input v-model="regionForm.enName" placeholder="请输入英文名称" />
        </el-form-item>
        <el-form-item label="中文名称" prop="cnName">
          <el-input v-model="regionForm.cnName" placeholder="请输入中文名称" />
        </el-form-item>
        <el-form-item label="区域" prop="area">
          <el-input v-model="regionForm.area" placeholder="请输入区域" />
        </el-form-item>
        <el-form-item label="排序号" prop="sortNum">
          <el-input v-model="regionForm.sortNum" placeholder="请输入排序号" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('regionForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'Region',
  data() {
    return {
      regionLoading: '',
      regionDialog: false,
      regionData: [],
      regionForm: {
        'id': '',
        'sCode': '',
        'lCode': '',
        'enName': '',
        'cnName': '',
        'area': '',
        'sortNum': ''
      },
      searchForm: {
        'lCode': '',
        'cnName': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      regionRules: {
        sCode: [
          { required: true, message: '请输入国际编码', trigger: 'blur' }
        ],
        lCode: [
          { required: true, message: '请输入国际代码', trigger: 'blur' }
        ],
        enName: [
          { required: true, message: '请输入英文名称', trigger: 'blur' }
        ],
        cnName: [
          { required: true, message: '请输入中文名称', trigger: 'blur' }
        ],
        area: [
          { required: true, message: '请输入区域', trigger: 'blur' }
        ]
      }
    };
  },
  mounted: function() {
    this.doSearch();
  },
  methods: {
    dialogAdd: function() {
      this.regionForm = {
        'id': '',
        'sCode': '',
        'lCode': '',
        'enName': '',
        'cnName': '',
        'area': ''
      };
      if (this.$refs.regionForm) {
        this.$refs.regionForm.resetFields();
      }
      this.regionDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.regionForm) {
        this.$refs.regionForm.resetFields();
      }
      this.$http({
        url: '/common/region/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.regionForm = {
            'id': res.object.id,
            'sCode': res.object.sCode,
            'lCode': res.object.lCode,
            'enName': res.object.enName,
            'cnName': res.object.cnName,
            'area': res.object.area,
            'sortNum': res.object.sortNum
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.regionDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.regionLoading = true;
      this.$http({
        url: '/common/region/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.regionData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.regionLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/common/region/save',
            method: 'post',
            data: this.regionForm
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
          this.regionDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该区域代码, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/region/del',
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
