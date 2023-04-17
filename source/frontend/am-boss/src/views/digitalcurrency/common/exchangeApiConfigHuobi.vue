<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户id">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户id"></el-input>
      </el-form-item>
      <el-form-item label="交易所账号">
        <el-input v-model="searchForm.exchangeAccount" clearable placeholder="请输入交易所账号"></el-input>
      </el-form-item>
      <el-form-item label="APIKEY">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入APIKEY"></el-input>
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="searchForm.remark" clearable placeholder="请输入备注"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="exchangeApiConfigHuobiLoading" :data="exchangeApiConfigHuobiData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="accountId" label="平台账户id" />
      <el-table-column prop="exchange" label="交易所" />
      <el-table-column prop="exchangeAccount" label="交易所账号" />
      <el-table-column prop="apiKey" label="APIKEY" />
      <el-table-column prop="authorigty" label="权限" >
        <template scope="scope">
          <div v-if="scope.row.authorigty == 'readonly'">只读</div>
          <div v-else-if="scope.row.authorigty == 'trade'">交易</div>
        </template>
      </el-table-column>
      <el-table-column prop="ip" label="ip地址" />
      <el-table-column prop="spotAccountId" label="现货账户ID" />
      <el-table-column prop="remark" label="备注" />
      <el-table-column prop="createdate" label="创建时间" :formatter="dateFormat" />
      <el-table-column prop="relatedExchangeAccount" label="关联只读api" />
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
    <el-dialog title="用户交易所api配置管理" :visible.sync="exchangeApiConfigHuobiDialog" :close-on-click-modal="false" width="600">
      <el-form ref="exchangeApiConfigHuobiForm" :model="exchangeApiConfigHuobiForm" :rules="exchangeApiConfigHuobiRules" label-width="150px" class="exchangeApiConfigHuobiForm">
        <el-form-item label="平台账户id" prop="accountId">
          <el-input v-model="exchangeApiConfigHuobiForm.accountId" placeholder="请输入平台账户id" />
        </el-form-item>
        <el-form-item label="交易所" prop="exchange">
          <el-input v-model="exchangeApiConfigHuobiForm.exchange" readonly="readonly"  placeholder="请输入交易所" />
        </el-form-item>
        <el-form-item label="交易所账号" prop="exchangeAccount">
          <el-input v-model="exchangeApiConfigHuobiForm.exchangeAccount" placeholder="请输入交易所账号" />
        </el-form-item>
        <el-form-item label="APIKEY" prop="apiKey">
          <el-input v-model="exchangeApiConfigHuobiForm.apiKey" placeholder="请输入APIKEY" />
        </el-form-item>
        <el-form-item label="APISECRET" prop="apiSecret">
          <el-input v-model="exchangeApiConfigHuobiForm.apiSecret" placeholder="请输入APISECRET" />
        </el-form-item>
        <el-form-item label="PASSPHRASE" prop="passPhrase">
          <el-input v-model="exchangeApiConfigHuobiForm.passPhrase" placeholder="请输入PASSPHRASE" />
        </el-form-item>
        <el-form-item label="权限" prop="authorigty">
          <el-select v-model="exchangeApiConfigHuobiForm.authorigty" placeholder="请选择权限" value="">
            <el-option key="readonly" label="只读" value="readonly" />
            <el-option key="trade" label="交易" value="trade" />
          </el-select>
        </el-form-item>
        <el-form-item label="ip地址" prop="ip">
          <el-input v-model="exchangeApiConfigHuobiForm.ip" placeholder="请输入ip地址" />
        </el-form-item>
        <el-form-item label="现货账户ID" prop="spotAccountId">
          <el-input v-model="exchangeApiConfigHuobiForm.spotAccountId" placeholder="请输入现货账户ID(火币),okex为空" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="exchangeApiConfigHuobiForm.remark" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="关联只读api" prop="relatedExchangeAccount">
          <el-input v-model="exchangeApiConfigHuobiForm.relatedExchangeAccount" placeholder="请输入关联只读api" />
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('exchangeApiConfigHuobiForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'ExchangeApiConfigHuobiName',
  data() {
    return {
      exchangeApiConfigHuobiLoading: true,
      exchangeApiConfigHuobiDialog: false,
      exchangeApiConfigHuobiData: [],
      commodityTypeSelects: [],
      dicts: [],
      exchangeApiConfigHuobiForm: {
        'id': '',
        'accountId': '',
        'exchange': 'Huobi',
        'exchangeAccount': '',
        'apiKey': '',
        'apiSecret': '',
        'passPhrase': '',
        'authorigty': '',
        'ip': '',
        'spotAccountId': '',
        'remark': '',
        'createdate': '',
        'relatedExchangeAccount': ''
      },
      searchForm: {
        'id': '',
        'accountId': '',
        'exchange': 'Huobi',
        'exchangeAccount': '',
        'apiKey': '',
        'apiSecret': '',
        'passPhrase': '',
        'authorigty': '',
        'ip': '',
        'spotAccountId': '',
        'remark': '',
        'createdate': '',
        'relatedExchangeAccount': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      exchangeApiConfigHuobiRules: {
        accountId: [
          { required: true, message: '平台账户id不可为空', trigger: 'change' }
        ],
        exchange: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        exchangeAccount: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        apiKey: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        apiSecret: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        authorigty: [
          { required: true, message: '不可为空', trigger: 'change' }
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
        url: '/digitalcurrency/dict/exchangeApiConfig',
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
      this.exchangeApiConfigHuobiLoading = true;
      this.$http({
        url: '/digitalcurrency/common/exchangeApiConfig/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.exchangeApiConfigHuobiData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.exchangeApiConfigHuobiLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.exchangeApiConfigHuobiForm = {
        'id': '',
        'accountId': '',
        'exchange': 'Huobi',
        'exchangeAccount': '',
        'apiKey': '',
        'apiSecret': '',
        'passPhrase': '',
        'authorigty': '',
        'ip': '',
        'spotAccountId': '',
        'remark': '',
        'createdate': '',
        'relatedExchangeAccount': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.exchangeApiConfigHuobiDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.exchangeApiConfigHuobiForm) {
        this.$refs.exchangeApiConfigHuobiForm.resetFields();
      }
      this.$http({
        url: '/digitalcurrency/common/exchangeApiConfig/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.exchangeApiConfigHuobiForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'exchange': 'Huobi',
            'exchangeAccount': res.object.exchangeAccount,
            'apiKey': res.object.apiKey,
            'apiSecret': res.object.apiSecret,
            'passPhrase': res.object.passPhrase,
            'authorigty': res.object.authorigty,
            'ip': res.object.ip,
            'spotAccountId': res.object.spotAccountId,
            'remark': res.object.remark,
            'createdate': res.object.createdate,
            'relatedExchangeAccount': res.object.relatedExchangeAccount
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.exchangeApiConfigHuobiDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/digitalcurrency/common/exchangeApiConfig/save',
            method: 'post',
            data: this.exchangeApiConfigHuobiForm
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
          this.exchangeApiConfigHuobiDialog = false;
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
          url: '/digitalcurrency/common/exchangeApiConfig/del',
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
		.exchangeApiConfigHuobiForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
