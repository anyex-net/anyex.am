<template>
  <div class="app-container">

    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="币种编号">
        <el-input v-model="searchForm.currencyNo" clearable placeholder="请输币种编号"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="wpfuturesCurrencyInfoLoading" :data="wpfuturesCurrencyInfoData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="currencyNo" label="币种编号" />
      <el-table-column prop="currencyGroupNo" label="币种组编号" />
      <el-table-column prop="tradeRate" label="交易汇率" />
      <el-table-column prop="tradeRate2" label="交易汇率2" />
      <el-table-column prop="futureAlg" label="币种组独立标志" />
      <el-table-column prop="optionAlg" label="是否是基币" :formatter="statusFormat"/>
    </el-table>

    <el-pagination
      style="text-align:center;"
      background
      layout="total, sizes, prev, pager, next, jumper"
      :hide-on-single-page="true"
      :page-size="pageParams.rows"
      :page-count="pageParams.totalPage"
      :current-page="pageParams.page"
      :page-sizes="[5, 10, 20, 30, 40, 50, 100]"
      @current-change="doSearch($event, 'page')"
      @size-change="doSearch($event, 'size')"
    />

    <el-dialog title="币种信息编辑" :visible.sync="wpfuturesCurrencyInfoDialog" :close-on-click-modal="false" width="500px">
      <el-form ref="wpfuturesCurrencyInfoForm" :model="wpfuturesCurrencyInfoForm" :rules="wpfuturesCurrencyInfoRules" label-width="120px" class="wpfuturesCurrencyInfoForm">
        <el-form-item label="币种编号" prop="currencyNo">
          <el-input v-model="wpfuturesCurrencyInfoForm.currencyNo" placeholder="请输入币种编号" />
        </el-form-item>
        <el-form-item label="币种组编号" prop="currencyGroupNo">
          <el-input v-model="wpfuturesCurrencyInfoForm.currencyGroupNo" placeholder="请输入币种组编号" />
        </el-form-item>
        <el-form-item label="交易汇率" prop="tradeRate">
          <el-input v-model="wpfuturesCurrencyInfoForm.tradeRate" placeholder="请输入交易汇率" />
        </el-form-item>
        <el-form-item label="交易汇率2" prop="tradeRate2">
          <el-input v-model="wpfuturesCurrencyInfoForm.tradeRate2" placeholder="请输入交易汇率2" />
        </el-form-item>
        <el-form-item label="币种组独立标志" prop="futureAlg">
          <el-input v-model="wpfuturesCurrencyInfoForm.futureAlg" placeholder="请输入币种组独立标志" />
        </el-form-item>
        <el-form-item label="是否是基币" prop="optionAlg">
          <el-select v-model="wpfuturesCurrencyInfoForm.optionAlg" placeholder="请选择是否是基币" value="">
            <el-option v-for="data in dicts.optionAlg" :key="data.key" :label="data.value" :value="data.key"/>
          </el-select>
        </el-form-item>
        <el-divider></el-divider>
        <el-form-item>
          <el-button type="primary" @click="doSubmit('wpfuturesCurrencyInfoForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'WpfuturesCurrencyInfo',
  data() {
    return {
      wpfuturesCurrencyInfoLoading: '',
      wpfuturesCurrencyInfoDialog: false,
      wpfuturesCurrencyInfoData: [],
      dicts: [],
      wpfuturesCurrencyInfoForm: {
        'id': '',
        'currencyNo': '',
        'currencyGroupNo': '',
        'tradeRate': '',
        'tradeRate2': '',
        'futureAlg': '',
        'optionAlg': ''
      },
      searchForm: {
        'currencyNo': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0
      },
      wpfuturesCurrencyInfoRules: {
        currencyNo: [
          { required: true, message: '请输入币种编号', trigger: 'blur' }
        ],
        currencyGroupNo: [
          { required: true, message: '请输入币种组编号', trigger: 'blur' }
        ],
        tradeRate: [
          { required: true, message: '请输入交易汇率', trigger: 'blur' }
        ],
        tradeRate2: [
          { required: true, message: '请输入交易汇率2', trigger: 'blur' }
        ],
        futureAlg: [
          { required: true, message: '请输入币种组独立标志', trigger: 'blur' }
        ],
        optionAlg: [
          { required: true, message: '是否是基币', trigger: 'change' }
        ]
      }
    };
  },
  mounted: function() {
    this.doSearch();
    this.doInitData();
  },
  methods: {
    table_index(index) {
      return (this.pageParams.page - 1) * this.pageParams.rows + index + 1;
    },

    dateFormat: function(row, column) {
      const date = row[column.property];
      if (date === undefined || date === '') {
        return '';
      }
      return this.$moment(date).format('YYYY-MM-DD HH:mm:ss');
    },
    statusFormat: function(row, column) {
      const date = row[column.property];
      console.log(date.toString());
      if (date === undefined || date === '') {
        return '';
      }
      var p = column.property;
      console.log("p:"+p)
      const obj = this.dicts[p];
      console.log("obj:"+JSON.stringify(obj))
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
        url: '/wpfutures/dict/optionAlgType',
        method: 'get'
      }).then(res => {
        if (res.code === 200) {
          this.dicts = res.object;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    dialogAdd: function() {
      this.wpfuturesCurrencyInfoForm = {
        'id': '',
        'wpfuturesCurrencyInfo': '',
        'buildVersion': '',
        'deviceType': '',
        'canSupport': '',
        'checkStatus': '',
        'remark': ''
      };
      if (this.$refs.wpfuturesCurrencyInfoForm) {
        this.$refs.wpfuturesCurrencyInfoForm.resetFields();
      }
      this.wpfuturesCurrencyInfoDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.wpfuturesCurrencyInfoForm) {
        this.$refs.wpfuturesCurrencyInfoForm.resetFields();
      }
      this.$http({
        url: '/wpfutures/wpfuturesCurrencyInfo/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesCurrencyInfoForm = {
            'id': res.object.id,
            'currencyNo': res.object.currencyNo,
            'currencyGroupNo': res.object.currencyGroupNo,
            'tradeRate': res.object.tradeRate,
            'tradeRate2': res.object.tradeRate2,
            'futureAlg': res.object.futureAlg,
            'optionAlg': res.object.optionAlg
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.wpfuturesCurrencyInfoDialog = true;
    },
    doSearch: function(data, type) {
      if (type === 'page') {
        this.pageParams.page = data;
      }
      if (type === 'size') {
        this.pageParams.rows = data;
      }
      this.wpfuturesCurrencyInfoLoading = true;
      this.$http({
        url: '/wpfutures/wpfuturesCurrencyInfo/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.wpfuturesCurrencyInfoData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.wpfuturesCurrencyInfoLoading = false;
        }
      }).catch(error => {
        console.log(error);
      });
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/wpfutures/wpfuturesCurrencyInfo/save',
            method: 'post',
            data: this.wpfuturesCurrencyInfoForm
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
          this.wpfuturesCurrencyInfoDialog = false;
        }
      });
    },
    doDelete: function(row, column) {
      this.$confirm('确认删除该app版本, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/wpfutures/wpfuturesCurrencyInfo/del',
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

</style>
