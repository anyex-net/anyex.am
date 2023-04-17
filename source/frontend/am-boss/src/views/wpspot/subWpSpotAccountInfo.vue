<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="主键">
        <el-input v-model="searchForm.id" clearable placeholder="请输入主键"></el-input>
      </el-form-item>
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="母账户外盘现货投资者帐号ID">
        <el-select v-model="searchForm.motherWpSpotAccountInfoId" clearable placeholder="请输入母账户外盘现货投资者帐号ID" value="">
          <el-option v-for="data in dicts" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subWpSpotAccountInfoLoading" :data="subWpSpotAccountInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID" />
      <el-table-column prop="motherWpSpotAccountInfoId" label="母账户子账户投资者帐号ID" />
      <el-table-column prop="remark" label="备注" />
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
    <el-dialog title="子账户投资帐号信息表管理" :visible.sync="subWpSpotAccountInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="subWpSpotAccountInfoForm" :model="subWpSpotAccountInfoForm" :rules="subWpSpotAccountInfoRules" label-width="180px" class="subWpSpotAccountInfoForm">
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subWpSpotAccountInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID" />
        </el-form-item>
        <el-form-item label="母账户外盘现货投资者帐号ID" prop="motherWpSpotAccountInfoId">
          <el-select v-model="subWpSpotAccountInfoForm.motherWpSpotAccountInfoId" clearable placeholder="请输入母账户外盘现货投资者帐号ID" value="">
            <el-option v-for="data in dicts" :key="data.id" :label="`${data.investorID}/${data.id}`" :value="data.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="subWpSpotAccountInfoForm.remark" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('subWpSpotAccountInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SubWpSpotAccountInfoName',
  data() {
    return {
      subWpSpotAccountInfoLoading: true,
      subWpSpotAccountInfoDialog: false,
      subWpSpotAccountInfoData: [],
      commodityTypeSelects: [],
      dicts: [],
      subWpSpotAccountInfoForm: {
        'id': '',
        'subAccountId': '',
        'motherWpSpotAccountInfoId': '',
        'remark': ''
      },
      searchForm: {
        'id': '',
        'subAccountId': '',
        'motherWpSpotAccountInfoId': '',
        'remark': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      subWpSpotAccountInfoRules: {
        subAccountId: [
          { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
        ],
        motherWpSpotAccountInfoId: [
          { required: true, message: '母账户子账户投资者帐号ID不可为空', trigger: 'change' }
        ],
        remark: [
          { required: true, message: '备注不可为空', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    this.doInitData();
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
        url: '/wpspot/subWpSpotAccountInfo/selectAll',
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
      this.subWpSpotAccountInfoLoading = true;
      this.$http({
        url: '/wpspot/subWpSpotAccountInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.subWpSpotAccountInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.subWpSpotAccountInfoLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.subWpSpotAccountInfoForm = {
        'id': '',
        'subAccountId': '',
        'motherWpSpotAccountInfoId': '',
        'remark': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.subWpSpotAccountInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.subWpSpotAccountInfoForm) {
        this.$refs.subWpSpotAccountInfoForm.resetFields();
      }
      this.$http({
        url: '/wpspot/subWpSpotAccountInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.subWpSpotAccountInfoForm = {
            'id': res.object.id,
            'subAccountId': res.object.subAccountId,
            'motherWpSpotAccountInfoId': res.object.motherWpSpotAccountInfoId,
            'remark': res.object.remark
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.subWpSpotAccountInfoDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpspot/subWpSpotAccountInfo/save',
            method: 'post',
            data: this.subWpSpotAccountInfoForm
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
          this.subWpSpotAccountInfoDialog = false;
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
          url: '/wpspot/subWpSpotAccountInfo/del',
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
		.subWpSpotAccountInfoForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
