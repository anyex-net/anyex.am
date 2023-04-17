<template>
  <div class="app-container">

    <el-table
      v-loading="resLoading"
      :data="resData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
      lazy
      :load="doLoad"
    >
      <el-table-column prop="resName" label="资源名称" width="150px" />
      <el-table-column prop="resCode" label="资源编码" width="200px" />
      <el-table-column label="类型">
        <template slot-scope="scope">
          <span v-if="scope.row.type === false">菜单</span>
          <span v-if="scope.row.type === true">权限</span>
        </template>
      </el-table-column>
      <el-table-column prop="iconCls" label="图标" />
      <el-table-column prop="resUrl" label="地址" width="150px" />
      <el-table-column prop="sortNum" label="排序号" />
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

    <el-dialog title="资源信息" :visible.sync="resDialog" :close-on-click-modal="false" width="620px">
      <el-form ref="resForm" :inline="true" :model="resForm" :rules="resRules" label-width="80px" class="resForm">
        <el-form-item label="编号" prop="resCode">
          <el-input v-model="resForm.resCode" placeholder="请输入编号" />
        </el-form-item>
        <el-form-item label="名称" prop="resName">
          <el-input v-model="resForm.resName" placeholder="请输入名称" />
        </el-form-item>
        <el-form-item label="地址" prop="resUrl">
          <el-input v-model="resForm.resUrl" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item label="排序号" prop="sortNum">
          <el-input v-model="resForm.sortNum" placeholder="请输入排序号" />
        </el-form-item>
        <el-form-item label="图标" prop="iconCls">
          <el-input v-model="resForm.iconCls" placeholder="请输入图标" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="resForm.type" placeholder="请选择类型" value="">
            <el-option :key="false" label="菜单" :value="false" />
            <el-option :key="true" label="权限" :value="true" />
          </el-select>
        </el-form-item>
        <el-form-item label="上级资源" prop="parentId">
          <select-tree
            :value="resForm.parentId"
            :options="resTree"
            :clearable="true"
            :accordion="true"
            :multiple="false"
            :props="{value:'id',label:'resName',children:'children'}"
            @getValue="getValue($event)"
          />
        </el-form-item>
        <el-form-item style="display:block;" label="资源描述" prop="orgDest">
          <el-input v-model="resForm.resDest" style="width:485px;" type="textarea" placeholder="请输入资源描述" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button style="margin-left:80px;" type="primary" @click="doSubmit('resForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
import selectTree from '@/components/selectTree';

export default {
  name: 'Resource',
  components: {
    selectTree
  },
  data() {
    return {
      resLoading: '',
      resDialog: false,
      resData: [],
      resTree: [],
      resForm: {
        'id': '',
        'resCode': '',
        'resName': '',
        'resUrl': '',
        'parentId': '',
        'iconCls': '',
        'type': '',
        'resDest': '',
        'sortNum': ''
      },
      resRules: {
        resCode: [
          { required: true, message: '请输入资源编号', trigger: 'blur' }
        ],
        resName: [
          { required: true, message: '请选择资源名称', trigger: 'blur' }
        ],
        resUrl: [
          { required: true, message: '请选择资源名称', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请选择类型', trigger: 'change' }
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
      this.resForm.parentId = value;
    },
    dialogAdd: function(row, column) {
      this.resForm = {
        'id': '',
        'resCode': '',
        'resName': '',
        'resUrl': '',
        'parentId': column.id,
        'iconCls': '',
        'type': '',
        'resDest': '',
        'sortNum': ''
      };
      if (this.$refs.resForm) {
        this.$refs.resForm.resetFields();
      }
      this.resDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.resForm) {
        this.$refs.resForm.resetFields();
      }
      this.$http({
        url: '/system/resource/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.resForm = {
            'id': res.object.id,
            'resCode': res.object.resCode,
            'resName': res.object.resName,
            'resUrl': res.object.resUrl,
            'parentId': res.object.parentId,
            'iconCls': res.object.iconCls,
            'type': res.object.type,
            'resDest': res.object.resDest,
            'sortNum': res.object.sortNum
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.resDialog = true;
    },
    doSearch: function() {
      this.resLoading = true;
      this.$http({
        url: '/system/resource/data',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.resData = res.object;
          this.resData.forEach((item) => {
            item.hasChildren = true;
          });
          this.resLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doInitData: function() {
      this.$http({
        url: '/system/resource/tree',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.resTree = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doLoad(tree, treeNode, resolve) {
      this.$http({
        url: '/system/resource/data',
        method: 'post',
        data: {
          id: tree.id
        }
      }).then(res => {
        if (res.code === 200) {
          if (treeNode.level < 1) {
            res.object.forEach((item) => {
              item.hasChildren = true;
            });
          }
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
            url: '/system/resource/save',
            method: 'post',
            data: this.resForm
          }).then(res => {
            if (res.code === 200) {
              this.$message.success(res.message);
              this.doSearch();
              this.doInitData();
            } else {
              this.$message.error(res.message || 'Has Error');
            }
          }).catch(error => {
            this.$message.error(error);
          });
          this.resDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该资源, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/system/resource/del',
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

<style lang="scss">
  .resForm.el-form--inline .el-form-item__content {
    width: 196px;
  }
</style>
