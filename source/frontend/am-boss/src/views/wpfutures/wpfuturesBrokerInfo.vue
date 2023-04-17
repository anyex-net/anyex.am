<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="经纪商编码">
        <el-input v-model="searchForm.brokerNo" clearable placeholder="请输经纪商编码"></el-input>
      </el-form-item>
      <el-form-item label="经纪商名称">
        <el-input v-model="searchForm.brokerName" clearable placeholder="请输入经纪商名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="wpfuturesBrokerInfoLoading" :data="wpfuturesBrokerInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="序号" :index="table_index" width="50"/>
      <el-table-column prop="brokerNo" label="经纪商编码" />
      <el-table-column prop="brokerName" label="经纪商名称" />
      <el-table-column prop="brokerDomain" label="经纪商域名" />
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

    <el-dialog title="经纪商信息编辑" :visible.sync="wpfuturesBrokerInfoDialog" :close-on-click-modal="false" width="600px">
      <el-form ref="wpfuturesBrokerInfoForm" :model="wpfuturesBrokerInfoForm" :rules="wpfuturesBrokerInfoRules" label-width="120px" class="wpfuturesBrokerInfoForm">
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-input v-model="wpfuturesBrokerInfoForm.brokerNo" placeholder="请输入经纪商编码" />
        </el-form-item>
        <el-form-item label="经纪商名称" prop="brokerName">
          <el-input v-model="wpfuturesBrokerInfoForm.brokerName" placeholder="请输入经纪商名称" />
        </el-form-item>
        <el-form-item label="经纪商域名" prop="brokerDomain">
          <el-input v-model="wpfuturesBrokerInfoForm.brokerDomain" placeholder="请输入经纪商域名" />
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('wpfuturesBrokerInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'WpfuturesBrokerInfo',
  data() {
    return {
      wpfuturesBrokerInfoLoading: '',
      wpfuturesBrokerInfoDialog: false,
      wpfuturesBrokerInfoData: [],
      wpfuturesBrokerInfoForm: {
        'id': '',
        'brokerNo': '',
        'brokerName': '',
        'brokerDomain': ''
      },
      searchForm: {
        'brokerNo': '',
        'brokerName': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      wpfuturesBrokerInfoRules: {
        brokerNo: [
          { required: true, message: '请输入经纪商编码', trigger: 'blur' }
        ],
        brokerName: [
          { required: true, message: '请输入经纪商名称', trigger: 'blur' }
        ],
        brokerDomain: [
          { required: true, message: '请输入经纪商域名', trigger: 'blur' }
        ]
      }
    };
  },
  mounted: function() {
    this.doSearch();
  },
  methods: {
    table_index(index) {
      return (this.pageParams.page - 1) * this.pageParams.rows + index + 1;
    },

    dateFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      return this.$moment(date).format('YYYY-MM-DD HH:mm:ss');
    },
    dialogAdd: function() {
      this.wpfuturesBrokerInfoForm = {
        'id': '',
        'wpfuturesBrokerInfo': '',
        'buildVersion': '',
        'deviceType': '',
        'canSupport': '',
        'checkStatus': '',
        'remark': ''
      };
      if (this.$refs.wpfuturesBrokerInfoForm) {
        this.$refs.wpfuturesBrokerInfoForm.resetFields();
      }
      this.wpfuturesBrokerInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesBrokerInfoForm) {
        this.$refs.wpfuturesBrokerInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesBrokerInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesBrokerInfoForm = {
            'id': res.object.id,
            'brokerNo': res.object.brokerNo,
            'brokerName': res.object.brokerName,
            'brokerDomain': res.object.brokerDomain
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesBrokerInfoDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.wpfuturesBrokerInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesBrokerInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesBrokerInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.wpfuturesBrokerInfoLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/wpfuturesBrokerInfo/save',
            method: 'post',
            data: this.wpfuturesBrokerInfoForm
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
          this.wpfuturesBrokerInfoDialog = false;
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
          url: '/wpfutures/wpfuturesBrokerInfo/del',
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

