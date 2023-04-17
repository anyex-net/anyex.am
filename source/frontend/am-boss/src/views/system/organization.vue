<template>
  <div class="app-container">

    <el-table
      v-loading="orgLoading"
      :data="orgData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
      lazy
      :load="doLoad"
    >
      <el-table-column prop="orgCode" label="机构编码" />
      <el-table-column prop="orgName" label="机构名称" />
      <el-table-column prop="orgDest" label="机构描述" />
      <el-table-column prop="createByName" label="创建人" />
      <el-table-column prop="createDate" :formatter="dateFormat" width="200" label="创建时间" />
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="primary" @click="dialogAdd(scope.$index, scope.row)">添加</el-button>
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="机构信息" :visible.sync="orgDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="orgForm" :model="orgForm" :rules="orgRules" label-width="80px" class="orgForm">
        <el-form-item label="机构编码" prop="orgCode">
          <el-input v-model="orgForm.orgCode" placeholder="请输入机构编码" />
        </el-form-item>
        <el-form-item label="机构名称" prop="orgName">
          <el-input v-model="orgForm.orgName" placeholder="请输入机构名称" />
        </el-form-item>
        <el-form-item label="排序号" prop="sortNum">
          <el-input v-model="orgForm.sortNum" placeholder="请输入排序号" />
        </el-form-item>
        <el-form-item label="上级资源" prop="parentId">
          <select-tree
            :value="orgForm.parentId"
            :options="orgTree"
            :clearable="true"
            :accordion="true"
            :multiple="false"
            :props="{value:'id',label:'orgName',children:'children'}"
            @getValue="getValue($event)"
          />
        </el-form-item>
        <el-form-item label="机构描述" prop="orgDest">
          <el-input v-model="orgForm.orgDest" type="textarea" placeholder="请输入机构描述" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('orgForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
import selectTree from '@/components/selectTree';

export default {
  name: 'Organization',
  components: {
    selectTree
  },
  data() {
    return {
      orgLoading: '',
      orgDialog: false,
      orgData: [],
      orgTree: [],
      orgForm: {
        'id': '',
        'parentId': '',
        'orgCode': '',
        'orgName': '',
        'orgDest': '',
        'sortNum': ''
      },
      orgRules: {
        orgCode: [
          { required: true, message: '请输入机构编码', trigger: 'blur' }
        ],
        orgName: [
          { required: true, message: '请选择机构名称', trigger: 'blur' }
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
      this.orgForm.parentId = value;
    },
    dialogAdd: function(row, column) {
      this.orgForm = {
        'id': '',
        'parentId': column.id,
        'orgCode': '',
        'orgName': '',
        'orgDest': '',
        'sortNum': ''
      };
      if (this.$refs.orgForm) {
        this.$refs.orgForm.resetFields();
      }
      this.orgDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.orgForm) {
        this.$refs.orgForm.resetFields();
      }
      this.$http({
        url: '/system/organiz/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.orgForm = {
            'id': res.object.id,
            'parentId': res.object.parentId,
            'orgCode': res.object.orgCode,
            'orgName': res.object.orgName,
            'orgDest': res.object.orgDest,
            'sortNum': res.object.sortNum
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.orgDialog = true;
    },
    doInitData: function() {
      this.$http({
        url: '/system/organiz/tree',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.orgTree = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSearch: function() {
      this.orgLoading = true;
      this.$http({
        url: '/system/organiz/data',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.orgData = res.object;
          this.orgData.forEach((item) => {
            item.hasChildren = true;
          });
          this.orgLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doLoad(tree, treeNode, resolve) {
      this.$http({
        url: '/system/organiz/data',
        method: 'post',
        data: {
          id: tree.id
        }
      }).then(res => {
        if (res.code === 200) {
          resolve(res.object);
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/system/organiz/save',
            method: 'post',
            data: this.orgForm
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
          this.orgDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该机构, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/system/organiz/del',
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
