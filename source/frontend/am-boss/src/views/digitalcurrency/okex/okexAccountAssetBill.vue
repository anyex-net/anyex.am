<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="账单 ID">
        <el-input v-model="searchForm.billId" clearable placeholder="请输入账单 ID"></el-input>
      </el-form-item>
      <el-form-item label="账户余额币种">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入账户余额币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountAssetBillLoading"
      :data="okexAccountAssetBillData"
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
      <el-table-column prop="accountId" label="平台账户ID" />
      <el-table-column prop="apiKey" label="外部平台apikey" />
      <el-table-column prop="billId" label="账单 ID" />
      <el-table-column prop="ccy" label="账户余额币种" />
      <el-table-column prop="balChg" label="账户层面的余额变动数量" />
      <el-table-column prop="bal" label="账户层面的余额数量" />
      <el-table-column prop="type" label="账单类型" :formatter="statusFormat"/>
      <el-table-column prop="ts" label="账单创建时间" :formatter="dateFormat" />
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
    <el-dialog title="账户资金流水管理" :visible.sync="okexAccountAssetBillDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="okexAccountAssetBillForm"
        :model="okexAccountAssetBillForm"
        :rules="okexAccountAssetBillRules"
        label-width="150px"
        class="okexAccountAssetBillForm"
      >
        <el-form-item label="主键" prop="id">
          <el-input v-model="okexAccountAssetBillForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="okexAccountAssetBillForm.accountId" placeholder="请输入平台账户ID" />
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="okexAccountAssetBillForm.apiKey" placeholder="请输入外部平台apikey" />
        </el-form-item>
        <el-form-item label="账单 ID" prop="billId">
          <el-input v-model="okexAccountAssetBillForm.billId" placeholder="请输入账单 ID" />
        </el-form-item>
        <el-form-item label="账户余额币种" prop="ccy">
          <el-input v-model="okexAccountAssetBillForm.ccy" placeholder="请输入账户余额币种" />
        </el-form-item>
        <el-form-item label="账户层面的余额变动数量" prop="balChg">
          <el-input v-model="okexAccountAssetBillForm.balChg" placeholder="请输入账户层面的余额变动数量" />
        </el-form-item>
        <el-form-item label="账户层面的余额数量" prop="bal">
          <el-input v-model="okexAccountAssetBillForm.bal" placeholder="请输入账户层面的余额数量" />
        </el-form-item>
        <el-form-item label="账单类型" prop="type">
          <el-input v-model="okexAccountAssetBillForm.type" placeholder="请输入账单类型" />
        </el-form-item>
        <el-form-item label="账单创建时间" prop="ts">
          <el-input v-model="okexAccountAssetBillForm.ts" placeholder="请输入账单创建时间" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountAssetBillForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OkexAccountAssetBillName',
  data() {
    return {
      okexAccountAssetBillLoading: true,
      okexAccountAssetBillDialog: false,
      okexAccountAssetBillData: [],
      commodityTypeSelects: [],
      dicts: [],
      okexAccountAssetBillForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'billId': '',
        'ccy': '',
        'balChg': '',
        'bal': '',
        'type': '',
        'ts': ''
      },
      searchForm: {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'billId': '',
        'ccy': '',
        'balChg': '',
        'bal': '',
        'type': '',
        'ts': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      okexAccountAssetBillRules: {
        accountId: [
          { required: true, message: '平台账户ID不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
        ],
        billId: [
          { required: true, message: '账单 ID不可为空', trigger: 'change' }
        ],
        ccy: [
          { required: true, message: '账户余额币种不可为空', trigger: 'change' }
        ],
        balChg: [
          { required: true, message: '账户层面的余额变动数量不可为空', trigger: 'change' }
        ],
        bal: [
          { required: true, message: '账户层面的余额数量不可为空', trigger: 'change' }
        ],
        type: [
          { required: true, message: '账单类型不可为空', trigger: 'change' }
        ],
        ts: [
          { required: true, message: '账单创建时间不可为空', trigger: 'change' }
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
      if(this.dicts[p] === undefined){
        return ''
      }
      const obj = this.dicts[p].list;
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
        url: '/digitalcurrency/okex/dict/okexAccountAssetBill',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object.list;
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
      this.okexAccountAssetBillLoading = true;
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAssetBill/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetBillData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.okexAccountAssetBillLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.okexAccountAssetBillForm = {
        'id': '',
        'accountId': '',
        'apiKey': '',
        'billId': '',
        'ccy': '',
        'balChg': '',
        'bal': '',
        'type': '',
        'ts': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.okexAccountAssetBillDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.okexAccountAssetBillForm) {
        this.$refs.okexAccountAssetBillForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/okex/okexAccountAssetBill/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.okexAccountAssetBillForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'apiKey': res.object.apiKey,
            'billId': res.object.billId,
            'ccy': res.object.ccy,
            'balChg': res.object.balChg,
            'bal': res.object.bal,
            'type': res.object.type,
            'ts': res.object.ts
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.okexAccountAssetBillDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/okex/okexAccountAssetBill/save',
            method: 'post',
            data: this.okexAccountAssetBillForm
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
          this.okexAccountAssetBillDialog = false;
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
          url: '/digitalcurrency/okex/okexAccountAssetBill/del',
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
  .okexAccountAssetBillForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
