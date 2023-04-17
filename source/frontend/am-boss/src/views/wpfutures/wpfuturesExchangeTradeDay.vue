<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="主键">
        <el-input v-model="searchForm.id" clearable placeholder="请输入主键"></el-input>
      </el-form-item>
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="品种编号">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编号"></el-input>
      </el-form-item>
      <el-form-item label="星期几(1~7)">
        <el-input v-model="searchForm.weekNum" clearable placeholder="请输入星期几(1~7)"></el-input>
      </el-form-item>
      <el-form-item label="是否交易日">
        <el-select v-model="searchForm.isTradeDay" clearable placeholder="请输入是否交易日">
          <el-option :key="0" label="非交易日" :value="0" />
          <el-option :key="1" label="交易日" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesExchangeTradeDayLoading" :data="wpfuturesExchangeTradeDayData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码"/>
      <el-table-column prop="commodityNo" label="品种编号"/>
      <el-table-column prop="weekNum" label="星期几(1~7)"/>
      <el-table-column prop="isTradeDay" label="是否交易日">
        <template scope="scope">
          <div v-if="scope.row.isTradeDay == 0">非交易日</div>
          <div v-else-if="scope.row.isTradeDay == 1">交易日</div>
        </template>
      </el-table-column>
      <el-table-column prop="tradeDayTime" label="交易日零点时间戳" :formatter="dateFormat"/>
      <el-table-column prop="tradeDayOpenTime" label="交易日开盘时间戳" :formatter="dateFormat"/>
      <el-table-column prop="tradeDayCloseTime" label="交易日收盘时间戳" :formatter="dateFormat"/>
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
    <el-dialog title="外盘期货交易所交易日表管理" :visible.sync="wpfuturesExchangeTradeDayDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="wpfuturesExchangeTradeDayForm" :model="wpfuturesExchangeTradeDayForm"
               :rules="wpfuturesExchangeTradeDayRules" label-width="150px" class="wpfuturesExchangeTradeDayForm">
        <el-form-item label="交易所编码" prop="exchangeNo">
          <el-input v-model="wpfuturesExchangeTradeDayForm.exchangeNo" placeholder="请输入交易所编码"/>
        </el-form-item>
        <el-form-item label="品种编号" prop="commodityNo">
          <el-input v-model="wpfuturesExchangeTradeDayForm.commodityNo" placeholder="请输入品种编号"/>
        </el-form-item>
        <el-form-item label="星期几(1~7)" prop="weekNum">
          <el-input v-model="wpfuturesExchangeTradeDayForm.weekNum" placeholder="请输入星期几(1~7)"/>
        </el-form-item>
        <el-form-item label="是否交易日" prop="isTradeDay">
          <el-select v-model="wpfuturesExchangeTradeDayForm.isTradeDay" placeholder="请输入是否交易日">
            <el-option :key="0" label="非交易日" :value="0" />
            <el-option :key="1" label="交易日" :value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="交易日零点时间戳" prop="tradeDayTime">
          <el-input v-model="wpfuturesExchangeTradeDayForm.tradeDayTime" placeholder="请输入交易日零点时间戳"/>
        </el-form-item>
        <el-form-item label="交易日开盘时间戳" prop="tradeDayOpenTime">
          <el-input v-model="wpfuturesExchangeTradeDayForm.tradeDayOpenTime" placeholder="请输入交易日开盘时间戳"/>
        </el-form-item>
        <el-form-item label="交易日收盘时间戳" prop="tradeDayCloseTime">
          <el-input v-model="wpfuturesExchangeTradeDayForm.tradeDayCloseTime" placeholder="请输入交易日收盘时间戳"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('wpfuturesExchangeTradeDayForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'WpfuturesExchangeTradeDayName',
    data() {
      return {
        wpfuturesExchangeTradeDayLoading: true,
        wpfuturesExchangeTradeDayDialog: false,
        wpfuturesExchangeTradeDayData: [],
        commodityTypeSelects: [],
        dicts: [],
        wpfuturesExchangeTradeDayForm: {
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
          'id': '',
          'exchangeNo': '',
          'commodityNo': '',
          'weekNum': '',
          'isTradeDay': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        wpfuturesExchangeTradeDayRules: {
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
            { required: true, message: '是否交易日不可为空', trigger: 'change' }
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
          url: '/wpfutures/dict/wpfuturesExchangeTradeDay',
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
        this.wpfuturesExchangeTradeDayLoading = true;
        this.$http({
          url: '/wpfutures/wpfuturesExchangeTradeDay/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesExchangeTradeDayData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.wpfuturesExchangeTradeDayLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.wpfuturesExchangeTradeDayForm = {
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
        this.wpfuturesExchangeTradeDayDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.wpfuturesExchangeTradeDayForm) {
          this.$refs.wpfuturesExchangeTradeDayForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/wpfuturesExchangeTradeDay/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesExchangeTradeDayForm = {
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
        this.wpfuturesExchangeTradeDayDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/wpfuturesExchangeTradeDay/save',
              method: 'post',
              data: this.wpfuturesExchangeTradeDayForm
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
            this.wpfuturesExchangeTradeDayDialog = false;
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
            url: '/wpfutures/wpfuturesExchangeTradeDay/del',
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
  .wpfuturesExchangeTradeDayForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
