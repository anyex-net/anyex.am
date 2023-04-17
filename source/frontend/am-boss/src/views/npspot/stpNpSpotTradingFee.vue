<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所代码">
        <el-select v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码">
          <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="产品代码">
        <el-select v-model="searchForm.productID" clearable placeholder="请输入产品代码">
          <el-option v-for="data in dicts['productID']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="证券类别代码">
        <el-select v-model="searchForm.securityType" clearable placeholder="请输入证券类别代码">
          <el-option v-for="data in dicts['securityType']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="证券代码">
        <el-input v-model="searchForm.securityID" clearable placeholder="请输入证券代码"></el-input>
      </el-form-item>
      <el-form-item label="业务类别">
        <el-select v-model="searchForm.bizClass" clearable placeholder="请输入业务类别">
          <el-option v-for="data in dicts['bizClass']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="stpNpSpotTradingFeeLoading" :data="stpNpSpotTradingFeeData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="80">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查询</el-button>
<!--          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>-->
        </template>
      </el-table-column>
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="productID" label="产品代码" :formatter="statusFormat"/>
      <el-table-column prop="securityType" label="证券类别代码" :formatter="statusFormat"/>
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="bizClass" label="业务类别" :formatter="statusFormat"/>
      <el-table-column prop="stampTaxRatioByAmt" label="印花税(港股印花税)按金额收取比例" />
      <el-table-column prop="stampTaxRatioByPar" label="印花税(港股印花税)按面值收取比例" />
      <el-table-column prop="stampTaxFeePerOrder" label="印花税(港股印花税,单位港币)按笔收取金额" />
      <el-table-column prop="stampTaxFeeByVolume" label="印花税(港股印花税,单位港币)按数量收取金额" />
      <el-table-column prop="stampTaxFeeMin" label="印花税(港股印花税,单位港币)最低收取金额" />
      <el-table-column prop="stampTaxFeeMax" label="印花税(港股印花税,单位港币)最高收取金额" />
      <el-table-column prop="transferRatioByAmt" label="过户费(港股证券组合费)按金额收取比例" />
      <el-table-column prop="transferRatioByPar" label="过户费(港股证券组合费)按面值收取比例" />
      <el-table-column prop="transferFeePerOrder" label="过户费(港股证券组合费,单位港币)按笔收取金额" />
      <el-table-column prop="transferFeeByVolume" label="过户费(港股证券组合费,单位港币)按数量收取金额" />
      <el-table-column prop="transferFeeMin" label="过户费(港股证券组合费,单位港币)最低收取金额" />
      <el-table-column prop="transferFeeMax" label="过户费(港股证券组合费,单位港币)最高收取金额" />
      <el-table-column prop="handlingRatioByAmt" label="经手费(港股交易费)按金额收取比例" />
      <el-table-column prop="handlingRatioByPar" label="经手费(港股交易费)按面值收取比例" />
      <el-table-column prop="handlingFeePerOrder" label="经手费(港股交易费,单位港币)按笔收取金额" />
      <el-table-column prop="handlingFeeByVolume" label="经手费(港股交易费,单位港币)按数量收取金额" />
      <el-table-column prop="handlingFeeMin" label="经手费(港股交易费,单位港币)最低收取金额" />
      <el-table-column prop="handlingFeeMax" label="经手费(港股交易费,单位港币)最高收取金额" />
      <el-table-column prop="regulateRatioByAmt" label="证管费(港股交易征费)按金额收取比例" />
      <el-table-column prop="regulateRatioByPar" label="证管费(港股交易征费)按面值收取比例" />
      <el-table-column prop="regulateFeePerOrder" label="证管费(港股交易征费,单位港币)按笔收取金额" />
      <el-table-column prop="regulateFeeByVolume" label="证管费(港股交易征费,单位港币)按数量收取金额" />
      <el-table-column prop="regulateFeeMin" label="证管费(港股交易征费,单位港币)最低收取金额" />
      <el-table-column prop="regulateFeeMax" label="证管费(港股交易征费,单位港币)最高收取金额" />
      <el-table-column prop="settlementRatioByAmt" label="结算费(港股股份交收费)按金额收取比例" />
      <el-table-column prop="settlementRatioByPar" label="结算费(港股股份交收费)按面值收取比例" />
      <el-table-column prop="settlementFeePerOrder" label="结算费(港股股份交收费,单位港币)按笔收取金额" />
      <el-table-column prop="settlementFeeByVolume" label="结算费(港股股份交收费,单位港币)按数量收取金额" />
      <el-table-column prop="settlementFeeMin" label="结算费(港股股份交收费,单位港币)最低收取金额" />
      <el-table-column prop="settlementFeeMax" label="结算费(港股股份交收费,单位港币)最高收取金额" />
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
    <el-dialog title="内盘现货基础交易费率表管理" :visible.sync="stpNpSpotTradingFeeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="stpNpSpotTradingFeeForm" :model="stpNpSpotTradingFeeForm" :rules="stpNpSpotTradingFeeRules" label-width="250px" class="stpNpSpotTradingFeeForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="stpNpSpotTradingFeeForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-select v-model="stpNpSpotTradingFeeForm.exchangeID" clearable placeholder="请输入交易所代码">
            <el-option v-for="data in dicts['exchangeID']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="产品代码" prop="productID">
          <el-select v-model="stpNpSpotTradingFeeForm.productID" clearable placeholder="请输入产品代码">
            <el-option v-for="data in dicts['productID']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="证券类别代码" prop="securityType">
          <el-select v-model="stpNpSpotTradingFeeForm.securityType" clearable placeholder="请输入证券类别代码">
            <el-option v-for="data in dicts['securityType']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="stpNpSpotTradingFeeForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="业务类别" prop="bizClass">
          <el-select v-model="stpNpSpotTradingFeeForm.bizClass" clearable placeholder="请输入业务类别">
            <el-option v-for="data in dicts['bizClass']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item label="印花税(港股印花税)按金额收取比例" prop="stampTaxRatioByAmt">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxRatioByAmt" placeholder="请输入印花税(港股印花税)按金额收取比例" />
        </el-form-item>
        <el-form-item label="印花税(港股印花税)按面值收取比例" prop="stampTaxRatioByPar">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxRatioByPar" placeholder="请输入印花税(港股印花税)按面值收取比例" />
        </el-form-item>
        <el-form-item label="印花税(港股印花税,单位港币)按笔收取金额" prop="stampTaxFeePerOrder">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxFeePerOrder" placeholder="请输入印花税(港股印花税,单位港币)按笔收取金额" />
        </el-form-item>
        <el-form-item label="印花税(港股印花税,单位港币)按数量收取金额" prop="stampTaxFeeByVolume">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxFeeByVolume" placeholder="请输入印花税(港股印花税,单位港币)按数量收取金额" />
        </el-form-item>
        <el-form-item label="印花税(港股印花税,单位港币)最低收取金额" prop="stampTaxFeeMin">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxFeeMin" placeholder="请输入印花税(港股印花税,单位港币)最低收取金额" />
        </el-form-item>
        <el-form-item label="印花税(港股印花税,单位港币)最高收取金额" prop="stampTaxFeeMax">
          <el-input v-model="stpNpSpotTradingFeeForm.stampTaxFeeMax" placeholder="请输入印花税(港股印花税,单位港币)最高收取金额" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费)按金额收取比例" prop="transferRatioByAmt">
          <el-input v-model="stpNpSpotTradingFeeForm.transferRatioByAmt" placeholder="请输入过户费(港股证券组合费)按金额收取比例" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费)按面值收取比例" prop="transferRatioByPar">
          <el-input v-model="stpNpSpotTradingFeeForm.transferRatioByPar" placeholder="请输入过户费(港股证券组合费)按面值收取比例" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费,单位港币)按笔收取金额" prop="transferFeePerOrder">
          <el-input v-model="stpNpSpotTradingFeeForm.transferFeePerOrder" placeholder="请输入过户费(港股证券组合费,单位港币)按笔收取金额" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费,单位港币)按数量收取金额" prop="transferFeeByVolume">
          <el-input v-model="stpNpSpotTradingFeeForm.transferFeeByVolume" placeholder="请输入过户费(港股证券组合费,单位港币)按数量收取金额" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费,单位港币)最低收取金额" prop="transferFeeMin">
          <el-input v-model="stpNpSpotTradingFeeForm.transferFeeMin" placeholder="请输入过户费(港股证券组合费,单位港币)最低收取金额" />
        </el-form-item>
        <el-form-item label="过户费(港股证券组合费,单位港币)最高收取金额" prop="transferFeeMax">
          <el-input v-model="stpNpSpotTradingFeeForm.transferFeeMax" placeholder="请输入过户费(港股证券组合费,单位港币)最高收取金额" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费)按金额收取比例" prop="handlingRatioByAmt">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingRatioByAmt" placeholder="请输入经手费(港股交易费)按金额收取比例" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费)按面值收取比例" prop="handlingRatioByPar">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingRatioByPar" placeholder="请输入经手费(港股交易费)按面值收取比例" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费,单位港币)按笔收取金额" prop="handlingFeePerOrder">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingFeePerOrder" placeholder="请输入经手费(港股交易费,单位港币)按笔收取金额" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费,单位港币)按数量收取金额" prop="handlingFeeByVolume">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingFeeByVolume" placeholder="请输入经手费(港股交易费,单位港币)按数量收取金额" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费,单位港币)最低收取金额" prop="handlingFeeMin">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingFeeMin" placeholder="请输入经手费(港股交易费,单位港币)最低收取金额" />
        </el-form-item>
        <el-form-item label="经手费(港股交易费,单位港币)最高收取金额" prop="handlingFeeMax">
          <el-input v-model="stpNpSpotTradingFeeForm.handlingFeeMax" placeholder="请输入经手费(港股交易费,单位港币)最高收取金额" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费)按金额收取比例" prop="regulateRatioByAmt">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateRatioByAmt" placeholder="请输入证管费(港股交易征费)按金额收取比例" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费)按面值收取比例" prop="regulateRatioByPar">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateRatioByPar" placeholder="请输入证管费(港股交易征费)按面值收取比例" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费,单位港币)按笔收取金额" prop="regulateFeePerOrder">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateFeePerOrder" placeholder="请输入证管费(港股交易征费,单位港币)按笔收取金额" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费,单位港币)按数量收取金额" prop="regulateFeeByVolume">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateFeeByVolume" placeholder="请输入证管费(港股交易征费,单位港币)按数量收取金额" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费,单位港币)最低收取金额" prop="regulateFeeMin">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateFeeMin" placeholder="请输入证管费(港股交易征费,单位港币)最低收取金额" />
        </el-form-item>
        <el-form-item label="证管费(港股交易征费,单位港币)最高收取金额" prop="regulateFeeMax">
          <el-input v-model="stpNpSpotTradingFeeForm.regulateFeeMax" placeholder="请输入证管费(港股交易征费,单位港币)最高收取金额" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费)按金额收取比例" prop="settlementRatioByAmt">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementRatioByAmt" placeholder="请输入结算费(港股股份交收费)按金额收取比例" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费)按面值收取比例" prop="settlementRatioByPar">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementRatioByPar" placeholder="请输入结算费(港股股份交收费)按面值收取比例" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费,单位港币)按笔收取金额" prop="settlementFeePerOrder">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementFeePerOrder" placeholder="请输入结算费(港股股份交收费,单位港币)按笔收取金额" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费,单位港币)按数量收取金额" prop="settlementFeeByVolume">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementFeeByVolume" placeholder="请输入结算费(港股股份交收费,单位港币)按数量收取金额" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费,单位港币)最低收取金额" prop="settlementFeeMin">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementFeeMin" placeholder="请输入结算费(港股股份交收费,单位港币)最低收取金额" />
        </el-form-item>
        <el-form-item label="结算费(港股股份交收费,单位港币)最高收取金额" prop="settlementFeeMax">
          <el-input v-model="stpNpSpotTradingFeeForm.settlementFeeMax" placeholder="请输入结算费(港股股份交收费,单位港币)最高收取金额" />
        </el-form-item>
