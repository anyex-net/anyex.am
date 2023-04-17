<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码" prop="exchangeNo">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码" value="">
        </el-input>
      </el-form-item>
      <el-form-item label="品种类型" prop="commodityType">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码"></el-input>
      </el-form-item>
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.contractNo1" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="启用状态" prop="enableStatus">
        <el-select v-model="searchForm.enableStatus" placeholder="请选择启用状态">
          <el-option key="enable" label="是" value="enable" />
          <el-option key="disable" label="否" value="disable" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="wpfuturesExchangeContractLoading" :data="wpfuturesExchangeContractData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat" />
      <el-table-column prop="commodityNo" label="品种编号" />
      <el-table-column prop="contractNo1" label="合约代码1" />
      <el-table-column prop="strikePrice1" label="执行价1" />
      <el-table-column prop="callOrPutFlag1" label="看涨看跌标示1" :formatter="statusFormat" />
      <el-table-column prop="contractNo2" label="合约代码2" />
      <el-table-column prop="strikePrice2" label="执行价2" />
      <el-table-column prop="callOrPutFlag2" label="看涨看跌标示2" :formatter="statusFormat" />
      <el-table-column prop="contractType" label="合约类型" :formatter="statusFormat" />
      <el-table-column prop="quoteUnderlyingContract" label="行情真实合约" />
      <el-table-column prop="contractName" label="合约名称" />
      <el-table-column prop="contractExpDate" label="合约到期日" />
      <el-table-column prop="lastTradeDate" label="最后交易日" />
      <el-table-column prop="firstNoticeDate" label="首次通知日" />
      <el-table-column prop="enableStatus" label="启用状态">
        <template scope="scope">
          <p v-if="scope.row.enableStatus=='disable'">否</p>
          <p v-if="scope.row.enableStatus=='enable'">是</p>
        </template>
      </el-table-column>
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
    <el-dialog title="期货合约管理" :visible.sync="wpfuturesExchangeContractDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="wpfuturesExchangeContractForm"
        :model="wpfuturesExchangeContractForm"
        :rules="wpfuturesExchangeContractRules"
        label-width="150px"
        class="wpfuturesExchangeContractForm"
      >
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="wpfuturesExchangeContractForm.commodityType" clearable placeholder="请选择品种类型" value="">
                <el-option v-for="data in dicts.commodityType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="交易所编码" prop="exchangeNo">
              <el-input v-model="wpfuturesExchangeContractForm.exchangeNo" placeholder="请输入交易所编码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种编号" prop="commodityNo">
              <el-input v-model="wpfuturesExchangeContractForm.commodityNo" placeholder="请输入品种编号" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="合约代码1" prop="contractNo1">
              <el-input v-model="wpfuturesExchangeContractForm.contractNo1" placeholder="请输入合约代码1" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="执行价1" prop="strikePrice1">
              <el-input v-model="wpfuturesExchangeContractForm.strikePrice1" placeholder="请输入执行价1" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="看涨看跌标示1" prop="callOrPutFlag1">
              <el-select v-model="wpfuturesExchangeContractForm.callOrPutFlag1" clearable placeholder="请输入看涨看跌标示1" value="">
                <el-option v-for="data in dicts.callOrPutFlag1" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="合约代码2" prop="contractNo2">
              <el-input v-model="wpfuturesExchangeContractForm.contractNo2" placeholder="请输入合约代码2" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="执行价2" prop="strikePrice2">
              <el-input v-model="wpfuturesExchangeContractForm.strikePrice2" placeholder="请输入执行价2" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="看涨看跌标示2" prop="callOrPutFlag2">
              <el-select v-model="wpfuturesExchangeContractForm.callOrPutFlag2" clearable placeholder="请输入看涨看跌标示2" value="">
                <el-option v-for="data in dicts.callOrPutFlag2" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="合约类型" prop="contractType">
              <el-select v-model="wpfuturesExchangeContractForm.contractType" clearable placeholder="请输入合约类型" value="">
                <el-option v-for="data in dicts.contractType" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="行情真实合约" prop="quoteUnderlyingContract">
              <el-input v-model="wpfuturesExchangeContractForm.quoteUnderlyingContract" placeholder="请输入行情真实合约" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="合约名称" prop="contractName">
              <el-input v-model="wpfuturesExchangeContractForm.contractName" placeholder="请输入合约名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="合约到期日" prop="contractExpDate">
              <el-input v-model="wpfuturesExchangeContractForm.contractExpDate" placeholder="请输入合约到期日" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="最后交易日" prop="lastTradeDate">
              <el-input v-model="wpfuturesExchangeContractForm.lastTradeDate" placeholder="请输入最后交易日" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="首次通知日" prop="firstNoticeDate">
              <el-input v-model="wpfuturesExchangeContractForm.firstNoticeDate" placeholder="请输入首次通知日" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="启用状态" prop="enableStatus">
              <el-select v-model="wpfuturesExchangeContractForm.enableStatus" placeholder="请选择启用状态">
                <el-option key="enable" label="是" value="enable" />
                <el-option key="disable" label="否" value="disable" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=24 align="center">
              <el-button type="success" @click="doSubmit('wpfuturesExchangeContractForm')">提交</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'OtcDigitalCoinConfig',
  data() {
    return {
      wpfuturesExchangeContractLoading: true,
      wpfuturesExchangeContractDialog: false,
      wpfuturesExchangeContractData: [],
      commodityTypeSelects: [],
      dicts: [],
      wpfuturesExchangeContractForm: {
        'id': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo1': '',
        'strikePrice1': '',
        'callOrPutFlag1': '',
        'contractNo2': '',
        'strikePrice2': '',
        'callOrPutFlag2': '',
        'contractType': '',
        'quoteUnderlyingContract': '',
        'contractName': '',
        'contractExpDate': '',
        'lastTradeDate': '',
        'firstNoticeDate': '',
        'enableStatus': ''
      },
      searchForm: {
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo1': '',
        "enableStatus": ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpfuturesExchangeContractRules: {
        exchangeNo: [
          { required: true, message: '请输入交易所编码', trigger: 'change' }
        ],
        commodityType: [
          { required: true, message: '请输入品种类型', trigger: 'change' }
        ],
        commodityNo: [
          { required: true, message: '请输入品种编号', trigger: 'change' }
        ],
        contractNo1: [
          { required: true, message: '请输入合约代码1', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '请选择启用状态', trigger: 'change' }
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
        url: '/wpfutures/dict/WpfuturesExchangeContract',
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
      this.wpfuturesExchangeContractLoading = true;
      this.$http({
        url: '/wpfutures/WpfuturesExchangeContract/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeContractData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesExchangeContractLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpfuturesExchangeContractForm = {
        'id': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'contractNo1': '',
        'strikePrice1': '',
        'callOrPutFlag1': '',
        'contractNo2': '',
        'strikePrice2': '',
        'callOrPutFlag2': '',
        'contractType': '',
        'quoteUnderlyingContract': '',
        'contractName': '',
        'contractExpDate': '',
        'lastTradeDate': '',
        'firstNoticeDate': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpfuturesExchangeContractDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesExchangeContractForm) {
        this.$refs.wpfuturesExchangeContractForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/WpfuturesExchangeContract/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeContractForm = {
            'id': res.object.id,
            'exchangeNo': res.object.exchangeNo,
            'commodityType': res.object.commodityType,
            'commodityNo': res.object.commodityNo,
            'contractNo1': res.object.contractNo1,
            'strikePrice1': res.object.strikePrice1,
            'callOrPutFlag1': res.object.callOrPutFlag1,
            'contractNo2': res.object.contractNo2,
            'strikePrice2': res.object.strikePrice2,
            'callOrPutFlag2': res.object.callOrPutFlag2,
            'contractType': res.object.contractType,
            'quoteUnderlyingContract': res.object.quoteUnderlyingContract,
            'contractName': res.object.contractName,
            'contractExpDate': res.object.contractExpDate,
            'lastTradeDate': res.object.lastTradeDate,
            'firstNoticeDate': res.object.firstNoticeDate,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesExchangeContractDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/WpfuturesExchangeContract/save',
            method: 'post',
            data: this.wpfuturesExchangeContractForm
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
          this.wpfuturesExchangeContractDialog = false;
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
          url: '/wpfutures/WpfuturesExchangeContract/del',
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
.wpfuturesExchangeContractForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
