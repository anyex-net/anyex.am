<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiMarginLoanInfoLoading" :data="huobiMarginLoanInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="interestRate" label="基础日币息率"/>
      <el-table-column prop="minLoanAmt" label="最小允许借币金额"/>
      <el-table-column prop="maxLoanAmt" label="最大允许借币金额"/>
      <el-table-column prop="loanableAmt" label="最大可借金额"/>
      <el-table-column prop="actualRate" label="实际借币币息率"/>
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
    <el-dialog title="借币基础信息管理" :visible.sync="huobiMarginLoanInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="huobiMarginLoanInfoForm" :model="huobiMarginLoanInfoForm" :rules="huobiMarginLoanInfoRules"
               label-width="150px" class="huobiMarginLoanInfoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiMarginLoanInfoForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiMarginLoanInfoForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="基础日币息率" prop="interestRate">
          <el-input v-model="huobiMarginLoanInfoForm.interestRate" placeholder="请输入基础日币息率"/>
        </el-form-item>
        <el-form-item label="最小允许借币金额" prop="minLoanAmt">
          <el-input v-model="huobiMarginLoanInfoForm.minLoanAmt" placeholder="请输入最小允许借币金额"/>
        </el-form-item>
        <el-form-item label="最大允许借币金额" prop="maxLoanAmt">
          <el-input v-model="huobiMarginLoanInfoForm.maxLoanAmt" placeholder="请输入最大允许借币金额"/>
        </el-form-item>
        <el-form-item label="最大可借金额" prop="loanableAmt">
          <el-input v-model="huobiMarginLoanInfoForm.loanableAmt" placeholder="请输入最大可借金额"/>
        </el-form-item>
        <el-form-item label="实际借币币息率" prop="actualRate">
          <el-input v-model="huobiMarginLoanInfoForm.actualRate" placeholder="请输入实际借币币息率"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiMarginLoanInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiMarginLoanInfoName',
    data() {
      return {
        huobiMarginLoanInfoLoading: true,
        huobiMarginLoanInfoDialog: false,
        huobiMarginLoanInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiMarginLoanInfoForm: {
          'id': '',
          'currency': '',
          'interestRate': '',
          'minLoanAmt': '',
          'maxLoanAmt': '',
          'loanableAmt': '',
          'actualRate': ''
        },
        searchForm: {
          'currency': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiMarginLoanInfoRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiMarginLoanInfo',
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
        this.huobiMarginLoanInfoLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginLoanInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginLoanInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiMarginLoanInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiMarginLoanInfoForm = {
          'id': '',
          'currency': '',
          'interestRate': '',
          'minLoanAmt': '',
          'maxLoanAmt': '',
          'loanableAmt': '',
          'actualRate': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiMarginLoanInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiMarginLoanInfoForm) {
          this.$refs.huobiMarginLoanInfoForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiMarginLoanInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiMarginLoanInfoForm = {
              'id': res.object.id,
              'currency': res.object.currency,
              'interestRate': res.object.interestRate,
              'minLoanAmt': res.object.minLoanAmt,
              'maxLoanAmt': res.object.maxLoanAmt,
              'loanableAmt': res.object.loanableAmt,
              'actualRate': res.object.actualRate
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiMarginLoanInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiMarginLoanInfo/save',
              method: 'post',
              data: this.huobiMarginLoanInfoForm
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
            this.huobiMarginLoanInfoDialog = false;
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
            url: '/digitalcurrency/huobi/huobiMarginLoanInfo/del',
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
  .huobiMarginLoanInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
