<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="交易所名称">
        <el-input v-model="searchForm.exchangeName" clearable placeholder="请输入交易所名称"></el-input>
      </el-form-item>
      <el-form-item label="交易所是否开市" prop="openMarket">
        <el-select v-model="searchForm.openMarket" placeholder="请选择" value="">
          <el-option key="open" label="是" value="open" />
          <el-option key="close" label="否" value="close" />
        </el-select>
      </el-form-item>
      <el-form-item label="启用状态" prop="enableStatus">
        <el-select v-model="searchForm.enableStatus" placeholder="请选择启用状态">
          <el-option key="enable" label="是" value="enable" />
          <el-option key="disable" label="否" value="disable" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="wpfuturesExchangeInfoLoading" :data="wpfuturesExchangeInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label="序号" :index="table_index" width="50" />
      <el-table-column prop="exchangeNo" label="交易所编码" />
      <el-table-column prop="exchangeName" label="交易所名称" />
      <el-table-column prop="exchangeDomain" label="交易所域名" />
      <el-table-column prop="openMarket" label="交易所是否开市" >
        <template scope="scope">
          <div v-if="scope.row.openMarket == 'open'">是</div>
          <div v-else-if="scope.row.openMarket == 'close'">否</div>
        </template>
      </el-table-column>
      <el-table-column prop="enableStatus" label="启用状态">
        <template scope="scope">
          <p v-if="scope.row.enableStatus=='disable'">否</p>
          <p v-if="scope.row.enableStatus=='enable'">是</p>
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
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="交易所信息编辑" :visible.sync="wpfuturesExchangeInfoDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="wpfuturesExchangeInfoForm" :model="wpfuturesExchangeInfoForm" :rules="wpfuturesExchangeInfoRules" label-width="120px" class="wpfuturesExchangeInfoForm">
        <el-form-item label="交易所编码" prop="exchangeNo">
          <el-input v-model="wpfuturesExchangeInfoForm.exchangeNo" placeholder="请输入交易所编码" />
        </el-form-item>
        <el-form-item label="交易所名称" prop="exchangeName">
          <el-input v-model="wpfuturesExchangeInfoForm.exchangeName" placeholder="请输入交易所名称(无名称填编码)" />
        </el-form-item>
        <el-form-item label="交易所域名" prop="exchangeDomain">
          <el-input v-model="wpfuturesExchangeInfoForm.exchangeDomain" placeholder="请输入交易所域名" />
        </el-form-item>
        <el-form-item label="交易所是否开市" prop="openMarket">
          <el-select v-model="wpfuturesExchangeInfoForm.openMarket" placeholder="请选择交易所是否开市" value="">
            <el-option key="open" label="是" value="open" />
            <el-option key="close" label="否" value="close" />
          </el-select>
        </el-form-item>
        <el-form-item label="启用状态" prop="enableStatus">
          <el-select v-model="wpfuturesExchangeInfoForm.enableStatus" placeholder="请选择启用状态">
            <el-option key="enable" label="是" value="enable" />
            <el-option key="disable" label="否" value="disable" />
          </el-select>
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('wpfuturesExchangeInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'WpfuturesExchangeInfo',
  data() {
    return {
      wpfuturesExchangeInfoLoading: '',
      wpfuturesExchangeInfoDialog: false,
      wpfuturesExchangeInfoData: [],
      wpfuturesExchangeInfoForm: {
        'id': '',
        'exchangeNo': '',
        'exchangeName': '',
        'exchangeDomain': '',
        'openMarket': '',
        'enableStatus': ''
      },
      searchForm: {
        'exchangeNo': '',
        'exchangeName': '',
        'openMarket': '',
        'enableStatus': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      wpfuturesExchangeInfoRules: {
        exchangeNo: [
          { required: true, message: '请输入交易所编码', trigger: 'blur' }
        ],
        exchangeName: [
          { required: true, message: '请输入交易所名称', trigger: 'blur' }
        ],
        exchangeDomain: [
          { required: true, message: '请输入交易所域名', trigger: 'blur' }
        ],
        openMarket: [
          { required: true, message: '请选择交易所是否开市', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '请选择启用状态', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    this.doSearch();
  },
  methods: {
    table_index(index) {
      return (this.pageParams.page - 1) * this.pageParams.rows + index + 1;
    },

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
        url: '/wpfutures/dict/wpfuturesCurrencyInfo',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    dialogAdd: function() {
      this.wpfuturesExchangeInfoForm = {
        'id': '',
        'wpfuturesExchangeInfo': '',
        'buildVersion': '',
        'deviceType': '',
        'canSupport': '',
        'checkStatus': '',
        'remark': '',
        'enableStatus': ''
      };
      if (this.$refs.wpfuturesExchangeInfoForm) {
        this.$refs.wpfuturesExchangeInfoForm.resetFields();
      }
      this.wpfuturesExchangeInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesExchangeInfoForm) {
        this.$refs.wpfuturesExchangeInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesExchangeInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeInfoForm = {
            'id': res.object.id,
            'exchangeNo': res.object.exchangeNo,
            'exchangeName': res.object.exchangeName,
            'exchangeDomain': res.object.exchangeDomain,
            'openMarket': res.object.openMarket,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesExchangeInfoDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.wpfuturesExchangeInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesExchangeInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.wpfuturesExchangeInfoLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/wpfuturesExchangeInfo/save',
            method: 'post',
            data: this.wpfuturesExchangeInfoForm
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
          this.wpfuturesExchangeInfoDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该app版本, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/wpfutures/wpfuturesExchangeInfo/del',
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

</style>
