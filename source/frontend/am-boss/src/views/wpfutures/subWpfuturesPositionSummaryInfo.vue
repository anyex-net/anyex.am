<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="子账户AM平台账户ID">
        <el-input v-model="searchForm.subAccountId" clearable placeholder="请输入子账户AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="交易所编号">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编号"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-input v-model="searchForm.commodityType" clearable placeholder="请输入品种类型"></el-input>
      </el-form-item>
      <el-form-item label="品种编码类型">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码类型"></el-input>
      </el-form-item>
      <el-form-item label="合约1">
        <el-input v-model="searchForm.contractNo" clearable placeholder="请输入合约1"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="subWpfuturesPositionSummaryInfoLoading" :data="subWpfuturesPositionSummaryInfoData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="subAccountId" label="子账户AM平台账户ID"/>
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
    <el-dialog title="子账户持仓汇总表管理" :visible.sync="subWpfuturesPositionSummaryInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="subWpfuturesPositionSummaryInfoForm" :model="subWpfuturesPositionSummaryInfoForm"
               :rules="subWpfuturesPositionSummaryInfoRules" label-width="150px"
               class="subWpfuturesPositionSummaryInfoForm">
        <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="交易所编号" prop="exchangeNo">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
        </el-form-item>
        <el-form-item label="品种类型" prop="commodityType">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.commodityType" placeholder="请输入品种类型"/>
        </el-form-item>
        <el-form-item label="品种编码类型" prop="commodityNo">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
        </el-form-item>
        <el-form-item label="合约1" prop="contractNo">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.contractNo" placeholder="请输入合约1"/>
        </el-form-item>
        <el-form-item label="执行价格" prop="strikePrice">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.strikePrice" placeholder="请输入执行价格"/>
        </el-form-item>
        <el-form-item label="看张看跌" prop="callOrPutFlag">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
        </el-form-item>
        <el-form-item label="买入卖出" prop="matchSide">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.matchSide" placeholder="请输入买入卖出"/>
        </el-form-item>
        <el-form-item label="持仓价" prop="positionPrice">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.positionPrice" placeholder="请输入持仓价"/>
        </el-form-item>
        <el-form-item label="持仓量" prop="positionQty">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.positionQty" placeholder="请输入持仓量"/>
        </el-form-item>
        <el-form-item label="历史持仓量" prop="hisPositionQty">
          <el-input v-model="subWpfuturesPositionSummaryInfoForm.hisPositionQty" placeholder="请输入历史持仓量"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubWpfuturesPositionSummaryInfoName',
    data() {
      return {
        subWpfuturesPositionSummaryInfoLoading: true,
        subWpfuturesPositionSummaryInfoDialog: false,
        subWpfuturesPositionSummaryInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        subWpfuturesPositionSummaryInfoForm: {
          'id': '',
          'subAccountId': '',
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
          'id': '',
          'subAccountId': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        subWpfuturesPositionSummaryInfoRules: {
          subAccountId: [
            { required: true, message: '子账户AM平台账户ID不可为空', trigger: 'change' }
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
        this.subWpfuturesPositionSummaryInfoLoading = true;
        this.$http({
          url: '/wpfutures/subWpfuturesPositionSummaryInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesPositionSummaryInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subWpfuturesPositionSummaryInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subWpfuturesPositionSummaryInfoForm = {
          'id': '',
          'subAccountId': '',
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
        this.subWpfuturesPositionSummaryInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subWpfuturesPositionSummaryInfoForm) {
          this.$refs.subWpfuturesPositionSummaryInfoForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/subWpfuturesPositionSummaryInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesPositionSummaryInfoForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
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
        this.subWpfuturesPositionSummaryInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/subWpfuturesPositionSummaryInfo/save',
              method: 'post',
              data: this.subWpfuturesPositionSummaryInfoForm
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
            this.subWpfuturesPositionSummaryInfoDialog = false;
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
            url: '/wpfutures/subWpfuturesPositionSummaryInfo/del',
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
  .subWpfuturesPositionSummaryInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
