<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="账户id">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入账户id"></el-input>
      </el-form-item>
      <el-form-item label="策略类型">
        <el-input v-model="searchForm.strategyType" clearable placeholder="请输入策略类型"></el-input>
      </el-form-item>
      <el-form-item label="策略名称">
        <el-input v-model="searchForm.strategyName" clearable placeholder="请输入策略名称"></el-input>
      </el-form-item>
      <el-form-item label="资金账号">
        <el-input v-model="searchForm.accountNo" clearable placeholder="请输入资金账号"></el-input>
      </el-form-item>
      <el-form-item label="交易所">
        <el-input v-model="searchForm.exchange" clearable placeholder="请输入交易所"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="quantStrategyInfoLoading" :data="quantStrategyInfoData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <div align="left">
            <el-button size="mini" type="warning" @click="doDetail(scope.$index, scope.row)">配置明细</el-button>
          </div>
          <div align="left" style="margin-top: 2px">
            <el-button size="mini" type="primary" @click="doStatusDetail(scope.$index, scope.row)">运行状态</el-button>
          </div>
          <div align="left" style="margin-top: 2px">
            <el-button v-if="scope.row.status === 1" size="mini" type="danger" @click="doStatus(scope.$index, scope.row)">停用</el-button>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="账户id"/>
      <el-table-column prop="strategyType" label="策略类型"/>
      <el-table-column prop="strategyId" label="策略id"/>
      <el-table-column prop="strategyName" label="策略名称"/>
      <el-table-column prop="accountNo" label="资金账号"/>
      <el-table-column prop="status" label="运行状态">
        <template slot-scope="scope">
          <span v-if="scope.row.status==0">已暂停</span>
          <span v-if="scope.row.status==1">运行中</span>
          <span v-if="scope.row.status==2">运行异常</span>
          <span v-if="scope.row.status==3">启动中</span>
          <span v-if="scope.row.status==4">暂停中</span>
        </template>
      </el-table-column>
      <el-table-column prop="updateTime" label="更新时间" :formatter="dateFormat"/>
      <el-table-column prop="exchange" label="交易所"/>
      <el-table-column prop="marketType" label="市场类型">
        <template slot-scope="scope">
          <span v-if="scope.row.marketType==='wp'">外盘</span>
          <span v-if="scope.row.marketType==='np'">内盘</span>
          <span v-if="scope.row.marketType==='vcoin'">vcoin</span>
        </template>
      </el-table-column>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="createTime" label="记录创建时间" :formatter="dateFormat"/>
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
    <el-dialog title="量化策略配置信息" :visible.sync="quantStrategyInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="quantStrategyPLAddPosForm" :model="quantStrategyPLAddPosForm"
               label-width="150px" class="quantStrategyInfoForm">
        <el-form-item label="账户id" prop="accountId" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.accountId"/>
        </el-form-item>
        <el-form-item label="策略名称" prop="strategyName" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.strategyName"/>
        </el-form-item>
        <el-form-item label="资金账号" prop="accountNo" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.accountNo"/>
        </el-form-item>
        <el-form-item label="更新时间" prop="updateTime" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.updateTime"/>
        </el-form-item>
        <el-form-item label="交易所" prop="exchange" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.exchange" placeholder="请输入资金账号"/>
        </el-form-item>
        <el-form-item label="市场类型" prop="marketType" style="margin-bottom: 3px">
          <el-select v-model="quantStrategyPLAddPosForm.marketType" placeholder="请输入市场类型">
            <el-option value="wp" label="外盘"></el-option>
            <el-option value="np" label="内盘"></el-option>
            <el-option value="vcoin" label="vcoin"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="合约号" prop="contractNo" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.contractNo"/>
        </el-form-item>
        <el-form-item label="保证金币种" prop="currencyNo" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.currencyNo"/>
        </el-form-item>
        <el-form-item label="合约品种代码" prop="product" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.product"/>
        </el-form-item>
        <el-form-item label="开仓方向" prop="entrustDirect" style="margin-bottom: 3px">
          <el-select v-model="quantStrategyPLAddPosForm.entrustDirect">
            <el-option value="buy" label="买"></el-option>
            <el-option value="sell" label="卖"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="止盈价" prop="stopProfitPrice" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.stopProfitPrice"/>
        </el-form-item>
        <el-form-item label="止盈容错比例" prop="stopProfitPriceRatio" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.stopProfitPriceRatio"/>
        </el-form-item>
        <el-form-item label="最大单笔委托数量" prop="maxEntrustAmt" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.maxEntrustAmt"/>
        </el-form-item>
        <el-form-item label="起始开仓价格" prop="openPositionPrice" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.openPositionPrice"/>
        </el-form-item>
        <el-form-item label="停止加仓价格" prop="stopAddPositionPrice" style="margin-bottom: 3px">
          <el-input v-model="quantStrategyPLAddPosForm.stopAddPositionPrice"/>
        </el-form-item>
      </el-form>
    </el-dialog>
    <el-dialog title="量化策略运行状态信息" :visible.sync="quantStrategyRunInfoDialog" :close-on-click-modal="false" width="600">
      <el-form ref="StrategyRunInfoForm" :model="StrategyRunInfoForm"
               label-width="150px" class="StrategyRunInfoForm">
        <el-form-item label="合约代码" prop="contractCode" style="margin-bottom: 3px">
          <el-input v-model="StrategyRunInfoForm.contractCode"/>
        </el-form-item>
        <el-form-item label="最新价" prop="lastPrice" style="margin-bottom: 3px">
          <el-input v-model="StrategyRunInfoForm.lastPrice"/>
        </el-form-item>
        <el-form-item label="c持仓量" prop="positionValue" style="margin-bottom: 3px">
          <el-input v-model="StrategyRunInfoForm.positionValue"/>
        </el-form-item>
        <el-form-item label="可用资金" prop="availableFund" style="margin-bottom: 3px">
          <el-input v-model="StrategyRunInfoForm.availableFund"/>
        </el-form-item>
        <el-form-item label="保证金币种" prop="marginCurrency" style="margin-bottom: 3px">
          <el-input v-model="StrategyRunInfoForm.marginCurrency" placeholder="保证金币种"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'QuantStrategyInfoName',
    data() {
      return {
        quantStrategyInfoLoading: true,
        quantStrategyInfoDialog: false,
        quantStrategyRunInfoDialog: false,
        quantStrategyInfoData: [],
        commodityTypeSelects: [],
        dicts: [],
        quantStrategyInfoForm: {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'strategyName': '',
          'accountNo': '',
          'status': '',
          'updateTime': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'createTime': ''
        },
        quantStrategyPLAddPosForm: {
          'id': '',
          'accountId': '',
          'strategyName': '',
          'accountNo': '',
          'updateTime': '',
          'exchange': '',
          'marketType': '',
          'contractNo': '',
          'createTime': '',
          'currencyNo': '',
          'product': '',
          'entrustDirect': '',
          'stopProfitPrice': '',
          'stopProfitPriceRatio': '',
          'maxEntrustAmt': '',
          'openPositionPrice': '',
          'stopAddPositionPrice': ''
        },
        StrategyRunInfoForm: {
          'lastPrice': '',
          'contractCode': '',
          'positionValue': '',
          'availableFund': '',
          'marginCurrency': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'strategyName': '',
          'accountNo': '',
          'status': '',
          'updateTime': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'createTime': ''
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
        this.quantStrategyInfoLoading = true;
        this.$http({
          url: '/quant/quantStrategyInfo/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyInfoData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.quantStrategyInfoLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.quantStrategyInfoForm = {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'strategyName': '',
          'accountNo': '',
          'status': '',
          'updateTime': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'createTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.quantStrategyInfoDialog = true;
      },
      doDetail: function(row, column) {
        if (this.$refs.quantStrategyInfoForm) {
          this.$refs.quantStrategyInfoForm.resetFields();
        }
        this.$http({
          url: '/quant/quantStrategyPLAddPos/findBy',
          method: 'get',
          params: {
            'id': column.strategyId
          }
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyPLAddPosForm= {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'strategyName': res.object.strategyName,
              'accountNo': res.object.accountNo,
              'updateTime': res.object.updateTime,
              'exchange': res.object.exchange,
              'marketType': res.object.marketType,
              'contractNo': res.object.contractNo,
              'createTime': res.object.createTime,
              'currencyNo': res.object.currencyNo,
              'product': res.object.product,
              'entrustDirect': res.object.entrustDirect,
              'stopProfitPrice': res.object.stopProfitPrice,
              'stopProfitPriceRatio': res.object.stopProfitPriceRatio,
              'maxEntrustAmt': res.object.maxEntrustAmt,
              'openPositionPrice': res.object.openPositionPrice,
              'stopAddPositionPrice': res.object.stopAddPositionPrice
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.quantStrategyInfoDialog = true;
      },
      doStatusDetail: function(row, column) {
        if (this.$refs.StrategyRunInfoForm) {
          this.$refs.StrategyRunInfoForm.resetFields();
        }
        this.$http({
          url: '/quant/quantStrategyInfo/getStatusInfo',
          method: 'post',
          params: {
            'id': column.strategyId
          }
        }).then(res => {
          if (res.code === 200) {
            this.StrategyRunInfoForm= {
              'lastPrice': res.object.lastPrice,
              'contractCode': res.object.contractCode,
              'positionValue': res.object.positionValue,
              'availableFund': res.object.availableFund,
              'marginCurrency': res.object.marginCurrency
            };
            this.quantStrategyRunInfoDialog = true;
          }else {
            this.$message.error(res.message || 'Has Error');
          }
        }).catch(error => {
          this.$message.error(error);
        });
      },
      doStatus: function(row, column) {
        this.$confirm('确认停用该策略, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: '/quant/quantStrategyInfo/updateStatus',
            method: 'post',
            data: {
              id: column.id,
            }
          }).then(res => {
            if (res.code === 200) {
              this.$message.success('已停用');
              this.doSearch();
            }
          }).catch(error => {
            console.log(error);
          });
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消'
          });
        });
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/quant/quantStrategyInfo/save',
              method: 'post',
              data: this.quantStrategyInfoForm
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
            this.quantStrategyInfoDialog = false;
          }
        });
      },
    }
  };
</script>

<style lang="scss" scoped>
  .quantStrategyInfoForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
