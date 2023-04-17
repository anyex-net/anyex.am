<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="交易所名称">
        <el-input v-model="searchForm.exchangeName" clearable placeholder="请输入交易所名称"></el-input>
      </el-form-item>
      <el-form-item label="交易所域名">
        <el-input v-model="searchForm.exchangeDomain" clearable placeholder="请输入交易所域名"></el-input>
      </el-form-item>
      <el-form-item label="交易所是否开市">
        <el-select v-model="searchForm.openMarket" placeholder="请选择" value="">
          <el-option key="open" label="是" value="open"/>
          <el-option key="close" label="否" value="close"/>
        </el-select>
      </el-form-item>
      <el-form-item label="启用状态">
        <el-select v-model="searchForm.enableStatus" placeholder="请选择启用状态">
          <el-option key="enable" label="是" value="enable"/>
          <el-option key="disable" label="否" value="disable"/>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesExchangeInfoLoading" :data="esNpfuturesExchangeInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码"/>
      <el-table-column prop="exchangeName" label="交易所名称"/>
      <el-table-column prop="exchangeDomain" label="交易所域名"/>
      <el-table-column prop="openMarket" label="交易所是否开市">
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
      :total="pageParams.total"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />
    <el-dialog title="内盘期货交易所信息表管理" :visible.sync="esNpfuturesExchangeInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesExchangeInfoForm" :model="esNpfuturesExchangeInfoForm"
               :rules="esNpfuturesExchangeInfoRules" label-width="150px" class="esNpfuturesExchangeInfoForm">
        <el-form-item label="交易所编码" prop="exchangeNo">
          <el-input v-model="esNpfuturesExchangeInfoForm.exchangeNo" placeholder="请输入交易所编码"/>
        </el-form-item>
        <el-form-item label="交易所名称" prop="exchangeName">
          <el-input v-model="esNpfuturesExchangeInfoForm.exchangeName" placeholder="请输入交易所名称"/>
        </el-form-item>
        <el-form-item label="交易所域名" prop="exchangeDomain">
          <el-input v-model="esNpfuturesExchangeInfoForm.exchangeDomain" placeholder="请输入交易所域名"/>
        </el-form-item>
        <el-form-item label="交易所是否开市" prop="openMarket">
          <el-select v-model="esNpfuturesExchangeInfoForm.openMarket" placeholder="请选择" value="">
            <el-option key="open" label="是" value="open"/>
            <el-option key="close" label="否" value="close"/>
          </el-select>
        </el-form-item>
        <el-form-item label="启用状态" prop="enableStatus">
          <el-select v-model="esNpfuturesExchangeInfoForm.enableStatus" placeholder="请选择启用状态">
            <el-option key="enable" label="是" value="enable"/>
            <el-option key="disable" label="否" value="disable"/>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('esNpfuturesExchangeInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesExchangeInfoName',
    data() {
      return {
        esNpfuturesExchangeInfoLoading: true,
        esNpfuturesExchangeInfoDialog: false,
        esNpfuturesExchangeInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesExchangeInfoForm: {
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
          'exchangeDomain': '',
          'openMarket': '',
          'enableStatus': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesExchangeInfoRules: {
          exchangeNo: [
            { required: true, message: '交易所编码不可为空', trigger: 'change' }
          ],
          exchangeName: [
            { required: true, message: '交易所名称不可为空', trigger: 'change' }
          ],
          exchangeDomain: [
            { required: true, message: '交易所域名不可为空', trigger: 'change' }
          ],
          openMarket: [
            { required: true, message: '交易所是否开市(open、close)不可为空', trigger: 'change' }
          ],
          enableStatus: [
            { required: true, message: '启用状态(启用enable、不启用disable)不可为空', trigger: 'change' }
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
      doInitData() {
        this.$http({
          url: '/npfutures/dict/esNpfuturesExchangeInfo',
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
        this.esNpfuturesExchangeInfoLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesExchangeInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesExchangeInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesExchangeInfoForm = {
          'id': '',
          'exchangeNo': '',
          'exchangeName': '',
          'exchangeDomain': '',
          'openMarket': '',
          'enableStatus': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesExchangeInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesExchangeInfoForm) {
          this.$refs.esNpfuturesExchangeInfoForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesExchangeInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeInfoForm = {
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
        this.esNpfuturesExchangeInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesExchangeInfo/save',
              method: 'post',
              data: this.esNpfuturesExchangeInfoForm
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
            this.esNpfuturesExchangeInfoDialog = false;
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
            url: '/npfutures/esNpfuturesExchangeInfo/del',
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
  .esNpfuturesExchangeInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
