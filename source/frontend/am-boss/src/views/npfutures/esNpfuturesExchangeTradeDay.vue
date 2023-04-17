<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="品种编号">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编号"></el-input>
      </el-form-item>
      <el-form-item label="星期几(1~7)">
        <el-input v-model="searchForm.weekNum" clearable placeholder="请输入星期几(1~7)"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="esNpfuturesExchangeTradeDayLoading" :data="esNpfuturesExchangeTradeDayData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码"/>
      <el-table-column prop="commodityNo" label="品种编号"/>
      <el-table-column prop="weekNum" label="星期几(1~7)"/>
      <el-table-column prop="isTradeDay" label="是否交易日(1交易日、0非交易日)"/>
      <el-table-column prop="tradeDayTime" label="交易日零点时间戳"/>
      <el-table-column prop="tradeDayOpenTime" label="交易日开盘时间戳"/>
      <el-table-column prop="tradeDayCloseTime" label="交易日收盘时间戳"/>
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
    <el-dialog title="内盘期货交易所交易日表管理" :visible.sync="esNpfuturesExchangeTradeDayDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesExchangeTradeDayForm" :model="esNpfuturesExchangeTradeDayForm"
               :rules="esNpfuturesExchangeTradeDayRules" label-width="150px" class="esNpfuturesExchangeTradeDayForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="交易所编码" prop="exchangeNo">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.exchangeNo" placeholder="请输入交易所编码"/>
        </el-form-item>
        <el-form-item label="品种编号" prop="commodityNo">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.commodityNo" placeholder="请输入品种编号"/>
        </el-form-item>
        <el-form-item label="星期几(1~7)" prop="weekNum">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.weekNum" placeholder="请输入星期几(1~7)"/>
        </el-form-item>
        <el-form-item label="是否交易日(1交易日、0非交易日)" prop="isTradeDay">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.isTradeDay" placeholder="请输入是否交易日(1交易日、0非交易日)"/>
        </el-form-item>
        <el-form-item label="交易日零点时间戳" prop="tradeDayTime">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.tradeDayTime" placeholder="请输入交易日零点时间戳"/>
        </el-form-item>
        <el-form-item label="交易日开盘时间戳" prop="tradeDayOpenTime">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.tradeDayOpenTime" placeholder="请输入交易日开盘时间戳"/>
        </el-form-item>
        <el-form-item label="交易日收盘时间戳" prop="tradeDayCloseTime">
          <el-input v-model="esNpfuturesExchangeTradeDayForm.tradeDayCloseTime" placeholder="请输入交易日收盘时间戳"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('esNpfuturesExchangeTradeDayForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesExchangeTradeDayName',
    data() {
      return {
        esNpfuturesExchangeTradeDayLoading: true,
        esNpfuturesExchangeTradeDayDialog: false,
        esNpfuturesExchangeTradeDayData: [],
        commodityTypeSelects: [],
        dicts: [],
        esNpfuturesExchangeTradeDayForm: {
          'id': '',
          'exchangeNo': '',
          'commodityNo': '',
          'weekNum': '',
          'isTradeDay': '',
          'tradeDayTime': '',
          'tradeDayOpenTime': '',
          'tradeDayCloseTime': ''
        },
        searchForm: {
          'exchangeNo': '',
          'commodityNo': '',
          'weekNum': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesExchangeTradeDayRules: {
          exchangeNo: [
            { required: true, message: '交易所编码不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编号不可为空', trigger: 'change' }
          ],
          weekNum: [
            { required: true, message: '星期几(1~7)不可为空', trigger: 'change' }
          ],
          isTradeDay: [
            { required: true, message: '是否交易日(1交易日、0非交易日)不可为空', trigger: 'change' }
          ],
          tradeDayTime: [
            { required: true, message: '交易日零点时间戳不可为空', trigger: 'change' }
          ],
          tradeDayOpenTime: [
            { required: true, message: '交易日开盘时间戳不可为空', trigger: 'change' }
          ],
          tradeDayCloseTime: [
            { required: true, message: '交易日收盘时间戳不可为空', trigger: 'change' }
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
        this.esNpfuturesExchangeTradeDayLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesExchangeTradeDay/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeTradeDayData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesExchangeTradeDayLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesExchangeTradeDayForm = {
          'id': '',
          'exchangeNo': '',
          'commodityNo': '',
          'weekNum': '',
          'isTradeDay': '',
          'tradeDayTime': '',
          'tradeDayOpenTime': '',
          'tradeDayCloseTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesExchangeTradeDayDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesExchangeTradeDayForm) {
          this.$refs.esNpfuturesExchangeTradeDayForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesExchangeTradeDay/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeTradeDayForm = {
              'id': res.object.id,
              'exchangeNo': res.object.exchangeNo,
              'commodityNo': res.object.commodityNo,
              'weekNum': res.object.weekNum,
              'isTradeDay': res.object.isTradeDay,
              'tradeDayTime': res.object.tradeDayTime,
              'tradeDayOpenTime': res.object.tradeDayOpenTime,
              'tradeDayCloseTime': res.object.tradeDayCloseTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesExchangeTradeDayDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesExchangeTradeDay/save',
              method: 'post',
              data: this.esNpfuturesExchangeTradeDayForm
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
            this.esNpfuturesExchangeTradeDayDialog = false;
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
            url: '/npfutures/esNpfuturesExchangeTradeDay/del',
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
  .esNpfuturesExchangeTradeDayForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
