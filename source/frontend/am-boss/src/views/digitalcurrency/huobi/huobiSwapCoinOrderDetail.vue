<template>
<div class="app-container">
<el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
<el-form-item label="平台账户ID">
<el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
</el-form-item>
<el-form-item label="外部平台apikey">
<el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
</el-form-item>
<el-form-item label="品种代码">
<el-input v-model="searchForm.symbol" clearable placeholder="请输入品种代码"></el-input>
</el-form-item>
<el-form-item label="订单来源">
<el-input v-model="searchForm.orderSource" clearable placeholder="请输入订单来源"></el-input>
</el-form-item>
<el-form-item label="合约类型">
<el-input v-model="searchForm.contractType" clearable placeholder="请输入合约类型"></el-input>
</el-form-item>
<el-form-item label="合约代码">
<el-input v-model="searchForm.contractCode" clearable placeholder="请输入合约代码"></el-input>
</el-form-item>
<el-form-item label="买卖">
<el-input v-model="searchForm.direction" clearable placeholder="请输入买卖"></el-input>
</el-form-item>
<el-form-item label="开平">
<el-input v-model="searchForm.offset" clearable placeholder="请输入开平"></el-input>
</el-form-item>
<el-form-item>
<el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
</el-form-item>
</el-form>
<el-table v-loading="huobiSwapCoinOrderDetailLoading" :data="huobiSwapCoinOrderDetailData" style="width:100%;margin-bottom:20px;" border row-key="id">
<el-table-column type="index" label="" />
<el-table-column prop="accountId" label="平台账户ID" />
<el-table-column prop="apiKey" label="外部平台apikey" />
<el-table-column prop="detailId" label="全局唯一的交易标识" />
<el-table-column prop="matchId" label="撮合结果id" />
<el-table-column prop="orderId" label="订单ID" />
<el-table-column prop="orderIdStr" label="String类型订单ID" />
<el-table-column prop="symbol" label="品种代码" />
<el-table-column prop="orderSource" label="订单来源" />
<el-table-column prop="contractType" label="合约类型" />
<el-table-column prop="contractCode" label="合约代码" />
<el-table-column prop="direction" label="买卖" />
<el-table-column prop="offset" label="开平" />
<el-table-column prop="tradeVolume" label="累计成交数量" />
<el-table-column prop="tradePrice" label="成交价格" />
<el-table-column prop="tradeTurnover" label="本笔成交金额" />
<el-table-column prop="createDate" label="成交时间" :formatter="dateFormat"/>
<el-table-column prop="offsetProfitloss" label="平仓盈亏" />
<el-table-column prop="tradeFee" label="成交手续费" />
<el-table-column prop="role" label="taker或maker" />
<el-table-column prop="feeAsset" label="手续费币种" />
<el-table-column prop="realProfit" label="真实收益" />
<el-table-column label="操作" width="250">
<template slot-scope="scope">
<el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
<el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
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
<el-dialog title="永续合约账户成交明细管理" :visible.sync="huobiSwapCoinOrderDetailDialog" :close-on-click-modal="false" width="600">
<el-form ref="huobiSwapCoinOrderDetailForm" :model="huobiSwapCoinOrderDetailForm" :rules="huobiSwapCoinOrderDetailRules" label-width="150px" class="huobiSwapCoinOrderDetailForm">
<el-form-item label="主键" prop="id">
<el-input v-model="huobiSwapCoinOrderDetailForm.id" placeholder="请输入主键" />
</el-form-item>
<el-form-item label="平台账户ID" prop="accountId">
<el-input v-model="huobiSwapCoinOrderDetailForm.accountId" placeholder="请输入平台账户ID" />
</el-form-item>
<el-form-item label="外部平台apikey" prop="apiKey">
<el-input v-model="huobiSwapCoinOrderDetailForm.apiKey" placeholder="请输入外部平台apikey" />
</el-form-item>
<el-form-item label="全局唯一的交易标识" prop="detailId">
<el-input v-model="huobiSwapCoinOrderDetailForm.detailId" placeholder="请输入全局唯一的交易标识" />
</el-form-item>
<el-form-item label="撮合结果id" prop="matchId">
<el-input v-model="huobiSwapCoinOrderDetailForm.matchId" placeholder="请输入撮合结果id" />
</el-form-item>
<el-form-item label="订单ID" prop="orderId">
<el-input v-model="huobiSwapCoinOrderDetailForm.orderId" placeholder="请输入订单ID" />
</el-form-item>
<el-form-item label="String类型订单ID" prop="orderIdStr">
<el-input v-model="huobiSwapCoinOrderDetailForm.orderIdStr" placeholder="请输入String类型订单ID" />
</el-form-item>
<el-form-item label="品种代码" prop="symbol">
<el-input v-model="huobiSwapCoinOrderDetailForm.symbol" placeholder="请输入品种代码" />
</el-form-item>
<el-form-item label="订单来源" prop="orderSource">
<el-input v-model="huobiSwapCoinOrderDetailForm.orderSource" placeholder="请输入订单来源" />
</el-form-item>
<el-form-item label="合约类型" prop="contractType">
<el-input v-model="huobiSwapCoinOrderDetailForm.contractType" placeholder="请输入合约类型" />
</el-form-item>
<el-form-item label="合约代码" prop="contractCode">
<el-input v-model="huobiSwapCoinOrderDetailForm.contractCode" placeholder="请输入合约代码" />
</el-form-item>
<el-form-item label="买卖" prop="direction">
<el-input v-model="huobiSwapCoinOrderDetailForm.direction" placeholder="请输入买卖" />
</el-form-item>
<el-form-item label="开平" prop="offset">
<el-input v-model="huobiSwapCoinOrderDetailForm.offset" placeholder="请输入开平" />
</el-form-item>
<el-form-item label="累计成交数量" prop="tradeVolume">
<el-input v-model="huobiSwapCoinOrderDetailForm.tradeVolume" placeholder="请输入累计成交数量" />
</el-form-item>
<el-form-item label="成交价格" prop="tradePrice">
<el-input v-model="huobiSwapCoinOrderDetailForm.tradePrice" placeholder="请输入成交价格" />
</el-form-item>
<el-form-item label="本笔成交金额" prop="tradeTurnover">
<el-input v-model="huobiSwapCoinOrderDetailForm.tradeTurnover" placeholder="请输入本笔成交金额" />
</el-form-item>
<el-form-item label="成交时间" prop="createDate">
<el-input v-model="huobiSwapCoinOrderDetailForm.createDate" placeholder="请输入成交时间" />
</el-form-item>
<el-form-item label="平仓盈亏" prop="offsetProfitloss">
<el-input v-model="huobiSwapCoinOrderDetailForm.offsetProfitloss" placeholder="请输入平仓盈亏" />
</el-form-item>
<el-form-item label="成交手续费" prop="tradeFee">
<el-input v-model="huobiSwapCoinOrderDetailForm.tradeFee" placeholder="请输入成交手续费" />
</el-form-item>
<el-form-item label="taker或maker" prop="role">
<el-input v-model="huobiSwapCoinOrderDetailForm.role" placeholder="请输入taker或maker" />
</el-form-item>
<el-form-item label="手续费币种" prop="feeAsset">
<el-input v-model="huobiSwapCoinOrderDetailForm.feeAsset" placeholder="请输入手续费币种" />
</el-form-item>
<el-form-item label="真实收益" prop="realProfit">
<el-input v-model="huobiSwapCoinOrderDetailForm.realProfit" placeholder="请输入真实收益" />
</el-form-item>
<el-form-item>
<el-button type="success" @click="doSubmit('huobiSwapCoinOrderDetailForm')">提交</el-button>
</el-form-item>
</el-form>
</el-dialog>
</div>
</template>