<!--        <el-form-item>-->
<!--          <el-button type="success" @click="doSubmit('stpNpSpotTradingFeeForm')">提交</el-button>-->
<!--        </el-form-item>-->
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotTradingFeeName',
  data() {
    return {
      stpNpSpotTradingFeeLoading: true,
      stpNpSpotTradingFeeDialog: false,
      stpNpSpotTradingFeeData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotTradingFeeForm: {
        'id': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass': '',
        'stampTaxRatioByAmt': '',
        'stampTaxRatioByPar': '',
        'stampTaxFeePerOrder': '',
        'stampTaxFeeByVolume': '',
        'stampTaxFeeMin': '',
        'stampTaxFeeMax': '',
        'transferRatioByAmt': '',
        'transferRatioByPar': '',
        'transferFeePerOrder': '',
        'transferFeeByVolume': '',
        'transferFeeMin': '',
        'transferFeeMax': '',
        'handlingRatioByAmt': '',
        'handlingRatioByPar': '',
        'handlingFeePerOrder': '',
        'handlingFeeByVolume': '',
        'handlingFeeMin': '',
        'handlingFeeMax': '',
        'regulateRatioByAmt': '',
        'regulateRatioByPar': '',
        'regulateFeePerOrder': '',
        'regulateFeeByVolume': '',
        'regulateFeeMin': '',
        'regulateFeeMax': '',
        'settlementRatioByAmt': '',
        'settlementRatioByPar': '',
        'settlementFeePerOrder': '',
        'settlementFeeByVolume': '',
        'settlementFeeMin': '',
        'settlementFeeMax': ''
      },
      searchForm: {
        'id': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotTradingFeeRules: {
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        productID: [
          { required: true, message: '产品代码不可为空', trigger: 'change' }
        ],
        securityType: [
          { required: true, message: '证券类别代码不可为空', trigger: 'change' }
        ],
        securityID: [
          { required: true, message: '证券代码不可为空', trigger: 'change' }
        ],
        bizClass: [
          { required: true, message: '业务类别不可为空', trigger: 'change' }
        ],
        stampTaxRatioByAmt: [
          { required: true, message: '印花税(港股印花税)按金额收取比例不可为空', trigger: 'change' }
        ],
        stampTaxRatioByPar: [
          { required: true, message: '印花税(港股印花税)按面值收取比例不可为空', trigger: 'change' }
        ],
        stampTaxFeePerOrder: [
          { required: true, message: '印花税(港股印花税,单位港币)按笔收取金额不可为空', trigger: 'change' }
        ],
        stampTaxFeeByVolume: [
          { required: true, message: '印花税(港股印花税,单位港币)按数量收取金额不可为空', trigger: 'change' }
        ],
        stampTaxFeeMin: [
          { required: true, message: '印花税(港股印花税,单位港币)最低收取金额不可为空', trigger: 'change' }
        ],
        stampTaxFeeMax: [
          { required: true, message: '印花税(港股印花税,单位港币)最高收取金额不可为空', trigger: 'change' }
        ],
        transferRatioByAmt: [
          { required: true, message: '过户费(港股证券组合费)按金额收取比例不可为空', trigger: 'change' }
        ],
        transferRatioByPar: [
          { required: true, message: '过户费(港股证券组合费)按面值收取比例不可为空', trigger: 'change' }
        ],
        transferFeePerOrder: [
          { required: true, message: '过户费(港股证券组合费,单位港币)按笔收取金额不可为空', trigger: 'change' }
        ],
        transferFeeByVolume: [
          { required: true, message: '过户费(港股证券组合费,单位港币)按数量收取金额不可为空', trigger: 'change' }
        ],
        transferFeeMin: [
          { required: true, message: '过户费(港股证券组合费,单位港币)最低收取金额不可为空', trigger: 'change' }
        ],
        transferFeeMax: [
          { required: true, message: '过户费(港股证券组合费,单位港币)最高收取金额不可为空', trigger: 'change' }
        ],
        handlingRatioByAmt: [
          { required: true, message: '经手费(港股交易费)按金额收取比例不可为空', trigger: 'change' }
        ],
        handlingRatioByPar: [
          { required: true, message: '经手费(港股交易费)按面值收取比例不可为空', trigger: 'change' }
        ],
        handlingFeePerOrder: [
          { required: true, message: '经手费(港股交易费,单位港币)按笔收取金额不可为空', trigger: 'change' }
        ],
        handlingFeeByVolume: [
          { required: true, message: '经手费(港股交易费,单位港币)按数量收取金额不可为空', trigger: 'change' }
        ],
        handlingFeeMin: [
          { required: true, message: '经手费(港股交易费,单位港币)最低收取金额不可为空', trigger: 'change' }
        ],
        handlingFeeMax: [
          { required: true, message: '经手费(港股交易费,单位港币)最高收取金额不可为空', trigger: 'change' }
        ],
        regulateRatioByAmt: [
          { required: true, message: '证管费(港股交易征费)按金额收取比例不可为空', trigger: 'change' }
        ],
        regulateRatioByPar: [
          { required: true, message: '证管费(港股交易征费)按面值收取比例不可为空', trigger: 'change' }
        ],
        regulateFeePerOrder: [
          { required: true, message: '证管费(港股交易征费,单位港币)按笔收取金额不可为空', trigger: 'change' }
        ],
        regulateFeeByVolume: [
          { required: true, message: '证管费(港股交易征费,单位港币)按数量收取金额不可为空', trigger: 'change' }
        ],
        regulateFeeMin: [
          { required: true, message: '证管费(港股交易征费,单位港币)最低收取金额不可为空', trigger: 'change' }
        ],
        regulateFeeMax: [
          { required: true, message: '证管费(港股交易征费,单位港币)最高收取金额不可为空', trigger: 'change' }
        ],
        settlementRatioByAmt: [
          { required: true, message: '结算费(港股股份交收费)按金额收取比例不可为空', trigger: 'change' }
        ],
        settlementRatioByPar: [
          { required: true, message: '结算费(港股股份交收费)按面值收取比例不可为空', trigger: 'change' }
        ],
        settlementFeePerOrder: [
          { required: true, message: '结算费(港股股份交收费,单位港币)按笔收取金额不可为空', trigger: 'change' }
        ],
        settlementFeeByVolume: [
          { required: true, message: '结算费(港股股份交收费,单位港币)按数量收取金额不可为空', trigger: 'change' }
        ],
        settlementFeeMin: [
          { required: true, message: '结算费(港股股份交收费,单位港币)最低收取金额不可为空', trigger: 'change' }
        ],
        settlementFeeMax: [
          { required: true, message: '结算费(港股股份交收费,单位港币)最高收取金额不可为空', trigger: 'change' }
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
        url: '/npspot/dict/stpNpSpotInvestorTradingFee',
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
      this.stpNpSpotTradingFeeLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotTradingFee/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotTradingFeeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotTradingFeeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotTradingFeeForm = {
        'id': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass': '',
        'stampTaxRatioByAmt': '',
        'stampTaxRatioByPar': '',
        'stampTaxFeePerOrder': '',
        'stampTaxFeeByVolume': '',
        'stampTaxFeeMin': '',
        'stampTaxFeeMax': '',
        'transferRatioByAmt': '',
        'transferRatioByPar': '',
        'transferFeePerOrder': '',
        'transferFeeByVolume': '',
        'transferFeeMin': '',
        'transferFeeMax': '',
        'handlingRatioByAmt': '',
        'handlingRatioByPar': '',
        'handlingFeePerOrder': '',
        'handlingFeeByVolume': '',
        'handlingFeeMin': '',
        'handlingFeeMax': '',
        'regulateRatioByAmt': '',
        'regulateRatioByPar': '',
        'regulateFeePerOrder': '',
        'regulateFeeByVolume': '',
        'regulateFeeMin': '',
        'regulateFeeMax': '',
        'settlementRatioByAmt': '',
        'settlementRatioByPar': '',
        'settlementFeePerOrder': '',
        'settlementFeeByVolume': '',
        'settlementFeeMin': '',
        'settlementFeeMax': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotTradingFeeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotTradingFeeForm) {
        this.$refs.stpNpSpotTradingFeeForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotTradingFee/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotTradingFeeForm = {
            'id': res.object.id,
            'exchangeID': res.object.exchangeID,
            'productID': res.object.productID,
            'securityType': res.object.securityType,
            'securityID': res.object.securityID,
            'bizClass': res.object.bizClass,
            'stampTaxRatioByAmt': res.object.stampTaxRatioByAmt,
            'stampTaxRatioByPar': res.object.stampTaxRatioByPar,
            'stampTaxFeePerOrder': res.object.stampTaxFeePerOrder,
            'stampTaxFeeByVolume': res.object.stampTaxFeeByVolume,
            'stampTaxFeeMin': res.object.stampTaxFeeMin,
            'stampTaxFeeMax': res.object.stampTaxFeeMax,
            'transferRatioByAmt': res.object.transferRatioByAmt,
            'transferRatioByPar': res.object.transferRatioByPar,
            'transferFeePerOrder': res.object.transferFeePerOrder,
            'transferFeeByVolume': res.object.transferFeeByVolume,
            'transferFeeMin': res.object.transferFeeMin,
            'transferFeeMax': res.object.transferFeeMax,
            'handlingRatioByAmt': res.object.handlingRatioByAmt,
            'handlingRatioByPar': res.object.handlingRatioByPar,
            'handlingFeePerOrder': res.object.handlingFeePerOrder,
            'handlingFeeByVolume': res.object.handlingFeeByVolume,
            'handlingFeeMin': res.object.handlingFeeMin,
            'handlingFeeMax': res.object.handlingFeeMax,
            'regulateRatioByAmt': res.object.regulateRatioByAmt,
            'regulateRatioByPar': res.object.regulateRatioByPar,
            'regulateFeePerOrder': res.object.regulateFeePerOrder,
            'regulateFeeByVolume': res.object.regulateFeeByVolume,
            'regulateFeeMin': res.object.regulateFeeMin,
            'regulateFeeMax': res.object.regulateFeeMax,
            'settlementRatioByAmt': res.object.settlementRatioByAmt,
            'settlementRatioByPar': res.object.settlementRatioByPar,
            'settlementFeePerOrder': res.object.settlementFeePerOrder,
            'settlementFeeByVolume': res.object.settlementFeeByVolume,
            'settlementFeeMin': res.object.settlementFeeMin,
            'settlementFeeMax': res.object.settlementFeeMax
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotTradingFeeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotTradingFee/save',
            method: 'post',
            data: this.stpNpSpotTradingFeeForm
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
          this.stpNpSpotTradingFeeDialog = false;
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
          url: '/npspot/stpNpSpotTradingFee/del',
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
		.stpNpSpotTradingFeeForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
