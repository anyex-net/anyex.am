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
        <el-input v-model="searchForm.instType" clearable placeholder="请输入产品类型"></el-input>
      </el-form-item>
      <el-form-item label="保证金模式">
        <el-select v-model="searchForm.mgnMode" clearable placeholder="请选择保证金模式" value="">
          <el-option v-for="data in mgnModeList" :key="data.key" :label="data.value" :value="data.key">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="持仓方向">
        <el-input v-model="searchForm.posSide" clearable placeholder="请输入持仓方向"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexAccountPositionLoading"
      :data="okexAccountPositionData"
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
      <el-table-column prop="instType" label="产品类型"/>
      <el-table-column prop="mgnMode" label="保证金模式" :formatter="statusFormat"/>
      <el-table-column prop="posId" label="持仓ID"/>
      <el-table-column prop="posSide" label="持仓方向"/>
      <el-table-column prop="pos" label="持仓数量"/>
      <el-table-column prop="posCcy" label="仓位资产币种"/>
      <el-table-column prop="availPos" label="可平仓数量"/>
      <el-table-column prop="avgPx" label="开仓平均价"/>
      <el-table-column prop="upl" label="未实现收益"/>
      <el-table-column prop="uplRatio" label="未实现收益率"/>
      <el-table-column prop="instId" label="产品ID"/>
      <el-table-column prop="lever" label="杠杆倍数"/>
      <el-table-column prop="liqPx" label="预估强平价"/>
      <el-table-column prop="imr" label="初始保证金"/>
      <el-table-column prop="margin" label="保证金余额"/>
      <el-table-column prop="mgnRatio" label="保证金率"/>
      <el-table-column prop="mmr" label="维持保证金"/>
      <el-table-column prop="liab" label="负债额"/>
      <el-table-column prop="liabCcy" label="负债币种"/>
      <el-table-column prop="interest" label="利息"/>
      <el-table-column prop="tradeId" label="最新成交ID"/>
      <el-table-column prop="optVal" label="期权市值"/>
      <el-table-column prop="adl" label="信号区 "/>
      <el-table-column prop="ccy" label="占用保证金的币种"/>
      <el-table-column prop="last" label="最新成交价"/>
      <el-table-column prop="cTime" label="持仓创建时间"/>
      <el-table-column prop="uTime" label="最近一次持仓更新时间"/>
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
    <el-dialog title="账户持仓信息管理" :visible.sync="okexAccountPositionDialog" :close-on-click-modal="false" width="60%">
      <el-form
        ref="okexAccountPositionForm"
        :model="okexAccountPositionForm"
        :rules="okexAccountPositionRules"
        label-width="150px"
        class="okexAccountPositionForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="平台账户ID" prop="accountId">
              <el-input v-model="okexAccountPositionForm.accountId" placeholder="请输入平台账户ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="外部平台apikey" prop="apiKey">
              <el-input v-model="okexAccountPositionForm.apiKey" placeholder="请输入外部平台apikey"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="instType">
              <el-input v-model="okexAccountPositionForm.instType" placeholder="请输入产品类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="保证金模式" prop="commodityType">
              <el-select v-model="okexAccountPositionForm.mgnMode" clearable placeholder="请选择保证金模式" value="">
                <el-option v-for="data in mgnModeList" :key="data.key" :label="data.value" :value="data.key">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓ID" prop="posId">
              <el-input v-model="okexAccountPositionForm.posId" placeholder="请输入持仓ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="持仓方向" prop="posSide">
              <el-input v-model="okexAccountPositionForm.posSide" placeholder="请输入持仓方向"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓数量" prop="pos">
              <el-input v-model="okexAccountPositionForm.pos" placeholder="请输入持仓数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="仓位资产币种" prop="posCcy">
              <el-input v-model="okexAccountPositionForm.posCcy" placeholder="请输入仓位资产币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可平仓数量" prop="availPos">
              <el-input v-model="okexAccountPositionForm.availPos" placeholder="请输入可平仓数量"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="开仓平均价" prop="avgPx">
              <el-input v-model="okexAccountPositionForm.avgPx" placeholder="请输入开仓平均价"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="未实现收益" prop="upl">
              <el-input v-model="okexAccountPositionForm.upl" placeholder="请输入未实现收益"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="未实现收益率" prop="uplRatio">
              <el-input v-model="okexAccountPositionForm.uplRatio" placeholder="请输入未实现收益率"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="产品ID" prop="instId">
              <el-input v-model="okexAccountPositionForm.instId" placeholder="请输入产品ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="杠杆倍数" prop="lever">
              <el-input v-model="okexAccountPositionForm.lever" placeholder="请输入杠杆倍数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="预估强平价" prop="liqPx">
              <el-input v-model="okexAccountPositionForm.liqPx" placeholder="请输入预估强平价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="初始保证金" prop="imr">
              <el-input v-model="okexAccountPositionForm.imr" placeholder="请输入初始保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金余额" prop="margin">
              <el-input v-model="okexAccountPositionForm.margin" placeholder="请输入保证金余额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="保证金率" prop="mgnRatio">
              <el-input v-model="okexAccountPositionForm.mgnRatio" placeholder="请输入保证金率"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="维持保证金" prop="mmr">
              <el-input v-model="okexAccountPositionForm.mmr" placeholder="请输入维持保证金"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="负债额" prop="liab">
              <el-input v-model="okexAccountPositionForm.liab" placeholder="请输入负债额"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="负债币种" prop="liabCcy">
              <el-input v-model="okexAccountPositionForm.liabCcy" placeholder="请输入负债币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="利息" prop="interest">
              <el-input v-model="okexAccountPositionForm.interest" placeholder="请输入利息"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新成交ID" prop="tradeId">
              <el-input v-model="okexAccountPositionForm.tradeId" placeholder="请输入最新成交ID"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权市值" prop="optVal">
              <el-input v-model="okexAccountPositionForm.optVal" placeholder="请输入期权市值"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="信号区 " prop="adl">
              <el-input v-model="okexAccountPositionForm.adl" placeholder="请输入信号区 "/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="占用保证金的币种" prop="ccy">
              <el-input v-model="okexAccountPositionForm.ccy" placeholder="请输入占用保证金的币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最新成交价" prop="last">
              <el-input v-model="okexAccountPositionForm.last" placeholder="请输入最新成交价"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="持仓创建时间" prop="cTime">
              <el-input v-model="okexAccountPositionForm.cTime" placeholder="请输入持仓创建时间"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最近一次持仓更新时间" prop="uTime">
              <el-input v-model="okexAccountPositionForm.uTime" placeholder="请输入最近一次持仓更新时间"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexAccountPositionName',
    data() {
      return {
        okexAccountPositionLoading: true,
        okexAccountPositionDialog: false,
        okexAccountPositionData: [],
        commodityTypeSelects: [],
        dicts: [],
        mgnModeList: [],
        okexAccountPositionForm: {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'mgnMode': '',
          'posId': '',
          'posSide': '',
          'pos': '',
          'posCcy': '',
          'availPos': '',
          'avgPx': '',
          'upl': '',
          'uplRatio': '',
          'instId': '',
          'lever': '',
          'liqPx': '',
          'imr': '',
          'margin': '',
          'mgnRatio': '',
          'mmr': '',
          'liab': '',
          'liabCcy': '',
          'interest': '',
          'tradeId': '',
          'optVal': '',
          'adl': '',
          'ccy': '',
          'last': '',
          'cTime': '',
          'uTime': ''
        },
        searchForm: {
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'mgnMode': '',
          'posSide': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexAccountPositionRules: {
          accountId: [
            { required: true, message: '平台账户ID不可为空', trigger: 'change' }
          ],
          apiKey: [
            { required: true, message: '外部平台apikey不可为空', trigger: 'change' }
          ],
          instType: [
            { required: true, message: '产品类型不可为空', trigger: 'change' }
          ],
          mgnMode: [
            { required: true, message: '保证金模式不可为空', trigger: 'change' }
          ],
          posId: [
            { required: true, message: '持仓ID不可为空', trigger: 'change' }
          ],
          posSide: [
            { required: true, message: '持仓方向不可为空', trigger: 'change' }
          ],
          pos: [
            { required: true, message: '持仓数量不可为空', trigger: 'change' }
          ],
          posCcy: [
            { required: true, message: '仓位资产币种不可为空', trigger: 'change' }
          ],
          availPos: [
            { required: true, message: '可平仓数量不可为空', trigger: 'change' }
          ],
          avgPx: [
            { required: true, message: '开仓平均价不可为空', trigger: 'change' }
          ],
          upl: [
            { required: true, message: '未实现收益不可为空', trigger: 'change' }
          ],
          uplRatio: [
            { required: true, message: '未实现收益率不可为空', trigger: 'change' }
          ],
          instId: [
            { required: true, message: '产品ID不可为空', trigger: 'change' }
          ],
          lever: [
            { required: true, message: '杠杆倍数不可为空', trigger: 'change' }
          ],
          liqPx: [
            { required: true, message: '预估强平价不可为空', trigger: 'change' }
          ],
          imr: [
            { required: true, message: '初始保证金不可为空', trigger: 'change' }
          ],
          margin: [
            { required: true, message: '保证金余额不可为空', trigger: 'change' }
          ],
          mgnRatio: [
            { required: true, message: '保证金率不可为空', trigger: 'change' }
          ],
          mmr: [
            { required: true, message: '维持保证金不可为空', trigger: 'change' }
          ],
          liab: [
            { required: true, message: '负债额不可为空', trigger: 'change' }
          ],
          liabCcy: [
            { required: true, message: '负债币种不可为空', trigger: 'change' }
          ],
          interest: [
            { required: true, message: '利息不可为空', trigger: 'change' }
          ],
          tradeId: [
            { required: true, message: '最新成交ID不可为空', trigger: 'change' }
          ],
          optVal: [
            { required: true, message: '期权市值不可为空', trigger: 'change' }
          ],
          adl: [
            { required: true, message: '信号区 不可为空', trigger: 'change' }
          ],
          ccy: [
            { required: true, message: '占用保证金的币种不可为空', trigger: 'change' }
          ],
          last: [
            { required: true, message: '最新成交价不可为空', trigger: 'change' }
          ],
          cTime: [
            { required: true, message: '持仓创建时间不可为空', trigger: 'change' }
          ],
          uTime: [
            { required: true, message: '最近一次持仓更新时间不可为空', trigger: 'change' }
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
          url: '/digitalcurrency/okex/dict/okexAccountPosition',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.mgnModeList = res.object.list.mgnMode.list
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
        this.okexAccountPositionLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexAccountPosition/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountPositionData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexAccountPositionLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexAccountPositionForm = {
          'id': '',
          'accountId': '',
          'apiKey': '',
          'instType': '',
          'mgnMode': '',
          'posId': '',
          'posSide': '',
          'pos': '',
          'posCcy': '',
          'availPos': '',
          'avgPx': '',
          'upl': '',
          'uplRatio': '',
          'instId': '',
          'lever': '',
          'liqPx': '',
          'imr': '',
          'margin': '',
          'mgnRatio': '',
          'mmr': '',
          'liab': '',
          'liabCcy': '',
          'interest': '',
          'tradeId': '',
          'optVal': '',
          'adl': '',
          'ccy': '',
          'last': '',
          'cTime': '',
          'uTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexAccountPositionDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexAccountPositionForm) {
          this.$refs.okexAccountPositionForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexAccountPosition/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexAccountPositionForm = {
              'id': res.object.id,
              'accountId': res.object.accountId,
              'apiKey': res.object.apiKey,
              'instType': res.object.instType,
              'mgnMode': res.object.mgnMode,
              'posId': res.object.posId,
              'posSide': res.object.posSide,
              'pos': res.object.pos,
              'posCcy': res.object.posCcy,
              'availPos': res.object.availPos,
              'avgPx': res.object.avgPx,
              'upl': res.object.upl,
              'uplRatio': res.object.uplRatio,
              'instId': res.object.instId,
              'lever': res.object.lever,
              'liqPx': res.object.liqPx,
              'imr': res.object.imr,
              'margin': res.object.margin,
              'mgnRatio': res.object.mgnRatio,
              'mmr': res.object.mmr,
              'liab': res.object.liab,
              'liabCcy': res.object.liabCcy,
              'interest': res.object.interest,
              'tradeId': res.object.tradeId,
              'optVal': res.object.optVal,
              'adl': res.object.adl,
              'ccy': res.object.ccy,
              'last': res.object.last,
              'cTime': res.object.cTime,
              'uTime': res.object.uTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexAccountPositionDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexAccountPosition/save',
              method: 'post',
              data: this.okexAccountPositionForm
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
            this.okexAccountPositionDialog = false;
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
            url: '/digitalcurrency/okex/okexAccountPosition/del',
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
  .okexAccountPositionForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
