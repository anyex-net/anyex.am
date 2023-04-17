<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪商编码">
        <el-input v-model="searchForm.brokerNo" clearable placeholder="请输入经纪商编码"></el-input>
      </el-form-item>
      <el-form-item label="客户资金帐号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入客户资金帐号"></el-input>
      </el-form-item>
      <el-form-item label="交易所编号">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编号"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-input v-model="searchForm.commodityType" clearable placeholder="请输入品种类型"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesPositionSummaryInfoLoading" :data="wpfuturesPositionSummaryInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerNo" label="经纪商编码" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="客户资金帐号"/>
      <el-table-column prop="exchangeNo" label="交易所编号" :formatter="statusFormat"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编码类型"/>
      <el-table-column prop="contractNo" label="合约1"/>
      <el-table-column prop="strikePrice" label="执行价格"/>
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat"/>
      <el-table-column prop="matchSide" label="买入卖出" :formatter="statusFormat"/>
      <el-table-column prop="positionPrice" label="持仓价"/>
      <el-table-column prop="positionQty" label="持仓量"/>
      <el-table-column prop="hisPositionQty" label="历史持仓量"/>
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
    <el-dialog title="外盘期货持仓汇总表管理" :visible.sync="wpfuturesPositionSummaryInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="wpfuturesPositionSummaryInfoForm" :model="wpfuturesPositionSummaryInfoForm"
               :rules="wpfuturesPositionSummaryInfoRules" label-width="150px" class="wpfuturesPositionSummaryInfoForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.id" placeholder="请输入主键"/>
        </el-form-item>
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪商编码" prop="brokerNo">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.brokerNo" placeholder="请输入经纪商编码"/>
        </el-form-item>
        <el-form-item label="客户资金帐号" prop="accountNo">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.accountNo" placeholder="请输入客户资金帐号"/>
        </el-form-item>
        <el-form-item label="交易所编号" prop="exchangeNo">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
        </el-form-item>
        <el-form-item label="品种类型" prop="commodityType">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.commodityType" placeholder="请输入品种类型"/>
        </el-form-item>
        <el-form-item label="品种编码类型" prop="commodityNo">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
        </el-form-item>
        <el-form-item label="合约1" prop="contractNo">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.contractNo" placeholder="请输入合约1"/>
        </el-form-item>
        <el-form-item label="执行价格" prop="strikePrice">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.strikePrice" placeholder="请输入执行价格"/>
        </el-form-item>
        <el-form-item label="看张看跌" prop="callOrPutFlag">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
        </el-form-item>
        <el-form-item label="买入卖出" prop="matchSide">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.matchSide" placeholder="请输入买入卖出"/>
        </el-form-item>
        <el-form-item label="持仓价" prop="positionPrice">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.positionPrice" placeholder="请输入持仓价"/>
        </el-form-item>
        <el-form-item label="持仓量" prop="positionQty">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.positionQty" placeholder="请输入持仓量"/>
        </el-form-item>
        <el-form-item label="历史持仓量" prop="hisPositionQty">
          <el-input v-model="wpfuturesPositionSummaryInfoForm.hisPositionQty" placeholder="请输入历史持仓量"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'WpfuturesPositionSummaryInfo',
    data() {
      return {
        wpfuturesPositionSummaryInfoLoading: true,
        wpfuturesPositionSummaryInfoDialog: false,
        wpfuturesPositionSummaryInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        wpfuturesPositionSummaryInfoForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'matchSide': '',
          'positionPrice': '',
          'positionQty': '',
          'hisPositionQty': ''
        },
        searchForm: {
          'accountId': '',
          'brokerNo': '',
          'accountNo': '',
          'exchangeNo': '',
          'commodityType': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        wpfuturesPositionSummaryInfoRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerNo: [
            { required: true, message: '经纪商编码不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '客户资金帐号不可为空', trigger: 'change' }
          ],
          exchangeNo: [
            { required: true, message: '交易所编号不可为空', trigger: 'change' }
          ],
          commodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编码类型不可为空', trigger: 'change' }
          ],
          contractNo: [
            { required: true, message: '合约1不可为空', trigger: 'change' }
          ],
          strikePrice: [
            { required: true, message: '执行价格不可为空', trigger: 'change' }
          ],
          callOrPutFlag: [
            { required: true, message: '看张看跌不可为空', trigger: 'change' }
          ],
          matchSide: [
            { required: true, message: '买入卖出不可为空', trigger: 'change' }
          ],
          positionPrice: [
            { required: true, message: '持仓价不可为空', trigger: 'change' }
          ],
          positionQty: [
            { required: true, message: '持仓量不可为空', trigger: 'change' }
          ],
          hisPositionQty: [
            { required: true, message: '历史持仓量不可为空', trigger: 'change' }
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
          url: '/wpfutures/dict/wpfuturesPositionInfo',
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
        this.wpfuturesPositionSummaryInfoLoading = true;
        this.$http({
          url: '/wpfutures/wpfuturesPositionSummaryInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesPositionSummaryInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.wpfuturesPositionSummaryInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.wpfuturesPositionSummaryInfoForm = {
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
          'matchSide': '',
          'positionPrice': '',
          'positionQty': '',
          'hisPositionQty': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.wpfuturesPositionSummaryInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.wpfuturesPositionSummaryInfoForm) {
          this.$refs.wpfuturesPositionSummaryInfoForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/wpfuturesPositionSummaryInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.wpfuturesPositionSummaryInfoForm = {
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
              'matchSide': res.object.matchSide,
              'positionPrice': res.object.positionPrice,
              'positionQty': res.object.positionQty,
              'hisPositionQty': res.object.hisPositionQty
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.wpfuturesPositionSummaryInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/wpfuturesPositionSummaryInfo/save',
              method: 'post',
              data: this.wpfuturesPositionSummaryInfoForm
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
            this.wpfuturesPositionSummaryInfoDialog = false;
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
            url: '/wpfutures/wpfuturesPositionSummaryInfo/del',
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
  .wpfuturesPositionSummaryInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
