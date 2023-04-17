<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="AM平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入AM平台账户ID"></el-input>
      </el-form-item>
<!--      <el-form-item label="经纪公司代码">-->
<!--        <el-input v-model="searchForm.brokerID" clearable placeholder="请输入经纪公司代码"></el-input>-->
<!--      </el-form-item>-->
      <el-form-item label="投资者帐号">
        <el-input v-model="searchForm.investorID" clearable placeholder="请输入投资者帐号"></el-input>
      </el-form-item>
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
      <el-form-item label="报单类型">
        <el-select v-model="searchForm.orderType" clearable placeholder="请输入报单类型">
          <el-option v-for="data in dicts['orderType']" :key="data.key" :label="data.value" :value="data.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
<!--        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>-->
      </el-form-item>
    </el-form>
    <el-table v-loading="stpNpSpotInvestorTradingFeeLoading" :data="stpNpSpotInvestorTradingFeeData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column prop="id" label="主键" />
      <el-table-column prop="accountId" label="AM平台账户ID" />
      <el-table-column prop="brokerID" label="经纪公司代码" />
      <el-table-column prop="investorID" label="投资者帐号" />
      <el-table-column prop="exchangeID" label="交易所代码" :formatter="statusFormat"/>
      <el-table-column prop="productID" label="产品代码" :formatter="statusFormat"/>
      <el-table-column prop="securityType" label="证券类别代码" :formatter="statusFormat"/>
      <el-table-column prop="securityID" label="证券代码" />
      <el-table-column prop="bizClass" label="业务类别" :formatter="statusFormat"/>
      <el-table-column prop="brokerageType" label="佣金类型(0:毛佣金;1:净佣金)" :formatter="statusFormat"/>
      <el-table-column prop="ratioByAmt" label="佣金按金额收取比例" />
      <el-table-column prop="ratioByPar" label="佣金按面值收取比例" />
      <el-table-column prop="feePerOrder" label="佣金按笔收取金额" />
      <el-table-column prop="feeMin" label="佣金最低收取金额" />
      <el-table-column prop="feeMax" label="佣金最高收取金额" />
      <el-table-column prop="feeByVolume" label="佣金按数量收取金额" />
      <el-table-column prop="departmentID" label="经纪公司部门代码" />
      <el-table-column prop="orderType" label="报单类型" :formatter="statusFormat"/>
