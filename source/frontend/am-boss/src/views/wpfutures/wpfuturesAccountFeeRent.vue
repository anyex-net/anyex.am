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
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
        <el-button type="danger" @click="doInit()">初始化手续费</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesAccountFeeRentLoading" :data="wpfuturesAccountFeeRentData"
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
      <el-table-column prop="matchSource" label="成交来源" :formatter="statusFormat"/>
      <el-table-column prop="calculateMode" label="计算方式" :formatter="statusFormat"/>
      <el-table-column prop="currencyGroupNo" label="币种组编号"/>
      <el-table-column prop="currencyNo" label="币种编号"/>
      <el-table-column prop="openCloseFee" label="开平手续费"/>
      <el-table-column prop="closeTodayFee" label="平今手续费"/>
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
    <el-dialog title="外盘期货客户手续费计算参数信息" :visible.sync="wpfuturesAccountFeeRentDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="wpfuturesAccountFeeRentForm" :model="wpfuturesAccountFeeRentForm"
               :rules="wpfuturesAccountFeeRentRules" label-width="150px" class="wpfuturesAccountFeeRentForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="wpfuturesAccountFeeRentForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-select v-model="wpfuturesAccountFeeRentForm.brokerNo" clearable placeholder="请选择经纪商" value="">
            <el-option v-for="data in dicts.brokerNo" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="客户资金账号" prop="accountNo">
          <el-input v-model="wpfuturesAccountFeeRentForm.accountNo" placeholder="请输入客户资金账号"/>
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeNo">
          <el-input v-model="wpfuturesAccountFeeRentForm.exchangeNo" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="品种类型" prop="commodityType">
          <el-select v-model="wpfuturesAccountFeeRentForm.commodityType" clearable placeholder="请选择经纪商" value="">
            <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="品种编码" prop="commodityNo">
          <el-input v-model="wpfuturesAccountFeeRentForm.commodityNo" placeholder="请输入品种编码"/>
        </el-form-item>
        <el-form-item label="成交来源" prop="matchSource">
          <el-select v-model="wpfuturesAccountFeeRentForm.matchSource" clearable placeholder="请选择经纪商" value="">
            <el-option v-for="data in dicts.matchSource" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="计算方式" prop="calculateMode">
          <el-select v-model="wpfuturesAccountFeeRentForm.calculateMode" clearable placeholder="请选择经纪商" value="">
            <el-option v-for="data in dicts.calculateMode" :key="data.key" :label="data.value" :value="data.key">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="币种组编号" prop="currencyGroupNo">
          <el-input v-model="wpfuturesAccountFeeRentForm.currencyGroupNo" placeholder="请输入币种组编号"/>
        </el-form-item>
        <el-form-item label="币种编号" prop="currencyNo">
          <el-input v-model="wpfuturesAccountFeeRentForm.currencyNo" placeholder="请输入币种编号"/>
        </el-form-item>
        <el-form-item label="开平手续费" prop="openCloseFee">
          <el-input v-model="wpfuturesAccountFeeRentForm.openCloseFee" placeholder="请输入开平手续费"/>
        </el-form-item>
        <el-form-item label="平今手续费" prop="closeTodayFee">
          <el-input v-model="wpfuturesAccountFeeRentForm.closeTodayFee" placeholder="请输入平今手续费"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('wpfuturesAccountFeeRentForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'WpfuturesAccountFeeRentName',
    data() {
      return {
        wpfuturesAccountFeeRentLoading: true,
        wpfuturesAccountFeeRentDialog: false,
        wpfuturesAccountFeeRentData: [],
        commodityTypeSelects: [],
        dicts: [],
        wpfuturesAccountFeeRentForm: {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'matchSource': '',
          'calculateMode': '',
          'currencyGroupNo': '',
          'currencyNo': '',
          'openCloseFee': '',
          'closeTodayFee': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        wpfuturesAccountFeeRentRules: {
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
          matchSource: [
            { required: true, message: '成交来源不可为空', trigger: 'change' }
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
          openCloseFee: [
            { required: true, message: '开平手续费不可为空', trigger: 'change' }
          ],
          closeTodayFee: [
            { required: true, message: '平今手续费不可为空', trigger: 'change' }
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
        this.wpfuturesAccountFeeRentLoading = true;
        this.$http({
          url: '/wpfutures/wpfuturesAccountFeeRent/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesAccountFeeRentData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.wpfuturesAccountFeeRentLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.wpfuturesAccountFeeRentForm = {
          'id': '',
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'matchSource': '',
          'calculateMode': '',
          'currencyGroupNo': '',
          'currencyNo': '',
          'openCloseFee': '',
          'closeTodayFee': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.wpfuturesAccountFeeRentDialog = true;
      },
      doInit: function() {
        this.$http({
          url: '/wpfutures/wpfuturesAccountFeeRent/init',
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
        if (this.$refs.wpfuturesAccountFeeRentForm) {
          this.$refs.wpfuturesAccountFeeRentForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/wpfuturesAccountFeeRent/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesAccountFeeRentForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerNo': res.object.brokerNo,
              'accountNo': res.object.accountNo,
              'exchangeNo': res.object.exchangeNo,
              'commodityType': res.object.commodityType,
              'commodityNo': res.object.commodityNo,
              'matchSource': res.object.matchSource,
              'calculateMode': res.object.calculateMode,
              'currencyGroupNo': res.object.currencyGroupNo,
              'currencyNo': res.object.currencyNo,
              'openCloseFee': res.object.openCloseFee,
              'closeTodayFee': res.object.closeTodayFee
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.wpfuturesAccountFeeRentDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/wpfuturesAccountFeeRent/save',
              method: 'post',
              data: this.wpfuturesAccountFeeRentForm
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
            this.wpfuturesAccountFeeRentDialog = false;
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
            url: '/wpfutures/wpfuturesAccountFeeRent/del',
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
  .wpfuturesAccountFeeRentForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
