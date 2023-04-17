<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="产品类型">
        <el-select v-model="searchForm.instType" clearable placeholder="请输入产品类型">
          <el-option v-for="data in instTypeList" :key="data.key" :label="data.value" :value="data.key"/>
        </el-select>
      </el-form-item>
      <el-form-item label="产品id">
        <el-input v-model="searchForm.instId" clearable placeholder="请输入产品id"></el-input>
      </el-form-item>
      <el-form-item label="合约标的指数">
        <el-input v-model="searchForm.uly" clearable placeholder="请输入合约标的指数"></el-input>
      </el-form-item>
      <el-form-item label="手续费档位">
        <el-input v-model="searchForm.category" clearable placeholder="请输入手续费档位"></el-input>
      </el-form-item>
      <el-form-item label="交易货币币种">
        <el-input v-model="searchForm.baseCcy" clearable placeholder="请输入交易货币币种"></el-input>
      </el-form-item>
      <el-form-item label="计价货币币种">
        <el-input v-model="searchForm.quoteCcy" clearable placeholder="请输入计价货币币种"></el-input>
      </el-form-item>
      <el-form-item label="盈亏结算和保证金币种">
        <el-input v-model="searchForm.settleCcy" clearable placeholder="请输入盈亏结算和保证金币种"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-loading="okexInstrumentsLoading"
      :data="okexInstrumentsData"
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
      <el-table-column prop="instType" label="产品类型" :formatter="statusFormat"/>
      <el-table-column prop="instId" label="产品id"/>
      <el-table-column prop="uly" label="合约标的指数"/>
      <el-table-column prop="category" label="手续费档位"/>
      <el-table-column prop="baseCcy" label="交易货币币种"/>
      <el-table-column prop="quoteCcy" label="计价货币币种"/>
      <el-table-column prop="settleCcy" label="盈亏结算和保证金币种"/>
      <el-table-column prop="ctVal" label="合约面值 "/>
      <el-table-column prop="ctMult" label="合约乘数"/>
      <el-table-column prop="ctValCcy" label="合约面值计价币种"/>
      <el-table-column prop="optType" label="期权类型"/>
      <el-table-column prop="stk" label="行权价格"/>
      <el-table-column prop="listTime" label="上线日期" :formatter="dateFormat"/>
      <el-table-column prop="expTime" label="交割日期 " :formatter="dateFormat"/>
      <el-table-column prop="lever" label="杠杆倍数"/>
      <el-table-column prop="tickSz" label="下单价格精度"/>
      <el-table-column prop="lotSz" label="下单数量精度"/>
      <el-table-column prop="minSz" label="最小下单数量"/>
      <el-table-column prop="ctType" label="合约类型" :formatter="statusFormat"/>
      <el-table-column prop="alias" label="合约日期别名" :formatter="statusFormat"/>
      <el-table-column prop="state" label="产品状态" :formatter="statusFormat"/>
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
    <el-dialog title="产品信息管理" :visible.sync="okexInstrumentsDialog" :close-on-click-modal="false" width="60%">
      <el-form
        ref="okexInstrumentsForm"
        :model="okexInstrumentsForm"
        :rules="okexInstrumentsRules"
        label-width="150px"
        class="okexInstrumentsForm"
      >
        <el-row>
          <el-col :span="8">
            <el-form-item label="主键" prop="id">
              <el-input v-model="okexInstrumentsForm.id" placeholder="请输入主键"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品类型" prop="instType">
              <el-input v-model="okexInstrumentsForm.instType" placeholder="请输入产品类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="产品id" prop="instId">
              <el-input v-model="okexInstrumentsForm.instId" placeholder="请输入产品id"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约标的指数" prop="uly">
              <el-input v-model="okexInstrumentsForm.uly" placeholder="请输入合约标的指数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="手续费档位" prop="category">
              <el-input v-model="okexInstrumentsForm.category" placeholder="请输入手续费档位"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交易货币币种" prop="baseCcy">
              <el-input v-model="okexInstrumentsForm.baseCcy" placeholder="请输入交易货币币种"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="计价货币币种" prop="quoteCcy">
              <el-input v-model="okexInstrumentsForm.quoteCcy" placeholder="请输入计价货币币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="盈亏结算和保证金币种" prop="settleCcy">
              <el-input v-model="okexInstrumentsForm.settleCcy" placeholder="请输入盈亏结算和保证金币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约面值 " prop="ctVal">
              <el-input v-model="okexInstrumentsForm.ctVal" placeholder="请输入合约面值 "/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="合约乘数" prop="ctMult">
              <el-input v-model="okexInstrumentsForm.ctMult" placeholder="请输入合约乘数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约面值计价币种" prop="ctValCcy">
              <el-input v-model="okexInstrumentsForm.ctValCcy" placeholder="请输入合约面值计价币种"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="期权类型" prop="optType">
              <el-input v-model="okexInstrumentsForm.optType" placeholder="请输入期权类型"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="行权价格" prop="stk">
              <el-input v-model="okexInstrumentsForm.stk" placeholder="请输入行权价格"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="上线日期" prop="listTime">
              <el-input v-model="okexInstrumentsForm.listTime" placeholder="请输入上线日期"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="交割日期 " prop="expTime">
              <el-input v-model="okexInstrumentsForm.expTime" placeholder="请输入交割日期 "/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="杠杆倍数" prop="lever">
              <el-input v-model="okexInstrumentsForm.lever" placeholder="请输入杠杆倍数"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="下单价格精度" prop="tickSz">
              <el-input v-model="okexInstrumentsForm.tickSz" placeholder="请输入下单价格精度"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="下单数量精度" prop="lotSz">
              <el-input v-model="okexInstrumentsForm.lotSz" placeholder="请输入下单数量精度"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="最小下单数量" prop="minSz">
              <el-input v-model="okexInstrumentsForm.minSz" placeholder="请输入最小下单数量"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约类型" prop="ctType">
              <el-input v-model="okexInstrumentsForm.ctType" placeholder="请输入合约类型"/>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="合约日期别名" prop="alias">
              <el-input v-model="okexInstrumentsForm.alias" placeholder="请输入合约日期别名"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="产品状态" prop="state">
              <el-input v-model="okexInstrumentsForm.state" placeholder="请输入产品状态"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button type="success" @click="doSubmit('okexInstrumentsForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'OkexInstrumentsName',
    data() {
      return {
        okexInstrumentsLoading: true,
        okexInstrumentsDialog: false,
        okexInstrumentsData: [],
        commodityTypeSelects: [],
        dicts: [],
        instTypeList: [],
        okexInstrumentsForm: {
          'id': '',
          'instType': '',
          'instId': '',
          'uly': '',
          'category': '',
          'baseCcy': '',
          'quoteCcy': '',
          'settleCcy': '',
          'ctVal': '',
          'ctMult': '',
          'ctValCcy': '',
          'optType': '',
          'stk': '',
          'listTime': '',
          'expTime': '',
          'lever': '',
          'tickSz': '',
          'lotSz': '',
          'minSz': '',
          'ctType': '',
          'alias': '',
          'state': ''
        },
        searchForm: {
          'instType': '',
          'instId': '',
          'uly': '',
          'category': '',
          'baseCcy': '',
          'quoteCcy': '',
          'settleCcy': ''
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        okexInstrumentsRules: {}
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
          url: '/digitalcurrency/okex/dict/okexInstruments',
          method: 'get'
        }).then(res => {
          if (res.code === 200) {
            this.dicts = res.object.list;
            this.instTypeList = res.object.list.instType.list
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
        this.okexInstrumentsLoading = true;
        this.$http({
          url: '/digitalcurrency/okex/okexInstruments/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.okexInstrumentsData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.okexInstrumentsLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.okexInstrumentsForm = {
          'id': '',
          'instType': '',
          'instId': '',
          'uly': '',
          'category': '',
          'baseCcy': '',
          'quoteCcy': '',
          'settleCcy': '',
          'ctVal': '',
          'ctMult': '',
          'ctValCcy': '',
          'optType': '',
          'stk': '',
          'listTime': '',
          'expTime': '',
          'lever': '',
          'tickSz': '',
          'lotSz': '',
          'minSz': '',
          'ctType': '',
          'alias': '',
          'state': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.okexInstrumentsDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.okexInstrumentsForm) {
          this.$refs.okexInstrumentsForm.resetFields();
        }
        this.$http({
          url: '/digitalcurrency/okex/okexInstruments/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.okexInstrumentsForm = {
              'id': res.object.id,
              'instType': res.object.instType,
              'instId': res.object.instId,
              'uly': res.object.uly,
              'category': res.object.category,
              'baseCcy': res.object.baseCcy,
              'quoteCcy': res.object.quoteCcy,
              'settleCcy': res.object.settleCcy,
              'ctVal': res.object.ctVal,
              'ctMult': res.object.ctMult,
              'ctValCcy': res.object.ctValCcy,
              'optType': res.object.optType,
              'stk': res.object.stk,
              'listTime': res.object.listTime,
              'expTime': res.object.expTime,
              'lever': res.object.lever,
              'tickSz': res.object.tickSz,
              'lotSz': res.object.lotSz,
              'minSz': res.object.minSz,
              'ctType': res.object.ctType,
              'alias': res.object.alias,
              'state': res.object.state
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.okexInstrumentsDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/digitalcurrency/okex/okexInstruments/save',
              method: 'post',
              data: this.okexInstrumentsForm
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
            this.okexInstrumentsDialog = false;
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
            url: '/digitalcurrency/okex/okexInstruments/del',
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
  .okexInstrumentsForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