<!--      <el-table-column label="操作" width="250">-->
<!--        <template slot-scope="scope">-->
<!--          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>-->
<!--          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>-->
<!--        </template>-->
<!--      </el-table-column>-->
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
    <el-dialog title="内盘现货佣金费率表管理" :visible.sync="stpNpSpotInvestorTradingFeeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="stpNpSpotInvestorTradingFeeForm" :model="stpNpSpotInvestorTradingFeeForm" :rules="stpNpSpotInvestorTradingFeeRules" label-width="150px" class="stpNpSpotInvestorTradingFeeForm">
        <el-form-item label="主键" prop="id">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.id" placeholder="请输入主键" />
        </el-form-item>
        <el-form-item label="AM平台账户ID" prop="accountId">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.accountId" placeholder="请输入AM平台账户ID" />
        </el-form-item>
        <el-form-item label="经纪公司代码" prop="brokerID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.brokerID" placeholder="请输入经纪公司代码" />
        </el-form-item>
        <el-form-item label="投资者帐号" prop="investorID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.investorID" placeholder="请输入投资者帐号" />
        </el-form-item>
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="产品代码" prop="productID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.productID" placeholder="请输入产品代码" />
        </el-form-item>
        <el-form-item label="证券类别代码" prop="securityType">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.securityType" placeholder="请输入证券类别代码" />
        </el-form-item>
        <el-form-item label="证券代码" prop="securityID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.securityID" placeholder="请输入证券代码" />
        </el-form-item>
        <el-form-item label="业务类别" prop="bizClass">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.bizClass" placeholder="请输入业务类别" />
        </el-form-item>
        <el-form-item label="佣金类型(0:毛佣金;1:净佣金)" prop="brokerageType">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.brokerageType" placeholder="请输入佣金类型(0:毛佣金;1:净佣金)" />
        </el-form-item>
        <el-form-item label="佣金按金额收取比例" prop="ratioByAmt">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.ratioByAmt" placeholder="请输入佣金按金额收取比例" />
        </el-form-item>
        <el-form-item label="佣金按面值收取比例" prop="ratioByPar">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.ratioByPar" placeholder="请输入佣金按面值收取比例" />
        </el-form-item>
        <el-form-item label="佣金按笔收取金额" prop="feePerOrder">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.feePerOrder" placeholder="请输入佣金按笔收取金额" />
        </el-form-item>
        <el-form-item label="佣金最低收取金额" prop="feeMin">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.feeMin" placeholder="请输入佣金最低收取金额" />
        </el-form-item>
        <el-form-item label="佣金最高收取金额" prop="feeMax">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.feeMax" placeholder="请输入佣金最高收取金额" />
        </el-form-item>
        <el-form-item label="佣金按数量收取金额" prop="feeByVolume">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.feeByVolume" placeholder="请输入佣金按数量收取金额" />
        </el-form-item>
        <el-form-item label="经纪公司部门代码" prop="departmentID">
          <el-input v-model="stpNpSpotInvestorTradingFeeForm.departmentID" placeholder="请输入经纪公司部门代码" />
        </el-form-item>
        <el-form-item label="报单类型" prop="orderType">
          <el-select v-model="stpNpSpotInvestorTradingFeeForm.orderType" clearable placeholder="请输入业务类别">
            <el-option v-for="data in dicts['orderType']" :key="data.key" :label="data.value" :value="data.key" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('stpNpSpotInvestorTradingFeeForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'StpNpSpotInvestorTradingFeeName',
  data() {
    return {
      stpNpSpotInvestorTradingFeeLoading: true,
      stpNpSpotInvestorTradingFeeDialog: false,
      stpNpSpotInvestorTradingFeeData: [],
      commodityTypeSelects: [],
      dicts: [],
      stpNpSpotInvestorTradingFeeForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass': '',
        'brokerageType': '',
        'ratioByAmt': '',
        'ratioByPar': '',
        'feePerOrder': '',
        'feeMin': '',
        'feeMax': '',
        'feeByVolume': '',
        'departmentID': '',
        'orderType': ''
      },
      searchForm: {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass' : '',
        'orderType': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      stpNpSpotInvestorTradingFeeRules: {
        accountId: [
          { required: true, message: 'AM平台账户ID不可为空', trigger: 'change' }
        ],
        brokerID: [
          { required: true, message: '经纪公司代码不可为空', trigger: 'change' }
        ],
        investorID: [
          { required: true, message: '投资者帐号不可为空', trigger: 'change' }
        ],
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
        brokerageType: [
          { required: true, message: '佣金类型(0:毛佣金;1:净佣金)不可为空', trigger: 'change' }
        ],
        ratioByAmt: [
          { required: true, message: '佣金按金额收取比例不可为空', trigger: 'change' }
        ],
        ratioByPar: [
          { required: true, message: '佣金按面值收取比例不可为空', trigger: 'change' }
        ],
        feePerOrder: [
          { required: true, message: '佣金按笔收取金额不可为空', trigger: 'change' }
        ],
        feeMin: [
          { required: true, message: '佣金最低收取金额不可为空', trigger: 'change' }
        ],
        feeMax: [
          { required: true, message: '佣金最高收取金额不可为空', trigger: 'change' }
        ],
        feeByVolume: [
          { required: true, message: '佣金按数量收取金额不可为空', trigger: 'change' }
        ],
        departmentID: [
          { required: true, message: '经纪公司部门代码不可为空', trigger: 'change' }
        ],
        orderType: [
          { required: true, message: '报单类型不可为空', trigger: 'change' }
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
      this.stpNpSpotInvestorTradingFeeLoading = true;
      this.$http({
        url: '/npspot/stpNpSpotInvestorTradingFee/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotInvestorTradingFeeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.stpNpSpotInvestorTradingFeeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.stpNpSpotInvestorTradingFeeForm = {
        'id': '',
        'accountId': '',
        'brokerID': '',
        'investorID': '',
        'exchangeID': '',
        'productID': '',
        'securityType': '',
        'securityID': '',
        'bizClass': '',
        'brokerageType': '',
        'ratioByAmt': '',
        'ratioByPar': '',
        'feePerOrder': '',
        'feeMin': '',
        'feeMax': '',
        'feeByVolume': '',
        'departmentID': '',
        'orderType': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.stpNpSpotInvestorTradingFeeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.stpNpSpotInvestorTradingFeeForm) {
        this.$refs.stpNpSpotInvestorTradingFeeForm.resetFields();
      }
      this.$http({
        url: '/npspot/stpNpSpotInvestorTradingFee/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.stpNpSpotInvestorTradingFeeForm = {
            'id': res.object.id,
            'accountId': res.object.accountId,
            'brokerID': res.object.brokerID,
            'investorID': res.object.investorID,
            'exchangeID': res.object.exchangeID,
            'productID': res.object.productID,
            'securityType': res.object.securityType,
            'securityID': res.object.securityID,
            'bizClass': res.object.bizClass,
            'brokerageType': res.object.brokerageType,
            'ratioByAmt': res.object.ratioByAmt,
            'ratioByPar': res.object.ratioByPar,
            'feePerOrder': res.object.feePerOrder,
            'feeMin': res.object.feeMin,
            'feeMax': res.object.feeMax,
            'feeByVolume': res.object.feeByVolume,
            'departmentID': res.object.departmentID,
            'orderType': res.object.orderType
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.stpNpSpotInvestorTradingFeeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/stpNpSpotInvestorTradingFee/save',
            method: 'post',
            data: this.stpNpSpotInvestorTradingFeeForm
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
          this.stpNpSpotInvestorTradingFeeDialog = false;
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
          url: '/npspot/stpNpSpotInvestorTradingFee/del',
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
		.stpNpSpotInvestorTradingFeeForm {
		/deep/ .el-select {
		width: 100%;
		}
		}
</style>
