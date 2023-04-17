<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="母账户内盘期货投资者帐号ID">
        <el-select v-model="searchForm.motherNpfuturesAccountInfoId" clearable placeholder="请选择母账户外盘期货投资者帐号" value="">
          <el-option v-for="data in idSelect" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subNpfuturesAccountInfoLoading" :data="subNpfuturesAccountInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
      <el-table-column prop="motherNpfuturesAccountInfoId" label="母账户内盘期货投资者帐号ID"/>
      <el-table-column prop="brokerID" label="经纪商编码"/>
      <el-table-column prop="investorID" label="资金账号"/>
      <el-table-column prop="remark" label="备注"/>
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
    <el-dialog title="子账户投资帐号信息" :visible.sync="subNpfuturesAccountInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="subNpfuturesAccountInfoForm" :model="subNpfuturesAccountInfoForm"
               :rules="subNpfuturesAccountInfoRules" label-width="150px" class="subNpfuturesAccountInfoForm">
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subNpfuturesAccountInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="母账户内盘期货投资者帐号ID" prop="motherNpfuturesAccountInfoId">
          <el-select v-model="subNpfuturesAccountInfoForm.motherNpfuturesAccountInfoId" clearable placeholder="请选择母账户投资者帐号/ID" value="">
            <el-option v-for="data in idSelect" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="subNpfuturesAccountInfoForm.remark" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('subNpfuturesAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubNpfuturesAccountInfoName',
    data() {
      return {
        subNpfuturesAccountInfoLoading: true,
        subNpfuturesAccountInfoDialog: false,
        subNpfuturesAccountInfoData: [],
        idSelect: [],
        subNpfuturesAccountInfoForm: {
          'id': '',
          'subAccountId': '',
          'motherNpfuturesAccountInfoId': '',
          'brokerNo': '',
          'investorID': '',
          'remark': ''
        },
        searchForm: {
          'subAccountId': '',
          'motherNpfuturesAccountInfoId': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subNpfuturesAccountInfoRules: {
          subAccountId: [
            { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
          ],
          motherNpfuturesAccountInfoId: [
            { required: true, message: '母账户内盘期货投资者帐号ID不可为空', trigger: 'change' }
          ],
          remark: [
            { required: true, message: '备注不可为空', trigger: 'change' }
          ]
        }
      };
    },
    mounted: function() {
      this.doSelectAll();
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
        this.subNpfuturesAccountInfoLoading = true;
        this.$http({
          url: '/npfutures/subNpfuturesAccountInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesAccountInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subNpfuturesAccountInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      doSelectAll() {
        this.$http({
          url: '/npfutures/subNpfuturesAccountInfo/selectAll',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.idSelect = res.object;
          }
        }).catch(error => {
          console.log(error);
        });
      },
      dialogAdd: function() {
        this.subNpfuturesAccountInfoForm = {
          'id': '',
          'subAccountId': '',
          'motherNpfuturesAccountInfoId': '',
          'remark': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subNpfuturesAccountInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subNpfuturesAccountInfoForm) {
          this.$refs.subNpfuturesAccountInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/subNpfuturesAccountInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subNpfuturesAccountInfoForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
              'motherNpfuturesAccountInfoId': res.object.motherNpfuturesAccountInfoId,
              'remark': res.object.remark
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.subNpfuturesAccountInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/subNpfuturesAccountInfo/save',
              method: 'post',
              data: this.subNpfuturesAccountInfoForm
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
            this.subNpfuturesAccountInfoDialog = false;
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
            url: '/npfutures/subNpfuturesAccountInfo/del',
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
  .subNpfuturesAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
