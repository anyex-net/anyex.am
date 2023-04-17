<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="合约代码">
        <el-input v-model="searchForm.instrumentID" clearable placeholder="请输入合约代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="合约名称">
        <el-input v-model="searchForm.instrumentName" clearable placeholder="请输入合约名称"></el-input>
      </el-form-item>
      <el-form-item label="合约在交易所的代码">
        <el-input v-model="searchForm.exchangeInstID" clearable placeholder="请输入合约在交易所的代码"></el-input>
      </el-form-item>
      <el-form-item label="产品代码">
        <el-input v-model="searchForm.productID" clearable placeholder="请输入产品代码"></el-input>
      </el-form-item>
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.productClass" clearable placeholder="请输入产品类型">
          <el-option v-for="data in productClass" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
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
    <el-table
      v-loading="npfuturesExchangeInstrumentLoading"
      :data="npfuturesExchangeInstrumentData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="instrumentID" label="合约代码" />
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="instrumentName" label="合约名称" />
      <el-table-column prop="exchangeInstID" label="合约在交易所的代码" />
      <el-table-column prop="productID" label="产品代码" />
      <el-table-column prop="productClass" label="产品类型" :formatter="statusFormat" />
      <el-table-column prop="deliveryYear" label="交割年份" />
      <el-table-column prop="deliveryMonth" label="交割月" />
      <el-table-column prop="maxMarketOrderVolume" label="市价单最大下单量" />
      <el-table-column prop="minMarketOrderVolume" label="市价单最小下单量" />
      <el-table-column prop="maxLimitOrderVolume" label="限价单最大下单量" />
      <el-table-column prop="minLimitOrderVolume" label="限价单最小下单量" />
      <el-table-column prop="volumeMultiple" label="合约数量乘数" />
      <el-table-column prop="priceTick" label="最小变动价位" />
      <el-table-column prop="createDate" label="创建日" />
      <el-table-column prop="openDate" label="上市日" />
      <el-table-column prop="expireDate" label="到期日" />
      <el-table-column prop="startDelivDate" label="开始交割日" />
      <el-table-column prop="endDelivDate" label="结束交割日" />
      <el-table-column prop="instLifePhase" label="合约生命周期状态" :formatter="statusFormat" />
      <el-table-column prop="isTrading" label="当前是否交易" />
      <el-table-column prop="positionType" label="持仓类型" :formatter="statusFormat" />
      <el-table-column prop="positionDateType" label="持仓日期类型" :formatter="statusFormat" />
      <el-table-column prop="longMarginRatio" label="多头保证金率" />
      <el-table-column prop="shortMarginRatio" label="空头保证金率" />
      <el-table-column prop="maxMarginSideAlgorithm" label="是否使用大额单边保证金算法" :formatter="statusFormat" />
      <el-table-column prop="underlyingInstrID" label="基础商品代码" />
      <el-table-column prop="strikePrice" label="执行价" />
      <el-table-column prop="optionsType" label="期权类型" :formatter="statusFormat" />
      <el-table-column prop="underlyingMultiple" label="合约基础商品乘数" />
      <el-table-column prop="combinationType" label="组合类型" :formatter="statusFormat" />
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
    <el-dialog
      title="内盘期货交易所期货合约表管理"
      :visible.sync="npfuturesExchangeInstrumentDialog"
      :close-on-click-modal="false"
      width="70%"
    >
      <el-form
        ref="npfuturesExchangeInstrumentForm"
        :model="npfuturesExchangeInstrumentForm"
        :rules="npfuturesExchangeInstrumentRules"
        label-width="150px"
        class="npfuturesExchangeInstrumentForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约代码" prop="instrumentID">
              <el-input v-model="npfuturesExchangeInstrumentForm.instrumentID" placeholder="请输入合约代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易所代码" prop="exchangeID">
              <el-input v-model="npfuturesExchangeInstrumentForm.exchangeID" placeholder="请输入交易所代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约名称" prop="instrumentName">
              <el-input v-model="npfuturesExchangeInstrumentForm.instrumentName" placeholder="请输入合约名称" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约在交易所的代码" prop="exchangeInstID">
              <el-input v-model="npfuturesExchangeInstrumentForm.exchangeInstID" placeholder="请输入合约在交易所的代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品代码" prop="productID">
              <el-input v-model="npfuturesExchangeInstrumentForm.productID" placeholder="请输入产品代码" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="productClass">
              <el-select v-model="npfuturesExchangeInstrumentForm.productClass" placeholder="请选择产品类型">
                <el-option v-for="data in productClass" :key="data.key" :label="data.value" :value="data.key" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="交割年份" prop="deliveryYear">
              <el-input v-model="npfuturesExchangeInstrumentForm.deliveryYear" placeholder="请输入交割年份" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交割月" prop="deliveryMonth">
              <el-input v-model="npfuturesExchangeInstrumentForm.deliveryMonth" placeholder="请输入交割月" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="市价单最大下单量" prop="maxMarketOrderVolume">
              <el-input v-model="npfuturesExchangeInstrumentForm.maxMarketOrderVolume" placeholder="请输入市价单最大下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="市价单最小下单量" prop="minMarketOrderVolume">
              <el-input v-model="npfuturesExchangeInstrumentForm.minMarketOrderVolume" placeholder="请输入市价单最小下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价单最大下单量" prop="maxLimitOrderVolume">
              <el-input v-model="npfuturesExchangeInstrumentForm.maxLimitOrderVolume" placeholder="请输入限价单最大下单量" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="限价单最小下单量" prop="minLimitOrderVolume">
              <el-input v-model="npfuturesExchangeInstrumentForm.minLimitOrderVolume" placeholder="请输入限价单最小下单量" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约数量乘数" prop="volumeMultiple">
              <el-input v-model="npfuturesExchangeInstrumentForm.volumeMultiple" placeholder="请输入合约数量乘数" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最小变动价位" prop="priceTick">
              <el-input v-model="npfuturesExchangeInstrumentForm.priceTick" placeholder="请输入最小变动价位" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="创建日" prop="createDate">
              <el-input v-model="npfuturesExchangeInstrumentForm.createDate" placeholder="请输入创建日" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="上市日" prop="openDate">
              <el-input v-model="npfuturesExchangeInstrumentForm.openDate" placeholder="请输入上市日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="到期日" prop="expireDate">
              <el-input v-model="npfuturesExchangeInstrumentForm.expireDate" placeholder="请输入到期日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开始交割日" prop="startDelivDate">
              <el-input v-model="npfuturesExchangeInstrumentForm.startDelivDate" placeholder="请输入开始交割日" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="结束交割日" prop="endDelivDate">
              <el-input v-model="npfuturesExchangeInstrumentForm.endDelivDate" placeholder="请输入结束交割日" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约生命周期状态" prop="instLifePhase">
              <el-select v-model="npfuturesExchangeInstrumentForm.instLifePhase" placeholder="请选择合约生命周期状态">
                <el-option v-for="data in instLifePhase" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当前是否交易" prop="isTrading">
              <el-input v-model="npfuturesExchangeInstrumentForm.isTrading" placeholder="请输入当前是否交易" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓类型" prop="positionType">
              <el-select v-model="npfuturesExchangeInstrumentForm.positionType" placeholder="请选择持仓类型">
                <el-option v-for="data in positionType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓日期类型" prop="positionDateType">
              <el-select v-model="npfuturesExchangeInstrumentForm.positionDateType" placeholder="请选择持仓日期类型">
                <el-option v-for="data in positionDateType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="多头保证金率" prop="longMarginRatio">
              <el-input v-model="npfuturesExchangeInstrumentForm.longMarginRatio" placeholder="请输入多头保证金率" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="空头保证金率" prop="shortMarginRatio">
              <el-input v-model="npfuturesExchangeInstrumentForm.shortMarginRatio" placeholder="请输入空头保证金率" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="是否使用大额单边保证金算法" prop="maxMarginSideAlgorithm">
              <el-select v-model="npfuturesExchangeInstrumentForm.maxMarginSideAlgorithm" placeholder="请选择是否使用大额单边保证金算法">
                <el-option v-for="data in maxMarginSideAlgorithm" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="基础商品代码" prop="underlyingInstrID">
              <el-input v-model="npfuturesExchangeInstrumentForm.underlyingInstrID" placeholder="请输入基础商品代码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="执行价" prop="strikePrice">
              <el-input v-model="npfuturesExchangeInstrumentForm.strikePrice" placeholder="请输入执行价" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权类型" prop="optionsType">
              <el-select v-model="npfuturesExchangeInstrumentForm.optionsType" placeholder="请输入期权类型">
                <el-option v-for="data in optionsType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约基础商品乘数" prop="underlyingMultiple">
              <el-input v-model="npfuturesExchangeInstrumentForm.underlyingMultiple" placeholder="请输入合约基础商品乘数" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="组合类型" prop="combinationType">
              <el-select v-model="npfuturesExchangeInstrumentForm.combinationType" placeholder="请输入组合类型">
                <el-option v-for="data in combinationType" :key="data.key" :label="data.value" :value="data.key"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="启用状态" prop="enableStatus">
              <el-select v-model="npfuturesExchangeInstrumentForm.enableStatus" placeholder="请选择启用状态">
                <el-option key="enable" label="是" value="enable" />
                <el-option key="disable" label="否" value="disable" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24" align="center">
            <el-form-item>
              <el-button type="success" @click="doSubmit('npfuturesExchangeInstrumentForm')">提交</el-button>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NpfuturesExchangeInstrumentName',
  data() {
    return {
      npfuturesExchangeInstrumentLoading: true,
      npfuturesExchangeInstrumentDialog: false,
      npfuturesExchangeInstrumentData: [],
      productClass: [],
      instLifePhase: [],
      positionType: [],
      positionDateType: [],
      maxMarginSideAlgorithm: [],
      optionsType: [],
      combinationType: [],
      dicts: [],
      npfuturesExchangeInstrumentForm: {
        'id': '',
        'instrumentID': '',
        'exchangeID': '',
        'instrumentName': '',
        'exchangeInstID': '',
        'productID': '',
        'productClass': '',
        'deliveryYear': '',
        'deliveryMonth': '',
        'maxMarketOrderVolume': '',
        'minMarketOrderVolume': '',
        'maxLimitOrderVolume': '',
        'minLimitOrderVolume': '',
        'volumeMultiple': '',
        'priceTick': '',
        'createDate': '',
        'openDate': '',
        'expireDate': '',
        'startDelivDate': '',
        'endDelivDate': '',
        'instLifePhase': '',
        'isTrading': '',
        'positionType': '',
        'positionDateType': '',
        'longMarginRatio': '',
        'shortMarginRatio': '',
        'maxMarginSideAlgorithm': '',
        'underlyingInstrID': '',
        'strikePrice': '',
        'optionsType': '',
        'underlyingMultiple': '',
        'combinationType': '',
        'enableStatus': ''
      },
      searchForm: {
        'instrumentID': '',
        'exchangeID': '',
        'instrumentName': '',
        'exchangeInstID': '',
        'productID': '',
        'productClass': '',
        'enableStatus': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      npfuturesExchangeInstrumentRules: {
        instrumentID: [
          { required: true, message: '合约代码不可为空', trigger: 'change' }
        ],
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        instrumentName: [
          { required: true, message: '合约名称不可为空', trigger: 'change' }
        ],
        exchangeInstID: [
          { required: true, message: '合约在交易所的代码不可为空', trigger: 'change' }
        ],
        productID: [
          { required: true, message: '产品代码不可为空', trigger: 'change' }
        ],
        productClass: [
          { required: true, message: '产品类型不可为空', trigger: 'change' }
        ],
        deliveryYear: [
          { required: true, message: '交割年份不可为空', trigger: 'change' }
        ],
        deliveryMonth: [
          { required: true, message: '交割月不可为空', trigger: 'change' }
        ],
        maxMarketOrderVolume: [
          { required: true, message: '市价单最大下单量不可为空', trigger: 'change' }
        ],
        minMarketOrderVolume: [
          { required: true, message: '市价单最小下单量不可为空', trigger: 'change' }
        ],
        maxLimitOrderVolume: [
          { required: true, message: '限价单最大下单量不可为空', trigger: 'change' }
        ],
        minLimitOrderVolume: [
          { required: true, message: '限价单最小下单量不可为空', trigger: 'change' }
        ],
        volumeMultiple: [
          { required: true, message: '合约数量乘数不可为空', trigger: 'change' }
        ],
        priceTick: [
          { required: true, message: '最小变动价位不可为空', trigger: 'change' }
        ],
        createDate: [
          { required: true, message: '创建日不可为空', trigger: 'change' }
        ],
        openDate: [
          { required: true, message: '上市日不可为空', trigger: 'change' }
        ],
        expireDate: [
          { required: true, message: '到期日不可为空', trigger: 'change' }
        ],
        /*
        startDelivDate: [
          { required: true, message: '开始交割日不可为空', trigger: 'change' }
        ],
        */
        endDelivDate: [
          { required: true, message: '结束交割日不可为空', trigger: 'change' }
        ],
        instLifePhase: [
          { required: true, message: '合约生命周期状态不可为空', trigger: 'change' }
        ],
        isTrading: [
          { required: true, message: '当前是否交易不可为空', trigger: 'change' }
        ],
        positionType: [
          { required: true, message: '持仓类型不可为空', trigger: 'change' }
        ],
        positionDateType: [
          { required: true, message: '持仓日期类型不可为空', trigger: 'change' }
        ],
        longMarginRatio: [
          { required: true, message: '多头保证金率不可为空', trigger: 'change' }
        ],
        shortMarginRatio: [
          { required: true, message: '空头保证金率不可为空', trigger: 'change' }
        ],
        maxMarginSideAlgorithm: [
          { required: true, message: '是否使用大额单边保证金算法不可为空', trigger: 'change' }
        ],
        strikePrice: [
          { required: true, message: '执行价不可为空', trigger: 'change' }
        ],
        underlyingMultiple: [
          { required: true, message: '合约基础商品乘数不可为空', trigger: 'change' }
        ],
        combinationType: [
          { required: true, message: '组合类型不可为空', trigger: 'change' }
        ],
        enableStatus: [
          { required: true, message: '启用状态不可为空', trigger: 'change' }
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
        url: '/npfutures/dict/npfuturesExchangeInstrument',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
          this.productClass = res.object.productClass.list;
          this.instLifePhase = res.object.instLifePhase.list;
          this.positionType = res.object.positionType.list;
          this.positionDateType = res.object.positionDateType.list;
          this.maxMarginSideAlgorithm = res.object.maxMarginSideAlgorithm.list;
          this.optionsType = res.object.optionsType.list;
          this.combinationType = res.object.combinationType.list;
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
      this.npfuturesExchangeInstrumentLoading = true;
      this.$http({
        url: '/npfutures/npfuturesExchangeInstrument/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeInstrumentData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.npfuturesExchangeInstrumentLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.npfuturesExchangeInstrumentForm = {
        'id': '',
        'instrumentID': '',
        'exchangeID': '',
        'instrumentName': '',
        'exchangeInstID': '',
        'productID': '',
        'productClass': '',
        'deliveryYear': '',
        'deliveryMonth': '',
        'maxMarketOrderVolume': '',
        'minMarketOrderVolume': '',
        'maxLimitOrderVolume': '',
        'minLimitOrderVolume': '',
        'volumeMultiple': '',
        'priceTick': '',
        'createDate': '',
        'openDate': '',
        'expireDate': '',
        'startDelivDate': '',
        'endDelivDate': '',
        'instLifePhase': '',
        'isTrading': '',
        'positionType': '',
        'positionDateType': '',
        'longMarginRatio': '',
        'shortMarginRatio': '',
        'maxMarginSideAlgorithm': '',
        'underlyingInstrID': '',
        'strikePrice': '',
        'optionsType': '',
        'underlyingMultiple': '',
        'combinationType': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.npfuturesExchangeInstrumentDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.npfuturesExchangeInstrumentForm) {
        this.$refs.npfuturesExchangeInstrumentForm.resetFields();
      }
      this.$http({
        url: '/npfutures/npfuturesExchangeInstrument/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.npfuturesExchangeInstrumentForm = {
            'id': res.object.id,
            'instrumentID': res.object.instrumentID,
            'exchangeID': res.object.exchangeID,
            'instrumentName': res.object.instrumentName,
            'exchangeInstID': res.object.exchangeInstID,
            'productID': res.object.productID,
            'productClass': res.object.productClass,
            'deliveryYear': res.object.deliveryYear,
            'deliveryMonth': res.object.deliveryMonth,
            'maxMarketOrderVolume': res.object.maxMarketOrderVolume,
            'minMarketOrderVolume': res.object.minMarketOrderVolume,
            'maxLimitOrderVolume': res.object.maxLimitOrderVolume,
            'minLimitOrderVolume': res.object.minLimitOrderVolume,
            'volumeMultiple': res.object.volumeMultiple,
            'priceTick': res.object.priceTick,
            'createDate': res.object.createDate,
            'openDate': res.object.openDate,
            'expireDate': res.object.expireDate,
            'startDelivDate': res.object.startDelivDate,
            'endDelivDate': res.object.endDelivDate,
            'instLifePhase': res.object.instLifePhase,
            'isTrading': res.object.isTrading,
            'positionType': res.object.positionType,
            'positionDateType': res.object.positionDateType,
            'longMarginRatio': res.object.longMarginRatio,
            'shortMarginRatio': res.object.shortMarginRatio,
            'maxMarginSideAlgorithm': res.object.maxMarginSideAlgorithm,
            'underlyingInstrID': res.object.underlyingInstrID,
            'strikePrice': res.object.strikePrice,
            'optionsType': res.object.optionsType,
            'underlyingMultiple': res.object.underlyingMultiple,
            'combinationType': res.object.combinationType,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.npfuturesExchangeInstrumentDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npfutures/npfuturesExchangeInstrument/save',
            method: 'post',
            data: this.npfuturesExchangeInstrumentForm
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
          this.npfuturesExchangeInstrumentDialog = false;
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
          url: '/npfutures/npfuturesExchangeInstrument/del',
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
  .npfuturesExchangeInstrumentForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
