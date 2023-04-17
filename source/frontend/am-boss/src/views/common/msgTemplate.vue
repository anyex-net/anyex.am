<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="模版Key">
        <el-input v-model="searchForm.tplKey" clearable placeholder="请输入模版Key"></el-input>
      </el-form-item>
      <el-form-item label="消息标题">
        <el-input v-model="searchForm.title" clearable placeholder="请输入消息标题"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="tempLoading" :data="tempData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="模版类型">
        <template slot-scope="scope">
          <span v-if="scope.row.type === 'sms'">短信</span>
          <span v-if="scope.row.type === 'email'">邮件</span>
        </template>
      </el-table-column>
      <el-table-column label="语言类型">
        <template slot-scope="scope">
          <span v-if="scope.row.lang === 'zh_CN'">简体中文</span>
          <span v-if="scope.row.lang === 'zh_HK'">繁体中文</span>
          <span v-if="scope.row.lang === 'en_US'">English</span>
        </template>
      </el-table-column>
      <el-table-column prop="tplKey" label="模版Key" />
      <el-table-column prop="title" label="消息标题" />
      <el-table-column prop="createDate" :formatter="dateFormat" width="200" label="创建时间" />
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

    <el-dialog title="消息模版" :visible.sync="tempDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="tempForm" :model="tempForm" :rules="tempRules" label-width="80px" class="tempForm">
        <el-form-item label="消息标题" prop="title">
          <el-input v-model="tempForm.title" placeholder="请输入消息标题" />
        </el-form-item>
        <el-form-item label="模版Key" prop="tplKey">
          <el-input v-model="tempForm.tplKey" placeholder="请输入模版Key" />
        </el-form-item>
        <el-form-item label="模版类型" prop="type">
          <el-select v-model="tempForm.type" placeholder="请选择模版类型" value="">
            <el-option key="sms" label="短信" value="sms" />
            <el-option key="email" label="邮件" value="email" />
          </el-select>
        </el-form-item>
        <el-form-item label="语言类型" prop="lang">
          <el-select v-model="tempForm.lang" placeholder="请选择语言类型" value="">
            <el-option key="zh_CN" label="简体中文" value="zh_CN" />
            <el-option key="zh_HK" label="繁体中文" value="zh_HK" />
            <el-option key="en_US" label="English" value="en_US" />
          </el-select>
        </el-form-item>
        <el-form-item label="消息内容" prop="content">
          <el-input v-model="tempForm.content" type="textarea" placeholder="请输入消息内容" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('tempForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'MsgTemplate',
  data() {
    return {
      tempLoading: '',
      tempDialog: false,
      tempData: [],
      tempForm: {
        'id': '',
        'title': '',
        'tplKey': '',
        'type': '',
        'lang': '',
        'content': ''
      },
      searchForm: {
        'title': '',
        'tplKey': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      tempRules: {
        title: [
          { required: true, message: '请输入消息标题', trigger: 'blur' }
        ],
        tplKey: [
          { required: true, message: '请输入模版Key', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请选择消息类型', trigger: 'change' }
        ],
        lang: [
          { required: true, message: '请输入语言类型', trigger: 'change' }
        ],
        content: [
          { required: true, message: '请输入消息内容', trigger: 'blur' }
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
      this.tempForm = {
        'id': '',
        'title': '',
        'tplKey': '',
        'type': '',
        'lang': '',
        'content': ''
      };
      if (this.$refs.tempForm) {
        this.$refs.tempForm.resetFields();
      }
      this.tempDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.tempForm) {
        this.$refs.tempForm.resetFields();
      }
      this.$http({
        url: '/common/msgtemplate/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.tempForm = {
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
      this.tempDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.tempLoading = true;
      this.$http({
        url: '/common/msgtemplate/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.tempData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.tempLoading = false;
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
            data: this.tempForm
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
          this.tempDialog = false;
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
    }
  }
};
</script>

<style lang="scss" scoped>

</style>
