<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司简称">
        <el-input v-model="searchForm.brokerAbbr" clearable placeholder="请输入经纪公司简称"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司名称">
        <el-input v-model="searchForm.brokerName" clearable placeholder="请输入经纪公司名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpSpotBrokerLoading" :data="wpSpotBrokerData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="brokerAbbr" label="经纪公司简称" />
      <el-table-column prop="brokerName" label="经纪公司名称" />
      <el-table-column prop="brokerDomain" label="经纪公司域名" />
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
      :total="pageParams.total"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />
    <el-dialog title="外盘现货经纪商信息表管理" :visible.sync="wpSpotBrokerDialog" :close-on-click-modal="false" width="600">
      <el-form ref="wpSpotBrokerForm" :model="wpSpotBrokerForm" :rules="wpSpotBrokerRules" label-width="150px" class="wpSpotBrokerForm">
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="wpSpotBrokerForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="wpSpotBrokerForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="经纪公司简称" prop="brokerAbbr">
          <el-input v-model="wpSpotBrokerForm.brokerAbbr" placeholder="请输入经纪公司简称" />
        </el-form-item>
        <el-form-item label="经纪公司名称" prop="brokerName">
          <el-input v-model="wpSpotBrokerForm.brokerName" placeholder="请输入经纪公司名称" />
        </el-form-item>
        <el-form-item label="经纪公司域名" prop="brokerDomain">
          <el-input v-model="wpSpotBrokerForm.brokerDomain" placeholder="请输入经纪公司域名" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('wpSpotBrokerForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WpSpotBrokerName',
  data() {
    return {
      wpSpotBrokerLoading: true,
      wpSpotBrokerDialog: false,
      wpSpotBrokerData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpSpotBrokerForm: {
        'id': '',
        'brokerID': '',
        'brokerAbbr': '',
        'brokerName': '',
        'brokerDomain': ''
      },
      searchForm: {
        'id': '',
        'brokerID': '',
        'brokerAbbr': '',
        'brokerName': '',
        'brokerDomain': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpSpotBrokerRules: {
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        brokerAbbr: [
          { required: true, message: '经纪公司简称不可为空', trigger: 'change' }
        ],
        brokerName: [
          { required: true, message: '经纪公司名称不可为空', trigger: 'change' }
        ],
        brokerDomain: [
          { required: true, message: '经纪公司域名不可为空', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    // this.doInitData();
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
    doInitData() {
      this.$http({
        url: '/wpspot/dict/wpSpotBroker',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.wpSpotBrokerLoading = true;
      this.$http({
        url: '/wpspot/wpSpotBroker/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotBrokerData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpSpotBrokerLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpSpotBrokerForm = {
        'id': '',
        'brokerID': '',
        'brokerAbbr': '',
        'brokerName': '',
        'brokerDomain': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpSpotBrokerDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpSpotBrokerForm) {
        this.$refs.wpSpotBrokerForm.resetFields();
      }
      this.$http({
        url: '/wpspot/wpSpotBroker/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpSpotBrokerForm = {
            'id': res.object.id,
            'brokerID': res.object.brokerID,
            'brokerAbbr': res.object.brokerAbbr,
            'brokerName': res.object.brokerName,
            'brokerDomain': res.object.brokerDomain
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpSpotBrokerDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/wpSpotBroker/save',
            method: 'post',
            data: this.wpSpotBrokerForm
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
          this.wpSpotBrokerDialog = false;
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
          url: '/wpspot/wpSpotBroker/del',
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
		.wpSpotBrokerForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
