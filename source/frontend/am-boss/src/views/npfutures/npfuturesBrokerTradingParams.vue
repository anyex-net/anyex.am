<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="经纪公司代码">
        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>
      </el-form-item>
      <el-form-item label="投资者帐号">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者帐号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="npfuturesBrokerTradingParamsLoading" :data="npfuturesBrokerTradingParamsData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="AM平台账户ID"/>
      <el-table-column prop="brokerID" label="经纪公司代码"/>
      <el-table-column prop="investorID" label="投资者帐号"/>
      <el-table-column prop="marginPriceType" label="保证金价格类型" :formatter="statusFormat"/>
      <el-table-column prop="algorithm" label="盈亏算法" :formatter="statusFormat"/>
      <el-table-column prop="availIncludeCloseProfit" label="可用是否包含平仓盈利">
        <template scope="scope">
          <p v-if="scope.row.availIncludeCloseProfit==0">否</p>
          <p v-if="scope.row.availIncludeCloseProfit==1">是</p>
        </template>
      </el-table-column>
      <el-table-column prop="currencyID" label="币种代码"/>
      <el-table-column prop="optionRoyaltyPriceType" label="期权权利金价格类型" :formatter="statusFormat"/>
      <el-table-column prop="accountNo" label="投资者帐号(对应AccountID)"/>
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
    <el-dialog title="期货经纪公司交易参数" :visible.sync="npfuturesBrokerTradingParamsDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="npfuturesBrokerTradingParamsForm" :model="npfuturesBrokerTradingParamsForm"
               :rules="npfuturesBrokerTradingParamsRules" label-width="150px" class="npfuturesBrokerTradingParamsForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="npfuturesBrokerTradingParamsForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="npfuturesBrokerTradingParamsForm.brokerID" placeholder="请输入经纪公司代码"/>
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="npfuturesBrokerTradingParamsForm.investorID" placeholder="请输入投资者帐号"/>
        </el-form-item>
        <el-form-item label="保证金价格类型" prop="marginPriceType">
          <el-select v-model="npfuturesBrokerTradingParamsForm.marginPriceType" placeholder="请输入保证金价格类型">
            <el-option v-for="data in marginPriceType" :key="data.key" :label="data.value"
                       :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="盈亏算法" prop="algorithm">
          <el-select v-model="npfuturesBrokerTradingParamsForm.algorithm" placeholder="请输入盈亏算法">
            <el-option v-for="data in algorithm" :key="data.key" :label="data.value"
                       :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="可用是否包含平仓盈利" prop="availIncludeCloseProfit">
          <el-select v-model="npfuturesBrokerTradingParamsForm.availIncludeCloseProfit" placeholder="请输入可用是否包含平仓盈利">
            <el-option value="0" label="否"></el-option>
            <el-option value="1" label="是"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="币种代码" prop="currencyID">
          <el-input v-model="npfuturesBrokerTradingParamsForm.currencyID" placeholder="请输入币种代码"/>
        </el-form-item>
        <el-form-item label="期权权利金价格类型" prop="optionRoyaltyPriceType">
          <el-select v-model="npfuturesBrokerTradingParamsForm.optionRoyaltyPriceType" placeholder="请输入期权权利金价格类型">
            <el-option v-for="data in optionRoyaltyPriceType" :key="data.key" :label="data.value"
                       :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="投资者帐号(对应AccountID)" prop="accountNo">
          <el-input v-model="npfuturesBrokerTradingParamsForm.accountNo" placeholder="请输入投资者帐号(对应AccountID)"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('npfuturesBrokerTradingParamsForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'NpfuturesBrokerTradingParamsName',
    data() {
      return {
        npfuturesBrokerTradingParamsLoading: true,
        npfuturesBrokerTradingParamsDialog: false,
        npfuturesBrokerTradingParamsData: [],
        marginPriceType: [],
        algorithm: [],
        optionRoyaltyPriceType: [],
        dicts: [],
        npfuturesBrokerTradingParamsForm: {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'investorID': '',
          'marginPriceType': '',
          'algorithm': '',
          'availIncludeCloseProfit': '',
          'currencyID': '',
          'optionRoyaltyPriceType': '',
          'accountNo': ''
        },
        searchForm: {
          'accountId': '',
          'brokerID': '',
          'investorID': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        npfuturesBrokerTradingParamsRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerID: [
            { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
          ],
          investorID: [
            { required: true, message: '投资者帐号不可为空', trigger: 'change' }
          ],
          marginPriceType: [
            { required: true, message: '保证金价格类型不可为空', trigger: 'change' }
          ],
          algorithm: [
            { required: true, message: '盈亏算法不可为空', trigger: 'change' }
          ],
          availIncludeCloseProfit: [
            { required: true, message: '可用是否包含平仓盈利不可为空', trigger: 'change' }
          ],
          currencyID: [
            { required: true, message: '币种代码不可为空', trigger: 'change' }
          ],
          optionRoyaltyPriceType: [
            { required: true, message: '期权权利金价格类型不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '投资者帐号(对应AccountID)不可为空', trigger: 'change' }
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
        const obj = this.dicts[p].list;
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
          url: '/npfutures/dict/npfuturesFee',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.marginPriceType = res.object.marginPriceType.list;
            this.algorithm = res.object.algorithm.list;
            this.optionRoyaltyPriceType = res.object.optionRoyaltyPriceType.list;
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
        this.npfuturesBrokerTradingParamsLoading = true;
        this.$http({
          url: '/npfutures/npfuturesBrokerTradingParams/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.npfuturesBrokerTradingParamsData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.npfuturesBrokerTradingParamsLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.npfuturesBrokerTradingParamsForm = {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'investorID': '',
          'marginPriceType': '',
          'algorithm': '',
          'availIncludeCloseProfit': '',
          'currencyID': '',
          'optionRoyaltyPriceType': '',
          'accountNo': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.npfuturesBrokerTradingParamsDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.npfuturesBrokerTradingParamsForm) {
          this.$refs.npfuturesBrokerTradingParamsForm.resetFields();
        }
        this.$http({
          url: '/npfutures/npfuturesBrokerTradingParams/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.npfuturesBrokerTradingParamsForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerID': res.object.brokerID,
              'investorID': res.object.investorID,
              'marginPriceType': res.object.marginPriceType,
              'algorithm': res.object.algorithm,
              'availIncludeCloseProfit': res.object.availIncludeCloseProfit,
              'currencyID': res.object.currencyID,
              'optionRoyaltyPriceType': res.object.optionRoyaltyPriceType,
              'accountNo': res.object.accountNo
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.npfuturesBrokerTradingParamsDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/npfuturesBrokerTradingParams/save',
              method: 'post',
              data: this.npfuturesBrokerTradingParamsForm
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
            this.npfuturesBrokerTradingParamsDialog = false;
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
            url: '/npfutures/npfuturesBrokerTradingParams/del',
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
  .npfuturesBrokerTradingParamsForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
