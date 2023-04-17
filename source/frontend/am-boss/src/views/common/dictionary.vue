<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="字典名称">
        <el-input v-model="searchForm.name" clearable placeholder="请输入字典名称"></el-input>
      </el-form-item>
      <el-form-item label="字典编码">
        <el-input v-model="searchForm.code" clearable placeholder="请输入字典编码"></el-input>
      </el-form-item>
      <el-form-item label="语言类型">
        <el-select v-model="searchForm.lang" clearable placeholder="请选择语言类型" value="">
          <el-option key="zh_CN" label="简体中文" value="zh_CN" />
          <el-option key="zh_HK" label="繁体中文" value="zh_HK" />
          <el-option key="en_US" label="English" value="en_US" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table
      v-loading="dictLoading"
      :data="dictData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
      lazy
      :load="doLoad"
    >
      <el-table-column prop="name" label="字典名称" />
      <el-table-column prop="code" label="字典编码" />
      <el-table-column prop="dest" label="键值描述" />
      <el-table-column label="语言类型">
        <template slot-scope="scope">
          <span v-if="scope.row.lang === 'zh_CN'">简体中文</span>
          <span v-if="scope.row.lang === 'zh_HK'">繁体中文</span>
          <span v-if="scope.row.lang === 'en_US'">English</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span v-if="scope.row.active === true">启用</span>
          <span v-if="scope.row.active === false">禁用</span>
        </template>
      </el-table-column>
      <el-table-column prop="createDate" :formatter="dateFormat" width="200" label="创建时间" />
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="数据字典" :visible.sync="dictDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="dictForm" :model="dictForm" :rules="dictRules" label-width="80px" class="dictForm">
        <el-form-item label="字典名称" prop="name">
          <el-input v-model="dictForm.name" placeholder="请输入字典名称" />
        </el-form-item>
        <el-form-item label="字典编码" prop="code">
          <el-input v-model="dictForm.code" placeholder="请输入字典编码" />
        </el-form-item>
        <el-form-item label="键值描述" prop="dest">
          <el-input v-model="dictForm.dest" placeholder="请输入键值描述" />
        </el-form-item>
        <el-form-item label="语言类型" prop="lang">
          <el-select v-model="dictForm.lang" placeholder="请选择语言类型" value="">
            <el-option key="zh_CN" label="简体中文" value="zh_CN" />
            <el-option key="zh_HK" label="繁体中文" value="zh_HK" />
            <el-option key="en_US" label="English" value="en_US" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="active">
          <el-select v-model="dictForm.active" placeholder="请选择状态" value="">
            <el-option :key="true" label="启用" :value="true" />
            <el-option :key="false" label="禁用" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item label="上级资源" prop="parentId">
          <select-tree
            :value="dictForm.parentId"
            :options="dictTree"
            :clearable="true"
            :accordion="true"
            :multiple="false"
            :props="{value:'id',label:'name',children:'children'}"
            @getValue="getValue($event)"
          />
        </el-form-item>
        <el-form-item label="排序号" prop="sortNum">
          <el-input v-model="dictForm.sortNum" placeholder="请输入排序号" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('dictForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
import selectTree from '@/components/selectTree';

export default {
  name: 'Dictionary',
  components: {
    selectTree
  },
  data() {
    return {
      dictLoading: '',
      dictDialog: false,
      dictData: [],
      dictTree: [],
      dictForm: {
        'id': '',
        'name': '',
        'code': '',
        'dest': '',
        'lang': '',
        'active': '',
        'parentId': '',
        'sortNum': ''
      },
      searchForm: {
        'name': '',
        'code': '',
        'lang': ''
      },
      dictRules: {
        name: [
          { required: true, message: '请输入字典名称', trigger: 'blur' }
        ],
        code: [
          { required: true, message: '请输入字典编码', trigger: 'blur' }
        ],
        active: [
          { required: true, message: '请选择状态', trigger: 'change' }
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
      this.dictForm.parentId = value;
    },
    dialogAdd: function() {
      this.dictForm = {
        'id': '',
        'name': '',
        'code': '',
        'dest': '',
        'lang': '',
        'active': '',
        'parentId': '',
        'sortNum': ''
      };
      if (this.$refs.dictForm) {
        this.$refs.dictForm.resetFields();
      }
      this.dictDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.dictForm) {
        this.$refs.dictForm.resetFields();
      }
      this.$http({
        url: '/common/dict/findById',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.dictForm = {
            'id': res.object.id,
            'name': res.object.name,
            'code': res.object.code,
            'dest': res.object.dest,
            'lang': res.object.lang,
            'active': res.object.active,
            'parentId': res.object.parentId,
            'sortNum': res.object.sortNum
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.dictDialog = true;
    },
    doInitData: function() {
      this.$http({
        url: '/common/dict/tree',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dictTree = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSearch: function() {
      this.dictLoading = true;
      this.$http({
        url: '/common/dict/data',
        method: 'post',
        data: this.searchForm
      }).then(res => {
        if (res.code === 200) {
          this.dictData = res.object;
          this.dictData.forEach((item) => {
            item.hasChildren = true;
          });
          this.dictLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doLoad(tree, treeNode, resolve) {
      this.$http({
        url: '/common/dict/data',
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
            url: '/common/dict/save',
            method: 'post',
            data: this.dictForm
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
          this.dictDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该数据字典, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/dict/del',
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
