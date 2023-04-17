<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所名称">
        <el-input v-model="searchForm.exchangeName" clearable placeholder="请输入交易所名称"></el-input>
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
    <el-table v-loading="stpNpSpotExchangeLoading" :data="stpNpSpotExchangeData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeID" label="交易所代码"/>
      <el-table-column prop="exchangeName" label="交易所名称"/>
      <el-table-column prop="tradingDay" label="交易日"/>
      <el-table-column prop="dataSyncStatus" label="数据同步状态"/>
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
      :total="pageParams.total"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />
    <el-dialog title="内盘现货交易所" :visible.sync="stpNpSpotExchangeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="stpNpSpotExchangeForm" :model="stpNpSpotExchangeForm" :rules="stpNpSpotExchangeRules"
               label-width="150px" class="stpNpSpotExchangeForm">
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="stpNpSpotExchangeForm.exchangeID" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="交易所名称" prop="exchangeName">
          <el-input v-model="stpNpSpotExchangeForm.exchangeName" placeholder="请输入交易所名称"/>
        </el-form-item>
        <el-form-item label="交易日" prop="tradingDay">
          <el-input v-model="stpNpSpotExchangeForm.tradingDay" placeholder="请输入交易日"/>
        </el-form-item>
        <el-form-item label="数据同步状态" prop="dataSyncStatus">
          <el-input v-model="stpNpSpotExchangeForm.dataSyncStatus" placeholder="请输入数据同步状态"/>
        </el-form-item>
        <el-form-item label="启用状态" prop="enableStatus">
          <el-select v-model="stpNpSpotExchangeForm.enableStatus" placeholder="请选择启用状态">
            <el-option key="enable" label="是" value="enable" />
            <el-option key="disable" label="否" value="disable" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('stpNpSpotExchangeForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'StpNpSpotExchangeName',
    data() {
      return {
        stpNpSpotExchangeLoading: true,
        stpNpSpotExchangeDialog: false,
        stpNpSpotExchangeData: [],
        commodityTypeSelects: [],
        dicts: [],
        stpNpSpotExchangeForm: {
          'id': '',
          'exchangeID': '',
          'exchangeName': '',
          'tradingDay': '',
          'dataSyncStatus': '',
          'enableStatus': ''
        },
        searchForm: {
          'id': '',
          'exchangeID': '',
          'exchangeName': '',
          'enableStatus': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        stpNpSpotExchangeRules: {
          exchangeID: [
            { required: true, message: '交易所代码不可为空', trigger: 'change' }
          ],
          exchangeName: [
            { required: true, message: '交易所名称不可为空', trigger: 'change' }
          ],
          tradingDay: [
            { required: true, message: '交易日不可为空', trigger: 'change' }
          ],
          dataSyncStatus: [
            { required: true, message: '数据同步状态不可为空', trigger: 'change' }
          ]
        }
      };
    },
    mounted: function() {
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
        this.stpNpSpotExchangeLoading = true;
        this.$http({
          url: '/npspot/stpNpSpotExchange/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotExchangeData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.stpNpSpotExchangeLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.stpNpSpotExchangeForm = {
          'id': '',
          'exchangeID': '',
          'exchangeName': '',
          'tradingDay': '',
          'dataSyncStatus': '',
          'enableStatus': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.stpNpSpotExchangeDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.stpNpSpotExchangeForm) {
          this.$refs.stpNpSpotExchangeForm.resetFields();
        }
        this.$http({
          url: '/npspot/stpNpSpotExchange/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.stpNpSpotExchangeForm = {
              'id': res.object.id,
              'exchangeID': res.object.exchangeID,
              'exchangeName': res.object.exchangeName,
              'tradingDay': res.object.tradingDay,
              'dataSyncStatus': res.object.dataSyncStatus,
              'enableStatus': res.object.enableStatus
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.stpNpSpotExchangeDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npspot/stpNpSpotExchange/save',
              method: 'post',
              data: this.stpNpSpotExchangeForm
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
            this.stpNpSpotExchangeDialog = false;
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
            url: '/npspot/stpNpSpotExchange/del',
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
  .stpNpSpotExchangeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
