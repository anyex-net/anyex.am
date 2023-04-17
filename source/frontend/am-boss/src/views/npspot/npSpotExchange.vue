<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="交易所代码">
        <el-input v-model="searchForm.exchangeID" clearable placeholder="请输入交易所代码"></el-input>
      </el-form-item>
      <el-form-item label="交易所名称">
        <el-input v-model="searchForm.exchangeName" clearable placeholder="请输入交易所名称"></el-input>
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
      v-loading="npSpotExchangeLoading"
      :data="npSpotExchangeData"
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
      <el-table-column prop="exchangeID" label="交易所代码" />
      <el-table-column prop="exchangeName" label="交易所名称" />
      <el-table-column prop="exchangeProperty" label="交易所属性">
        <template scope="scope">
          <div v-if="scope.row.exchangeProperty == 0">正常</div>
          <div v-else-if="scope.row.exchangeProperty == 1">根据成交生成报单</div>
        </template>
      </el-table-column>
      <el-table-column prop="exchangeDomain" label="交易所域名" />
      <el-table-column prop="openMarket" label="交易所是否开市">
        <template scope="scope">
          <div v-if="scope.row.openMarket == 'open'">是</div>
          <div v-else-if="scope.row.openMarket == 'close'">否</div>
        </template>
      </el-table-column>
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
    <el-dialog title="内盘现货交易所表管理" :visible.sync="npSpotExchangeDialog" :close-on-click-modal="false" width="600">
      <el-form
        ref="npSpotExchangeForm"
        :model="npSpotExchangeForm"
        :rules="npSpotExchangeRules"
        label-width="150px"
        class="npSpotExchangeForm"
      >
        <el-form-item label="交易所代码" prop="exchangeID">
          <el-input v-model="npSpotExchangeForm.exchangeID" placeholder="请输入交易所代码" />
        </el-form-item>
        <el-form-item label="交易所名称" prop="exchangeName">
          <el-input v-model="npSpotExchangeForm.exchangeName" placeholder="请输入交易所名称">
          </el-input>
        </el-form-item>
<!--        <el-form-item label="交易所属性" prop="exchangeProperty">-->
<!--          <el-select v-model="npSpotExchangeForm.exchangeProperty" placeholder="请输入交易所属性">-->
<!--            <el-option key="0" label="正常" value="0" />-->
<!--            <el-option key="1" label="根据成交生成报单" value="1" />-->
<!--          </el-select>-->
<!--        </el-form-item>-->
<!--        <el-form-item label="交易所域名" prop="exchangeDomain">-->
<!--          <el-input v-model="npSpotExchangeForm.exchangeDomain" placeholder="请输入交易所域名" />-->
<!--        </el-form-item>-->
<!--        <el-form-item label="交易所是否开市" prop="openMarket">-->
<!--          <el-select v-model="npSpotExchangeForm.openMarket" clearable placeholder="请选择交易所是否开市">-->
<!--            <el-option key="open" label="是" value="open" />-->
<!--            <el-option key="close" label="否" value="close" />-->
<!--          </el-select>-->
<!--        </el-form-item>-->
        <el-form-item label="启用状态" prop="enableStatus">
          <el-select v-model="npSpotExchangeForm.enableStatus" placeholder="请选择启用状态">
            <el-option key="enable" label="是" value="enable" />
            <el-option key="disable" label="否" value="disable" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('npSpotExchangeForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NpSpotExchange',
  data() {
    return {
      npSpotExchangeLoading: true,
      npSpotExchangeDialog: false,
      npSpotExchangeData: [],
      commodityTypeSelects: [],
      dicts: [],
      npSpotExchangeForm: {
        'id': '',
        'exchangeID': '',
        'exchangeName': '',
        'exchangeProperty': '',
        'exchangeDomain': '',
        'openMarket': '',
        'enableStatus': ''
      },
      searchForm: {
        'exchangeID': '',
        'exchangeName': '',
        'openMarket': '',
        'enableStatus': ''
      },
      pageParams: {
        'rows': 10,
        'page': 1,
        'totalPage': 0,
        'total': 0
      },
      npSpotExchangeRules: {
        exchangeID: [
          { required: true, message: '交易所代码不可为空', trigger: 'change' }
        ],
        // exchangeName: [
        //   { required: true, message: '交易所名称不可为空', trigger: 'change' }
        // ],
        // exchangeProperty: [
        //   { required: true, message: '交易所属性不可为空', trigger: 'change' }
        // ],
        // exchangeDomain: [
        //   { required: true, message: '交易所域名不可为空', trigger: 'change' }
        // ],
        // openMarket: [
        //   { required: true, message: '交易所是否开市不可为空', trigger: 'change' }
        // ],
        enableStatus: [
          { required: true, message: '启用状态不可为空', trigger: 'change' }
        ]
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
        url: '/npspot/dict/npSpotExchange',
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
      this.npSpotExchangeLoading = true;
      this.$http({
        url: '/npspot/npSpotExchange/data',
        method: 'post',
        data: Object.assign(this.pageParams, this.searchForm)
      }).then(res => {
        if (res.code === 200) {
          this.npSpotExchangeData = res.rows;
          this.pageParams.totalPage = res.totalPage;
          this.pageParams.total = res.total;
          this.npSpotExchangeLoading = false;
        } else {
          this.$message.error(res);
        }
      }).catch(error => {
        console.log(error);
        this.$message.error(error);
      });
    },
    dialogAdd: function() {
      this.npSpotExchangeForm = {
        'id': '',
        'exchangeID': '',
        'exchangeName': '',
        'exchangeProperty': '',
        'exchangeDomain': '',
        'openMarket': '',
        'enableStatus': ''
      };
      if (this.$refs.otcLegalConfigForm) {
        this.$refs.otcLegalConfigForm.resetFields();
      }
      this.npSpotExchangeDialog = true;
    },
    dialogEdit: function(row, column) {
      if (this.$refs.npSpotExchangeForm) {
        this.$refs.npSpotExchangeForm.resetFields();
      }
      this.$http({
        url: '/npspot/npSpotExchange/findBy',
        method: 'get',
        params: {
          'id': column.id
        }
      }).then(res => {
        if (res.code === 200) {
          this.npSpotExchangeForm = {
            'id': res.object.id,
            'exchangeID': res.object.exchangeID,
            'exchangeName': res.object.exchangeName,
            'exchangeProperty': res.object.exchangeProperty,
            'exchangeDomain': res.object.exchangeDomain,
            'openMarket': res.object.openMarket,
            'enableStatus': res.object.enableStatus
          };
        }
      }).catch(error => {
        this.$message.error(error);
      });
      this.npSpotExchangeDialog = true;
    },
    doSubmit: function(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$http({
            url: '/npspot/npSpotExchange/save',
            method: 'post',
            data: this.npSpotExchangeForm
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
          this.npSpotExchangeDialog = false;
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
          url: '/npspot/npSpotExchange/del',
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
  .npSpotExchangeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
