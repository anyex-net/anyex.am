<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="母账户内盘现货投资者帐号ID">
        <el-select v-model="searchForm.motherNpspotAccountInfoId" clearable placeholder="请选择母账户内盘现货投资者帐号" value="">
          <el-option v-for="data in dicts" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="subStpNpSpotAccountInfoLoading"
      :data="subStpNpSpotAccountInfoData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" />
      <el-table-column prop="motherNpspotAccountInfoId" label="母账户内盘现货投资者帐号ID" />
      <el-table-column prop="remark" label="备注" />
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
    <el-dialog
      title="子账户投资帐号信息表管理"
      :visible.sync="subStpNpSpotAccountInfoDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="subStpNpSpotAccountInfoForm"
        :model="subStpNpSpotAccountInfoForm"
        :rules="subStpNpSpotAccountInfoRules"
        label-width="150px"
        class="subStpNpSpotAccountInfoForm"
      >
<!--        <el-form-item label="主键" prop="id">-->
<!--          <el-input v-model="subStpNpSpotAccountInfoForm.id" placeholder="请输入主键" />-->
<!--        </el-form-item>-->
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subStpNpSpotAccountInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
        </el-form-item>
        <el-form-item label="母账户内盘现货投资者帐号ID" prop="subAccountId">
          <el-select v-model="subStpNpSpotAccountInfoForm.motherNpspotAccountInfoId" clearable placeholder="请选择母账户内盘现货投资者帐号" value="">
            <el-option v-for="data in dicts" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="subStpNpSpotAccountInfoForm.remark" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('subStpNpSpotAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubStpNpSpotAccountInfoName',
  data() {
    return {
      subStpNpSpotAccountInfoLoading: true,
      subStpNpSpotAccountInfoDialog: false,
      subStpNpSpotAccountInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      subStpNpSpotAccountInfoForm: {
        'id': '',
        'subAccountId': '',
        'motherNpspotAccountInfoId': '',
        'remark': ''
      },
      searchForm: {
        'id': '',
        'subAccountId': '',
        'motherNpspotAccountInfoId': '',
        'remark': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subStpNpSpotAccountInfoRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
        ],
        motherNpspotAccountInfoId: [
          { required: true, message: '母账户内盘现货投资者帐号ID不可为空', trigger: 'change' }
        ],
        remark: [
          { required: true, message: '备注不可为空', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    // this.doInitData();
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
    doInitData() {
      this.$http({
        url: '/npspot/dict/subStpNpSpotAccountInfo',
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
      this.subStpNpSpotAccountInfoLoading = true;
      this.$http({
        url: '/npspot/subStpNpSpotAccountInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotAccountInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subStpNpSpotAccountInfoLoading = false;
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
        url: '/npspot/subStpNpSpotAccountInfo/selectAll',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          console.log("dicts", this.dicts[0]);
        }
      }).catch(error => {
        console.log(error);
      });
    },
    dialogAdd: function() {
      this.subStpNpSpotAccountInfoForm = {
        'id': '',
        'subAccountId': '',
        'motherNpspotAccountInfoId': '',
        'remark': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subStpNpSpotAccountInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subStpNpSpotAccountInfoForm) {
        this.$refs.subStpNpSpotAccountInfoForm.resetFields();
      }
      this.$http({
        url: '/npspot/subStpNpSpotAccountInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subStpNpSpotAccountInfoForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
            'motherNpspotAccountInfoId': res.object.motherNpspotAccountInfoId,
            'remark': res.object.remark
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subStpNpSpotAccountInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/subStpNpSpotAccountInfo/save',
            method: 'post',
            data: this.subStpNpSpotAccountInfoForm
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
          this.subStpNpSpotAccountInfoDialog = false;
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
          url: '/npspot/subStpNpSpotAccountInfo/del',
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
  .subStpNpSpotAccountInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
