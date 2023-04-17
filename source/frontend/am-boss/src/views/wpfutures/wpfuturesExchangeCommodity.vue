<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="品种类型" prop="stockinfoId">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编码">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编码"></el-input>
      </el-form-item>
      <el-form-item label="品种名称">
        <el-input v-model="searchForm.commodityName" clearable placeholder="请输入品种名称"></el-input>
      </el-form-item>
      <el-form-item label="品种名称(英文)">
        <el-input v-model="searchForm.commodityEngName" clearable placeholder="请输入品种名称"></el-input>
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
    <el-table v-loading="wpfuturesExchangeCommodityLoading" :data="wpfuturesExchangeCommodityData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码" />
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat" />
      <el-table-column prop="commodityNo" label="品种编号" />
      <el-table-column prop="commodityName" label="品种名称" />
      <el-table-column prop="commodityEngName" label="品种英文名称" />
      <el-table-column prop="relateExchangeNo" label="关联交易所编码" />
      <el-table-column prop="relateCommodityType" label="关联品种类型" :formatter="statusFormat" />
      <el-table-column prop="relateCommodityNo" label="关联品种编号" />
      <el-table-column prop="relateExchangeNo2" label="关联交易所编码2" />
      <el-table-column prop="relateCommodityType2" label="关联品种类型2" :formatter="statusFormat" />
      <el-table-column prop="relateCommodityNo2" label="关联品种编号2" />
      <el-table-column prop="currencyGroupNo" label="currencyGroupNo" />
      <el-table-column prop="tradeCurrency" label="交易币种" />
      <el-table-column prop="contractSize" label="每手乘数" />
      <el-table-column prop="openCloseMode" label="开平方式" :formatter="statusFormat" />
      <el-table-column prop="strikePriceTimes" label="执行价格倍数" />
      <el-table-column prop="commodityTickSize" label="最小变动价位" />
      <el-table-column prop="commodityDenominator" label="报价分母" />
      <el-table-column prop="cmbDirect" label="组合方向" :formatter="statusFormat" />
      <el-table-column prop="deliveryMode" label="交割行权方式" :formatter="statusFormat" />
      <el-table-column prop="deliveryDays" label="交割日偏移" />
      <el-table-column prop="addOneTime" label="T+1分割时间" />
      <el-table-column prop="commodityTimeZone" label="品种时区" />
      <el-table-column prop="isAddOne" label="是否处于T+1时段" :formatter="statusFormat" />
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
    <el-dialog title="期货品种管理" :visible.sync="wpfuturesExchangeCommodityDialog" :close-on-click-modal="false" width="800">
      <el-form ref="wpfuturesExchangeCommodityForm" :model="wpfuturesExchangeCommodityForm" :rules="wpfuturesExchangeCommodityRules" label-width="150px" class="wpfuturesExchangeCommodityForm">
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="wpfuturesExchangeCommodityForm.commodityType" clearable placeholder="请选择品种类型" value="">
                <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="交易所编码" prop="exchangeNo">
              <el-input v-model="wpfuturesExchangeCommodityForm.exchangeNo" placeholder="请输入交易所编码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种编号" prop="commodityNo">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityNo" placeholder="请输入品种编号" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="品种名称" prop="commodityName">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityName" placeholder="请输入品种名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种英文名称" prop="commodityEngName">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityEngName" placeholder="请输入品种英文名称" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="关联交易所编码" prop="relateExchangeNo">
              <el-input v-model="wpfuturesExchangeCommodityForm.relateExchangeNo" placeholder="请输入关联交易所编码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="关联品种类型" prop="relateCommodityType">
              <el-select
                v-model="wpfuturesExchangeCommodityForm.relateCommodityType"
                clearable
                placeholder="请输入关联品种类型"
                value=""
              >
                <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="关联品种编号" prop="relateCommodityNo">
              <el-input v-model="wpfuturesExchangeCommodityForm.relateCommodityNo" placeholder="请输入关联品种编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="关联交易所编码2" prop="relateExchangeNo2">
              <el-input v-model="wpfuturesExchangeCommodityForm.relateExchangeNo2" placeholder="请输入关联交易所编码2" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="关联品种类型2" prop="relateCommodityType2">
              <el-select
                v-model="wpfuturesExchangeCommodityForm.relateCommodityType2"
                clearable
                placeholder="请输入关联品种类型2"
                value=""
              >
                <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="关联品种编号2" prop="relateCommodityNo2">
              <el-input v-model="wpfuturesExchangeCommodityForm.relateCommodityNo2" placeholder="请输入关联品种编号" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="currencyGroupNo" prop="currencyGroupNo">
              <el-input v-model="wpfuturesExchangeCommodityForm.currencyGroupNo" placeholder="请输入currencyGroupNo" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="交易币种" prop="tradeCurrency">
              <el-input v-model="wpfuturesExchangeCommodityForm.tradeCurrency" placeholder="请输入交易币种" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="每手乘数" prop="contractSize">
              <el-input v-model="wpfuturesExchangeCommodityForm.contractSize" placeholder="请输入每手乘数" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="开平方式" prop="openCloseMode">
              <el-select
                v-model="wpfuturesExchangeCommodityForm.openCloseMode"
                clearable
                placeholder="请输入开平方式"
                value=""
              >
                <el-option
                  v-for="data in openCloseModeTypeSelects"
                  :key="data.key"
                  :label="data.value"
                  :value="data.key"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="执行价格倍数" prop="strikePriceTimes">
              <el-input v-model="wpfuturesExchangeCommodityForm.strikePriceTimes" placeholder="请输入执行价格倍数" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="最小变动价位" prop="commodityTickSize">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityTickSize" placeholder="请输入最小变动价位" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="报价分母" prop="commodityDenominator">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityDenominator" placeholder="请输入报价分母" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="组合方向" prop="cmbDirect">
              <el-select v-model="wpfuturesExchangeCommodityForm.cmbDirect" clearable placeholder="请输入组合方向" value="">
                <el-option v-for="data in cmbDirectTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="交割行权方式" prop="deliveryMode">
              <el-select
                v-model="wpfuturesExchangeCommodityForm.deliveryMode"
                clearable
                placeholder="请输入交割行权方式"
                value=""
              >
                <el-option
                  v-for="data in deliveryModeTypeSelects"
                  :key="data.key"
                  :label="data.value"
                  :value="data.key"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="交割日偏移" prop="deliveryDays">
              <el-input v-model="wpfuturesExchangeCommodityForm.deliveryDays" placeholder="请输入交割日偏移" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="T+1分割时间" prop="addOneTime">
              <el-input v-model="wpfuturesExchangeCommodityForm.addOneTime" placeholder="请输入T+1分割时间" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=12>
            <el-form-item label="品种时区" prop="commodityTimeZone">
              <el-input v-model="wpfuturesExchangeCommodityForm.commodityTimeZone" placeholder="请输入品种时区" />
            </el-form-item>
          </el-col>
          <el-col :span=12>
            <el-form-item label="是否处于T+1时段" prop="isAddOne">
              <el-select
                v-model="wpfuturesExchangeCommodityForm.isAddOne"
                clearable
                placeholder="请输入是否处于T+1时段"
                value=""
              >
                <el-option v-for="data in yesOrNoTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col>
            <el-form-item label="启用状态" prop="enableStatus">
              <el-select v-model="wpfuturesExchangeCommodityForm.enableStatus" placeholder="请选择启用状态">
                <el-option key="enable" label="是" value="enable" />
                <el-option key="disable" label="否" value="disable" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span=24 align="center">
              <el-button type="success" @click="doSubmit('wpfuturesExchangeCommodityForm')">提交</el-button>
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
      wpfuturesExchangeCommodityLoading: true,
      wpfuturesExchangeCommodityDialog: false,
      wpfuturesExchangeCommodityData: [],
      commodityTypeSelects: [],
      dicts: [],
      openCloseModeTypeSelects: [],
      cmbDirectTypeSelects: [],
      deliveryModeTypeSelects: [],
      yesOrNoTypeSelects: [],
      wpfuturesExchangeCommodityForm: {
        'id': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'commodityName': '',
        'commodityEngName': '',
        'relateExchangeNo': '',
        'relateCommodityType': '',
        'relateCommodityNo': '',
        'relateExchangeNo2': '',
        'relateCommodityType2': '',
        'relateCommodityNo2': '',
        'currencyGroupNo': '',
        'tradeCurrency': '',
        'contractSize': '',
        'openCloseMode': '',
        'strikePriceTimes': '',
        'commodityTickSize': '',
        'commodityDenominator': '',
        'cmbDirect': '',
        'deliveryMode': '',
        'deliveryDays': '',
        'addOneTime': '',
        'commodityTimeZone': '',
        'isAddOne': '',
        'enableStatus': ''
      },
      searchForm: {
        'commodityType': '',
        'commodityNo': '',
        'commodityName': '',
        'commodityEngName': '',
        'enableStatus': '',
        'sort': 'id',
        'order': 'asc'
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      wpfuturesExchangeCommodityRules: {
        id: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        exchangeNo: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityType: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityNo: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityName: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityEngName: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        currencyGroupNo: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        tradeCurrency: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        contractSize: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        openCloseMode: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        strikePriceTimes: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityTickSize: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityDenominator: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        deliveryDays: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        commodityTimeZone: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        isAddOne: [
          { required: true, message: '不可为空', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '不可为空', trigger: 'change' }
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
      if (p === 'relateCommodityType' || p === 'relateCommodityType2') {
        p = 'commodityType';
      }
      if (p === 'isAddOne') {
        p = 'yesOrNoType';
      }
      if (p === 'openCloseMode') {
        p = 'openCloseModeType';
      }
      if (p === 'cmbDirect') {
        p = 'cmbDirectType';
      }
      if (p === 'deliveryMode') {
        p = 'deliveryModeType';
      }
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
        url: '/wpfutures/dict/WpfuturesExchangeCommodity',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          this.commodityTypeSelects = res.object.commodityType;
          this.openCloseModeTypeSelects = res.object.openCloseModeType;
          this.cmbDirectTypeSelects = res.object.cmbDirectType;
          this.deliveryModeTypeSelects = res.object.deliveryModeType;
          this.yesOrNoTypeSelects = res.object.yesOrNoType;
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
      this.wpfuturesExchangeCommodityLoading = true;
      this.$http({
        url: '/wpfutures/WpfuturesExchangeCommodity/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeCommodityData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.wpfuturesExchangeCommodityLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.wpfuturesExchangeCommodityForm = {
        'id': '',
        'exchangeNo': '',
        'commodityType': '',
        'commodityNo': '',
        'commodityName': '',
        'commodityEngName': '',
        'relateExchangeNo': '',
        'relateCommodityType': '',
        'relateCommodityNo': '',
        'relateExchangeNo2': '',
        'relateCommodityType2': '',
        'relateCommodityNo2': '',
        'currencyGroupNo': '',
        'tradeCurrency': '',
        'contractSize': '',
        'openCloseMode': '',
        'strikePriceTimes': '',
        'commodityTickSize': '',
        'commodityDenominator': '',
        'cmbDirect': '',
        'deliveryMode': '',
        'deliveryDays': '',
        'addOneTime': '',
        'commodityTimeZone': '',
        'isAddOne': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.wpfuturesExchangeCommodityDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesExchangeCommodityForm) {
        this.$refs.wpfuturesExchangeCommodityForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/WpfuturesExchangeCommodity/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesExchangeCommodityForm = {
            'id': res.object.id,
            'exchangeNo': res.object.exchangeNo,
            'commodityType': res.object.commodityType,
            'commodityNo': res.object.commodityNo,
            'commodityName': res.object.commodityName,
            'commodityEngName': res.object.commodityEngName,
            'relateExchangeNo': res.object.relateExchangeNo,
            'relateCommodityType': res.object.relateCommodityType,
            'relateCommodityNo': res.object.relateCommodityNo,
            'relateExchangeNo2': res.object.relateExchangeNo2,
            'relateCommodityType2': res.object.relateCommodityType2,
            'relateCommodityNo2': res.object.relateCommodityNo2,
            'currencyGroupNo': res.object.currencyGroupNo,
            'tradeCurrency': res.object.tradeCurrency,
            'contractSize': res.object.contractSize,
            'openCloseMode': res.object.openCloseMode,
            'strikePriceTimes': res.object.strikePriceTimes,
            'commodityTickSize': res.object.commodityTickSize,
            'commodityDenominator': res.object.commodityDenominator,
            'cmbDirect': res.object.cmbDirect,
            'deliveryMode': res.object.deliveryMode,
            'deliveryDays': res.object.deliveryDays,
            'addOneTime': res.object.addOneTime,
            'commodityTimeZone': res.object.commodityTimeZone,
            'isAddOne': res.object.isAddOne,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesExchangeCommodityDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/WpfuturesExchangeCommodity/save',
            method: 'post',
            data: this.wpfuturesExchangeCommodityForm
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
          this.wpfuturesExchangeCommodityDialog = false;
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
          url: '/wpfutures/WpfuturesExchangeCommodity/del',
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
.wpfuturesExchangeCommodityForm {
  /deep/ .el-select {
    width: 100%;
  }
}
</style>
