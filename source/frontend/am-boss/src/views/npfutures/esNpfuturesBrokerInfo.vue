<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="经纪商编码">
        <el-input v-model="searchForm.brokerNo" clearable placeholder="请输入经纪商编码"></el-input>
      </el-form-item>
      <el-form-item label="经纪商名称">
        <el-input v-model="searchForm.brokerName" clearable placeholder="请输入经纪商名称"></el-input>
      </el-form-item>
      <el-form-item label="经纪商域名">
        <el-input v-model="searchForm.brokerDomain" clearable placeholder="请输入经纪商域名"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesBrokerInfoLoading" :data="esNpfuturesBrokerInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="brokerNo" label="经纪商编码"/>
      <el-table-column prop="brokerName" label="经纪商名称"/>
      <el-table-column prop="brokerDomain" label="经纪商域名"/>
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
    <el-dialog title="内盘期货经纪商信息表管理" :visible.sync="esNpfuturesBrokerInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesBrokerInfoForm" :model="esNpfuturesBrokerInfoForm" :rules="esNpfuturesBrokerInfoRules"
               label-width="150px" class="esNpfuturesBrokerInfoForm">
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-input v-model="esNpfuturesBrokerInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
        </el-form-item>
        <el-form-item label="经纪商名称" prop="brokerName">
          <el-input v-model="esNpfuturesBrokerInfoForm.brokerName" placeholder="请输入经纪商名称"/>
        </el-form-item>
        <el-form-item label="经纪商域名" prop="brokerDomain">
          <el-input v-model="esNpfuturesBrokerInfoForm.brokerDomain" placeholder="请输入经纪商域名"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('esNpfuturesBrokerInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesBrokerInfoName',
    data() {
      return {
        esNpfuturesBrokerInfoLoading: true,
        esNpfuturesBrokerInfoDialog: false,
        esNpfuturesBrokerInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesBrokerInfoForm: {
          'id': '',
          'brokerNo': '',
          'brokerName': '',
          'brokerDomain': ''
        },
        searchForm: {
          'brokerNo': '',
          'brokerName': '',
          'brokerDomain': ''
          ,
          'sort': 'id',
          'order': 'asc'
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesBrokerInfoRules: {
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          brokerName: [
            { required: true, message: '经纪商名称不可为空', trigger: 'change' }
          ],
          brokerDomain: [
            { required: true, message: '经纪商域名不可为空', trigger: 'change' }
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
        this.esNpfuturesBrokerInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesBrokerInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesBrokerInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesBrokerInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesBrokerInfoForm = {
          'id': '',
          'brokerNo': '',
          'brokerName': '',
          'brokerDomain': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesBrokerInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesBrokerInfoForm) {
          this.$refs.esNpfuturesBrokerInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesBrokerInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesBrokerInfoForm = {
              'id': res.object.id,
              'brokerNo': res.object.brokerNo,
              'brokerName': res.object.brokerName,
              'brokerDomain': res.object.brokerDomain
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesBrokerInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesBrokerInfo/save',
              method: 'post',
              data: this.esNpfuturesBrokerInfoForm
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
            this.esNpfuturesBrokerInfoDialog = false;
          }
        });
      },
      doDelete: function(row, column) {
        this.$confirm('确认删除该记录吗, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: '/npfutures/esNpfuturesBrokerInfo/del',
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
  .esNpfuturesBrokerInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