<script>
export default {
		name: 'HuobiSwapCoinOrderDetailName',
		data() {
		return {
		huobiSwapCoinOrderDetailLoading: true,
		huobiSwapCoinOrderDetailDialog: false,
		huobiSwapCoinOrderDetailData: [],
		commodityTypeSelects: [],
		dicts: [],
		huobiSwapCoinOrderDetailForm: {
		'id': '',
		'accountId': '',
		'apiKey': '',
		'detailId': '',
		'matchId': '',
		'orderId': '',
		'orderIdStr': '',
		'symbol': '',
		'orderSource': '',
		'contractType': '',
		'contractCode': '',
		'direction': '',
		'offset': '',
		'tradeVolume': '',
		'tradePrice': '',
		'tradeTurnover': '',
		'createDate': '',
		'offsetProfitloss': '',
		'tradeFee': '',
		'role': '',
		'feeAsset': '',
		'realProfit': ''
		},
		searchForm: {
		'accountId': '',
		'apiKey': '',
		'detailId': '',
		'matchId': '',
		'orderId': '',
		'orderIdStr': '',
		'symbol': '',
		'orderSource': '',
		'contractType': '',
		'contractCode': '',
		'direction': '',
		'offset': ''
		},
		pageParams: {
		'rows': 10,
		'page': 1,
		'totalPage': 0,
		'total': 0
		},
		huobiSwapCoinOrderDetailRules: {
accountId: [
		{ required: true, message: '平台账户ID不可为空', trigger: 'change' }
		],
apiKey: [
		{ required: true, message: '外部平台apikey不可为空', trigger: 'change' }
		],
		}
		};
		},
		mounted: function() {
		// this.doInitData();
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
		url: '/digitalcurrency/huobi/dict/huobiSwapCoinOrderDetail',
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
		this.huobiSwapCoinOrderDetailLoading = true;
		this.$http({
		url: '/digitalcurrency/huobi/huobiSwapCoinOrderDetail/data',
		method: 'post',
		data: Object.assign(this.pageParams, this.searchForm)
		}).then(res => {
		if (res.code === 200) {
		this.huobiSwapCoinOrderDetailData = res.rows;
		this.pageParams.totalPage = res.totalPage;
		this.pageParams.total = res.total;
		this.huobiSwapCoinOrderDetailLoading = false;
		} else {
		this.$message.error(res);
		}
		}).catch(error => {
		console.log(error);
		this.$message.error(error);
		});
		},
		dialogAdd: function() {
		this.huobiSwapCoinOrderDetailForm = {
		'id': '',
		'accountId': '',
		'apiKey': '',
		'detailId': '',
		'matchId': '',
		'orderId': '',
		'orderIdStr': '',
		'symbol': '',
		'orderSource': '',
		'contractType': '',
		'contractCode': '',
		'direction': '',
		'offset': '',
		'tradeVolume': '',
		'tradePrice': '',
		'tradeTurnover': '',
		'createDate': '',
		'offsetProfitloss': '',
		'tradeFee': '',
		'role': '',
		'feeAsset': '',
		'realProfit': ''
		};
		if (this.$refs.otcLegalConfigForm) {
		this.$refs.otcLegalConfigForm.resetFields();
		}
		this.huobiSwapCoinOrderDetailDialog = true;
		},
		dialogEdit: function(row, column) {
		if (this.$refs.huobiSwapCoinOrderDetailForm) {
		this.$refs.huobiSwapCoinOrderDetailForm.resetFields();
		}
		this.$http({
		url: '/digitalcurrency/huobi/huobiSwapCoinOrderDetail/findBy',
		method: 'get',
		params: {
		'id': column.id
		}
		}).then(res => {
		if (res.code === 200) {
		this.huobiSwapCoinOrderDetailForm = {
		'id': res.object.id,
		'accountId': res.object.accountId,
		'apiKey': res.object.apiKey,
		'detailId': res.object.detailId,
		'matchId': res.object.matchId,
		'orderId': res.object.orderId,
		'orderIdStr': res.object.orderIdStr,
		'symbol': res.object.symbol,
		'orderSource': res.object.orderSource,
		'contractType': res.object.contractType,
		'contractCode': res.object.contractCode,
		'direction': res.object.direction,
		'offset': res.object.offset,
		'tradeVolume': res.object.tradeVolume,
		'tradePrice': res.object.tradePrice,
		'tradeTurnover': res.object.tradeTurnover,
		'createDate': res.object.createDate,
		'offsetProfitloss': res.object.offsetProfitloss,
		'tradeFee': res.object.tradeFee,
		'role': res.object.role,
		'feeAsset': res.object.feeAsset,
		'realProfit': res.object.realProfit
		};
		}
		}).catch(error => {
		this.$message.error(error);
		});
		this.huobiSwapCoinOrderDetailDialog = true;
		},
		doSubmit: function(formName) {
		this.$refs[formName].validate((valid) => {
		if (valid) {
		this.$http({
		url: '/digitalcurrency/huobi/huobiSwapCoinOrderDetail/save',
		method: 'post',
		data: this.huobiSwapCoinOrderDetailForm
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
		this.huobiSwapCoinOrderDetailDialog = false;
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
		url: '/digitalcurrency/huobi/huobiSwapCoinOrderDetail/del',
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
		.huobiSwapCoinOrderDetailForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
