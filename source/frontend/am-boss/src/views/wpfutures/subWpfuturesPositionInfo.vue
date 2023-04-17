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
    <el-table v-loading="subWpfuturesPositionInfoLoading" :data="subWpfuturesPositionInfoData"
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
      <el-table-column prop="commodityNo" label="品种编码类型" />
      <el-table-column prop="contractNo" label="合约1"/>
      <el-table-column prop="strikePrice" label="执行价格"/>
      <el-table-column prop="callOrPutFlag" label="看张看跌" :formatter="statusFormat"/>
      <el-table-column prop="matchSide" label="买入卖出" :formatter="statusFormat"/>
      <el-table-column prop="hedgeFlag" label="投机保值" :formatter="statusFormat"/>
      <el-table-column prop="positionNo" label="本地持仓号，服务器编写"/>
      <el-table-column prop="serverFlag" label="服务器标识" :formatter="statusFormat"/>
      <el-table-column prop="orderNo" label="委托编码"/>
      <el-table-column prop="matchNo" label="本地成交号"/>
      <el-table-column prop="upperNo" label="上手号"/>
      <el-table-column prop="positionPrice" label="持仓价"/>
      <el-table-column prop="positionQty" label="持仓量"/>
      <el-table-column prop="positionStreamId" label="持仓流号"/>
      <el-table-column prop="commodityCurrencyGroup" label="品种币种组"/>
      <el-table-column prop="commodityCurrency" label="品种币种"/>
      <el-table-column prop="calculatePrice" label="当前计算价格"/>
      <el-table-column prop="accountInitialMargin" label="客户初始保证金"/>
      <el-table-column prop="accountMaintenanceMargin" label="客户维持保证金"/>
      <el-table-column prop="upperInitialMargin" label="上手初始保证金"/>
      <el-table-column prop="upperMaintenanceMargin" label="上手维持保证金"/>
      <el-table-column prop="positionProfit" label="持仓盈亏"/>
      <el-table-column prop="lMEPositionProfit" label="LME持仓盈亏"/>
      <el-table-column prop="optionMarketValue" label="期权市值"/>
      <el-table-column prop="isHistory" label="是否为昨仓" :formatter="statusFormat"/>
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
    <el-dialog title="子账户持仓明细" :visible.sync="subWpfuturesPositionInfoDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="subWpfuturesPositionInfoForm" :model="subWpfuturesPositionInfoForm"
               :rules="subWpfuturesPositionInfoRules" label-width="150px" class="subWpfuturesPositionInfoForm">
       <el-row>
         <el-col :span="8">
           <el-form-item label="子账户AM平台账户ID" prop="subAccountId">
             <el-input v-model="subWpfuturesPositionInfoForm.subAccountId" placeholder="请输入子账户AM平台账户ID"/>
           </el-form-item>
         </el-col>
         <el-col :span="8">
           <el-form-item label="交易所编号" prop="exchangeNo">
             <el-input v-model="subWpfuturesPositionInfoForm.exchangeNo" placeholder="请输入交易所编号"/>
           </el-form-item>
         </el-col>
         <el-col :span="8">
           <el-form-item label="品种类型" prop="commodityType">
             <el-input v-model="subWpfuturesPositionInfoForm.commodityType" placeholder="请输入品种类型"/>
           </el-form-item>
         </el-col>
       </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种编码类型" prop="commodityNo">
              <el-input v-model="subWpfuturesPositionInfoForm.commodityNo" placeholder="请输入品种编码类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约1" prop="contractNo">
              <el-input v-model="subWpfuturesPositionInfoForm.contractNo" placeholder="请输入合约1"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="执行价格" prop="strikePrice">
              <el-input v-model="subWpfuturesPositionInfoForm.strikePrice" placeholder="请输入执行价格"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="看张看跌" prop="callOrPutFlag">
              <el-input v-model="subWpfuturesPositionInfoForm.callOrPutFlag" placeholder="请输入看张看跌"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="买入卖出" prop="matchSide">
              <el-input v-model="subWpfuturesPositionInfoForm.matchSide" placeholder="请输入买入卖出"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="投机保值" prop="hedgeFlag">
              <el-input v-model="subWpfuturesPositionInfoForm.hedgeFlag" placeholder="请输入投机保值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="本地持仓号，服务器编写" prop="positionNo">
              <el-input v-model="subWpfuturesPositionInfoForm.positionNo" placeholder="请输入本地持仓号，服务器编写"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="服务器标识" prop="serverFlag">
              <el-input v-model="subWpfuturesPositionInfoForm.serverFlag" placeholder="请输入服务器标识"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="委托编码" prop="orderNo">
              <el-input v-model="subWpfuturesPositionInfoForm.orderNo" placeholder="请输入委托编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="本地成交号" prop="matchNo">
              <el-input v-model="subWpfuturesPositionInfoForm.matchNo" placeholder="请输入本地成交号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手号" prop="upperNo">
              <el-input v-model="subWpfuturesPositionInfoForm.upperNo" placeholder="请输入上手号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓价" prop="positionPrice">
              <el-input v-model="subWpfuturesPositionInfoForm.positionPrice" placeholder="请输入持仓价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓量" prop="positionQty">
              <el-input v-model="subWpfuturesPositionInfoForm.positionQty" placeholder="请输入持仓量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓流号" prop="positionStreamId">
              <el-input v-model="subWpfuturesPositionInfoForm.positionStreamId" placeholder="请输入持仓流号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种币种组" prop="commodityCurrencyGroup">
              <el-input v-model="subWpfuturesPositionInfoForm.commodityCurrencyGroup" placeholder="请输入品种币种组"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种币种" prop="commodityCurrency">
              <el-input v-model="subWpfuturesPositionInfoForm.commodityCurrency" placeholder="请输入品种币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当前计算价格" prop="calculatePrice">
              <el-input v-model="subWpfuturesPositionInfoForm.calculatePrice" placeholder="请输入当前计算价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="客户初始保证金" prop="accountInitialMargin">
              <el-input v-model="subWpfuturesPositionInfoForm.accountInitialMargin" placeholder="请输入客户初始保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="客户维持保证金" prop="accountMaintenanceMargin">
              <el-input v-model="subWpfuturesPositionInfoForm.accountMaintenanceMargin" placeholder="请输入客户维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手初始保证金" prop="upperInitialMargin">
              <el-input v-model="subWpfuturesPositionInfoForm.upperInitialMargin" placeholder="请输入上手初始保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上手维持保证金" prop="upperMaintenanceMargin">
              <el-input v-model="subWpfuturesPositionInfoForm.upperMaintenanceMargin" placeholder="请输入上手维持保证金"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓盈亏" prop="positionProfit">
              <el-input v-model="subWpfuturesPositionInfoForm.positionProfit" placeholder="请输入持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="LME持仓盈亏" prop="lMEPositionProfit">
              <el-input v-model="subWpfuturesPositionInfoForm.lMEPositionProfit" placeholder="请输入LME持仓盈亏"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权市值" prop="optionMarketValue">
              <el-input v-model="subWpfuturesPositionInfoForm.optionMarketValue" placeholder="请输入期权市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="是否为昨仓" prop="isHistory">
              <el-input v-model="subWpfuturesPositionInfoForm.isHistory" placeholder="请输入是否为昨仓"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'SubWpfuturesPositionInfoName',
    data() {
      return {
        subWpfuturesPositionInfoLoading: true,
        subWpfuturesPositionInfoDialog: false,
        subWpfuturesPositionInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        subWpfuturesPositionInfoForm: {
          'id': '',
          'subAccountId': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'matchSide': '',
          'hedgeFlag': '',
          'positionNo': '',
          'serverFlag': '',
          'orderNo': '',
          'matchNo': '',
          'upperNo': '',
          'positionPrice': '',
          'positionQty': '',
          'positionStreamId': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'calculatePrice': '',
          'accountInitialMargin': '',
          'accountMaintenanceMargin': '',
          'upperInitialMargin': '',
          'upperMaintenanceMargin': '',
          'positionProfit': '',
          'lMEPositionProfit': '',
          'optionMarketValue': '',
          'isHistory': ''
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
        subWpfuturesPositionInfoRules: {
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
          hedgeFlag: [
            { required: true, message: '投机保值不可为空', trigger: 'change' }
          ],
          positionNo: [
            { required: true, message: '本地持仓号，服务器编写不可为空', trigger: 'change' }
          ],
          serverFlag: [
            { required: true, message: '服务器标识不可为空', trigger: 'change' }
          ],
          orderNo: [
            { required: true, message: '委托编码不可为空', trigger: 'change' }
          ],
          matchNo: [
            { required: true, message: '本地成交号不可为空', trigger: 'change' }
          ],
          upperNo: [
            { required: true, message: '上手号不可为空', trigger: 'change' }
          ],
          positionPrice: [
            { required: true, message: '持仓价不可为空', trigger: 'change' }
          ],
          positionQty: [
            { required: true, message: '持仓量不可为空', trigger: 'change' }
          ],
          positionStreamId: [
            { required: true, message: '持仓流号不可为空', trigger: 'change' }
          ],
          commodityCurrencyGroup: [
            { required: true, message: '品种币种组不可为空', trigger: 'change' }
          ],
          commodityCurrency: [
            { required: true, message: '品种币种不可为空', trigger: 'change' }
          ],
          calculatePrice: [
            { required: true, message: '当前计算价格不可为空', trigger: 'change' }
          ],
          accountInitialMargin: [
            { required: true, message: '客户初始保证金不可为空', trigger: 'change' }
          ],
          accountMaintenanceMargin: [
            { required: true, message: '客户维持保证金不可为空', trigger: 'change' }
          ],
          upperInitialMargin: [
            { required: true, message: '上手初始保证金不可为空', trigger: 'change' }
          ],
          upperMaintenanceMargin: [
            { required: true, message: '上手维持保证金不可为空', trigger: 'change' }
          ],
          positionProfit: [
            { required: true, message: '持仓盈亏不可为空', trigger: 'change' }
          ],
          lMEPositionProfit: [
            { required: true, message: 'LME持仓盈亏不可为空', trigger: 'change' }
          ],
          optionMarketValue: [
            { required: true, message: '期权市值不可为空', trigger: 'change' }
          ],
          isHistory: [
            { required: true, message: '是否为昨仓不可为空', trigger: 'change' }
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
        this.subWpfuturesPositionInfoLoading = true;
        this.$http({
          url: '/wpfutures/subWpfuturesPositionInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesPositionInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.subWpfuturesPositionInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.subWpfuturesPositionInfoForm = {
          'id': '',
          'subAccountId': '',
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'contractNo': '',
          'strikePrice': '',
          'callOrPutFlag': '',
          'matchSide': '',
          'hedgeFlag': '',
          'positionNo': '',
          'serverFlag': '',
          'orderNo': '',
          'matchNo': '',
          'upperNo': '',
          'positionPrice': '',
          'positionQty': '',
          'positionStreamId': '',
          'commodityCurrencyGroup': '',
          'commodityCurrency': '',
          'calculatePrice': '',
          'accountInitialMargin': '',
          'accountMaintenanceMargin': '',
          'upperInitialMargin': '',
          'upperMaintenanceMargin': '',
          'positionProfit': '',
          'lMEPositionProfit': '',
          'optionMarketValue': '',
          'isHistory': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.subWpfuturesPositionInfoDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.subWpfuturesPositionInfoForm) {
          this.$refs.subWpfuturesPositionInfoForm.resetFields();
        }
        this.$http({
          url: '/wpfutures/subWpfuturesPositionInfo/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.subWpfuturesPositionInfoForm = {
              'id': res.object.id,
              'subAccountId': res.object.subAccountId,
              'exchangeNo': res.object.exchangeNo,
              'commodityType': res.object.commodityType,
              'commodityNo': res.object.commodityNo,
              'contractNo': res.object.contractNo,
              'strikePrice': res.object.strikePrice,
              'callOrPutFlag': res.object.callOrPutFlag,
              'matchSide': res.object.matchSide,
              'hedgeFlag': res.object.hedgeFlag,
              'positionNo': res.object.positionNo,
              'serverFlag': res.object.serverFlag,
              'orderNo': res.object.orderNo,
              'matchNo': res.object.matchNo,
              'upperNo': res.object.upperNo,
              'positionPrice': res.object.positionPrice,
              'positionQty': res.object.positionQty,
              'positionStreamId': res.object.positionStreamId,
              'commodityCurrencyGroup': res.object.commodityCurrencyGroup,
              'commodityCurrency': res.object.commodityCurrency,
              'calculatePrice': res.object.calculatePrice,
              'accountInitialMargin': res.object.accountInitialMargin,
              'accountMaintenanceMargin': res.object.accountMaintenanceMargin,
              'upperInitialMargin': res.object.upperInitialMargin,
              'upperMaintenanceMargin': res.object.upperMaintenanceMargin,
              'positionProfit': res.object.positionProfit,
              'lMEPositionProfit': res.object.lMEPositionProfit,
              'optionMarketValue': res.object.optionMarketValue,
              'isHistory': res.object.isHistory
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.subWpfuturesPositionInfoDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/wpfutures/subWpfuturesPositionInfo/save',
              method: 'post',
              data: this.subWpfuturesPositionInfoForm
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
            this.subWpfuturesPositionInfoDialog = false;
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
            url: '/wpfutures/subWpfuturesPositionInfo/del',
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
  .subWpfuturesPositionInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
