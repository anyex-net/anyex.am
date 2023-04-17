<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="账户编号">
        <el-input v-model="searchForm.huobiAccountId" clearable placeholder="请输入账户编号"></el-input>
      </el-form-item>
      <el-form-item label="类型">
        <el-input v-model="searchForm.type" clearable placeholder="请输入类型"></el-input>
      </el-form-item>
      <el-form-item label="币种">
        <el-input v-model="searchForm.currency" clearable placeholder="请输入币种"></el-input>
      </el-form-item>
      <el-form-item label="交易哈希">
        <el-input v-model="searchForm.txHash" clearable placeholder="请输入交易哈希"></el-input>
      </el-form-item>
      <el-form-item label="状态">
        <el-input v-model="searchForm.state" clearable placeholder="请输入状态"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="huobiDepositWithdrawRecordLoading" :data="huobiDepositWithdrawRecordData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="huobiAccountId" label="账户编号"/>
      <el-table-column prop="type" label="类型"/>
      <el-table-column prop="currency" label="币种"/>
      <el-table-column prop="txHash" label="交易哈希"/>
      <el-table-column prop="chain" label="链名称"/>
      <el-table-column prop="amount" label="个数"/>
      <el-table-column prop="address" label="目的地址"/>
      <el-table-column prop="addressTag" label="地址标签"/>
      <el-table-column prop="fee" label="手续费"/>
      <el-table-column prop="state" label="状态"/>
      <el-table-column prop="errorCode" label="提币失败错误码"/>
      <el-table-column prop="errorMsg" label="提币失败错误描述"/>
      <el-table-column prop="createdAt" label="发起时间"/>
      <el-table-column prop="updatedAt" label="最后更新时间" :formatter="dateFormat"/>
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
    <el-dialog title="现货充提记录管理" :visible.sync="huobiDepositWithdrawRecordDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="huobiDepositWithdrawRecordForm" :model="huobiDepositWithdrawRecordForm"
               :rules="huobiDepositWithdrawRecordRules" label-width="150px" class="huobiDepositWithdrawRecordForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="huobiDepositWithdrawRecordForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="平台账户ID" prop="accountId">
          <el-input v-model="huobiDepositWithdrawRecordForm.accountId" placeholder="请输入平台账户ID"/>
        </el-form-item>
        <el-form-item label="外部平台apikey" prop="apiKey">
          <el-input v-model="huobiDepositWithdrawRecordForm.apiKey" placeholder="请输入外部平台apikey"/>
        </el-form-item>
        <el-form-item label="账户编号" prop="huobiAccountId">
          <el-input v-model="huobiDepositWithdrawRecordForm.huobiAccountId" placeholder="请输入账户编号"/>
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-input v-model="huobiDepositWithdrawRecordForm.type" placeholder="请输入类型"/>
        </el-form-item>
        <el-form-item label="币种" prop="currency">
          <el-input v-model="huobiDepositWithdrawRecordForm.currency" placeholder="请输入币种"/>
        </el-form-item>
        <el-form-item label="交易哈希" prop="txHash">
          <el-input v-model="huobiDepositWithdrawRecordForm.txHash" placeholder="请输入交易哈希"/>
        </el-form-item>
        <el-form-item label="链名称" prop="chain">
          <el-input v-model="huobiDepositWithdrawRecordForm.chain" placeholder="请输入链名称"/>
        </el-form-item>
        <el-form-item label="个数" prop="amount">
          <el-input v-model="huobiDepositWithdrawRecordForm.amount" placeholder="请输入个数"/>
        </el-form-item>
        <el-form-item label="目的地址" prop="address">
          <el-input v-model="huobiDepositWithdrawRecordForm.address" placeholder="请输入目的地址"/>
        </el-form-item>
        <el-form-item label="地址标签" prop="addressTag">
          <el-input v-model="huobiDepositWithdrawRecordForm.addressTag" placeholder="请输入地址标签"/>
        </el-form-item>
        <el-form-item label="手续费" prop="fee">
          <el-input v-model="huobiDepositWithdrawRecordForm.fee" placeholder="请输入手续费"/>
        </el-form-item>
        <el-form-item label="状态" prop="state">
          <el-input v-model="huobiDepositWithdrawRecordForm.state" placeholder="请输入状态"/>
        </el-form-item>
        <el-form-item label="提币失败错误码" prop="errorCode">
          <el-input v-model="huobiDepositWithdrawRecordForm.errorCode" placeholder="请输入提币失败错误码"/>
        </el-form-item>
        <el-form-item label="提币失败错误描述" prop="errorMsg">
          <el-input v-model="huobiDepositWithdrawRecordForm.errorMsg" placeholder="请输入提币失败错误描述"/>
        </el-form-item>
        <el-form-item label="发起时间" prop="createdAt">
          <el-input v-model="huobiDepositWithdrawRecordForm.createdAt" placeholder="请输入发起时间"/>
        </el-form-item>
        <el-form-item label="最后更新时间" prop="updatedAt">
          <el-input v-model="huobiDepositWithdrawRecordForm.updatedAt" placeholder="请输入最后更新时间"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('huobiDepositWithdrawRecordForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'HuobiDepositWithdrawRecordName',
    data() {
      return {
        huobiDepositWithdrawRecordLoading: true,
        huobiDepositWithdrawRecordDialog: false,
        huobiDepositWithdrawRecordData: [],
        commodityTypeSelects: [],
        dicts: [],
        huobiDepositWithdrawRecordForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'type': '',
          'currency': '',
          'txHash': '',
          'chain': '',
          'amount': '',
          'address': '',
          'addressTag': '',
          'fee': '',
          'state': '',
          'errorCode': '',
          'errorMsg': '',
          'createdAt': '',
          'updatedAt': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'type': '',
          'currency': '',
          'txHash': '',
          'chain': '',
          'amount': '',
          'address': '',
          'addressTag': '',
          'fee': '',
          'state': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        huobiDepositWithdrawRecordRules: {}
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
          url: '/digitalcurrency/huobi/dict/huobiDepositWithdrawRecord',
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
        this.huobiDepositWithdrawRecordLoading = true;
        this.$http({
          url: '/digitalcurrency/huobi/huobiDepositWithdrawRecord/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.huobiDepositWithdrawRecordData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.huobiDepositWithdrawRecordLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.huobiDepositWithdrawRecordForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'huobiAccountId': '',
          'type': '',
          'currency': '',
          'txHash': '',
          'chain': '',
          'amount': '',
          'address': '',
          'addressTag': '',
          'fee': '',
          'state': '',
          'errorCode': '',
          'errorMsg': '',
          'createdAt': '',
          'updatedAt': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.huobiDepositWithdrawRecordDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.huobiDepositWithdrawRecordForm) {
          this.$refs.huobiDepositWithdrawRecordForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/huobi/huobiDepositWithdrawRecord/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.huobiDepositWithdrawRecordForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'huobiAccountId': res.object.huobiAccountId,
              'type': res.object.type,
              'currency': res.object.currency,
              'txHash': res.object.txHash,
              'chain': res.object.chain,
              'amount': res.object.amount,
              'address': res.object.address,
              'addressTag': res.object.addressTag,
              'fee': res.object.fee,
              'state': res.object.state,
              'errorCode': res.object.errorCode,
              'errorMsg': res.object.errorMsg,
              'createdAt': res.object.createdAt,
              'updatedAt': res.object.updatedAt
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.huobiDepositWithdrawRecordDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/huobi/huobiDepositWithdrawRecord/save',
              method: 'post',
              data: this.huobiDepositWithdrawRecordForm
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
            this.huobiDepositWithdrawRecordDialog = false;
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
            url: '/digitalcurrency/huobi/huobiDepositWithdrawRecord/del',
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
  .huobiDepositWithdrawRecordForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
