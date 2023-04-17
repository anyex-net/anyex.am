<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-select v-model="searchForm.brokerNo" clearable placeholder="请选择经纪商" value="">
          <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="客户资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金账号"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
        <el-button type="danger" @click="doInit()">初始化保证金</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesAccountMarginRentLoading" :data="wpfuturesAccountMarginRentData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="客户资金账号"/>
      <el-table-column prop="exchangeNo" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编码"/>
      <el-table-column prop="contractNo" label="合约代码"/>
      <el-table-column prop="strikePrice" label="执行价"/>
      <el-table-column prop="callOrPutFlag" label="看涨看跌" :formatter="statusFormat"/>
      <el-table-column prop="calculateMode" label="计算方式" :formatter="statusFormat"/>
      <el-table-column prop="currencyGroupNo" label="币种组编号"/>
      <el-table-column prop="currencyNo" label="币种编号"/>
      <el-table-column prop="initialMargin" label="买初始保证金"/>
      <el-table-column prop="maintenanceMargin" label="买维持保证金"/>
      <el-table-column prop="sellInitialMargin" label="卖初始保证金"/>
      <el-table-column prop="sellMaintenanceMargin" label="卖维持保证金"/>
      <el-table-column prop="lockMargin" label="锁保证金"/>
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
    <el-dialog title="外盘期货客户保证金计算参数信息" :visible.sync="wpfuturesAccountMarginRentDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="wpfuturesAccountMarginRentForm" :model="wpfuturesAccountMarginRentForm"
               :rules="wpfuturesAccountMarginRentRules" label-width="150px" class="wpfuturesAccountMarginRentForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="wpfuturesAccountMarginRentForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-select v-model="wpfuturesAccountMarginRentForm.brokerNo" clearable placeholder="请选择经纪商" value="">
            <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="客户资金账号" prop="accountNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.accountNo" placeholder="请输入客户资金账号"/>
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.exchangeNo" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="品种类型" prop="commodityType">
          <el-select v-model="wpfuturesAccountMarginRentForm.commodityType" clearable placeholder="请选择品种类型" value="">
            <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="品种编码" prop="commodityNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.commodityNo" placeholder="请输入品种编码"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.contractNo" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="执行价" prop="strikePrice">
          <el-input v-model="wpfuturesAccountMarginRentForm.strikePrice" placeholder="请输入执行价"/>
        </el-form-item>
        <el-form-item label="看涨看跌" prop="callOrPutFlag">
          <el-select v-model="wpfuturesAccountMarginRentForm.callOrPutFlag" clearable placeholder="请选择看涨看跌" value="">
            <el-option v-for="data in dicts.callOrPutFlag" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="计算方式" prop="calculateMode">
          <el-select v-model="wpfuturesAccountMarginRentForm.calculateMode" clearable placeholder="请选择计算方式" value="">
            <el-option v-for="data in dicts.calculateMode" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="币种组编号" prop="currencyGroupNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.currencyGroupNo" placeholder="请输入币种组编号"/>
        </el-form-item>
        <el-form-item label="币种编号" prop="currencyNo">
          <el-input v-model="wpfuturesAccountMarginRentForm.currencyNo" placeholder="请输入币种编号"/>
        </el-form-item>
        <el-form-item label="买初始保证金" prop="initialMargin">
          <el-input v-model="wpfuturesAccountMarginRentForm.initialMargin" placeholder="请输入买初始保证金"/>
        </el-form-item>
        <el-form-item label="买维持保证金" prop="maintenanceMargin">
          <el-input v-model="wpfuturesAccountMarginRentForm.maintenanceMargin" placeholder="请输入买维持保证金"/>
        </el-form-item>
        <el-form-item label="卖初始保证金" prop="sellInitialMargin">
          <el-input v-model="wpfuturesAccountMarginRentForm.sellInitialMargin" placeholder="请输入卖初始保证金"/>
        </el-form-item>
        <el-form-item label="卖维持保证金" prop="sellMaintenanceMargin">
          <el-input v-model="wpfuturesAccountMarginRentForm.sellMaintenanceMargin" placeholder="请输入卖维持保证金"/>
        </el-form-item>
        <el-form-item label="锁保证金" prop="lockMargin">
          <el-input v-model="wpfuturesAccountMarginRentForm.lockMargin" placeholder="请输入锁保证金"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('wpfuturesAccountMarginRentForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'WpfuturesAccountMarginRentName',
    data() {
      return {
        wpfuturesAccountMarginRentLoading: true,
        wpfuturesAccountMarginRentDialog: false,
        wpfuturesAccountMarginRentData: [],
        commodityTypeSelects: [],
        dicts: [],
        wpfuturesAccountMarginRentForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'calculateMode': '',
          'currencyGroupNo': '',
          'currencyNo': '',
          'initialMargin': '',
          'maintenanceMargin': '',
          'sellInitialMargin': '',
          'sellMaintenanceMargin': '',
          'lockMargin': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'calculateMode': '',
          'currencyGroupNo': '',
          'currencyNo': '',
          'initialMargin': '',
          'maintenanceMargin': '',
          'sellInitialMargin': '',
          'sellMaintenanceMargin': '',
          'lockMargin': ''
          ,
          'sort': 'id',
          'order': 'asc'
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        wpfuturesAccountMarginRentRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '客户资金账号不可为空', trigger: 'change' }
          ],
          exchangeNo: [
            { required: true, message: '交易所代码不可为空', trigger: 'change' }
          ],
          commodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编码不可为空', trigger: 'change' }
          ],
          contractNo: [
            { required: true, message: '合约代码不可为空', trigger: 'change' }
          ],
          strikePrice: [
            { required: true, message: '执行价不可为空', trigger: 'change' }
          ],
          callOrPutFlag: [
            { required: true, message: '看涨看跌不可为空', trigger: 'change' }
          ],
          calculateMode: [
            { required: true, message: '计算方式不可为空', trigger: 'change' }
          ],
          currencyGroupNo: [
            { required: true, message: '币种组编号不可为空', trigger: 'change' }
          ],
          currencyNo: [
            { required: true, message: '币种编号不可为空', trigger: 'change' }
          ],
          initialMargin: [
            { required: true, message: '买初始保证金不可为空', trigger: 'change' }
          ],
          maintenanceMargin: [
            { required: true, message: '买维持保证金不可为空', trigger: 'change' }
          ],
          sellInitialMargin: [
            { required: true, message: '卖初始保证金不可为空', trigger: 'change' }
          ],
          sellMaintenanceMargin: [
            { required: true, message: '卖维持保证金不可为空', trigger: 'change' }
          ],
          lockMargin: [
            { required: true, message: '锁保证金不可为空', trigger: 'change' }
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
          url: '/wpfutures/dict/wpfuturesFee',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.commodityTypeSelects = res.object.commodityType
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
        this.wpfuturesAccountMarginRentLoading = true;
        this.$http({
          url: '/wpfutures/wpfuturesAccountMarginRent/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesAccountMarginRentData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.wpfuturesAccountMarginRentLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.wpfuturesAccountMarginRentForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'calculateMode': '',
          'currencyGroupNo': '',
          'currencyNo': '',
          'initialMargin': '',
          'maintenanceMargin': '',
          'sellInitialMargin': '',
          'sellMaintenanceMargin': '',
          'lockMargin': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.wpfuturesAccountMarginRentDialog = true;
      },
      doInit: function() {
        this.$http({
          url: '/wpfutures/wpfuturesAccountMarginRent/init',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.$message.success(res.message);
            this.doSearch();
          }else {
            this.$message.error(res.message || 'Has Error');
          }
        }).catch(error => {
          console.log(error);
        });
      },
      dialogEdit: function(row, column) {
        if (this.$refs.wpfuturesAccountMarginRentForm) {
          this.$refs.wpfuturesAccountMarginRentForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/wpfuturesAccountMarginRent/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesAccountMarginRentForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'exchangeNo': res.object.exchangeNo,
              'commodityType': res.object.commodityType,
              'commodityNo': res.object.commodityNo,
              'contractNo': res.object.contractNo,
              'strikePrice': res.object.strikePrice,
              'callOrPutFlag': res.object.callOrPutFlag,
              'calculateMode': res.object.calculateMode,
              'currencyGroupNo': res.object.currencyGroupNo,
              'currencyNo': res.object.currencyNo,
              'initialMargin': res.object.initialMargin,
              'maintenanceMargin': res.object.maintenanceMargin,
              'sellInitialMargin': res.object.sellInitialMargin,
              'sellMaintenanceMargin': res.object.sellMaintenanceMargin,
              'lockMargin': res.object.lockMargin
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.wpfuturesAccountMarginRentDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/wpfuturesAccountMarginRent/save',
              method: 'post',
              data: this.wpfuturesAccountMarginRentForm
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
            this.wpfuturesAccountMarginRentDialog = false;
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
            url: '/wpfutures/wpfuturesAccountMarginRent/del',
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
  .wpfuturesAccountMarginRentForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
