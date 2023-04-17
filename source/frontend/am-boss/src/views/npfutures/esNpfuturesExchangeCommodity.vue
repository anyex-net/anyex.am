<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所编码">
        <el-input v-model="searchForm.exchangeNo" clearable placeholder="请输入交易所编码"></el-input>
      </el-form-item>
      <el-form-item label="品种类型">
        <el-select v-model="searchForm.commodityType" clearable placeholder="请选择品种类型" value="">
          <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="品种编号">
        <el-input v-model="searchForm.commodityNo" clearable placeholder="请输入品种编号"></el-input>
      </el-form-item>
      <el-form-item label="品种名称">
        <el-input v-model="searchForm.commodityName" clearable placeholder="请输入品种名称"></el-input>
      </el-form-item>
      <el-form-item label="启用状态">
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
    <el-table v-loading="esNpfuturesExchangeCommodityLoading" :data="esNpfuturesExchangeCommodityData"
              style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeNo" label="交易所编码"/>
      <el-table-column prop="commodityType" label="品种类型" :formatter="statusFormat"/>
      <el-table-column prop="commodityNo" label="品种编号"/>
      <el-table-column prop="commodityName" label="品种名称"/>
      <el-table-column prop="commodityEngName" label="品种英文名称"/>
      <el-table-column prop="relateExchangeNo" label="关联品种交易所编码"/>
      <el-table-column prop="relateCommodityType" label="关联品种品种类型"/>
      <el-table-column prop="relateCommodityNo" label="关联品种品种编号"/>
      <el-table-column prop="relateExchangeNo2" label="关联品种2交易所编码"/>
      <el-table-column prop="relateCommodityType2" label="关联品种2品种类型"/>
      <el-table-column prop="relateCommodityNo2" label="关联品种2品种编号"/>
      <el-table-column prop="tradeCurrency" label="交易币种"/>
      <el-table-column prop="settleCurrency" label="结算币种"/>
      <el-table-column prop="contractSize" label="每手乘数"/>
      <el-table-column prop="marginCalculateMode" label="期货保证金方式" :formatter="statusFormat"/>
      <el-table-column prop="optionMarginCalculateMode" label="期权保证金公式"/>
      <el-table-column prop="openCloseMode" label="开平方式" :formatter="statusFormat"/>
      <el-table-column prop="strikePriceTimes" label="执行价格倍数"/>
      <el-table-column prop="isOnlyQuoteCommodity" label="单行情品种"/>
      <el-table-column prop="commodityTickSize" label="最小变动价位"/>
      <el-table-column prop="commodityDenominator" label="报价分母"/>
      <el-table-column prop="cmbDirect" label="组合方向" :formatter="statusFormat"/>
      <el-table-column prop="onlyCanCloseDays" label="只可平仓提前天数"/>
      <el-table-column prop="deliveryMode" label="交割行权方式" :formatter="statusFormat"/>
      <el-table-column prop="deliveryDays" label="交割日偏移"/>
      <el-table-column prop="addOneTime" label="T+1分割时间"/>
      <el-table-column prop="commodityTimeZone" label="品种时区"/>
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
    <el-dialog title="内盘期货交易所期货品种信息表管理" :visible.sync="esNpfuturesExchangeCommodityDialog" :close-on-click-modal="false"
               width="600">
      <el-form ref="esNpfuturesExchangeCommodityForm" :model="esNpfuturesExchangeCommodityForm"
               :rules="esNpfuturesExchangeCommodityRules" label-width="150px" class="esNpfuturesExchangeCommodityForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="交易所编码" prop="exchangeNo">
              <el-input v-model="esNpfuturesExchangeCommodityForm.exchangeNo" placeholder="请输入交易所编码"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种类型" prop="commodityType">
              <el-select v-model="esNpfuturesExchangeCommodityForm.commodityType" clearable placeholder="请选择品种类型" value="">
                <el-option v-for="data in commodityTypeSelects" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种编号" prop="commodityNo">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityNo" placeholder="请输入品种编号"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="品种名称" prop="commodityName">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityName" placeholder="请输入品种名称"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种英文名称" prop="commodityEngName">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityEngName" placeholder="请输入品种英文名称"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="关联品种交易所编码" prop="relateExchangeNo">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateExchangeNo" placeholder="请输入关联品种交易所编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="关联品种品种类型" prop="relateCommodityType">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateCommodityType" placeholder="请输入关联品种品种类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="关联品种品种编号" prop="relateCommodityNo">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateCommodityNo" placeholder="请输入关联品种品种编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="关联品种2交易所编码" prop="relateExchangeNo2">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateExchangeNo2" placeholder="请输入关联品种2交易所编码"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="关联品种2品种类型" prop="relateCommodityType2">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateCommodityType2" placeholder="请输入关联品种2品种类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="关联品种2品种编号" prop="relateCommodityNo2">
              <el-input v-model="esNpfuturesExchangeCommodityForm.relateCommodityNo2" placeholder="请输入关联品种2品种编号"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易币种" prop="tradeCurrency">
              <el-input v-model="esNpfuturesExchangeCommodityForm.tradeCurrency" placeholder="请输入交易币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="结算币种" prop="settleCurrency">
              <el-input v-model="esNpfuturesExchangeCommodityForm.settleCurrency" placeholder="请输入结算币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="每手乘数" prop="contractSize">
              <el-input v-model="esNpfuturesExchangeCommodityForm.contractSize" placeholder="请输入每手乘数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期货保证金方式" prop="marginCalculateMode">
              <el-select
                v-model="esNpfuturesExchangeCommodityForm.deliveryMode"
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
          <el-col :span="8">
            <el-form-item label="期权保证金公式" prop="optionMarginCalculateMode">
              <el-input v-model="esNpfuturesExchangeCommodityForm.optionMarginCalculateMode" placeholder="请输入期权保证金公式"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开平方式" prop="openCloseMode">
              <el-select
                  v-model="esNpfuturesExchangeCommodityForm.openCloseMode"
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
          <el-col :span="8">
            <el-form-item label="执行价格倍数" prop="strikePriceTimes">
              <el-input v-model="esNpfuturesExchangeCommodityForm.strikePriceTimes" placeholder="请输入执行价格倍数"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="单行情品种" prop="isOnlyQuoteCommodity">
              <el-input v-model="esNpfuturesExchangeCommodityForm.isOnlyQuoteCommodity" placeholder="请输入单行情品种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最小变动价位" prop="commodityTickSize">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityTickSize" placeholder="请输入最小变动价位"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="报价分母" prop="commodityDenominator">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityDenominator" placeholder="请输入报价分母"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"> <el-form-item label="组合方向" prop="cmbDirect">
            <el-select v-model="esNpfuturesExchangeCommodityForm.cmbDirect" clearable placeholder="请输入组合方向" value="">
              <el-option v-for="data in cmbDirectTypeSelects" :key="data.key" :label="data.value" :value="data.key">
              </el-option>
            </el-select>
          </el-form-item></el-col>
          <el-col :span="8"> <el-form-item label="只可平仓提前天数" prop="onlyCanCloseDays">
            <el-input v-model="esNpfuturesExchangeCommodityForm.onlyCanCloseDays" placeholder="请输入只可平仓提前天数"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交割行权方式" prop="deliveryMode">
              <el-select
                v-model="esNpfuturesExchangeCommodityForm.deliveryMode"
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
          <el-col :span="8"> <el-form-item label="交割日偏移" prop="deliveryDays">
            <el-input v-model="esNpfuturesExchangeCommodityForm.deliveryDays" placeholder="请输入交割日偏移"/>
          </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="T+1分割时间" prop="addOneTime">
              <el-input v-model="esNpfuturesExchangeCommodityForm.addOneTime" placeholder="请输入T+1分割时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="品种时区" prop="commodityTimeZone">
              <el-input v-model="esNpfuturesExchangeCommodityForm.commodityTimeZone" placeholder="请输入品种时区"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8"><el-form-item label="启用状态" prop="enableStatus">
            <el-select v-model="esNpfuturesExchangeCommodityForm.enableStatus" placeholder="请选择启用状态">
              <el-option key="enable" label="是" value="enable" />
              <el-option key="disable" label="否" value="disable" />
            </el-select>
          </el-form-item></el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item>
              <el-button type="success" @click="doSubmit('esNpfuturesExchangeCommodityForm')">提交</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'EsNpfuturesExchangeCommodityName',
    data() {
      return {
        esNpfuturesExchangeCommodityLoading: true,
        esNpfuturesExchangeCommodityDialog: false,
        esNpfuturesExchangeCommodityData: [],
        commodityTypeSelects: [],
        cmbDirectTypeSelects: [],
        deliveryModeTypeSelects: [],
        openCloseModeTypeSelects: [],
        marginCalculateModeSelects: [],
        dicts: [],
        esNpfuturesExchangeCommodityForm: {
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
          'tradeCurrency': '',
          'settleCurrency': '',
          'contractSize': '',
          'marginCalculateMode': '',
          'optionMarginCalculateMode': '',
          'openCloseMode': '',
          'strikePriceTimes': '',
          'isOnlyQuoteCommodity': '',
          'commodityTickSize': '',
          'commodityDenominator': '',
          'cmbDirect': '',
          'onlyCanCloseDays': '',
          'deliveryMode': '',
          'deliveryDays': '',
          'addOneTime': '',
          'commodityTimeZone': '',
          'enableStatus': ''
        },
        searchForm: {
          'exchangeNo': '',
          'commodityType': '',
          'commodityNo': '',
          'commodityName': '',
          'enableStatus': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        esNpfuturesExchangeCommodityRules: {
          exchangeNo: [
            { required: true, message: '交易所编码不可为空', trigger: 'change' }
          ],
          commodityType: [
            { required: true, message: '品种类型不可为空', trigger: 'change' }
          ],
          commodityNo: [
            { required: true, message: '品种编号不可为空', trigger: 'change' }
          ],
          commodityName: [
            { required: true, message: '品种名称不可为空', trigger: 'change' }
          ],
          commodityEngName: [
            { required: true, message: '品种英文名称不可为空', trigger: 'change' }
          ],
          tradeCurrency: [
            { required: true, message: '交易币种不可为空', trigger: 'change' }
          ],
          settleCurrency: [
            { required: true, message: '结算币种不可为空', trigger: 'change' }
          ],
          contractSize: [
            { required: true, message: '每手乘数不可为空', trigger: 'change' }
          ],
          marginCalculateMode: [
            { required: true, message: '期货保证金方式不可为空', trigger: 'change' }
          ],
          openCloseMode: [
            { required: true, message: '开平方式不可为空', trigger: 'change' }
          ],
          strikePriceTimes: [
            { required: true, message: '执行价格倍数不可为空', trigger: 'change' }
          ],
          isOnlyQuoteCommodity: [
            { required: true, message: '单行情品种不可为空', trigger: 'change' }
          ],
          commodityTickSize: [
            { required: true, message: '最小变动价位不可为空', trigger: 'change' }
          ],
          commodityDenominator: [
            { required: true, message: '报价分母不可为空', trigger: 'change' }
          ],
          cmbDirect: [
            { required: true, message: '组合方向不可为空', trigger: 'change' }
          ],
          onlyCanCloseDays: [
            { required: true, message: '只可平仓提前天数不可为空', trigger: 'change' }
          ],
          deliveryMode: [
            { required: true, message: '交割行权方式不可为空', trigger: 'change' }
          ],
          deliveryDays: [
            { required: true, message: '交割日偏移不可为空', trigger: 'change' }
          ],
          addOneTime: [
            { required: true, message: 'T+1分割时间不可为空', trigger: 'change' }
          ],
          commodityTimeZone: [
            { required: true, message: '品种时区不可为空', trigger: 'change' }
          ],
          enableStatus: [
            { required: true, message: '启用状态(启用enable、不启用disable)不可为空', trigger: 'change' }
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
          url: '/npfutures/dict/esNpfuturesExchangeCommodity',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object;
            this.commodityTypeSelects = res.object.commodityType;
            this.openCloseModeTypeSelects = res.object.openCloseMode;
            this.cmbDirectTypeSelects = res.object.cmbDirect;
            this.deliveryModeTypeSelects = res.object.deliveryMode;
            this.marginCalculateModeSelects = res.object.marginCalculateMode;
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
        this.esNpfuturesExchangeCommodityLoading = true;
        this.$http({
          url: '/npfutures/esNpfuturesExchangeCommodity/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeCommodityData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.esNpfuturesExchangeCommodityLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.esNpfuturesExchangeCommodityForm = {
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
          'tradeCurrency': '',
          'settleCurrency': '',
          'contractSize': '',
          'marginCalculateMode': '',
          'optionMarginCalculateMode': '',
          'openCloseMode': '',
          'strikePriceTimes': '',
          'isOnlyQuoteCommodity': '',
          'commodityTickSize': '',
          'commodityDenominator': '',
          'cmbDirect': '',
          'onlyCanCloseDays': '',
          'deliveryMode': '',
          'deliveryDays': '',
          'addOneTime': '',
          'commodityTimeZone': '',
          'enableStatus': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.esNpfuturesExchangeCommodityDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.esNpfuturesExchangeCommodityForm) {
          this.$refs.esNpfuturesExchangeCommodityForm.resetFields();
        }
        this.$http({
          url: '/npfutures/esNpfuturesExchangeCommodity/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.esNpfuturesExchangeCommodityForm = {
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
              'tradeCurrency': res.object.tradeCurrency,
              'settleCurrency': res.object.settleCurrency,
              'contractSize': res.object.contractSize,
              'marginCalculateMode': res.object.marginCalculateMode,
              'optionMarginCalculateMode': res.object.optionMarginCalculateMode,
              'openCloseMode': res.object.openCloseMode,
              'strikePriceTimes': res.object.strikePriceTimes,
              'isOnlyQuoteCommodity': res.object.isOnlyQuoteCommodity,
              'commodityTickSize': res.object.commodityTickSize,
              'commodityDenominator': res.object.commodityDenominator,
              'cmbDirect': res.object.cmbDirect,
              'onlyCanCloseDays': res.object.onlyCanCloseDays,
              'deliveryMode': res.object.deliveryMode,
              'deliveryDays': res.object.deliveryDays,
              'addOneTime': res.object.addOneTime,
              'commodityTimeZone': res.object.commodityTimeZone,
              'enableStatus': res.object.enableStatus
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.esNpfuturesExchangeCommodityDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/npfutures/esNpfuturesExchangeCommodity/save',
              method: 'post',
              data: this.esNpfuturesExchangeCommodityForm
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
            this.esNpfuturesExchangeCommodityDialog = false;
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
            url: '/npfutures/esNpfuturesExchangeCommodity/del',
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
  .esNpfuturesExchangeCommodityForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
