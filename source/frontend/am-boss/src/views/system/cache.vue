<template>
  <div class="app-container cache-container">
    <el-form ref="searchForm" :model="searchForm" :inline="true" size="mini">
      <el-form-item label="key名称">
        <!--<el-select v-model="searchForm.redisKey" placeholder="请选择" clearable>
          <el-option
            v-for="(data,index) in keyNames"
            :key="index"
            :label="data"
            :value="data">
          </el-option>
        </el-select>-->
        <el-input v-model="searchForm.redisKey" placeholder="请输入key名称" clearable></el-input>
      </el-form-item>
      <!--<el-form-item label="缓存类型">
        <el-select v-model="searchForm.type" placeholder="请选择" clearable value="">
          <el-option key="redis" label="redis" value="redis" />
          <el-option key="mybatis" label="mybatis" value="mybatis" />
          <el-option key="session" label="session" value="session" />
        </el-select>
      </el-form-item>-->
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="doSearch()">查询</el-button>
        <!--<el-button type="success" icon="el-icon-circle-plus" @click="cleanKey()">清除缓存</el-button>-->
        <el-button style="margin-bottom:10px;" type="danger" size="mini" icon="el-icon-circle-plus" @click="cleanAll()">清除所有缓存</el-button>
        <el-button style="margin-bottom:10px;" type="danger" size="mini" icon="el-icon-circle-plus" @click="cleanMybatis()">清除Mybatis缓存</el-button>
        <el-button style="margin-bottom:10px;" type="danger" size="mini" icon="el-icon-circle-plus" @click="cleanSession()">清除session缓存</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="cacheLoading" :data="keyData" style="width:100%;margin-bottom:20px;" border row-key="id">
      <el-table-column label="key" prop="keyNames" />
      <el-table-column label="value" prop="keyValue" />
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button size="mini" type="danger" @click="cleanKey(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  name: 'Cache',
  data() {
    return {
      cacheLoading: true,
      keyData: [],
      keyNames: [],
      keyValue: [],
      orgData: [],
      searchForm: {
        'redisKey': ''
      }
    };
  },
  mounted: function() {
    this.doSearch();
    // this.doInitData();
  },
  methods: {
    doSearch: function() {
      this.cacheLoading = true;
      this.$http({
        url: '/system/cache/data',
        method: 'get',
        params: this.searchForm
      }).then(res => {
        if (res.code === 200) {
          this.keyData = Object.entries(res.object);
          this.keyNames = Object.keys(res.object);
          this.keyValue = Object.values(res.object);
          this.cacheLoading = false;
          for (let i = 0; i < this.keyNames.length; i++) {
            this.keyData[i].keyNames = this.keyNames[i];
            this.keyData[i].keyValue = JSON.stringify(this.keyValue[i]);
          }
        }
      }).catch(error => {
        console.log(error);
      });
    },
    cleanKey: function(row, column) {
      this.$confirm('确认删除该缓存, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http({
          url: '/system/cache/del',
          method: 'post',
          data: {
            redisKey: column.keyNames
          }
        }).then(res => {
          if (res.code === 200) {
            this.$message.success('清除缓存成功');
            this.doSearch();
            this.searchForm.redisKey = '';
          }
        }).catch(error => {
          console.log(error);
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    },
    cleanAll() {
      this.$http({
        url: '/system/cache/clean/all',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.$message.success('清除所有缓存成功');
          this.doSearch();
        }
      }).catch(error => {
        console.log(error);
      });
    },
    cleanMybatis() {
      this.$http({
        url: '/system/cache/clean/mybatis',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.$message.success('清除Mybatis缓存成功');
          this.doSearch();
        }
      }).catch(error => {
        console.log(error);
      });
    },
    cleanSession() {
      this.$http({
        url: '/system/cache/clean/session',
        method: 'post'
      }).then(res => {
        if (res.code === 200) {
          this.$message.success('清除session缓存成功');
          this.doSearch();
        }
      }).catch(error => {
        console.log(error);
      });
    }
  }
};
</script>

<style lang="scss">
  .cache-container {
    .el-table .cell {
      max-height: 200px;
      overflow-y: auto;
    }
  }
</style>
