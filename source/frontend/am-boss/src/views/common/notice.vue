<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="标题">
        <el-input v-model="searchForm.title" clearable placeholder="请输入标题"></el-input>
      </el-form-item>
      <el-form-item label="语言类型">
        <el-select v-model="searchForm.langType" clearable placeholder="请选择语言类型" value="">
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

    <el-table v-loading="noticeLoading" :data="noticeData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="title" label="标题" />
      <el-table-column label="语言类型">
        <template slot-scope="scope">
          <span v-if="scope.row.langType === 'zh_CN'">简体中文</span>
          <span v-if="scope.row.langType === 'zh_HK'">繁体中文</span>
          <span v-if="scope.row.langType === 'en_US'">English</span>
        </template>
      </el-table-column>
      <el-table-column prop="content" label="内容" />
      <el-table-column prop="remark" label="备注" />
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span v-if="scope.row.status === true">已发布</span>
          <span v-else>未发布</span>
        </template>
        </el-table-column>
        <el-table-column prop="publicDate" label="发布时间" :formatter="dateFormat" />
        <el-table-column prop="createBy" label="创建人" />
        <el-table-column prop="createDate" label="创建时间" :formatter="dateFormat" />
        <el-table-column label="操作" width="250">
          <template slot-scope="scope">
            <el-button size="mini" type="warning" @click="doUpdateStatus(scope.$index, scope.row)">
              <span v-if="scope.row.status === true">取消发布</span>
              <span v-else>发布</span>
            </el-button>
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
      :total="pageParams.total"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="平台通知公告" :visible.sync="noticeDialog" :close-on-click-modal="false" width="850px">
      <el-form ref="noticeForm" :model="noticeForm" :rules="noticeRules" label-width="80px" class="noticeForm">
        <el-form-item label="语言类型" prop="langType">
          <el-select v-model="noticeForm.langType" placeholder="请输入语言类型" value="" style="width: 300px;">
            <el-option key="zh_CN" label="简体中文" value="zh_CN" />
            <el-option key="zh_HK" label="繁体中文" value="zh_HK" />
            <el-option key="en_US" label="English" value="en_US" />
          </el-select>
        </el-form-item>
        <el-form-item label="是否发布" prop="status" style="width: 300px;">
          <el-select v-model="noticeForm.status" placeholder="请输入状态" value="">
            <el-option key="true" label="发布" value="true" />
            <el-option key="false" label="不发布" value="false" />
          </el-select>
        </el-form-item>
        <el-form-item label="发布时间">
          <el-date-picker
            v-model="noticeForm.publicDate"
            type="datetime"
            value-format="timestamp"
            placeholder="选择发布时间"
            style="width: 200px;"
          >
          </el-date-picker>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="noticeForm.title" placeholder="请输入标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <quill-editor ref="quillEditor" v-model="noticeForm.content" :options="editorOption" style="width:720px;"></quill-editor>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="noticeForm.remark" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('noticeForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'Notice',
  data() {
    return {
      noticeLoading: true,
      noticeDialog: false,
      noticeData: [],
      commodityTypeSelects: [],
      dicts: [],
      noticeForm: {
        'id': '',
        'langType': '',
        'title': '',
        'content': '',
        'remark': '',
        'status': '',
        'publicDate': ''
      },
      searchForm: {
        'langType': '',
        'title': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      noticeRules: {
        langType: [
          { required: true, message: '语言类型(zh_CN简体、zh_HK繁体、en_US英文)不可为空', trigger: 'blur' }
        ],
        title: [
          { required: true, message: '标题不可为空', trigger: 'blur' }
        ],
        content: [
          { required: true, message: '内容不可为空', trigger: 'blur' }
        ],
        status: [
          { required: true, message: '状态(0未发布、1已发布)不可为空', trigger: 'blur' }
        ],
        createBy: [
          { required: true, message: '创建人不可为空', trigger: 'blur' }
        ],
        createDate: [
          { required: true, message: '创建时间不可为空', trigger: 'blur' }
        ]
      },
      editorOption: {
        modules: {
          toolbar: {
            container: [
              [{ 'header': [1, 2, 3, 4, 5, 6] }], // custom button values
              ['bold'], // toggled buttons
              ['underline'], // toggled buttons
              ['blockquote'],
              // [{ 'direction': 'rtl' }], // text direction
              // [{ 'list': 'ordered' }, { 'list': 'bullet' }],
              // [{ 'script': 'sub' }, { 'script': 'super' }], // superscript/subscript
              // [{ 'indent': '-1' }, { 'indent': '+1' }], // outdent/indent
              //
              //
              [{ 'color': [] }, { 'background': [] }], // dropdown with defaults from theme
              // [{ 'font': [] }],
              [{ 'align': '' }],
              [{ 'align': 'center' }],
              [{ 'align': 'right' }],
              ['clean'], // remove formatting button
              ['link']
            ] // 工具栏
          }
        }
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
    statusFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      var p = column.property;
      const obj = this.dicts[p];
      const size = obj.length;
      for (var i = 0; i < size; i++) {
        if (obj[i].key === date) {
          return obj[i].value;
        }
      }
      return '';
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.noticeLoading = true;
      this.$http({
        url: '/common/notice/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.noticeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.noticeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.noticeForm = {
        'id': '',
        'langType': '',
        'title': '',
        'content': '',
        'remark': '',
        'status': '',
        'publicDate': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.noticeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.noticeForm) {
        this.$refs.noticeForm.resetFields();
      }
      this.$http({
        url: '/common/notice/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.noticeForm = {
            'id': res.object.id,
            'langType': res.object.langType,
            'title': res.object.title,
            'content': res.object.content,
            'remark': res.object.remark,
            'status': res.object.status,
            'createBy': res.object.createBy,
            'createDate': res.object.createBy,
            'publicDate': res.object.publicDate
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.noticeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/common/notice/save',
            method: 'post',
            data: this.noticeForm
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
          this.noticeDialog = false;
        }
      });
    },
    doUpdateStatus: function(row, column) {
      var tips = '';
      var status = '';
      if (column.status === true) {
        tips = '确认取消发布选择的信息, 是否继续?';
        status = 0;
      } else {
        tips = '确认发布选择的信息, 是否继续?';
        status = 1;
      }
      this.$confirm(tips, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/notice/updateStatus',
          method: 'post',
          data: {
            id: column.id,
            status: status
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
    doDelete: function(row, column) {
      this.$confirm('确认删除该记录吗, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/common/notice/del',
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
		.noticeForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
