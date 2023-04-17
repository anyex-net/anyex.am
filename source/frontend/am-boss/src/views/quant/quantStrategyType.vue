<template>
  <div class="app-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="策略类型">
        <el-input v-model="searchForm.strategyType" clearable placeholder="请输入策略类型"></el-input>
      </el-form-item>
      <el-form-item label="策略类型名称">
        <el-input v-model="searchForm.strategyTypeName" clearable placeholder="请输入策略类型名称"></el-input>
      </el-form-item>
      <el-form-item label="启用状态">
        <el-select v-model="searchForm.status" clearable placeholder="请输入启用状态">
          <el-option :key="0" label="禁用" :value="0" />
          <el-option :key="1" label="启用" :value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <el-button type="success" icon="el-icon-circle-plus" @click="dialogAdd()">添加</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="quantStrategyTypeLoading" :data="quantStrategyTypeData" style="width:100%;margin-bottom:20px;"
              border row-key="id">
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button size="mini" type="success" @click="dialogEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="doDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column prop="strategyType" label="策略类型"/>
      <el-table-column prop="strategyTypeName" label="策略类型名称"/>
      <el-table-column prop="status" label="启用状态">
        <template slot-scope="scope">
          <span v-if="scope.row.status == 0">禁用</span>
          <span v-if="scope.row.status == 1">启用</span>
        </template>
      </el-table-column>
      <el-table-column prop="remark" label="备注"/>
      <el-table-column prop="riskLevel" label="风险等级"/>
      <el-table-column prop="feeRate" label="费率"/>
      <el-table-column prop="hisYearYield" label="历史年化收益率"/>
      <el-table-column prop="updateTime" label="更新时间" :formatter="dateFormat"/>
      <el-table-column prop="createTime" label="记录创建时间" :formatter="dateFormat"/>
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
    <el-dialog title="量化策略类型信息" :visible.sync="quantStrategyTypeDialog" :close-on-click-modal="false" width="600">
      <el-form ref="quantStrategyTypeForm" :model="quantStrategyTypeForm" :rules="quantStrategyTypeRules"
               label-width="150px" class="quantStrategyTypeForm">
        <el-form-item label="策略类型" prop="strategyType">
          <el-input v-model="quantStrategyTypeForm.strategyType" placeholder="请输入策略类型"/>
        </el-form-item>
        <el-form-item label="策略类型名称" prop="strategyTypeName">
          <el-input v-model="quantStrategyTypeForm.strategyTypeName" placeholder="请输入策略类型名称"/>
        </el-form-item>
        <el-form-item label="启用状态" prop="status">
          <el-select v-model="quantStrategyTypeForm.status" clearable placeholder="请输入启用状态">
            <el-option :key="0" label="禁用" :value="0" />
            <el-option :key="1" label="启用" :value="1" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="quantStrategyTypeForm.remark" placeholder="请输入备注"/>
        </el-form-item>
        <el-form-item label="风险等级" prop="riskLevel">
          <el-input v-model="quantStrategyTypeForm.riskLevel" placeholder="请输入风险等级"/>
        </el-form-item>
        <el-form-item label="费率" prop="feeRate">
          <el-input v-model="quantStrategyTypeForm.feeRate" placeholder="请输入费率"/>
        </el-form-item>
        <el-form-item label="历史年化收益率" prop="hisYearYield">
          <el-input v-model="quantStrategyTypeForm.hisYearYield" placeholder="请输入历史年化收益率"/>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="doSubmit('quantStrategyTypeForm')">提交</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'QuantStrategyTypeName',
    data() {
      return {
        quantStrategyTypeLoading: true,
        quantStrategyTypeDialog: false,
        quantStrategyTypeData: [],
        commodityTypeSelects: [],
        dicts: [],
        quantStrategyTypeForm: {
          'id': '',
          'strategyType': '',
          'strategyTypeName': '',
          'status': '',
          'remark': '',
          'riskLevel': '',
          'feeRate': '',
          'hisYearYield': '',
          'updateTime': '',
          'createTime': ''
        },
        searchForm: {
          'id': '',
          'strategyType': '',
          'strategyTypeName': '',
          'status': '',
          'remark': '',
          'riskLevel': '',
          'feeRate': '',
          'hisYearYield': '',
          'updateTime': '',
          'createTime': ''
          ,
          'sort': 'id',
          'order': 'asc'
        },
        pageParams: {
          'rows': 10,
          'page': 1,
          'totalPage': 0,
          'total': 0
        },
        quantStrategyTypeRules: {
          strategyType: [
            { required: true, message: '策略类型不可为空', trigger: 'change' }
          ],
          strategyTypeName: [
            { required: true, message: '策略类型名称不可为空', trigger: 'change' }
          ],
          status: [
            { required: true, message: '启用状态（0禁用1启用）不可为空', trigger: 'change' }
          ],
          remark: [
            { required: true, message: '备注不可为空', trigger: 'change' }
          ],
          riskLevel: [
            { required: true, message: '风险等级不可为空', trigger: 'change' }
          ],
          feeRate: [
            { required: true, message: '费率不可为空', trigger: 'change' }
          ],
          hisYearYield: [
            { required: true, message: '历史年化收益率不可为空', trigger: 'change' }
          ],
          updateTime: [
            { required: true, message: '更新时间不可为空', trigger: 'change' }
          ],
          createTime: [
            { required: true, message: '记录创建时间不可为空', trigger: 'change' }
          ]
        }
      };
    },
    mounted: function() {
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
      doSearch: function(data, type) {
        if (type === 'page') {
          this.pageParams.page = data;
        }
        if (type === 'size') {
          this.pageParams.rows = data;
        }
        this.quantStrategyTypeLoading = true;
        this.$http({
          url: '/quant/quantStrategyType/data',
          method: 'post',
          data: Object.assign(this.pageParams, this.searchForm)
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyTypeData = res.rows;
            this.pageParams.totalPage = res.totalPage;
            this.pageParams.total = res.total;
            this.quantStrategyTypeLoading = false;
          } else {
            this.$message.error(res);
          }
        }).catch(error => {
          console.log(error);
          this.$message.error(error);
        });
      },
      dialogAdd: function() {
        this.quantStrategyTypeForm = {
          'id': '',
          'strategyType': '',
          'strategyTypeName': '',
          'status': '',
          'remark': '',
          'riskLevel': '',
          'feeRate': '',
          'hisYearYield': '',
          'updateTime': '',
          'createTime': ''
        };
        if (this.$refs.otcLegalConfigForm) {
          this.$refs.otcLegalConfigForm.resetFields();
        }
        this.quantStrategyTypeDialog = true;
      },
      dialogEdit: function(row, column) {
        if (this.$refs.quantStrategyTypeForm) {
          this.$refs.quantStrategyTypeForm.resetFields();
        }
        this.$http({
          url: '/quant/quantStrategyType/findBy',
          method: 'get',
          params: {
            'id': column.id
          }
        }).then(res => {
          if (res.code === 200) {
            this.quantStrategyTypeForm = {
              'id': res.object.id,
              'strategyType': res.object.strategyType,
              'strategyTypeName': res.object.strategyTypeName,
              'status': res.object.status,
              'remark': res.object.remark,
              'riskLevel': res.object.riskLevel,
              'feeRate': res.object.feeRate,
              'hisYearYield': res.object.hisYearYield,
              'updateTime': res.object.updateTime,
              'createTime': res.object.createTime
            };
          }
        }).catch(error => {
          this.$message.error(error);
        });
        this.quantStrategyTypeDialog = true;
      },
      doSubmit: function(formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.$http({
              url: '/quant/quantStrategyType/save',
              method: 'post',
              data: this.quantStrategyTypeForm
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
            this.quantStrategyTypeDialog = false;
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
            url: '/quant/quantStrategyType/del',
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
  .quantStrategyTypeForm {
    /deep/ .el-select {
      width: 100%;
    }
  }
</style>
