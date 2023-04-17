<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="平台账户ID">
        <el-input v-model="searchForm.accountId" clearable placeholder="请输入平台账户ID"></el-input>
      </el-form-item>
      <el-form-item label="外部平台apikey">
        <el-input v-model="searchForm.apiKey" clearable placeholder="请输入外部平台apikey"></el-input>
      </el-form-item>
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.instType" clearable placeholder="请输入产品类型">
        <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="账单类型">
        <el-select v-model="searchForm.type" clearable placeholder="请输入账单类型">
        <el-option v-for="data in typeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="账单子类型">
        <el-select v-model="searchForm.subType" clearable placeholder="请输入账单子类型">
        <el-option v-for="data in subTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="账户余额币种">
        <el-input v-model="searchForm.ccy" clearable placeholder="请输入账户余额币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountFillLoading"
      :data="okexAccountFillData"
      style="width:100%;margin-bottom:20px;"
      border
      row-key="id"
    >
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">查看</el-button>
        </template>
      </el-table-column>
      <el-table-column type="index" label=""/>
      <el-table-column prop="accountId" label="平台账户ID"/>
      <el-table-column prop="apiKey" label="外部平台apikey"/>
      <el-table-column prop="instType" label="产品类型" :formatter="statusFormat"/>
      <el-table-column prop="billId" label="账单ID"/>
      <el-table-column prop="type" label="账单类型" :formatter="statusFormat"/>
      <el-table-column prop="subType" label="账单子类型" :formatter="statusFormat"/>
      <el-table-column prop="ts" label="账单创建时间" :formatter="dateFormat"/>
      <el-table-column prop="balChg" label="账户层面的余额变动数量"/>
      <el-table-column prop="posBalChg" label="仓位层面的余额变动数量"/>
      <el-table-column prop="bal" label="账户层面的余额数量"/>
      <el-table-column prop="posBal" label="仓位层面的余额数量"/>
      <el-table-column prop="sz" label="数量"/>
      <el-table-column prop="ccy" label="账户余额币种"/>
      <el-table-column prop="pnl" label="收益"/>
      <el-table-column prop="fee" label="手续费"/>
      <el-table-column prop="mgnMode" label="保证金模式" :formatter="statusFormat"/>
      <el-table-column prop="instId" label="产品ID"/>
      <el-table-column prop="ordId" label="订单ID"/>
      <el-table-column prop="fromAccount" label="转出账户" :formatter="statusFormat"/>
      <el-table-column prop="toAccount" label="转入账户" :formatter="statusFormat"/>
      <el-table-column prop="notes" label="备注"/>
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
    <el-dialog title="账户账单流水管理" :visible.sync="okexAccountFillDialog" :close-on-click-modal="false" width="60%">
      <el-form
        ref="okexAccountFillForm"
        :model="okexAccountFillForm"
        :rules="okexAccountFillRules"
        label-width="150px"
        class="okexAccountFillForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="主键" prop="id">
              <el-input v-model="okexAccountFillForm.id" placeholder="请输入主键"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="平台账户ID" prop="accountId">
              <el-input v-model="okexAccountFillForm.accountId" placeholder="请输入平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="外部平台apikey" prop="apiKey">
              <el-input v-model="okexAccountFillForm.apiKey" placeholder="请输入外部平台apikey"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="instType">
              <el-select v-model="okexAccountFillForm.instType" placeholder="请输入产品类型">
                <el-option v-for="data in dicts.instType.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账单ID" prop="billId">
              <el-input v-model="okexAccountFillForm.billId" placeholder="请输入账单ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账单类型" prop="type">
              <el-select v-model="okexAccountFillForm.type" placeholder="请输入账单类型">
              <el-option v-for="data in dicts.type.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="账单子类型" prop="subType">
              <el-select v-model="okexAccountFillForm.subType" placeholder="请输入账单子类型">
              <el-option v-for="data in dicts.subType.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账单创建时间" prop="ts">
              <el-input v-model="okexAccountFillForm.ts" placeholder="请输入账单创建时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账户层面的余额变动数量" prop="balChg">
              <el-input v-model="okexAccountFillForm.balChg" placeholder="请输入账户层面的余额变动数量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="仓位层面的余额变动数量" prop="posBalChg">
              <el-input v-model="okexAccountFillForm.posBalChg" placeholder="请输入仓位层面的余额变动数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账户层面的余额数量" prop="bal">
              <el-input v-model="okexAccountFillForm.bal" placeholder="请输入账户层面的余额数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="仓位层面的余额数量" prop="posBal">
              <el-input v-model="okexAccountFillForm.posBal" placeholder="请输入仓位层面的余额数量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="数量" prop="sz">
              <el-input v-model="okexAccountFillForm.sz" placeholder="请输入数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="账户余额币种" prop="ccy">
              <el-input v-model="okexAccountFillForm.ccy" placeholder="请输入账户余额币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收益" prop="pnl">
              <el-input v-model="okexAccountFillForm.pnl" placeholder="请输入收益"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="手续费" prop="fee">
              <el-input v-model="okexAccountFillForm.fee" placeholder="请输入手续费"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金模式" prop="mgnMode">
              <el-select v-model="okexAccountFillForm.mgnMode" placeholder="请输入保证金模式">
              <el-option v-for="data in dicts.mgnMode.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品ID" prop="instId">
              <el-input v-model="okexAccountFillForm.instId" placeholder="请输入产品ID"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="订单ID" prop="ordId">
              <el-input v-model="okexAccountFillForm.ordId" placeholder="请输入订单ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="转出账户" prop="fromAccount">
              <el-select v-model="okexAccountFillForm.fromAccount" placeholder="请输入转出账户">
                <el-option v-for="data in dicts.fromAccount.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="转入账户" prop="toAccount">
              <el-select v-model="okexAccountFillForm.toAccount" placeholder="请输入转入账户">
                <el-option v-for="data in dicts.toAccount.list" :key="data.key" :label="data.value" :value="data.key"/>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="备注" prop="notes">
              <el-input v-model="okexAccountFillForm.notes" placeholder="请输入备注"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexAccountFillForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexAccountFillName',
    data() {
      return {
        okexAccountFillLoading: true,
        okexAccountFillDialog: false,
        okexAccountFillData: [],
        commodityTypeSelects: [],
        dicts: [],
        instTypeList: [],
        typeList: [],
        subTypeList: [],
        okexAccountFillForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'billId': '',
          'type': '',
          'subType': '',
          'ts': '',
          'balChg': '',
          'posBalChg': '',
          'bal': '',
          'posBal': '',
          'sz': '',
          'ccy': '',
          'pnl': '',
          'fee': '',
          'mgnMode': '',
          'instId': '',
          'ordId': '',
          'fromAccount': '',
          'toAccount': '',
          'notes': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'type': '',
          'subType': '',
          'ccy': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexAccountFillRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
          ],
          instType: [
            { required: true, message: '产品类型不可为空', trigger: 'change' }
          ],
          billId: [
            { required: true, message: '账单ID不可为空', trigger: 'change' }
          ],
          type: [
            { required: true, message: '账单类型不可为空', trigger: 'change' }
          ],
          subType: [
            { required: true, message: '账单子类型不可为空', trigger: 'change' }
          ],
          ts: [
            { required: true, message: '账单创建时间不可为空', trigger: 'change' }
          ],
          balChg: [
            { required: true, message: '账户层面的余额变动数量不可为空', trigger: 'change' }
          ],
          posBalChg: [
            { required: true, message: '仓位层面的余额变动数量不可为空', trigger: 'change' }
          ],
          bal: [
            { required: true, message: '账户层面的余额数量不可为空', trigger: 'change' }
          ],
          posBal: [
            { required: true, message: '仓位层面的余额数量不可为空', trigger: 'change' }
          ],
          sz: [
            { required: true, message: '数量不可为空', trigger: 'change' }
          ],
          ccy: [
            { required: true, message: '账户余额币种不可为空', trigger: 'change' }
          ],
          pnl: [
            { required: true, message: '收益不可为空', trigger: 'change' }
          ],
          fee: [
            { required: true, message: '手续费不可为空', trigger: 'change' }
          ],
          mgnMode: [
            { required: true, message: '保证金模式不可为空', trigger: 'change' }
          ],
          instId: [
            { required: true, message: '产品ID不可为空', trigger: 'change' }
          ],
          ordId: [
            { required: true, message: '订单ID不可为空', trigger: 'change' }
          ],
          fromAccount: [
            { required: true, message: '转出账户不可为空', trigger: 'change' }
          ],
          toAccount: [
            { required: true, message: '转入账户不可为空', trigger: 'change' }
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
        if(this.dicts[p] === undefined){
          return ''
        }
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
          url: '/digitalcurrency/okex/dict/okexAccountFill',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.instTypeList = res.object.list.instType.list
            this.mgnModeList = res.object.list.mgnMode.list
            this.typeList = res.object.list.type.list
            this.subTypeList = res.object.list.subType.list
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
        this.okexAccountFillLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexAccountFill/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountFillData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexAccountFillLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexAccountFillForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'billId': '',
          'type': '',
          'subType': '',
          'ts': '',
          'balChg': '',
          'posBalChg': '',
          'bal': '',
          'posBal': '',
          'sz': '',
          'ccy': '',
          'pnl': '',
          'fee': '',
          'mgnMode': '',
          'instId': '',
          'ordId': '',
          'fromAccount': '',
          'toAccount': '',
          'notes': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexAccountFillDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexAccountFillForm) {
          this.$refs.okexAccountFillForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexAccountFill/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountFillForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'instType': res.object.instType,
              'billId': res.object.billId,
              'type': res.object.type,
              'subType': res.object.subType,
              'ts': res.object.ts,
              'balChg': res.object.balChg,
              'posBalChg': res.object.posBalChg,
              'bal': res.object.bal,
              'posBal': res.object.posBal,
              'sz': res.object.sz,
              'ccy': res.object.ccy,
              'pnl': res.object.pnl,
              'fee': res.object.fee,
              'mgnMode': res.object.mgnMode,
              'instId': res.object.instId,
              'ordId': res.object.ordId,
              'fromAccount': res.object.fromAccount,
              'toAccount': res.object.toAccount,
              'notes': res.object.notes
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexAccountFillDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexAccountFill/save',
              method: 'post',
              data: this.okexAccountFillForm
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
            this.okexAccountFillDialog = false;
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
            url: '/digitalcurrency/okex/okexAccountFill/del',
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
  .okexAccountFillForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
