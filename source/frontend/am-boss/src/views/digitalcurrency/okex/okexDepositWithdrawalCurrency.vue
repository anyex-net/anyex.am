<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="币种名称">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入币种名称"></el-input>
      </el-form-item>
      <el-form-item label="币种中文名称">
        <el-input v-model="searchForm.name" clearable placeholder="请输入币种中文名称"></el-input>
      </el-form-item>
      <el-form-item label="链">
        <el-input v-model="searchForm.chain" clearable placeholder="请输入链"></el-input>
      </el-form-item>
      <el-form-item label="是否可充值">
        <el-input v-model="searchForm.canDep" clearable placeholder="请输入是否可充值"></el-input>
      </el-form-item>
      <el-form-item label="是否可提币">
        <el-input v-model="searchForm.canWd" clearable placeholder="请输入是否可提币"></el-input>
      </el-form-item>
      <el-form-item label="是否可内部转账">
        <el-input v-model="searchForm.canInternal" clearable placeholder="请输入是否可内部转账"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexDepositWithdrawalCurrencyLoading"
      :data="okexDepositWithdrawalCurrencyData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="" />
      <el-table-column prop="ccy" label="币种名称" />
      <el-table-column prop="name" label="币种中文名称" />
      <el-table-column prop="chain" label="链" />
      <el-table-column prop="canDep" label="是否可充值" />
      <el-table-column prop="canWd" label="是否可提币" />
      <el-table-column prop="canInternal" label="是否可内部转账" />
      <el-table-column prop="minWd" label="币种最小提币量" />
      <el-table-column prop="minFee" label="最小提币手续费数量" />
      <el-table-column prop="maxFee" label="最大提币手续费数量" />
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
      title="充提币种管理"
      :visible.sync="okexDepositWithdrawalCurrencyDialog"
      :close-on-click-modal="false"
      width="600"
    >
      <el-form
        ref="okexDepositWithdrawalCurrencyForm"
        :model="okexDepositWithdrawalCurrencyForm"
        :rules="okexDepositWithdrawalCurrencyRules"
        label-width="150px"
        class="okexDepositWithdrawalCurrencyForm"
      >
        <el-form-item label="币种名称" prop="ccy">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.ccy" placeholder="请输入币种名称" />
        </el-form-item>
        <el-form-item label="币种中文名称" prop="name">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.name" placeholder="请输入币种中文名称" />
        </el-form-item>
        <el-form-item label="链" prop="chain">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.chain" placeholder="请输入链" />
        </el-form-item>
        <el-form-item label="是否可充值" prop="canDep">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.canDep" placeholder="请输入是否可充值" />
        </el-form-item>
        <el-form-item label="是否可提币" prop="canWd">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.canWd" placeholder="请输入是否可提币" />
        </el-form-item>
        <el-form-item label="是否可内部转账" prop="canInternal">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.canInternal" placeholder="请输入是否可内部转账" />
        </el-form-item>
        <el-form-item label="币种最小提币量" prop="minWd">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.minWd" placeholder="请输入币种最小提币量" />
        </el-form-item>
        <el-form-item label="最小提币手续费数量" prop="minFee">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.minFee" placeholder="请输入最小提币手续费数量" />
        </el-form-item>
        <el-form-item label="最大提币手续费数量" prop="maxFee">
          <el-input v-model="okexDepositWithdrawalCurrencyForm.maxFee" placeholder="请输入最大提币手续费数量" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexDepositWithdrawalCurrencyForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexDepositWithdrawalCurrencyName',
  data() {
    return {
      okexDepositWithdrawalCurrencyLoading: true,
      okexDepositWithdrawalCurrencyDialog: false,
      okexDepositWithdrawalCurrencyData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexDepositWithdrawalCurrencyForm: {
        'id': '',
        'ccy': '',
        'name': '',
        'chain': '',
        'canDep': '',
        'canWd': '',
        'canInternal': '',
        'minWd': '',
        'minFee': '',
        'maxFee': ''
      },
      searchForm: {
        'id': '',
        'ccy': '',
        'name': '',
        'chain': '',
        'canDep': '',
        'canWd': '',
        'canInternal': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexDepositWithdrawalCurrencyRules: {
        ccy: [
          { required: true, message: '币种名称不可为空', trigger: 'change' }
        ],
        name: [
          { required: true, message: '币种中文名称不可为空', trigger: 'change' }
        ],
        canDep: [
          { required: true, message: '是否可充值不可为空', trigger: 'change' }
        ],
        canWd: [
          { required: true, message: '是否可提币不可为空', trigger: 'change' }
        ],
        canInternal: [
          { required: true, message: '是否可内部转账不可为空', trigger: 'change' }
        ],
        minWd: [
          { required: true, message: '币种最小提币量不可为空', trigger: 'change' }
        ],
        minFee: [
          { required: true, message: '最小提币手续费数量不可为空', trigger: 'change' }
        ],
        maxFee: [
          { required: true, message: '最大提币手续费数量不可为空', trigger: 'change' }
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
        url: '/digitalcurrency/okex/dict/okexDepositWithdrawalCurrency',
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
      this.okexDepositWithdrawalCurrencyLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexDepositWithdrawalCurrency/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexDepositWithdrawalCurrencyData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexDepositWithdrawalCurrencyLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexDepositWithdrawalCurrencyForm = {
        'id': '',
        'ccy': '',
        'name': '',
        'chain': '',
        'canDep': '',
        'canWd': '',
        'canInternal': '',
        'minWd': '',
        'minFee': '',
        'maxFee': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexDepositWithdrawalCurrencyDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexDepositWithdrawalCurrencyForm) {
        this.$refs.okexDepositWithdrawalCurrencyForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexDepositWithdrawalCurrency/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexDepositWithdrawalCurrencyForm = {
            'id': res.object.id,
            'ccy': res.object.ccy,
            'name': res.object.name,
            'chain': res.object.chain,
            'canDep': res.object.canDep,
            'canWd': res.object.canWd,
            'canInternal': res.object.canInternal,
            'minWd': res.object.minWd,
            'minFee': res.object.minFee,
            'maxFee': res.object.maxFee
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexDepositWithdrawalCurrencyDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexDepositWithdrawalCurrency/save',
            method: 'post',
            data: this.okexDepositWithdrawalCurrencyForm
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
          this.okexDepositWithdrawalCurrencyDialog = false;
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
          url: '/digitalcurrency/okex/okexDepositWithdrawalCurrency/del',
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
  .okexDepositWithdrawalCurrencyForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
