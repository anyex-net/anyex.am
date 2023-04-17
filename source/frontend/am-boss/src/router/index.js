import Vue from 'vue';
import Router from 'vue-router';

Vue.use(Router);

/* Layout */
import Layout from '@/layout';

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/',
    component: Layout,
    redirect: '/index',
    children: [
      {
        path: 'index',
        name: 'Index',
        component: () => import('@/views/index'),
        meta: { title: '首页', affix: true }
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login'),
    meta: { title: '登录' }
  },
  {
    path: '/system',
    component: Layout,
    meta: { title: '系统管理' },
    children: [
      {
        path: 'organiz',
        name: 'Organization',
        component: () => import('@/views/system/organization'),
        meta: { title: '机构管理' }
      },
      {
        path: 'resource',
        name: 'Resource',
        component: () => import('@/views/system/resource'),
        meta: { title: '资源管理' }
      },
      {
        path: 'role',
        name: 'Role',
        component: () => import('@/views/system/role'),
        meta: { title: '角色管理' }
      },
      {
        path: 'user',
        name: 'User',
        component: () => import('@/views/system/user'),
        meta: { title: '用户管理' }
      },
      {
        path: 'cache',
        name: 'Cache',
        component: () => import('@/views/system/cache'),
        meta: { title: '缓存管理' }
      }
    ]
  },
  {
    path: '/common',
    component: Layout,
    meta: { title: '公共模块' },
    children: [
      {
        path: 'dict',
        name: 'Dict',
        component: () => import('@/views/common/dictionary'),
        meta: { title: '数据字典' }
      },
      {
        path: 'msgtemplate',
        name: 'MsgTemplate',
        component: () => import('@/views/common/msgTemplate'),
        meta: { title: '消息模版' }
      },
      {
        path: 'region',
        name: 'Region',
        component: () => import('@/views/common/region'),
        meta: { title: '区域代码' }
      },
      {
        path: 'parameter',
        name: 'Parameter',
        component: () => import('@/views/common/parameter'),
        meta: { title: '系统参数' }
      },
      {
        path: 'feedback',
        name: 'Feedback',
        component: () => import('@/views/common/feedback'),
        meta: { title: '反馈意见' }
      },
      {
        path: 'appVersion',
        name: 'AppVersion',
        component: () => import('@/views/common/appVersion'),
        meta: { title: 'app版本' }
      },
      {
        path: 'appDevice',
        name: 'AppDevice',
        component: () => import('@/views/common/appDevice'),
        meta: { title: 'app设备' }
      },
      {
        path: 'quotation',
        name: 'Quotation',
        component: () => import('@/views/common/quotation'),
        meta: { title: '外部行情' }
      },
      {
        path: 'msgRecord',
        name: 'MsgRecord',
        component: () => import('@/views/common/msgRecord'),
        meta: { title: '消息记录' }
      },
      {
        path: 'notice',
        name: 'Notice',
        component: () => import('@/views/common/notice'),
        meta: { title: '平台公告' }
      }
    ]
  },
  {
    path: '/account',
    component: Layout,
    meta: { title: '账户管理' },
    children: [
      {
        path: 'account',
        name: 'Account',
        component: () => import('@/views/account/account'),
        meta: { title: '账户管理' }
      },
      {
        path: 'accountKyc',
        name: 'AccountKyc',
        component: () => import('@/views/account/accountKyc'),
        meta: { title: '账户认证' }
      }
    ]
  },
  {
    path: '/wpfutures',
    component: Layout,
    meta: { title: '外盘期货' },
    children: [
      {
        path: 'wpfuturesCurrencyInfo',
        name: 'WpfuturesCurrencyInfo',
        component: () => import('@/views/wpfutures/wpfuturesCurrencyInfo'),
        meta: { title: '币种信息' }
      },
      {
        path: 'wpfuturesBrokerInfo',
        name: 'WpfuturesBrokerInfo',
        component: () => import('@/views/wpfutures/wpfuturesBrokerInfo'),
        meta: { title: '经纪商信息' }
      },
      {
        path: 'wpfuturesExchangeInfo',
        name: 'WpfuturesExchangeInfo',
        component: () => import('@/views/wpfutures/wpfuturesExchangeInfo'),
        meta: { title: '交易所信息' }
      },
      {
        path: 'wpfuturesExchangeCommodity',
        name: 'WpfuturesExchangeCommodity',
        component: () => import('@/views/wpfutures/wpfuturesExchangeCommodity'),
        meta: { title: '期货品种' }
      },
      {
        path: 'wpfuturesExchangeContract',
        name: 'WpfuturesExchangeContract',
        component: () => import('@/views/wpfutures/wpfuturesExchangeContract'),
        meta: { title: '期货合约' }
      },
      {
        path: 'wpfuturesQuoteWhole',
        name: 'WpfuturesQuoteWhole',
        component: () => import('@/views/wpfutures/wpfuturesQuoteWhole'),
        meta: { title: '期货行情' }
      },
      {
        path: 'wpfuturesAccountInfo',
        name: 'WpfuturesAccountInfo',
        component: () => import('@/views/wpfutures/wpfuturesAccountInfo'),
        meta: { title: '期货资金账号' }
      },
      {
        path: 'wpfuturesFundData',
        name: 'WpfuturesFundData',
        component: () => import('@/views/wpfutures/wpfuturesFundData'),
        meta: { title: '期货资金信息' }
      },
      {
        path: 'wpfuturesPositionInfo',
        name: 'WpfuturesPositionInfo',
        component: () => import('@/views/wpfutures/wpfuturesPositionInfo'),
        meta: { title: '期货持仓信息' }
      },
      {
        path: 'wpfuturesPositionSummaryInfo',
        name: 'WpfuturesPositionSummaryInfo',
        component: () => import('@/views/wpfutures/wpfuturesPositionSummaryInfo'),
        meta: { title: '期货持仓汇总信息' }
      },
      {
        path: 'wpfuturesOrderInfo',
        name: 'WpfuturesOrderInfo',
        component: () => import('@/views/wpfutures/wpfuturesOrderInfo'),
        meta: { title: '期货委托订单' }
      },
      {
        path: 'wpfuturesFillInfo',
        name: 'WpfuturesFillInfo',
        component: () => import('@/views/wpfutures/wpfuturesFillInfo'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'wpfuturesExchangeTradeDay',
        name: 'WpfuturesExchangeTradeDay',
        component: () => import('@/views/wpfutures/wpfuturesExchangeTradeDay'),
        meta: { title: '外盘交易日' }
      },
      {
        path: 'wpfuturesOrderInfoHis',
        name: 'WpfuturesOrderInfoHis',
        component: () => import('@/views/wpfutures/wpfuturesOrderInfoHis'),
        meta: { title: '期货委托订单历史' }
      },
      {
        path: 'wpfuturesAccountFeeRent',
        name: 'WpfuturesAccountFeeRent',
        component: () => import('@/views/wpfutures/wpfuturesAccountFeeRent'),
        meta: { title: '期货客户手续费计算参数' }
      },
      {
        path: 'wpfuturesAccountMarginRent',
        name: 'WpfuturesAccountMarginRent',
        component: () => import('@/views/wpfutures/wpfuturesAccountMarginRent'),
        meta: { title: '期货客户保证金计算参数' }
      }
    ]
  },
  {
    path: '/wpfutures',
    component: Layout,
    meta: { title: '外盘期货子账户' },
    children: [
      {
        path: 'subWpfuturesAccountInfo',
        name: 'SubWpfuturesAccountInfo',
        component: () => import('@/views/wpfutures/subWpfuturesAccountInfo'),
        meta: { title: '期货子账户资金账号' }
      },
      {
        path: 'subWpfuturesFundData',
        name: 'SubWpfuturesFundData',
        component: () => import('@/views/wpfutures/subWpfuturesFundData'),
        meta: { title: '期货子账户资金信息' }
      },
      {
        path: 'subWpfuturesPositionInfo',
        name: 'SubWpfuturesPositionInfo',
        component: () => import('@/views/wpfutures/subWpfuturesPositionInfo'),
        meta: { title: '期货子账户持仓信息' }
      },
      {
        path: 'subWpfuturesPositionSummaryInfo',
        name: 'SubWpfuturesPositionSummaryInfo',
        component: () => import('@/views/wpfutures/subWpfuturesPositionSummaryInfo'),
        meta: { title: '期货子账户持仓汇总信息' }
      },
      {
        path: 'subWpfuturesOrderInfo',
        name: 'SubWpfuturesOrderInfo',
        component: () => import('@/views/wpfutures/subWpfuturesOrderInfo'),
        meta: { title: '期货子账户委托订单' }
      },
      {
        path: 'subWpfuturesFillInfo',
        name: 'SubWpfuturesFillInfo',
        component: () => import('@/views/wpfutures/subWpfuturesFillInfo'),
        meta: { title: '期货子账户成交信息' }
      },
      {
        path: 'subWpfuturesOrderInfoHis',
        name: 'SubWpfuturesOrderInfoHis',
        component: () => import('@/views/wpfutures/subWpfuturesOrderInfoHis'),
        meta: { title: '期货子账户委托订单历史' }
      }
    ]
  },
  {
    path: '/npfutures',
    component: Layout,
    meta: { title: '内盘期货' },
    children: [
      {
        path: 'npfuturesBroker',
        name: 'NpfuturesBroker',
        component: () => import('@/views/npfutures/npfuturesBroker'),
        meta: { title: '期货经纪商' }
      },
      {
        path: 'npfuturesExchange',
        name: 'NpfuturesExchange',
        component: () => import('@/views/npfutures/npfuturesExchange'),
        meta: { title: '期货交易所' }
      },
      {
        path: 'npfuturesExchangeProduct',
        name: 'NpfuturesExchangeProduct',
        component: () => import('@/views/npfutures/npfuturesExchangeProduct'),
        meta: { title: '期货品种' }
      },
      {
        path: 'npfuturesExchangeInstrument',
        name: 'NpfuturesExchangeInstrument',
        component: () => import('@/views/npfutures/npfuturesExchangeInstrument'),
        meta: { title: '期货合约' }
      },
      {
        path: 'npfuturesDepthMarketData',
        name: 'NpfuturesDepthMarketData',
        component: () => import('@/views/npfutures/npfuturesDepthMarketData'),
        meta: { title: '期货行情' }
      },
      {
        path: 'npfuturesAccountInfo',
        name: 'NpfuturesAccountInfo',
        component: () => import('@/views/npfutures/npfuturesAccountInfo'),
        meta: { title: '期货资金帐号' }
      },
      {
        path: 'npfuturesTradingAccount',
        name: 'NpfuturesTradingAccount',
        component: () => import('@/views/npfutures/npfuturesTradingAccount'),
        meta: { title: '期货资金信息' }
      },
      {
        path: 'npfuturesInvestorPositionDetail',
        name: 'NpfuturesInvestorPositionDetail',
        component: () => import('@/views/npfutures/npfuturesInvestorPositionDetail'),
        meta: { title: '期货持仓明细' }
      },
      {
        path: 'npfuturesInvestorPosition',
        name: 'NpfuturesInvestorPosition',
        component: () => import('@/views/npfutures/npfuturesInvestorPosition'),
        meta: { title: '期货持仓汇总' }
      },
      {
        path: 'npfuturesOrder',
        name: 'NpfuturesOrder',
        component: () => import('@/views/npfutures/npfuturesOrder'),
        meta: { title: '期货委托订单' }
      },
      {
        path: 'npfuturesTrade',
        name: 'NpfuturesTrade',
        component: () => import('@/views/npfutures/npfuturesTrade'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'npfuturesExchangeTradeDay',
        name: 'NpfuturesExchangeTradeDay',
        component: () => import('@/views/npfutures/npfuturesExchangeTradeDay'),
        meta: { title: '内盘交易日' }
      },
      {
        path: 'npfuturesOrderHis',
        name: 'NpfuturesOrderHis',
        component: () => import('@/views/npfutures/npfuturesOrderHis'),
        meta: { title: '期货委托订单历史' }
      },
      {
        path: 'subNpfuturesAccountInfo',
        name: 'SubNpfuturesAccountInfo',
        component: () => import('@/views/npfutures/subNpfuturesAccountInfo'),
        meta: { title: '子账户期货资金帐号' }
      },
      {
        path: 'subNpfuturesOrder',
        name: 'SubNpfuturesOrder',
        component: () => import('@/views/npfutures/subNpfuturesOrder'),
        meta: { title: '子账户期货委托订单' }
      },
      {
        path: 'subNpfuturesOrderHis',
        name: 'SubNpfuturesOrderHis',
        component: () => import('@/views/npfutures/subNpfuturesOrderHis'),
        meta: { title: '子账户期货委托订单历史' }
      },
      {
        path: 'subNpfuturesPosition',
        name: 'SubNpfuturesPosition',
        component: () => import('@/views/npfutures/subNpfuturesPosition'),
        meta: { title: '子账户期货持仓汇总' }
      },
      {
        path: 'subNpfuturesPositionDetail',
        name: 'SubNpfuturesPositionDetail',
        component: () => import('@/views/npfutures/subNpfuturesPositionDetail'),
        meta: { title: '子账户期货持仓明细' }
      },
      {
        path: 'subNpfuturesTrade',
        name: 'SubNpfuturesTrade',
        component: () => import('@/views/npfutures/subNpfuturesTrade'),
        meta: { title: '子账户期货成交信息' }
      },
      {
        path: 'subNpfuturesTradingAccount',
        name: 'SubNpfuturesTradingAccount',
        component: () => import('@/views/npfutures/subNpfuturesTradingAccount'),
        meta: { title: '子账户期货资金信息' }
      },
      {
        path: 'npfuturesBrokerTradingParams',
        name: 'NpfuturesBrokerTradingParams',
        component: () => import('@/views/npfutures/npfuturesBrokerTradingParams'),
        meta: { title: '期货经纪公司交易参数' }
      },
      {
        path: 'npfuturesInstrumentCommissionRate',
        name: 'NpfuturesInstrumentCommissionRate',
        component: () => import('@/views/npfutures/npfuturesInstrumentCommissionRate'),
        meta: { title: '期货合约手续费率' }
      },
      {
        path: 'npfuturesInstrumentMarginRate',
        name: 'NpfuturesInstrumentMarginRate',
        component: () => import('@/views/npfutures/npfuturesInstrumentMarginRate'),
        meta: { title: '期货合约保证金率' }
      },
      {
        path: 'npfuturesInstrumentOrderCommRate',
        name: 'NpfuturesInstrumentOrderCommRate',
        component: () => import('@/views/npfutures/npfuturesInstrumentOrderCommRate'),
        meta: { title: '期货报单手续费表(中金所持有)' }
      }
    ]
  },
  {
    path: '/npfutures',
    component: Layout,
    meta: { title: '内盘期货（易盛版）' },
    children: [
      {
        path: 'esNpfuturesBrokerInfo',
        name: 'EsNpfuturesBrokerInfo',
        component: () => import('@/views/npfutures/esNpfuturesBrokerInfo'),
        meta: { title: '期货经纪商' }
      },
      {
        path: 'esNpfuturesExchangeInfo',
        name: 'EsNpfuturesExchangeInfo',
        component: () => import('@/views/npfutures/esNpfuturesExchangeInfo'),
        meta: { title: '期货交易所' }
      },
      {
        path: 'esNpfuturesExchangeCommodity',
        name: 'EsNpfuturesExchangeCommodity',
        component: () => import('@/views/npfutures/esNpfuturesExchangeCommodity'),
        meta: { title: '期货品种' }
      },
      {
        path: 'esNpfuturesExchangeContract',
        name: 'EsNpfuturesExchangeContract',
        component: () => import('@/views/npfutures/esNpfuturesExchangeContract'),
        meta: { title: '期货合约' }
      },
      {
        path: 'esNpfuturesQuoteWhole',
        name: 'EsNpfuturesQuoteWhole',
        component: () => import('@/views/npfutures/esNpfuturesQuoteWhole'),
        meta: { title: '期货行情' }
      },
      {
        path: 'esNpfuturesAccountInfo',
        name: 'EsNpfuturesAccountInfo',
        component: () => import('@/views/npfutures/esNpfuturesAccountInfo'),
        meta: { title: '期货资金帐号' }
      },
      {
        path: 'esNpfuturesFundData',
        name: 'EsNpfuturesFundData',
        component: () => import('@/views/npfutures/esNpfuturesFundData'),
        meta: { title: '期货资金信息' }
      },
      {
        path: 'esNpfuturesPositionInfo',
        name: 'EsNpfuturesPositionInfo',
        component: () => import('@/views/npfutures/esNpfuturesPositionInfo'),
        meta: { title: '期货持仓明细' }
      },
      {
        path: 'esNpfuturesCloseInfo',
        name: 'EsNpfuturesCloseInfo',
        component: () => import('@/views/npfutures/esNpfuturesCloseInfo'),
        meta: { title: '期货平仓记录' }
      },
      {
        path: 'esNpfuturesOrderInfo',
        name: 'EsNpfuturesOrderInfo',
        component: () => import('@/views/npfutures/esNpfuturesOrderInfo'),
        meta: { title: '期货委托订单' }
      },
      {
        path: 'esNpfuturesFillInfo',
        name: 'EsNpfuturesFillInfo',
        component: () => import('@/views/npfutures/esNpfuturesFillInfo'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'esNpfuturesExchangeTradeDay',
        name: 'EsNpfuturesExchangeTradeDay',
        component: () => import('@/views/npfutures/esNpfuturesExchangeTradeDay'),
        meta: { title: '内盘交易日' }
      },
      {
        path: 'esNpfuturesOrderInfoHis',
        name: 'EsNpfuturesOrderInfoHis',
        component: () => import('@/views/npfutures/esNpfuturesOrderInfoHis'),
        meta: { title: '期货委托订单历史' }
      },
      {
        path: 'esNpfuturesAccountRentInfo',
        name: 'EsNpfuturesAccountRentInfo',
        component: () => import('@/views/npfutures/esNpfuturesAccountRentInfo'),
        meta: { title: '期货委托费率表' }
      }
    ]
  },
  {
    path: '/okex',
    component: Layout,
    meta: { title: '数字货币(OKEx)' },
    children: [
      {
        path: 'exchangeApiConfig',
        name: 'exchangeApiConfig',
        component: () => import('@/views/digitalcurrency/common/exchangeApiConfigOkex'),
        meta: { title: '用户交易所api配置' }
      },
      {
        path: 'okexAccountAsset',
        name: 'okexAccountAsset',
        component: () => import('@/views/digitalcurrency/okex/okexAccountAsset'),
        meta: { title: '账户余额汇总' }
      },
      {
        path: 'okexAccountAssetBill',
        name: 'okexAccountAssetBill',
        component: () => import('@/views/digitalcurrency/okex/okexAccountAssetBill'),
        meta: { title: '账户资金流水' }
      },
      {
        path: 'okexAccountAssetDetail',
        name: 'okexAccountAssetDetail',
        component: () => import('@/views/digitalcurrency/okex/okexAccountAssetDetail'),
        meta: { title: '账户余额明细' }
      },
      {
        path: 'okexAccountConfig',
        name: 'okexAccountConfig',
        component: () => import('@/views/digitalcurrency/okex/okexAccountConfig'),
        meta: { title: '账户配置' }
      },
      {
        path: 'okexAccountDepositAddr',
        name: 'okexAccountDepositAddr',
        component: () => import('@/views/digitalcurrency/okex/okexAccountDepositAddr'),
        meta: { title: '账户充值地址' }
      },
      {
        path: 'okexAccountDepositHistory',
        name: 'okexAccountDepositHistory',
        component: () => import('@/views/digitalcurrency/okex/okexAccountDepositHistory'),
        meta: { title: '账户充值记录' }
      },
      {
        path: 'okexAccountFill',
        name: 'okexAccountFill',
        component: () => import('@/views/digitalcurrency/okex/okexAccountFill'),
        meta: { title: '账户账单流水' }
      },
      {
        path: 'okexAccountInterest',
        name: 'okexAccountInterest',
        component: () => import('@/views/digitalcurrency/okex/okexAccountInterest'),
        meta: { title: '账户计息记录' }
      },
      {
        path: 'okexAccountPosition',
        name: 'okexAccountPosition',
        component: () => import('@/views/digitalcurrency/okex/okexAccountPosition'),
        meta: { title: '账户持仓信息' }
      },
      {
        path: 'okexAccountWithdrawalHistory',
        name: 'okexAccountWithdrawalHistory',
        component: () => import('@/views/digitalcurrency/okex/okexAccountWithdrawalHistory'),
        meta: { title: '账户提币记录' }
      },
      {
        path: 'okexDepositWithdrawalCurrency',
        name: 'okexDepositWithdrawalCurrency',
        component: () => import('@/views/digitalcurrency/okex/okexDepositWithdrawalCurrency'),
        meta: { title: '充提币种' }
      },
      {
        path: 'okexInstruments',
        name: 'okexInstruments',
        component: () => import('@/views/digitalcurrency/okex/okexInstruments'),
        meta: { title: '产品信息' }
      },
      {
        path: 'okexMarketTickers',
        name: 'okexMarketTickers',
        component: () => import('@/views/digitalcurrency/okex/okexMarketTickers'),
        meta: { title: '行情信息' }
      },
      {
        path: 'okexTradeFill',
        name: 'okexTradeFill',
        component: () => import('@/views/digitalcurrency/okex/okexTradeFill'),
        meta: { title: '账户成交明细' }
      },
      {
        path: 'okexTradeOrder',
        name: 'okexTradeOrder',
        component: () => import('@/views/digitalcurrency/okex/okexTradeOrder'),
        meta: { title: '账户订单信息' }
      },
      {
        path: 'okexTradeOrderAlgo',
        name: 'okexTradeOrderAlgo',
        component: () => import('@/views/digitalcurrency/okex/okexTradeOrderAlgo'),
        meta: { title: '账户策略委托单' }
      }
    ]
  },
  {
    path: '/huobi',
    component: Layout,
    meta: { title: '数字货币(Huobi)' },
    children: [
      {
        path: 'exchangeApiConfig',
        name: 'exchangeApiConfigHuobi',
        component: () => import('@/views/digitalcurrency/common/exchangeApiConfigHuobi'),
        meta: { title: '用户交易所api配置' }
      },
      {
        path: 'huobiAccountDepositAddress',
        name: 'huobiAccountDepositAddress',
        component: () => import('@/views/digitalcurrency/huobi/huobiAccountDepositAddress'),
        meta: { title: '现货充值地址' }
      },
      {
        path: 'huobiAccountWithdrawAddress',
        name: 'huobiAccountWithdrawAddress',
        component: () => import('@/views/digitalcurrency/huobi/huobiAccountWithdrawAddress'),
        meta: { title: '现货提币地址' }
      },
      {
        path: 'huobiCurrencys',
        name: 'huobiCurrencys',
        component: () => import('@/views/digitalcurrency/huobi/huobiCurrencys'),
        meta: { title: '币种' }
      },
      {
        path: 'huobiDepositWithdrawRecord',
        name: 'huobiDepositWithdrawRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiDepositWithdrawRecord'),
        meta: { title: '现货充提记录' }
      },
      {
        path: 'huobiFuturesAccountAsset',
        name: 'huobiFuturesAccountAsset',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesAccountAsset'),
        meta: { title: '交割合约账户信息' }
      },
      {
        path: 'huobiFuturesAccountPosition',
        name: 'huobiFuturesAccountPosition',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesAccountPosition'),
        meta: { title: '交割合约账户持仓信息' }
      },
      {
        path: 'huobiFuturesCoinInstruments',
        name: 'huobiFuturesCoinInstruments',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesCoinInstruments'),
        meta: { title: '现货交易对' }
      },
      {
        path: 'huobiFuturesFinancialRecord',
        name: 'huobiFuturesFinancialRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesFinancialRecord'),
        meta: { title: '交割合约账户财务记录' }
      },
      {
        path: 'huobiFuturesOrder',
        name: 'huobiFuturesOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesOrder'),
        meta: { title: '交割合约账户订单信息' }
      },
      {
        path: 'huobiFuturesOrderDetail',
        name: 'huobiFuturesOrderDetail',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesOrderDetail'),
        meta: { title: '交割合约账户成交明细' }
      },
      {
        path: 'huobiFuturesOrderPlan',
        name: 'huobiFuturesOrderPlan',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesOrderPlan'),
        meta: { title: '交割合约计划委托' }
      },
      {
        path: 'huobiFuturesOrderTpsl',
        name: 'huobiFuturesOrderTpsl',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesOrderTpsl'),
        meta: { title: '交割合约止盈止损委托' }
      },
      {
        path: 'huobiFuturesSettlementRecord',
        name: 'huobiFuturesSettlementRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiFuturesSettlementRecord'),
        meta: { title: '交割合约账户结算记录' }
      },
      {
        path: 'huobiMarginAccountInfo',
        name: 'huobiMarginAccountInfo',
        component: () => import('@/views/digitalcurrency/huobi/huobiMarginAccountInfo'),
        meta: { title: '借币账户信息(逐仓)' }
      },
      {
        path: 'huobiMarginCrossAccountInfo',
        name: 'huobiMarginCrossAccountInfo',
        component: () => import('@/views/digitalcurrency/huobi/huobiMarginCrossAccountInfo'),
        meta: { title: '借币账户信息(全仓)' }
      },
      {
        path: 'huobiMarginCrossOrder',
        name: 'huobiMarginCrossOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiMarginCrossOrder'),
        meta: { title: '借币订单(全仓)' }
      },
      {
        path: 'huobiMarginLoanInfo',
        name: 'huobiMarginLoanInfo',
        component: () => import('@/views/digitalcurrency/huobi/huobiMarginLoanInfo'),
        meta: { title: '借币基础信息' }
      },
      {
        path: 'huobiMarginOrder',
        name: 'huobiMarginOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiMarginOrder'),
        meta: { title: '借币订单(逐仓)' }
      },
      {
        path: 'huobiSpotAccountBalance',
        name: 'huobiSpotAccountBalance',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountBalance'),
        meta: { title: '现货账户余额' }
      },
      {
        path: 'huobiSpotAccountFund',
        name: 'huobiSpotAccountFund',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountFund'),
        meta: { title: '现货账户流水' }
      },
      {
        path: 'huobiSpotAccountInfo',
        name: 'huobiSpotAccountInfo',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountInfo'),
        meta: { title: '现货账户信息' }
      },
      {
        path: 'huobiSpotAccountLedger',
        name: 'huobiSpotAccountLedger',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountLedger'),
        meta: { title: '现货账户财务流水' }
      },
      {
        path: 'huobiSpotAccountOrder',
        name: 'huobiSpotAccountOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountOrder'),
        meta: { title: '现货订单' }
      },
      {
        path: 'huobiSpotAccountOrderAlgo',
        name: 'huobiSpotAccountOrderAlgo',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountOrderAlgo'),
        meta: { title: '现货策略委托' }
      },
      {
        path: 'huobiSpotAccountOrderDetail',
        name: 'huobiSpotAccountOrderDetail',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotAccountOrderDetail'),
        meta: { title: '现货成交明细' }
      },
      {
        path: 'huobiSpotInstruments',
        name: 'huobiSpotInstruments',
        component: () => import('@/views/digitalcurrency/huobi/huobiSpotInstruments'),
        meta: { title: '现货交易对' }
      },
      {
        path: 'huobiSwapCoinAccountAsset',
        name: 'huobiSwapCoinAccountAsset',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinAccountAsset'),
        meta: { title: '永续合约账户信息' }
      },
      {
        path: 'huobiSwapCoinAccountPosition',
        name: 'huobiSwapCoinAccountPosition',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinAccountPosition'),
        meta: { title: '永续合约账户持仓信息' }
      },
      {
        path: 'huobiSwapCoinCoinInstruments',
        name: 'huobiSwapCoinCoinInstruments',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinCoinInstruments'),
        meta: { title: '现货交易对' }
      },
      {
        path: 'huobiSwapCoinFinancialRecord',
        name: 'huobiSwapCoinFinancialRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinFinancialRecord'),
        meta: { title: '永续合约账户财务记录' }
      },
      {
        path: 'huobiSwapCoinOrder',
        name: 'huobiSwapCoinOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinOrder'),
        meta: { title: '永续合约账户订单信息' }
      },
      {
        path: 'huobiSwapCoinOrderDetail',
        name: 'huobiSwapCoinOrderDetail',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinOrderDetail'),
        meta: { title: '永续合约账户成交明细' }
      },
      {
        path: 'huobiSwapCoinOrderPlan',
        name: 'huobiSwapCoinOrderPlan',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinOrderPlan'),
        meta: { title: '永续合约计划委托' }
      },
      {
        path: 'huobiSwapCoinOrderTpsl',
        name: 'huobiSwapCoinOrderTpsl',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinOrderTpsl'),
        meta: { title: '永续合约止盈止损委托' }
      },
      {
        path: 'huobiSwapCoinSettlementRecord',
        name: 'huobiSwapCoinSettlementRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCoinSettlementRecord'),
        meta: { title: '永续合约账户结算记录' }
      },
      {
        path: 'huobiSwapCrossUsdtSettlementRecord',
        name: 'huobiSwapCrossUsdtSettlementRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapCrossUsdtSettlementRecord'),
        meta: { title: '永续(U)合约全仓账户结算记录' }
      },
      {
        path: 'huobiSwapUsdtAccountAsset',
        name: 'huobiSwapUsdtAccountAsset',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtAccountAsset'),
        meta: { title: '永续(U)合约逐仓账户信息' }
      },
      {
        path: 'huobiSwapUsdtAccountPosition',
        name: 'huobiSwapUsdtAccountPosition',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtAccountPosition'),
        meta: { title: '永续(U)合约账户逐仓持仓信息' }
      },
      {
        path: 'huobiSwapUsdtCoinInstruments',
        name: 'huobiSwapUsdtCoinInstruments',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtCoinInstruments'),
        meta: { title: '现货交易对' }
      },
      {
        path: 'huobiSwapUsdtCrossAccountAsset',
        name: 'huobiSwapUsdtCrossAccountAsset',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAsset'),
        meta: { title: '永续(U)合约全仓账户信息' }
      },
      {
        path: 'huobiSwapUsdtCrossAccountAssetDetail',
        name: 'huobiSwapUsdtCrossAccountAssetDetail',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtCrossAccountAssetDetail'),
        meta: { title: '永续(U)合约全仓账户信息明细' }
      },
      {
        path: 'huobiSwapUsdtCrossAccountPosition',
        name: 'huobiSwapUsdtCrossAccountPosition',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtCrossAccountPosition'),
        meta: { title: '永续(U)合约账户全仓持仓信息' }
      },
      {
        path: 'huobiSwapUsdtFinancialRecord',
        name: 'huobiSwapUsdtFinancialRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtFinancialRecord'),
        meta: { title: '永续(U)合约账户财务记录' }
      },
      {
        path: 'huobiSwapUsdtOrder',
        name: 'huobiSwapUsdtOrder',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtOrder'),
        meta: { title: '永续(U)合约账户订单信息' }
      },
      {
        path: 'huobiSwapUsdtOrderDetail',
        name: 'huobiSwapUsdtOrderDetail',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtOrderDetail'),
        meta: { title: '永续(U)合约账户成交明细' }
      },
      {
        path: 'huobiSwapUsdtOrderPlan',
        name: 'huobiSwapUsdtOrderPlan',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtOrderPlan'),
        meta: { title: '永续(U)合约计划委托' }
      },
      {
        path: 'huobiSwapUsdtOrderTpsl',
        name: 'huobiSwapUsdtOrderTpsl',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtOrderTpsl'),
        meta: { title: '永续(U)合约止盈止损委托' }
      },
      {
        path: 'huobiSwapUsdtSettlementRecord',
        name: 'huobiSwapUsdtSettlementRecord',
        component: () => import('@/views/digitalcurrency/huobi/huobiSwapUsdtSettlementRecord'),
        meta: { title: '永续(U)合约逐仓账户结算记录' }
      }
    ]
  },
  {
    path: '/quant',
    component: Layout,
    meta: { title: '量化策略' },
    children: [
      {
        path: 'quantStrategyType',
        name: 'QuantStrategyType',
        component: () => import('@/views/quant/quantStrategyType'),
        meta: { title: '策略类型管理' }
      },
      {
        path: 'quantStrategyInfo',
        name: 'QuantStrategyInfo',
        component: () => import('@/views/quant/quantStrategyInfo'),
        meta: { title: '策略综合管理' }
      },
      {
        path: 'quantStrategyLog',
        name: 'QuantStrategyLog',
        component: () => import('@/views/quant/quantStrategyLog'),
        meta: { title: '策略运行日志' }
      },
      {
        path: 'quantStrategyVolume',
        name: 'QuantStrategyVolume',
        component: () => import('@/views/quant/quantStrategyVolume'),
        meta: { title: '策略成交量' }
      }
    ]
  },
  {
    path: '/npspot',
    component: Layout,
    meta: { title: '内盘现货' },
    children: [
      {
        path: 'NpSpotBroker',
        name: 'NpSpotBroker',
        component: () => import('@/views/npspot/npSpotBroker'),
        meta: { title: '现货经纪商' }
      },
      {
        path: 'NpSpotExchange',
        name: 'NpSpotExchange',
        component: () => import('@/views/npspot/npSpotExchange'),
        meta: { title: '现货交易所' }
      },
      {
        path: 'NpSpotExchangeInstrument',
        name: 'NpSpotExchangeInstrument',
        component: () => import('@/views/npspot/npSpotExchangeInstrument'),
        meta: { title: '现货证券信息' }
      },
      {
        path: 'NpSpotDepthMarketData',
        name: 'NpSpotDepthMarketData',
        component: () => import('@/views/npspot/npSpotDepthMarketData'),
        meta: { title: '现货证券行情' }
      },
      {
        path: 'NpSpotExchangeTradeDay',
        name: 'NpSpotExchangeTradeDay',
        component: () => import('@/views/npspot/npSpotExchangeTradeDay'),
        meta: { title: '现货交易日' }
      },
      {
        path: 'NpSpotAccountInfo',
        name: 'NpSpotAccountInfo',
        component: () => import('@/views/npspot/npSpotAccountInfo'),
        meta: { title: '现货投资者账号' }
      },
      {
        path: 'NpSpotTradingAccount',
        name: 'npSpotTradingAccount',
        component: () => import('@/views/npspot/npSpotTradingAccount'),
        meta: { title: '现货资金信息' }
      },
      {
        path: 'NpSpotInvestorPosition',
        name: 'npSpotInvestorPosition',
        component: () => import('@/views/npspot/npSpotInvestorPosition'),
        meta: { title: '现货持仓汇总' }
      },
      {
        path: 'NpSpotOrder',
        name: 'npSpotOrder',
        component: () => import('@/views/npspot/npSpotOrder'),
        meta: { title: '现货委托订单' }
      },
      {
        path: 'NpSpotTrade',
        name: 'npSpotTrade',
        component: () => import('@/views/npspot/npSpotTrade'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'NpSpotOrderHis',
        name: 'npSpotOrderHis',
        component: () => import('@/views/npspot/npSpotOrderHis'),
        meta: { title: '现货委托订单历史' }
      }
    ]
  },
  {
    path: '/npspot',
    component: Layout,
    meta: { title: '内盘现货(华鑫4.0)' },
    children: [
      {
        path: 'StpNpSpotBroker',
        name: 'StpNpSpotBroker',
        component: () => import('@/views/npspot/stpNpSpotBroker'),
        meta: { title: '现货经纪商' }
      },
      {
        path: 'StpNpSpotExchange',
        name: 'StpNpSpotExchange',
        component: () => import('@/views/npspot/stpNpSpotExchange'),
        meta: { title: '现货交易所' }
      },
      {
        path: 'StpNpSpotSecurity',
        name: 'StpNpSpotSecurity',
        component: () => import('@/views/npspot/stpNpSpotSecurity'),
        meta: { title: '现货证券信息' }
      },
      {
        path: 'StpNpSpotMarketData',
        name: 'StpNpSpotMarketData',
        component: () => import('@/views/npspot/stpNpSpotMarketData'),
        meta: { title: '现货证券行情' }
      },
      {
        path: 'StpNpSpotExchangeTradeDay',
        name: 'StpNpSpotExchangeTradeDay',
        component: () => import('@/views/npspot/stpNpSpotExchangeTradeDay'),
        meta: { title: '现货交易日' }
      },
      {
        path: 'StpNpSpotAccountInfo',
        name: 'StpNpSpotAccountInfo',
        component: () => import('@/views/npspot/stpNpSpotAccountInfo'),
        meta: { title: '现货投资者账号' }
      },
      {
        path: 'StpNpSpotShareHolderAccount',
        name: 'StpNpSpotShareHolderAccount',
        component: () => import('@/views/npspot/stpNpSpotShareHolderAccount'),
        meta: { title: '现货股东账户' }
      },
      {
        path: 'StpNpSpotTradingAccount',
        name: 'StpNpSpotTradingAccount',
        component: () => import('@/views/npspot/stpNpSpotTradingAccount'),
        meta: { title: '现货资金信息' }
      },
      {
        path: 'StpNpSpotPosition',
        name: 'StpNpSpotPosition',
        component: () => import('@/views/npspot/stpNpSpotPosition'),
        meta: { title: '现货持仓汇总' }
      },
      {
        path: 'StpNpSpotOrder',
        name: 'StpNpSpotOrder',
        component: () => import('@/views/npspot/stpNpSpotOrder'),
        meta: { title: '现货委托订单' }
      },
      {
        path: 'StpNpSpotTrade',
        name: 'StpNpSpotTrade',
        component: () => import('@/views/npspot/stpNpSpotTrade'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'StpNpSpotOrderHis',
        name: 'StpNpSpotOrderHis',
        component: () => import('@/views/npspot/stpNpSpotOrderHis'),
        meta: { title: '现货委托订单历史' }
      },
      {
        path: 'StpNpSpotInvestorTradingFee',
        name: 'StpNpSpotInvestorTradingFee',
        component: () => import('@/views/npspot/stpNpSpotInvestorTradingFee'),
        meta: { title: '现货佣金表' }
      },
      {
        path: 'StpNpSpotTradingFee',
        name: 'StpNpSpotTradingFee',
        component: () => import('@/views/npspot/stpNpSpotTradingFee'),
        meta: { title: '现货基础交易费率表' }
      }
    ]
  },
  {
    path: '/npspot',
    component: Layout,
    meta: { title: '内盘现货子账户(华鑫4.0)' },
    children: [
      {
        path: 'SubStpNpSpotAccountInfo',
        name: 'SubStpNpSpotAccountInfo',
        component: () => import('@/views/npspot/subStpNpSpotAccountInfo'),
        meta: { title: '现货投资者账号' }
      },
      {
        path: 'SubStpNpSpotTradingAccount',
        name: 'SubStpNpSpotTradingAccount',
        component: () => import('@/views/npspot/subStpNpSpotTradingAccount'),
        meta: { title: '现货资金信息' }
      },
      {
        path: 'SubStpNpSpotPosition',
        name: 'SubStpNpSpotPosition',
        component: () => import('@/views/npspot/subStpNpSpotPosition'),
        meta: { title: '现货持仓汇总' }
      },
      {
        path: 'SubStpNpSpotOrder',
        name: 'SubStpNpSpotOrder',
        component: () => import('@/views/npspot/subStpNpSpotOrder'),
        meta: { title: '现货委托订单' }
      },
      {
        path: 'SubStpNpSpotTrade',
        name: 'SubStpNpSpotTrade',
        component: () => import('@/views/npspot/subStpNpSpotTrade'),
        meta: { title: '期货成交信息' }
      },
      {
        path: 'SubStpNpSpotOrderHis',
        name: 'SubStpNpSpotOrderHis',
        component: () => import('@/views/npspot/subStpNpSpotOrderHis'),
        meta: { title: '现货委托订单历史' }
      }
    ]
  },
  {
    path: '/wpspot',
    component: Layout,
    meta: { title: '外盘现货' },
    children: [
      {
        path: 'wpSpotBroker',
        name: 'WpSpotBroker',
        component: () => import('@/views/wpspot/wpSpotBroker'),
        meta: { title: '外盘现货经纪商' }
      },
      {
        path: 'wpSpotExchange',
        name: 'WpSpotExchange',
        component: () => import('@/views/wpspot/wpSpotExchange'),
        meta: { title: '外盘现货交易所' }
      },
      {
        path: 'wpSpotExchangeInstrument',
        name: 'WpSpotExchangeInstrument',
        component: () => import('@/views/wpspot/wpSpotExchangeInstrument'),
        meta: { title: '外盘现货合约' }
      },
      {
        path: 'wpSpotDepthMarketData',
        name: 'WpSpotDepthMarketData',
        component: () => import('@/views/wpspot/wpSpotDepthMarketData'),
        meta: { title: '外盘现货行情' }
      },
      {
        path: 'wpSpotAccountInfo',
        name: 'WpSpotAccountInfo',
        component: () => import('@/views/wpspot/wpSpotAccountInfo'),
        meta: { title: '外盘现货资金帐号' }
      },
      {
        path: 'wpSpotTradingAccount',
        name: 'WpSpotTradingAccount',
        component: () => import('@/views/wpspot/wpSpotTradingAccount'),
        meta: { title: '外盘现货资金信息' }
      },
      {
        path: 'wpSpotInvestorPositionDetail',
        name: 'WpSpotInvestorPositionDetail',
        component: () => import('@/views/wpspot/wpSpotInvestorPositionDetail'),
        meta: { title: '外盘现货持仓明细' }
      },
      {
        path: 'wpSpotInvestorPosition',
        name: 'WpSpotInvestorPosition',
        component: () => import('@/views/wpspot/wpSpotInvestorPosition'),
        meta: { title: '外盘现货持仓汇总' }
      },
      {
        path: 'wpSpotOrder',
        name: 'WpSpotOrder',
        component: () => import('@/views/wpspot/wpSpotOrder'),
        meta: { title: '外盘现货委托订单' }
      },
      {
        path: 'wpSpotTrade',
        name: 'WpSpotTrade',
        component: () => import('@/views/wpspot/wpSpotTrade'),
        meta: { title: '外盘现货成交信息' }
      },
      {
        path: 'wpSpotExchangeTradeDay',
        name: 'WpSpotExchangeTradeDay',
        component: () => import('@/views/wpspot/wpSpotExchangeTradeDay'),
        meta: { title: '外盘现货交易日' }
      },
      {
        path: 'wpSpotOrderHis',
        name: 'WpSpotOrderHis',
        component: () => import('@/views/wpspot/wpSpotOrderHis'),
        meta: { title: '外盘现货委托订单历史' }
      },
      {
        path: 'wpSpotInstrumentCommissionRate',
        name: 'WpSpotInstrumentCommissionRate',
        component: () => import('@/views/wpspot/wpSpotInstrumentCommissionRate'),
        meta: { title: '外盘现货合约手续费率' }
      }
    ]
  },
  {
    path: '/wpspot',
    component: Layout,
    meta: { title: '外盘现货子账户' },
    children: [
      {
        path: 'subWpSpotAccountInfo',
        name: 'subWpSpotAccountInfo',
        component: () => import('@/views/wpspot/subWpSpotAccountInfo'),
        meta: { title: '外盘现货资金帐号' }
      },
      {
        path: 'subWpSpotTradingAccount',
        name: 'subWpSpotTradingAccount',
        component: () => import('@/views/wpspot/subWpSpotTradingAccount'),
        meta: { title: '外盘现货资金信息' }
      },
      {
        path: 'subWpSpotPositionDetail',
        name: 'subWpSpotPositionDetail',
        component: () => import('@/views/wpspot/subWpSpotPositionDetail'),
        meta: { title: '外盘现货持仓明细' }
      },
      {
        path: 'subWpSpotPosition',
        name: 'subWpSpotPosition',
        component: () => import('@/views/wpspot/subWpSpotPosition'),
        meta: { title: '外盘现货持仓汇总' }
      },
      {
        path: 'subWpSpotOrder',
        name: 'subWpSpotOrder',
        component: () => import('@/views/wpspot/subWpSpotOrder'),
        meta: { title: '外盘现货委托订单' }
      },
      {
        path: 'subWpSpotTrade',
        name: 'subWpSpotTrade',
        component: () => import('@/views/wpspot/subWpSpotTrade'),
        meta: { title: '外盘现货成交信息' }
      },
      {
        path: 'subWpSpotOrderHis',
        name: 'subWpSpotOrderHis',
        component: () => import('@/views/wpspot/subWpSpotOrderHis'),
        meta: { title: '外盘现货委托订单历史' }
      }
    ]
  },
  {
    path: '/404',
    name: 'Page404',
    component: () => import('@/views/404'),
    hidden: true
  },
  // 404 page must be placed at the end !!!
  { path: '*', redirect: '/404', hidden: true }
];

const createRouter = () => new Router({
  mode: 'history',
  routes: constantRoutes
});

const router = createRouter();

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter();
  router.matcher = newRouter.matcher; // reset router
}

export default router;
