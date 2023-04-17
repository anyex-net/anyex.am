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
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="npfuturesInstrumentMarginRateLoading" :data="npfuturesInstrumentMarginRateData"
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
      <el-table-column prop="instrumentID" label="合约代码"/>
      <el-table-column prop="investorRange" label="投资者范围" :formatter="statusFormat"/>
      <el-table-column prop="hedgeFlag" label="投机套保标志" :formatter="statusFormat"/>
      <el-table-column prop="longMarginRatioByMoney" label="多头保证金率"/>
      <el-table-column prop="longMarginRatioByVolume" label="多头保证金费"/>
      <el-table-column prop="shortMarginRatioByMoney" label="空头保证金率"/>
      <el-table-column prop="shortMarginRatioByVolume" label="空头保证金费"/>
      <el-table-column prop="isRelative" label="是否相对交易所收取">
        <template scope="scope">
          <p v-if="scope.row.isRelative==0">否</p>
          <p v-if="scope.row.isRelative==1">是</p>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeID" label="交易所代码"/>
      <el-table-column prop="investUnitID" label="投资单元代码"/>
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
    <el-dialog title="期货合约保证金率" :visible.sync="npfuturesInstrumentMarginRateDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="npfuturesInstrumentMarginRateForm" :model="npfuturesInstrumentMarginRateForm"
               :rules="npfuturesInstrumentMarginRateRules" label-width="150px"
               class="npfuturesInstrumentMarginRateForm">
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="npfuturesInstrumentMarginRateForm.accountId" placeholder="请输入AM平台账户ID"/>
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="npfuturesInstrumentMarginRateForm.brokerID" placeholder="请输入经纪公司代码"/>
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="npfuturesInstrumentMarginRateForm.investorID" placeholder="请输入投资者帐号"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="instrumentID">
          <el-input v-model="npfuturesInstrumentMarginRateForm.instrumentID" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="投资者范围" prop="investorRange">
          <el-select v-model="npfuturesInstrumentMarginRateForm.investorRange" placeholder="请输入投资者范围">
            <el-option v-for="data in investorRange" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="投机套保标志" prop="hedgeFlag">
          <el-select v-model="npfuturesInstrumentMarginRateForm.hedgeFlag" placeholder="请输入投机套保标志">
            <el-option v-for="data in hedgeFlag" :key="data.key" :label="data.value" :value="data.key"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="多头保证金率" prop="longMarginRatioByMoney">
          <el-input v-model="npfuturesInstrumentMarginRateForm.longMarginRatioByMoney" placeholder="请输入多头保证金率"/>
        </el-form-item>
        <el-form-item label="多头保证金费" prop="longMarginRatioByVolume">
          <el-input v-model="npfuturesInstrumentMarginRateForm.longMarginRatioByVolume" placeholder="请输入多头保证金费"/>
        </el-form-item>
        <el-form-item label="空头保证金率" prop="shortMarginRatioByMoney">
          <el-input v-model="npfuturesInstrumentMarginRateForm.shortMarginRatioByMoney" placeholder="请输入空头保证金率"/>
        </el-form-item>
        <el-form-item label="空头保证金费" prop="shortMarginRatioByVolume">
          <el-input v-model="npfuturesInstrumentMarginRateForm.shortMarginRatioByVolume" placeholder="请输入空头保证金费"/>
        </el-form-item>
        <el-form-item label="是否相对交易所收取" prop="isRelative">
          <el-select v-model="npfuturesInstrumentMarginRateForm.isRelative" placeholder="请输入是否相对交易所收取">
            <el-option value="0" label="否"></el-option>
            <el-option value="1" label="是"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="npfuturesInstrumentMarginRateForm.exchangeID" placeholder="请输入交易所代码"/>
        </el-form-item>
        <el-form-item label="投资单元代码" prop="investUnitID">
          <el-input v-model="npfuturesInstrumentMarginRateForm.investUnitID" placeholder="请输入投资单元代码"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('npfuturesInstrumentMarginRateForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'NpfuturesInstrumentMarginRateName',
    data() {
      return {
        npfuturesInstrumentMarginRateLoading: true,
        npfuturesInstrumentMarginRateDialog: false,
        npfuturesInstrumentMarginRateData: [],
        investorRange: [],
        hedgeFlag: [],
        dicts: [],
        npfuturesInstrumentMarginRateForm: {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'investorID': '',
          'instrumentID': '',
          'investorRange': '',
          'hedgeFlag': '',
          'longMarginRatioByMoney': '',
          'longMarginRatioByVolume': '',
          'shortMarginRatioByMoney': '',
          'shortMarginRatioByVolume': '',
          'isRelative': '',
          'exchangeID': '',
          'investUnitID': ''
        },
        searchForm: {
          'accountId': '',
          'brokerID': '',
          'investorID': '',
          'instrumentID': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        npfuturesInstrumentMarginRateRules: {
          accountId: [
            { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
          ],
          brokerID: [
            { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
          ],
          investorID: [
            { required: true, message: '投资者帐号不可为空', trigger: 'change' }
          ],
          instrumentID: [
            { required: true, message: '合约代码不可为空', trigger: 'change' }
          ],
          investorRange: [
            { required: true, message: '投资者范围不可为空', trigger: 'change' }
          ],
          hedgeFlag: [
            { required: true, message: '投机套保标志不可为空', trigger: 'change' }
          ],
          longMarginRatioByMoney: [
            { required: true, message: '多头保证金率不可为空', trigger: 'change' }
          ],
          longMarginRatioByVolume: [
            { required: true, message: '多头保证金费不可为空', trigger: 'change' }
          ],
          shortMarginRatioByMoney: [
            { required: true, message: '空头保证金率不可为空', trigger: 'change' }
          ],
          shortMarginRatioByVolume: [
            { required: true, message: '空头保证金费不可为空', trigger: 'change' }
          ],
          isRelative: [
            { required: true, message: '是否相对交易所收取不可为空', trigger: 'change' }
          ],
          exchangeID: [
            { required: true, message: '交易所代码不可为空', trigger: 'change' }
          ],
          investUnitID: [
            { required: true, message: '投资单元代码不可为空', trigger: 'change' }
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
            this.investorRange = res.object.investorRange.list;
            this.hedgeFlag = res.object.hedgeFlag.list;
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
        this.npfuturesInstrumentMarginRateLoading = true;
        this.$http({
          url: '/npfutures/npfuturesInstrumentMarginRate/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.npfuturesInstrumentMarginRateData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.npfuturesInstrumentMarginRateLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.npfuturesInstrumentMarginRateForm = {
          'id': '',
          'accountId': '',
          'brokerID': '',
          'investorID': '',
          'instrumentID': '',
          'investorRange': '',
          'hedgeFlag': '',
          'longMarginRatioByMoney': '',
          'longMarginRatioByVolume': '',
          'shortMarginRatioByMoney': '',
          'shortMarginRatioByVolume': '',
          'isRelative': '',
          'exchangeID': '',
          'investUnitID': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.npfuturesInstrumentMarginRateDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.npfuturesInstrumentMarginRateForm) {
          this.$refs.npfuturesInstrumentMarginRateForm.resetFields();
        }
        this.$http({
          url: '/npfutures/npfuturesInstrumentMarginRate/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.npfuturesInstrumentMarginRateForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'brokerID': res.object.brokerID,
              'investorID': res.object.investorID,
              'instrumentID': res.object.instrumentID,
              'investorRange': res.object.investorRange,
              'hedgeFlag': res.object.hedgeFlag,
              'longMarginRatioByMoney': res.object.longMarginRatioByMoney,
              'longMarginRatioByVolume': res.object.longMarginRatioByVolume,
              'shortMarginRatioByMoney': res.object.shortMarginRatioByMoney,
              'shortMarginRatioByVolume': res.object.shortMarginRatioByVolume,
              'isRelative': res.object.isRelative.toString(),
              'exchangeID': res.object.exchangeID,
              'investUnitID': res.object.investUnitID
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.npfuturesInstrumentMarginRateDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/npfuturesInstrumentMarginRate/save',
              method: 'post',
              data: this.npfuturesInstrumentMarginRateForm
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
            this.npfuturesInstrumentMarginRateDialog = false;
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
            url: '/npfutures/npfuturesInstrumentMarginRate/del',
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
  .npfuturesInstrumentMarginRateForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
