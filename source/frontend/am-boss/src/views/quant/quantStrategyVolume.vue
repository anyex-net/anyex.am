<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="账户id">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入账户id"></el-input>
      </el-form-item>
      <el-form-item label="策略类型">
        <el-input v-model="searchForm.strategyType" clearable placeholder="请输入策略类型"></el-input>
      </el-form-item>
      <el-form-item label="策略id">
        <el-input v-model="searchForm.strategyId" clearable placeholder="请输入策略id"></el-input>
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
    <el-table v-loading="quantStrategyVolumeLoading" :data="quantStrategyVolumeData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="accountId" label="账户id"/>
      <el-table-column prop="strategyType" label="策略类型"/>
      <el-table-column prop="strategyId" label="策略id"/>
      <el-table-column prop="accountNo" label="资金账号"/>
      <el-table-column prop="exchange" label="交易所"/>
      <el-table-column prop="marketType" label="市场类型">
        <template slot-scope="scope">
          <span v-if="scope.row.marketType==='wp'">外盘</span>
          <span v-if="scope.row.marketType==='np'">内盘</span>
          <span v-if="scope.row.marketType==='vcoin'">vcoin</span>
        </template>
      </el-table-column>
      <el-table-column prop="contractCode" label="合约代码"/>
      <el-table-column prop="volume" label="成交额"/>
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
    <el-dialog title="量化策略成交量统计" :visible.sync="quantStrategyVolumeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="quantStrategyVolumeForm" :model="quantStrategyVolumeForm" :rules="quantStrategyVolumeRules"
               label-width="150px" class="quantStrategyVolumeForm">
        <el-form-item label="账户id" prop="accountId">
          <el-input v-model="quantStrategyVolumeForm.accountId" placeholder="请输入账户id"/>
        </el-form-item>
        <el-form-item label="策略类型" prop="strategyType">
          <el-input v-model="quantStrategyVolumeForm.strategyType" placeholder="请输入策略类型"/>
        </el-form-item>
        <el-form-item label="策略id" prop="strategyId">
          <el-input v-model="quantStrategyVolumeForm.strategyId" placeholder="请输入策略id"/>
        </el-form-item>
        <el-form-item label="资金账号" prop="accountNo">
          <el-input v-model="quantStrategyVolumeForm.accountNo" placeholder="请输入资金账号"/>
        </el-form-item>
        <el-form-item label="交易所" prop="exchange">
          <el-input v-model="quantStrategyVolumeForm.exchange" placeholder="请输入交易所"/>
        </el-form-item>
        <el-form-item label="市场类型" prop="marketType">
          <el-input v-model="quantStrategyVolumeForm.marketType" placeholder="请输入市场类型"/>
        </el-form-item>
        <el-form-item label="合约代码" prop="contractCode">
          <el-input v-model="quantStrategyVolumeForm.contractCode" placeholder="请输入合约代码"/>
        </el-form-item>
        <el-form-item label="成交额" prop="volume">
          <el-input v-model="quantStrategyVolumeForm.volume" placeholder="请输入成交额"/>
        </el-form-item>
        <el-form-item label="记录创建时间" prop="createTime">
          <el-input v-model="quantStrategyVolumeForm.createTime" placeholder="请输入记录创建时间"/>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'QuantStrategyVolumeName',
    data() {
      return {
        quantStrategyVolumeLoading: true,
        quantStrategyVolumeDialog: false,
        quantStrategyVolumeData: [],
        commodityTypeSelects: [],
        dicts: [],
        quantStrategyVolumeForm: {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'accountNo': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'volume': '',
          'createTime': ''
        },
        searchForm: {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'accountNo': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'volume': '',
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
        quantStrategyVolumeRules: {
          accountId: [
            { required: true, message: '账户id不可为空', trigger: 'change' }
          ],
          strategyType: [
            { required: true, message: '策略类型不可为空', trigger: 'change' }
          ],
          strategyId: [
            { required: true, message: '策略id不可为空', trigger: 'change' }
          ],
          accountNo: [
            { required: true, message: '资金账号不可为空', trigger: 'change' }
          ],
          exchange: [
            { required: true, message: '交易所不可为空', trigger: 'change' }
          ],
          marketType: [
            { required: true, message: '市场类型(wp,np,vcoin)不可为空', trigger: 'change' }
          ],
          contractCode: [
            { required: true, message: '合约代码不可为空', trigger: 'change' }
          ],
          volume: [
            { required: true, message: '成交额不可为空', trigger: 'change' }
          ],
          createTime: [
            { required: true, message: '记录创建时间不可为空', trigger: 'change' }
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
        this.quantStrategyVolumeLoading = true;
        this.$http({
          url: '/quant/quantStrategyVolume/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyVolumeData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.quantStrategyVolumeLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.quantStrategyVolumeForm = {
          'id': '',
          'accountId': '',
          'strategyType': '',
          'strategyId': '',
          'accountNo': '',
          'exchange': '',
          'marketType': '',
          'contractCode': '',
          'volume': '',
          'createTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.quantStrategyVolumeDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.quantStrategyVolumeForm) {
          this.$refs.quantStrategyVolumeForm.resetFields();
        }
        this.$http({
          url: '/quant/quantStrategyVolume/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyVolumeForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'strategyType': res.object.strategyType,
              'strategyId': res.object.strategyId,
              'accountNo': res.object.accountNo,
              'exchange': res.object.exchange,
              'marketType': res.object.marketType,
              'contractCode': res.object.contractCode,
              'volume': res.object.volume,
              'createTime': res.object.createTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.quantStrategyVolumeDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/quant/quantStrategyVolume/save',
              method: 'post',
              data: this.quantStrategyVolumeForm
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
            this.quantStrategyVolumeDialog = false;
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
            url: '/quant/quantStrategyVolume/del',
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
  .quantStrategyVolumeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
