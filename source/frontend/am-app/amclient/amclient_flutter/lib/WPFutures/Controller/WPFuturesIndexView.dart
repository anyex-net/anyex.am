import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Base/MyTextInputFormatter.dart';
import 'package:amclient_flutter/WPFutures/Http/WPFuturesHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/Model/WPFuturesIndexResponseModel.dart';
import 'package:amclient_flutter/WPFutures/Model/WPFuturesSocketModel.dart';
import 'package:amclient_flutter/WPFutures/View/WPFuturesViewWidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neveruseless/never/neverBus.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';
import 'package:neveruseless/neveruseless.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:date_format/date_format.dart' as DateFormat;

const double kLeftBarWidth = 72.0;
const double kTransactionPanelWidth = 290.0;
const double kSpotWidth = 230.0;

class WPFuturesIndexView extends StatefulWidget {
  final arguments;
  const WPFuturesIndexView({Key? key, this.arguments}) : super(key: key);

  @override
  _WPFuturesIndexViewState createState() => _WPFuturesIndexViewState();
}
class _WPFuturesIndexViewState extends State<WPFuturesIndexView> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {

  //币对选择页面是否显示
  bool _isShowCurrencyPick = true;
  //外盘期货交易所信息
  List<WpFuturesExchangeInfoListData>? _wpFuturesExchangeList = [];
  //选择的交易所
  String? _selectIndexExchangeNo = '';
  String _tempExchangeNo = '';

  //外盘期货品种信息
  List<WpFuturesExchangeCommodityListData>? _wpFuturesCommodityList = [];
  List<WpFuturesExchangeCommodityListData>? _tempWpFuturesCommodityList = [];
  //选择的外盘期货交易所期货品种ID
  String? _selectIndexCommodityID = '';
  String _tempCommodityID = '';
  //选择的外盘期货交易所期货品种No
  String? _selectIndexCommodityNo = '';
  //该品种下的交易货币
  String? _selectIndexTradeCurrency = '';
  String _tempTradeCurrency = '';

  //外盘期货交易所期货合约信息管理
  List<WpFuturesExchangeContractListData>? _wpFuturesContractList = [];
  List<WpFuturesExchangeContractListData>? _tempWpFuturesContractList = [];
  //选择的外盘期货交易所期货合约ID
  String? _selectIndexContractNo = '';
  String? _selectIndexContractID = '';
  String _tempContractID = '';
  //选择的外盘期货交易所期货合约对象
  WpFuturesExchangeContractListData? _selectIndexExchangeContractData;

  //外盘期货资金账号资金信息
  List<WpFuturesFundDataListData>? _wpFuturesFundDataList = [];
  //外盘期货成交
  List<WpFuturesFillInfoListData>? _wpFuturesFillInfoList = [];
  int _wpFuturesFillInfoPage = 1;
  bool? _wpFuturesFillInfohasNextPage = false;
  //外盘期货所有持仓信息
  List<WpFuturesPositionSummaryInfoListData>? _wpFuturesPositionSummaryInfoList = [];
  int _wpFuturesPositionSummaryPage = 1;
  bool? _wpFuturesPositionSummaryhasNextPage = false;
  //外盘期货委托订单
  List<WpFuturesOrderInfoListData>? _wpFuturesOrderInfoListData = [];
  int _wpFuturesOrderInfoPage = 1;
  bool? _wpFuturesOrderInfohasNextPage = false;
  //外盘期货历史委托订单
  List<WpFuturesOrderInfoListData>? _wpFuturesOrderInfoHisListData = [];
  int _wpFuturesOrderInfoHisPage = 1;
  bool? _wpFuturesOrderInfoHishasNextPage = false;

  //Socket Ticker模型
  WpFuturesSocketTickerModel? _socketTickerModel;

  //盘口与实时成交
  String _selectTransactionType = '买卖盘口';//order 盘口 trade 成交
  final List _selectTransactionTypeName = ['买卖盘口','最新成交'];

  //个人资产
  String _selectAssetEntrustmentType = '资产';//order 盘口 trade 成交
  final List _selectAssetEntrustmentTypeName = ['当前委托','历史委托','历史成交','持仓','资产'];

  //交易面板
  String _selectTransactionPanelType = '限价委托';//order 盘口 trade 成交
  final List _selectTransactionPanelTypeName = ['限价委托','市价委托','限价止损','市价止损',];

  //最新成交
  List _tradesList = [];

  //盘口深度
  List _tickAsksList = [];
  List _tickBidsList = [];
  List _tickAsksQtysList = [];
  List _tickBidsQtysList = [];

  //K线
  String _selectKlineTimeType = '2'; // 1 : 1分 2：5分 3：15分 4：30分 5：60分 6：24小时
  String _selectKlineTimeTypeName = '5分';//order 盘口 trade 成交
  bool _isTimeLine = false;
  final List _klineTimeTypeAllList = ['分时','1分','5分','15分','30分','60分','1日'];
  MainState _mainState = MainState.MA;
  String _mainStateName = 'MA';//order 盘口 trade 成交
  final List _mainStateList = ["MA", "BOLL", "NONE"];

  SecondaryState _secondaryState = SecondaryState.NONE;
  String _secondaryStateName = 'NONE';//order 盘口 trade 成交
  final List _secondaryStateList = ["NONE", "MACD", "KDJ","RSI","WR","CCI",];//{ MACD, KDJ, RSI, WR, CCI, NONE }

  List<KLineEntity>? _KLineList;

  //保证金率
  List<WpFuturesAccountMarginRentListData>? _marginRentListData;
  String _initialMarginTitle = '买入保证金:';
  String _initialMargin = '-';
  String _sellInitialMarginTitle = '卖出保证金:';
  String _sellInitialMargin = '-';
  //手续费率
  List<WpFuturesAccountFeeRentListData>? _feeRentListData;
  String _openFeeTitle = '买入手续费:';
  String _closeFeeTitle = '卖出手续费:';
  String _openCloseFee = '-';


  //交易面板套件
  final TextEditingController _transactionPriceController = TextEditingController();
  final TextEditingController _transactionNumberController = TextEditingController();
  final TextEditingController _transactionAmountController = TextEditingController();


  @override
  bool get wantKeepAlive => true;


  Timer? _timer;
  Timer? _privateTimer;

  //翻译字典
  Map? _bigOrderTranslate = {}; // 订单
  Map? _bigDealTranslate = {}; //成交
  Map? _bigSummaryInfoTranslate = {};//持仓汇总信息
  Map? _bigAssetInfoTranslate = {};
  List? _bigQuotationTranslate = [];

  //Socket套件
  bool _isSocektOn = false;
  late IOWebSocketChannel _channel;

  Animation<double>? _animation;
  AnimationController? _controller;

  var _lastPopTime = DateTime.now();



  //下部面板是否隐藏
  bool _accountWidgetShow = true;

  //盘口最新成交是否隐藏
  bool _spotWidgetHandicapShow = true;

  double _accountWidgetHeadYT = 0.0;
  double _accountWidgetHeight = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;
  double _accountWidgetHeightT = (window.physicalSize.height * 0.15) > 120.0 ? window.physicalSize.height * 0.15 : 120.0;

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();
  final ScrollController _controller4 = ScrollController();
  final ScrollController _controller5 = ScrollController();
  final ScrollController _controller6 = ScrollController();
  final ScrollController _controller7 = ScrollController();
  final ScrollController _controller8 = ScrollController();
  final ScrollController _controller9 = ScrollController();
  final ScrollController _controller10 = ScrollController();
  final ScrollController _controller11 = ScrollController();
  final ScrollController _controller12 = ScrollController();
  final ScrollController _controller13 = ScrollController();
  final ScrollController _controller14 = ScrollController();
  final ScrollController _controller15 = ScrollController();
  final ScrollController _controller16 = ScrollController();
  final ScrollController _controller17 = ScrollController();
  final ScrollController _controller18 = ScrollController();
  final ScrollController _controller19 = ScrollController();
  final ScrollController _controller20 = ScrollController();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('Assets/WPFuturesTranslateModel.json').then((value){
      List _translateAll = json.decode(value);
      for(int i=0;i<_translateAll.length;i++){
        if(_translateAll[i]['typeName'] == '订单'){
          _bigOrderTranslate = _translateAll[i]['typeContent'];
        }else if(_translateAll[i]['typeName'] == '成交'){
          _bigDealTranslate = _translateAll[i]['typeContent'];
        }else if(_translateAll[i]['typeName'] == '持仓汇总信息'){
          _bigSummaryInfoTranslate = _translateAll[i]['typeContent'];
        }else if(_translateAll[i]['typeName'] == '资产信息'){
          _bigAssetInfoTranslate = _translateAll[i]['typeContent'];
        }else if(_translateAll[i]['typeName'] == '行情'){
          _bigQuotationTranslate = _translateAll[i]['typeContent'];
        }else{
          break;
        }
      }
    });
    _WPFuturesWpfuturesExchangeInfoQryEsunnyCommonDataHttp();
    _channel = IOWebSocketChannel.connect(kWPFuturesSocketAddress);
    _isSocektOn = true;
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    //底部栏切换动作 1：点击到当前页面是 应该有一次刷新动作 2：socket应该重连一次，3：离开时关闭socket
    neverBus.on('pageController', (object) {
      if(!mounted){
        return;
      }
      setState(() {
        if(object == '/WPFuturesIndexView') {
          print("打开外盘期货界面");
          setState(() {
            _isShowCurrencyPick = true;
          });
          _WPFuturesWpfuturesExchangeInfoQryEsunnyCommonDataHttp();
          if(!_isSocektOn){
            _onRest();
          }
        }else{
          if(_isSocektOn){
            try{
              _onSendUnSocket();
              _channel.sink.close();
            }catch(e){
              try{
                _channel.sink.close();
              }catch(e){
                print("外盘Socket异常未处理关闭");
              }
            }
          }
        }
      });
    });
    neverBus.on('LoginSuccess', (object){
      if(!mounted){
        return;
      }
      _WPFuturesWpfuturesExchangeInfoQryEsunnyCommonDataHttp();
      _WPFuturesWpfuturesExchangeContractInitHttp();
    });
    neverBus.on('WPFuturesIndexReload', (object){
      if(!mounted){
        return;
      }
      _WPFuturesWpfuturesExchangeInfoDataHttp();
      _WPFuturesWpfuturesFundDataDataHttp();
    });
    // _onSendSocket();
    _WPFuturesWpfuturesExchangeContractInitHttp();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          if(_controller!.status == AnimationStatus.completed){
            _controller!.reset();
          }
        });
      });
  }

  String _findTrans(Map typeMap , String key,String code){
    if(typeMap.isEmpty){
      return code;
    }
    if(key == ''){
      return code;
    }
    if(code == ''){
      return code;
    }
    try{
      if(typeMap.containsKey(key)){
        List _list = typeMap[key];
        for(int i=0;i<_list.length;i++){
          if(_list[i]['key'] == code) {
            return _list[i]['value'];
          }
        }
        return code;
      }else{
        return code;
      }
    }catch(e){
      return code;
    }
  }

  //初始化外盘期货部分公共数据
  Future _WPFuturesWpfuturesExchangeInfoQryEsunnyCommonDataHttp() async{
    var response = await WPFuturesWpfuturesExchangeInfoQryEsunnyCommonData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        _WPFuturesWpfuturesExchangeInfoDataHttp();
        _WPFuturesWpfuturesFundDataDataHttp();
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[初始化外盘期货]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[初始化外盘期货]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货交易所信息
  Future _WPFuturesWpfuturesExchangeInfoDataHttp() async{
    var response = await WPFuturesWpfuturesExchangeInfoData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpFuturesExchangeList = WpFuturesExchangeInfoResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货交易所信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货交易所信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货交易所期货品种信息管理
  Future _WPFuturesWpfuturesExchangeCommodityDataHttp({String exchangeNo = ''}) async{
    var response = await WPFuturesWpfuturesExchangeCommodityData(exchangeNo: exchangeNo);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpFuturesCommodityList = WpFuturesExchangeCommodityResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货交易所期货品种信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货交易所期货品种信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //初始化外盘期货交易所期货合约信息
  Future _WPFuturesWpfuturesExchangeContractQryExchangeContractByAccountNoExchangeNoHttp({String commodityNo = '',String exchangeNo = ''}) async{
    var response = await WPFuturesWpfuturesExchangeContractQryExchangeContractByAccountNoExchangeNo(commodityNo: commodityNo,exchangeNo: exchangeNo);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        _WPFuturesWpfuturesExchangeContractDataHttp(commodityNo: commodityNo,exchangeNo: exchangeNo);
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[初始化外盘期货交易所]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[初始化外盘期货交易所]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货交易所期货合约信息管理
  Future _WPFuturesWpfuturesExchangeContractDataHttp({String commodityNo = '',String exchangeNo = ''}) async{
    var response = await WPFuturesWpfuturesExchangeContractData(exchangeNo: exchangeNo,commodityNo: commodityNo);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpFuturesContractList = WpFuturesExchangeContractResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货合约信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货合约信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货交易所期货合约 -默认款
  Future _WPFuturesWpfuturesExchangeContractInitHttp() async{
    var response = await WPFuturesWpfuturesExchangeContractInit();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _selectIndexExchangeContractData = WpFuturesExchangeContractListData.fromJson(response["object"]);
          _selectIndexExchangeNo = _selectIndexExchangeContractData!.exchangeNo;
          _selectIndexCommodityNo = _selectIndexExchangeContractData!.commodityNo;
          _selectIndexContractNo = _selectIndexExchangeContractData!.contractNo1;
          _selectIndexContractID = _selectIndexExchangeContractData!.id;
          _selectIndexTradeCurrency = _selectIndexExchangeContractData!.tradeCurrency;
          _WpfuturesWpfuturesAccountMarginRentDataHttp(
            exchangeNo: _selectIndexExchangeContractData!.exchangeNo!,
            commodityType: _selectIndexExchangeContractData!.commodityType!,
            commodityNo: _selectIndexExchangeContractData!.commodityNo!,
            contractNo: _selectIndexExchangeContractData!.contractNo1!,
          );
          _WpfuturesWpfuturesAccountFeeRentDataHttp(
            exchangeNo: _selectIndexExchangeContractData!.exchangeNo!,
            commodityType: _selectIndexExchangeContractData!.commodityType!,
            commodityNo: _selectIndexExchangeContractData!.commodityNo!,
          );
          _onSendSocket();
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货默认合约信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货默认合约信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //初始化外盘期货行情
  Future _WPFuturesWpfuturesSubscribeQuoteWholeSubscribeQuoteWholeHttp({String commodityNo = '',String exchangeNo = '',String contractNo = ''})async{
    var response = await WPFuturesWpfuturesSubscribeQuoteWholeSubscribeQuoteWhole(exchangeNo: exchangeNo,commodityNo: commodityNo,contractNo: contractNo);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {

        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[初始化外盘期货行情]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[初始化外盘期货行情]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘期货资金账号资金信息
  Future _WPFuturesWpfuturesFundDataDataHttp() async{
    var response = await WPFuturesWpfuturesFundDataData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _wpFuturesFundDataList = WpFuturesFundDataResponseData.fromJson(response).object;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货资金账号]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货资金账号]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘期货成交
  Future _WPFuturesWpfuturesFillInfoDataHttp() async{
    var response = await WPFuturesWpfuturesFillInfoData(page:_wpFuturesFillInfoPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        setState(() {
          if (_wpFuturesFillInfoPage == 1) {
            _wpFuturesFillInfoList = WpFuturesFillInfoResponseData.fromJson(response).rows;
          } else {
            _wpFuturesFillInfoList!.addAll(WpFuturesFillInfoResponseData.fromJson(response).rows!.toList());
          }
          _wpFuturesFillInfohasNextPage = WpFuturesFillInfoResponseData.fromJson(response).hasNext ?? false;
        });
      } else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货成交记录]遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货成交记录]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘期货所有持仓信息
  Future _WPFuturesWpfuturesPositionSummaryInfoDataHttp() async{
    var response = await WPFuturesWpfuturesPositionSummaryInfoData(page: _wpFuturesPositionSummaryPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          if (_wpFuturesPositionSummaryPage == 1) {
            _wpFuturesPositionSummaryInfoList = WpFuturesPositionSummaryInfoResponseData.fromJson(response).rows;
          } else {
            _wpFuturesPositionSummaryInfoList!.addAll(WpFuturesPositionSummaryInfoResponseData.fromJson(response).rows!.toList());
          }
          _wpFuturesPositionSummaryhasNextPage = WpFuturesPositionSummaryInfoResponseData.fromJson(response).hasNext ?? false;
        });
      }else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货持仓信息]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货持仓信息]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘期货委托订单
  Future _WPFuturesWpfuturesOrderInfoDataHttp() async{
    var response = await WPFuturesWpfuturesOrderInfoData(page: _wpFuturesOrderInfoPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        setState(() {
          if (_wpFuturesOrderInfoPage == 1) {
            _wpFuturesOrderInfoListData = WpFuturesOrderInfoResponseData.fromJson(response).rows;
          } else {
            _wpFuturesOrderInfoListData!.addAll(WpFuturesOrderInfoResponseData.fromJson(response).rows!.toList());
          }
          _wpFuturesOrderInfohasNextPage = WpFuturesFillInfoResponseData.fromJson(response).hasNext ?? false;
        });
      } else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货委托订单]遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货委托订单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //查询外盘期货历史委托订单
  Future _WPFuturesWpfuturesOrderInfoHisDataHttp() async{
    var response = await WPFuturesWpfuturesOrderInfoHisData(page: _wpFuturesOrderInfoHisPage);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        setState(() {
          if (_wpFuturesOrderInfoHisPage == 1) {
            _wpFuturesOrderInfoHisListData = WpFuturesOrderInfoResponseData.fromJson(response).rows;
          } else {
            _wpFuturesOrderInfoHisListData!.addAll(WpFuturesOrderInfoResponseData.fromJson(response).rows!.toList());
          }
          _wpFuturesOrderInfoHishasNextPage = WpFuturesFillInfoResponseData.fromJson(response).hasNext ?? false;
        });
      } else {
        try{
          showMyCustomText(response['message']);
        }catch(e){
          showMyCustomText('[获取外盘期货历史委托订单]遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取外盘期货历史委托订单]外盘历史委托接口遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货委托撤单
  Future _WPFuturesWpfuturesOrderInfoCancelOrderHttp({String accountNo = '',String orderNo = ''}) async{
    var response = await WPFuturesWpfuturesOrderInfoCancelOrder(accountNo: accountNo,orderNo:orderNo);
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _wpFuturesOrderInfoPage = 1;
          _WPFuturesWpfuturesOrderInfoDataHttp();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货委托撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货委托批量撤单
  Future _WPFuturesWpfuturesOrderInfoBatchCancelOrderHttp() async{
    var response = await WPFuturesWpfuturesOrderInfoBatchCancelOrder();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("批量撤单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _wpFuturesOrderInfoPage = 1;
          _WPFuturesWpfuturesOrderInfoDataHttp();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货批量撤单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货委托下单
  Future _WPFuturesWpfuturesOrderInfoInsertOrderHttp({String accountNo = '',String commodityNo = '',String contractNo = '', String exchangeNo = '',String orderPrice = '',String orderQty = '', String orderSide = '',String orderType = '',String timeInForce = '',}) async{
    var response = await WPFuturesWpfuturesOrderInfoInsertOrder(
        accountNo:accountNo,
        commodityNo:commodityNo,
        contractNo:contractNo,
        exchangeNo:exchangeNo,
        orderPrice:orderPrice,
        orderQty:orderQty,
        orderSide:orderSide,
        orderType:orderType,
        timeInForce:timeInForce,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        showMyCustomText("下单成功");
        Future.delayed(const Duration(milliseconds: 300)).then((onValue) async{
          _refreshEveryWhere();
        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText(response["message"]);
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货下单]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货 保证金率
  Future _WpfuturesWpfuturesAccountMarginRentDataHttp({String contractNo = '', String commodityNo = '',String exchangeNo = '',String commodityType = ''}) async {
    var response = await WpfuturesWpfuturesAccountMarginRentData(
        contractNo:contractNo,
        commodityNo:commodityNo,
        exchangeNo:exchangeNo,
        commodityType:commodityType,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {
        _marginRentListData = WpFuturesAccountMarginRentResponseData.fromJson(response).object;
        if(_marginRentListData!.isNotEmpty){
          if(_marginRentListData!.first.calculateMode! == '1'){
            _initialMarginTitle = '买入保证金率:';
            _initialMargin = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_marginRentListData!.first.initialMargin!) * 100, 2)).toString() + "%";
            _sellInitialMarginTitle = '卖出保证金率:';
            _sellInitialMargin = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_marginRentListData!.first.sellInitialMargin!) * 100, 2)).toString() + "%";
          }else if(_marginRentListData!.first.calculateMode! == '2'){
            _initialMarginTitle = '买入保证金:';
            _initialMargin = _marginRentListData!.first.initialMargin!;
            _sellInitialMarginTitle = '卖出保证金:';
            _sellInitialMargin = _marginRentListData!.first.sellInitialMargin!;
          }else{
            _initialMarginTitle = '买入保证金:';
            _initialMargin = _marginRentListData!.first.initialMargin!;
            _sellInitialMarginTitle = '卖出保证金:';
            _sellInitialMargin = _marginRentListData!.first.sellInitialMargin!;
          }
        }else{
          _initialMarginTitle = '买入保证金:';
          _initialMargin = '-';
          _sellInitialMarginTitle = '卖出保证金:';
          _sellInitialMargin = '-';
        }


        setState(() {

        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText('[外盘期货保证金率]遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货保证金率]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //外盘期货 手续费率
  Future _WpfuturesWpfuturesAccountFeeRentDataHttp({String commodityNo = '',String exchangeNo = '',String commodityType = ''}) async {
    var response = await WpfuturesWpfuturesAccountFeeRentData(
      commodityNo:commodityNo,
      exchangeNo:exchangeNo,
      commodityType:commodityType,
    );
    if (response is Map) {
      if(!mounted){
        return;
      }
      if (response["code"] == 200) {

        _feeRentListData = WpFuturesAccountFeeRentResponseData.fromJson(response).object;
        if(_feeRentListData!.isNotEmpty){
          if(_feeRentListData!.first.calculateMode! == '1'){
            _openFeeTitle = '买入手续费率:';
            _closeFeeTitle = '卖出手续费率:';
            _openCloseFee = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_feeRentListData!.first.openCloseFee!) * 100, 2)).toString() + "%";
          }else if(_feeRentListData!.first.calculateMode! == '0' || _feeRentListData!.first.calculateMode! == '2'){
            _openFeeTitle = '买入手续费:';
            _closeFeeTitle = '卖出手续费:';
            _openCloseFee = _feeRentListData!.first.openCloseFee!;
          }else{
            _openFeeTitle = '买入手续费:';
            _closeFeeTitle = '卖出手续费:';
            _openCloseFee = _feeRentListData!.first.openCloseFee!;
          }
        }else{
          _openFeeTitle = '买入手续费:';
          _closeFeeTitle = '卖出手续费:';
          _openCloseFee = '-';
        }
        setState(() {

        });
      } else {
        try{
          showMyCustomText("code:"  + response["code"].toString() + " " +  response["message"]);
        }catch(e){
          showMyCustomText('[外盘期货保证金率]遇到问题，请检查网络或重新刷新');
        }
      }
    } else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[外盘期货保证金率]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  //Socket订阅语句
  _onSendSocket(){
    if(_selectIndexContractNo! == ''){
      print("无数据不发sub");
      return;
    }
    String subsStr= "{\"subs\":\"quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".entrust,"
        + "quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".trade,"
        + "quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".kline." + _selectKlineTimeType
        + "\"}";

    // print(subsStr);
    _channel.sink.add(subsStr);
  }

  _onSendUnSocket(){
    if(_selectIndexContractNo! == ''){
      print("无数据不发unsub");
      return;
    }
    String subsStr= "{\"unsubs\":\"quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".entrust,"
        + "quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".trade,"
        + "quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".kline." + _selectKlineTimeType
        + "\"}";

    // print(subsStr);
    _channel.sink.add(subsStr);
  }

  _onData(event){
    if (!mounted) {
      return;
    }
    try{
      if(utf8.decode(event) == 'ping'){
        return;
      }
      // print(utf8.decode(event));
      Map _initDateMap = jsonDecode(utf8.decode(event));
      //最新成交，深度
      if(_initDateMap["depth"].toString() != '' && _initDateMap["depth"].toString() != 'null'){
        setState(() {
          Map _socketDepthMap = jsonDecode(_initDateMap["depth"]);
          _tickAsksList = _socketDepthMap['askPrices'].toString().split(",");
          _tickBidsList = _socketDepthMap['bidPrices'].toString().split(",");
          _tickAsksQtysList = _socketDepthMap['askQtys'].toString().split(",");
          _tickBidsQtysList = _socketDepthMap['bidQtys'].toString().split(",");
        });
      }
      //头部栏
      if(_initDateMap["ticker"].toString() != '' && _initDateMap["ticker"].toString() != 'null'){
        setState(() {
          Map _socketTickerMap = jsonDecode(_initDateMap["ticker"]);
          _socketTickerModel = WpFuturesSocketTickerModel.fromJson(_socketTickerMap);
        });
      }
      //K线
      if(_initDateMap["klines"].toString() != '' && _initDateMap["klines"].toString() != 'null'){
        List _list = jsonDecode(_initDateMap["klines"].toString());
        if(_list.isNotEmpty){
          if(_list.first['commodityCode'].toString() == _selectIndexCommodityNo && _list.first['contractCode'].toString() == _selectIndexContractNo && _list.first['exchange'].toString() == _selectIndexExchangeNo){
            if(_KLineList == null || _KLineList!.length == 0 || _KLineList!.last.commodityCode.toString() != _selectIndexCommodityNo || _KLineList!.last.contractCode.toString() != _selectIndexContractNo || _KLineList!.last.exchange.toString() != _selectIndexExchangeNo){
              _KLineList = _list.map((item) => KLineEntity.wpfromJson(item)).toList().cast<KLineEntity>();
              if(mounted){
                setState(() {
                  DataUtil.calculate(_KLineList!);
                });
              }
            }else{
              if(_KLineList == null || _KLineList!.length == 0 || _KLineList!.last.timeType.toString() != _selectKlineTimeType){
                _KLineList = _list.map((item) => KLineEntity.wpfromJson(item)).toList().cast<KLineEntity>();
                if(mounted){
                  setState(() {
                    DataUtil.calculate(_KLineList!);
                  });
                }
              }else{
                for(int i =0; i<_list.length;i++){
                  if((_KLineList!.last.time ?? 0) > (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    break;
                  }else if ((_KLineList!.last.time ?? 0) == (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    _KLineList!.removeLast();
                    _KLineList!.add(KLineEntity.wpfromJson(_list[i]));
                    if(mounted){
                      setState(() {
                        DataUtil.calculate(_KLineList!);
                      });
                    }
                  }else if ((_KLineList!.last.time ?? 0) < (int.tryParse(_list[i]['displayTime'].toString()) ?? 0)){
                    _KLineList!.add(KLineEntity.wpfromJson(_list[i]));
                    if(_KLineList!.length > 300){
                      _KLineList!.removeAt(0);
                    }
                    if(mounted){
                      setState(() {
                        DataUtil.calculate(_KLineList!);
                      });
                    }
                  }else{
                  }
                }
              }
            }
          }
        }
      }
      //最新成交
      if(_initDateMap["trades"].toString() != '' && _initDateMap["trades"].toString() != 'null'){
        if(_initDateMap['topic'] == ("quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo!)){
          List _list = jsonDecode(_initDateMap["trades"].toString());
          if(_list.isNotEmpty){
            if(_tradesList.isEmpty){
              _tradesList.addAll(_list);
            }else{
              _tradesList.insertAll(0,_list);
              if(_tradesList.length > 200){
                _tradesList.removeRange(200, _tradesList.length);
              }
            }
          }
        }else{
          _tradesList.clear();
        }
      }
    }catch(e){
      print(e);
    }
  }

  _onError(err){
    print("外盘期货WebSocket错误");
    WebSocketChannelException ex = err;
    print(ex);
    _isSocektOn = false;
  }

  _onDone(){
    print("外盘期货WebSocket断开");
    _isSocektOn = false;
  }

  _onRest(){
    print("外盘期货WebSocket重连");
    _channel=IOWebSocketChannel.connect(kWPFuturesSocketAddress);//brokerId=9999
    _isSocektOn = true;
    _channel.stream.listen(_onData, onError: _onError, onDone: _onDone);
    _onSendSocket();
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    if(_privateTimer != null){
      _privateTimer!.cancel();
    }
    _controller!.dispose();
    neverBus.off('pageController');
    neverBus.off('LoginSuccess');
    neverBus.off('WPFuturesIndexReload');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("外盘期货"),
          ),
          body:GestureDetector(
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Column(
                children: [
                  _selectTickerView(),
                  Expanded(
                    child: Stack(
                      alignment: const Alignment(-1,0),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: _SpotWidget(),
                                color: Colors.transparent,
                              ),
                              flex: 3,
                            ),
                            Container(
                              width: kTransactionPanelWidth,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              padding: const EdgeInsets.fromLTRB(2, 0, 3, 3),
                              child: _TransactionPanelWidget(),
                            ),
                          ],
                        ),
                        Offstage(
                          offstage: _isShowCurrencyPick,
                          child: _selectWpFuturesExchangeView(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                _isShowCurrencyPick = true;
              });
            },
          )
      ),
    );
  }

  //外盘期货交易所/合约/品种 选择页面
  Widget _selectWpFuturesExchangeView(){
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          color: APP_MainViewColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10, //阴影范围
              spreadRadius: 1, //阴影浓度
              color: Colors.black, //阴影颜色
              offset:Offset(3,3),
            ),
          ],
        ),
        width: 560,
        margin: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: ListView.builder(
                  controller: _controller1,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempExchangeNo == _wpFuturesExchangeList![index].exchangeNo! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow:const  [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_wpFuturesExchangeList![index].exchangeNo! + " " + _wpFuturesExchangeList![index].exchangeName!
                              + (_tempExchangeNo == _wpFuturesExchangeList![index].exchangeNo! ? "  >" : '')
                            ,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          _tempExchangeNo = _wpFuturesExchangeList![index].exchangeNo!;
                          _wpFuturesCommodityList!.clear();
                          _wpFuturesContractList!.clear();
                          _WPFuturesWpfuturesExchangeCommodityDataHttp(exchangeNo:_wpFuturesExchangeList![index].exchangeNo!);
                        });
                      },
                    );
                  },
                  itemCount: _wpFuturesExchangeList!.length,
                ),
              ),
              flex: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: APP_MainGreenColor,
                //边框圆角设置
                border: Border.all(width: 1, color: const Color.fromRGBO(15, 159, 131, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              ),
              child: const Text(""),
              alignment: Alignment.center,
              width: 3,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: ListView.builder(
                  controller: _controller2,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempCommodityID == _wpFuturesCommodityList![index].id! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow:const  [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_wpFuturesCommodityList![index].commodityNo! + " " + _wpFuturesCommodityList![index].commodityName!
                              + (_tempCommodityID == _wpFuturesCommodityList![index].id! ? "  >" : '')
                            ,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          _tempCommodityID = _wpFuturesCommodityList![index].id!;
                          _tempTradeCurrency = _wpFuturesCommodityList![index].tradeCurrency!;
                          _wpFuturesContractList!.clear();
                          _WPFuturesWpfuturesExchangeContractQryExchangeContractByAccountNoExchangeNoHttp(commodityNo: _wpFuturesCommodityList![index].commodityNo!,exchangeNo: _wpFuturesCommodityList![index].exchangeNo!);
                        });
                      },
                    );
                  },
                  itemCount: _wpFuturesCommodityList!.length,
                ),
              ),
              flex: 9,
            ),
            Container(
              decoration: BoxDecoration(
                color: APP_MainGreenColor,
                //边框圆角设置
                border: Border.all(width: 1, color:const  Color.fromRGBO(15, 159, 131, 1)),
                borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              ),
              child: const Text(""),
              alignment: Alignment.center,
              width: 3,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: ListView.builder(
                  controller: _controller3,
                  scrollDirection : Axis.vertical,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _tempContractID == _wpFuturesContractList![index].id! ? APP_MainGreenColor : APP_MainBarColor,
                          borderRadius:const  BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Text(_wpFuturesContractList![index].contractName!,style: const TextStyle(color: Colors.white,fontSize: 11),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        setState(() {
                          if(_selectIndexExchangeNo != "" && _selectIndexCommodityNo != "" && _selectIndexContractNo != ""){
                            if(_isSocektOn){
                              _onSendUnSocket();
                            }
                          }
                          _socketTickerModel = null;
                          _tickAsksList.clear();
                          _tickBidsList.clear();
                          _tradesList.clear();

                          _transactionPriceController.text = '';
                          _transactionAmountController.text = '';
                          _transactionNumberController.text = '';
                          // if(_selectIndexExchangeContractData != null){
                          //   _WPFuturesWpfuturesSubscribeQuoteWholeUnSubscribeQuoteWholeHttp(
                          //     commodityNo:  _selectIndexExchangeContractData!.commodityNo!,
                          //     contractNo:  _selectIndexExchangeContractData!.contractNo1!,
                          //     exchangeNo: _selectIndexExchangeContractData!.exchangeNo!,
                          //   );
                          // }

                          _selectIndexExchangeNo = _tempExchangeNo;

                          _selectIndexCommodityID = _tempCommodityID;
                          _selectIndexTradeCurrency = _tempTradeCurrency;
                          _selectIndexCommodityNo = _wpFuturesContractList![index].commodityNo!;
                          _tempWpFuturesCommodityList!.clear();
                          _tempWpFuturesCommodityList!.addAll(_wpFuturesCommodityList!);

                          _selectIndexContractNo = _wpFuturesContractList![index].contractNo1!;
                          _selectIndexContractID = _wpFuturesContractList![index].id!;
                          _tempWpFuturesContractList!.clear();
                          _tempWpFuturesContractList!.addAll(_wpFuturesContractList!);

                          _selectIndexExchangeContractData = _wpFuturesContractList![index];

                          _WPFuturesWpfuturesSubscribeQuoteWholeSubscribeQuoteWholeHttp(
                            commodityNo:  _wpFuturesContractList![index].commodityNo!,
                            contractNo:  _wpFuturesContractList![index].contractNo1!,
                            exchangeNo: _wpFuturesContractList![index].exchangeNo!,
                          );
                          _WpfuturesWpfuturesAccountMarginRentDataHttp(
                            exchangeNo:  _wpFuturesContractList![index].exchangeNo!,
                            commodityType:  _wpFuturesContractList![index].commodityType!,
                            commodityNo:  _wpFuturesContractList![index].commodityNo!,
                            contractNo:  _wpFuturesContractList![index].contractNo1!,
                          );
                          _WpfuturesWpfuturesAccountFeeRentDataHttp(
                            exchangeNo: _wpFuturesContractList![index].exchangeNo!,
                            commodityType: _wpFuturesContractList![index].commodityType!,
                            commodityNo: _wpFuturesContractList![index].commodityNo!,
                          );
                          if(_selectIndexExchangeNo != "" && _selectIndexCommodityNo != "" && _selectIndexContractNo != ""){
                            if(_isSocektOn){
                              _onSendSocket();
                            }else{
                              _onRest();
                            }
                          }
                          _isShowCurrencyPick = !_isShowCurrencyPick;
                        });
                      },
                    );
                  },
                  itemCount: _wpFuturesContractList!.length,
                ),
              ),
              flex: 9,
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  //外面期货当前选择合约的行情
  Widget _selectTickerView(){

    String _selectTickerHigh = ''; // 今日最高价
    String _selectTickerLow = ''; // 今日最低价
    String _selectTickerLast = ''; // 最新价
    String _selectTickerChangeRate = ''; //涨跌幅
    String _selectTickerTotalQty = ''; // 总成交量
    String _selectTickerOpeningPrice = '';//开盘价
    String _selectTickerOpeningPreSettlePrice = '';//昨日结算价
    String _selectTickerOpeningPreClosingPrice = '';//昨日收盘价
    String _selectTickerOpeningPositionQty = '';//持仓量

    if(_socketTickerModel != null){
      _selectTickerLast = _socketTickerModel!.qLastPrice!;//最新价
      _selectTickerChangeRate = _socketTickerModel!.qChangeRate!;//涨跌幅
      _selectTickerHigh = _socketTickerModel!.qHighPrice!;//当日最高价
      _selectTickerLow = _socketTickerModel!.qLowPrice!;//当日最低价
      _selectTickerTotalQty = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.qTotalQty!),dec: 4);//当日总成交量
      _selectTickerOpeningPrice = _socketTickerModel!.qOpeningPrice!;//开盘价
      _selectTickerOpeningPreSettlePrice = _socketTickerModel!.qPreSettlePrice!;//昨日结算价
      _selectTickerOpeningPreClosingPrice = _socketTickerModel!.qPreClosingPrice!;//昨日收盘价
      _selectTickerOpeningPositionQty = _transformationNum(neverDoubleTryOrZero(_socketTickerModel!.qPositionQty!),dec: 4);//持仓量
    }else{
      _selectTickerLast = "";//最新价
      _selectTickerChangeRate = "";//涨跌幅
      _selectTickerHigh = "";//当日最高价
      _selectTickerLow = "";//当日最低价
      _selectTickerTotalQty = "";//当日总成交额
      _selectTickerOpeningPrice = "";//开盘价
      _selectTickerOpeningPreSettlePrice = "";//昨日结算价
      _selectTickerOpeningPreClosingPrice = "";//昨日收盘价
      _selectTickerOpeningPositionQty = "";//持仓量
    }


    String  _selectIndexupDownRateStr = '-';
    Color  _selectIndexupDownRateColor = Colors.white;
    try{
      if(_selectTickerChangeRate != "" && _selectTickerChangeRate != null) {
        double _upDownRateDobule = neverDoubleTryOrZero(_selectTickerChangeRate);
        if(_upDownRateDobule > 0){
          _selectIndexupDownRateStr = '+' + (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = APP_MainGreenColor;
        }else if(_upDownRateDobule == 0){
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = Colors.white;
        }else{
          _selectIndexupDownRateStr = (NumUtil.getNumByValueDouble(_upDownRateDobule, 2))!.toStringAsFixed(2) + '%';
          _selectIndexupDownRateColor = APP_MainRedColor;
        }

      }else{
        _selectIndexupDownRateStr = '-';
        _selectIndexupDownRateColor = Colors.white;
      }
    }catch(e){
      _selectIndexupDownRateStr = '-';
      _selectIndexupDownRateColor = Colors.white;
    }

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: const BoxDecoration(
        color: APP_MainBarColor,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: GestureDetector(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(_selectIndexCommodityNo! + _selectIndexContractNo!
                        + (_selectIndexExchangeContractData != null ? ("." + _selectIndexExchangeContractData!.exchangeNo! + '  ' + _selectIndexExchangeContractData!.contractName!) : "")
                      ,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Icon(_isShowCurrencyPick ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 25,)
                ],
              ),
              behavior: HitTestBehavior.opaque,
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _isShowCurrencyPick = !_isShowCurrencyPick;
                  if(_isShowCurrencyPick == false){
                    _tempExchangeNo = _selectIndexExchangeNo!;//这里是交易所的临时判定
                    _tempCommodityID = _selectIndexCommodityID!;//这个是品种的临时判定
                    _tempTradeCurrency = _selectIndexTradeCurrency!;
                    _wpFuturesCommodityList!.clear();
                    _wpFuturesCommodityList!.addAll(_tempWpFuturesCommodityList!);
                    _tempContractID = _selectIndexContractID!;//这个是合约的临时判定
                    _wpFuturesContractList!.clear();
                    _wpFuturesContractList!.addAll(_tempWpFuturesContractList!);
                    _WPFuturesWpfuturesExchangeInfoDataHttp();
                  }
                });
              },
            ),
            alignment: Alignment.center,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(_selectTickerLast,style: TextStyle(fontSize: 14,color: _selectIndexupDownRateColor,fontWeight: FontWeight.w500),),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectIndexupDownRateStr,style: TextStyle(fontSize: 12,color: _selectIndexupDownRateColor),),
                  alignment: Alignment.centerLeft,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("最低价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectTickerLow,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("最高价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(_selectTickerHigh,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text("成交量"+ "(手)" ,style: TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerTotalQty,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("今日开盘价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")") ,style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPrice,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("昨日收盘价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPreClosingPrice,style:const  TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("昨日结算价" + (_selectIndexTradeCurrency == "" ? "" : "(" + _selectIndexTradeCurrency! + ")"),style: const TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPreSettlePrice,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text("持仓量" + "(手)" ,style: TextStyle(fontSize: 10,color: Colors.grey),),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(_selectTickerOpeningPositionQty,style: const TextStyle(fontSize: 14,color: Colors.white),),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  alignment: Alignment.center,
                )
              ],
            ),
          ),
        ],
      ),//头部选择币种栏
    );
  }

  //币种列表 买卖盘口/最新成交
  Widget _SpotWidget(){
    ChartStyle _chartStyle = ChartStyle();
    ChartColors _chartColors = ChartColors();
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        color: APP_MainBarColor,
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          controller: _controller4,
                          scrollDirection : Axis.horizontal,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              child: Container(
                                height: 30,
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: _selectKlineTimeTypeName == _klineTimeTypeAllList[index] ? APP_MainGreenColor : Colors.transparent,
                                        child: const Text('',style: TextStyle(color: Colors.transparent),),
                                        alignment: Alignment.topCenter,
                                        height: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_klineTimeTypeAllList[index],style: const TextStyle(color: Colors.white),),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          color: _selectKlineTimeTypeName == _klineTimeTypeAllList[index] ? APP_MainBGColor : Colors.transparent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              ),
                              onTap: (){
                                setState(() {
                                  // String _selectKlineTimeType = '2'; // 1 : 1分 2：5分 3：15分 4：30分 5：60分 6：24小时
                                  _selectKlineTimeTypeName = _klineTimeTypeAllList[index];
                                  if(_isSocektOn){
                                    if(_selectIndexContractNo! == ''){
                                      print("无数据不发unsub");
                                      return;
                                    }
                                    String subsStr= "{\"unsubs\":\"quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".kline." + _selectKlineTimeType + "\"}";
                                    _channel.sink.add(subsStr);
                                  }
                                  if(_selectKlineTimeTypeName == '1分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "1";
                                  }else if(_selectKlineTimeTypeName == '5分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "2";
                                  }else if(_selectKlineTimeTypeName == '15分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "3";
                                  }else if(_selectKlineTimeTypeName == '30分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "4";
                                  }else if(_selectKlineTimeTypeName == '60分'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "5";
                                  }else if(_selectKlineTimeTypeName == '1日'){
                                    _isTimeLine = false;
                                    _selectKlineTimeType = "6";
                                  }else if(_selectKlineTimeTypeName == '分时'){
                                    _isTimeLine = true;
                                    _selectKlineTimeType = "1";
                                  }
                                  if(_isSocektOn){
                                    if(_selectIndexContractNo! == ''){
                                      print("无数据不发sub");
                                      return;
                                    }
                                    String subsStr= "{\"subs\":\"quote.wpfutures.esunny." + _selectIndexExchangeNo! + "." + _selectIndexCommodityNo! + "." + _selectIndexContractNo! + ".kline." + _selectKlineTimeType + "\"}";
                                    _channel.sink.add(subsStr);
                                  }else{
                                    _onRest();
                                  }

                                });
                              },
                            );
                          },
                          itemCount: _klineTimeTypeAllList.length,
                        ),
                        margin: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                      ),
                      Container(
                        height: 30,
                        margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 30,
                                color: APP_MainBarColor,
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                  controller: _controller5,
                                  scrollDirection : Axis.horizontal,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      child: Container(
                                        height: 30,
                                        child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                color: _mainStateName == _mainStateList[index] ? APP_MainGreenColor : Colors.transparent,
                                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                                alignment: Alignment.topCenter,
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_mainStateList[index],style: const TextStyle(color: Colors.white),),
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  color: _mainStateName == _mainStateList[index] ? APP_MainBGColor : Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          _mainStateName = _mainStateList[index];
                                          if(_mainStateName == 'MA'){
                                            _mainState = MainState.MA;
                                          }else if(_mainStateName == 'BOLL'){
                                            _mainState = MainState.BOLL;
                                          }else if(_mainStateName == 'NONE'){
                                            _mainState = MainState.NONE;
                                          }else{

                                          }
                                        });
                                      },
                                    );
                                  },
                                  itemCount: _mainStateList.length,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 30,
                                color: APP_MainBarColor,
                                alignment: Alignment.centerLeft,
                                child: ListView.builder(
                                  controller: _controller6,
                                  scrollDirection : Axis.horizontal,
                                  itemBuilder: (context,index){
                                    return GestureDetector(
                                      child: Container(
                                        height: 30,
                                        child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                color: _secondaryStateName == _secondaryStateList[index] ? APP_MainGreenColor : Colors.transparent,
                                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                                alignment: Alignment.topCenter,
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(_secondaryStateList[index],style:const  TextStyle(color: Colors.white),),
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  color: _secondaryStateName == _secondaryStateList[index] ? APP_MainBGColor : Colors.transparent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      ),
                                      onTap: (){
                                        setState(() {

                                          //{ MACD, KDJ, RSI, WR, CCI, NONE }

                                          _secondaryStateName = _secondaryStateList[index];
                                          if(_secondaryStateName == 'NONE'){
                                            _secondaryState = SecondaryState.NONE;
                                          }else if(_secondaryStateName == 'MACD'){
                                            _secondaryState = SecondaryState.MACD;
                                          }else if(_secondaryStateName == 'KDJ'){
                                            _secondaryState = SecondaryState.KDJ;
                                          }else if(_secondaryStateName == 'RSI'){
                                            _secondaryState = SecondaryState.RSI;
                                          }else if(_secondaryStateName == 'WR'){
                                            _secondaryState = SecondaryState.WR;
                                          }else if(_secondaryStateName == 'CCI'){
                                            _secondaryState = SecondaryState.CCI;
                                          }
                                        });
                                      },
                                    );
                                  },
                                  itemCount: _secondaryStateList.length,
                                ),
                                margin: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: KChartWidget(
                            _KLineList,
                            _chartStyle, // Required for styling purposes
                            _chartColors,// Required for styling purposes
                            // Required，Data must be an ordered list，(history=>now)
                            isLine: _isTimeLine,// Decide whether it is k-line or time-sharing
                            mainState: _mainState,// Decide what the main view shows
                            secondaryState: _secondaryState,// Decide what the sub view shows
                            fixedLength: 4,// Displayed decimal precision
                            timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                            onLoadMore: (bool a) {},// Called when the data scrolls to the end. When a is true, it means the user is pulled to the end of the right side of the data. When a
                            // is false, it means the user is pulled to the end of the left side of the data.
                            maDayList: const [5,10,20],// Display of MA,This parameter must be equal to DataUtil.calculate‘s maDayList
                            bgColor: const [Colors.black, Colors.black],// The background color of the chart is gradient
                            isChinese: true,// Graphic language
                            volHidden: false,// hide volume
                            isOnDrag: (isDrag){
                            },// true is on Drag.Don't load data while Draging.
                            onSecondaryTap:(){},// on secondary rect taped.
                            flingCurve : Curves.decelerate,
                            deviationwidth: -kLeftBarWidth, //自定义的一个偏移量
                            widgetWidth: MediaQuery.of(context).size.width > 595 ?
                            MediaQuery.of(context).size.width - kLeftBarWidth - kTransactionPanelWidth - (_spotWidgetHandicapShow ? kSpotWidth : 35 )  :
                            MediaQuery.of(context).size.width,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      )
                    ],
                  ),
                ),
                _spotWidgetHandicapShow ? Container(
                  margin: const EdgeInsets.fromLTRB(3, 0, 1, 3),
                  width: kSpotWidth,
                  color: APP_MainBGColor,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        color: APP_MainBarColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _controller7,
                                scrollDirection : Axis.horizontal,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    child: Container(
                                      height: 30,
                                      child: IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: _selectTransactionType == _selectTransactionTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                                              child: const Text('',style: TextStyle(color: Colors.transparent),),
                                              alignment: Alignment.topCenter,
                                              height: 4,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_selectTransactionTypeName[index],style: const TextStyle(color: Colors.white),),
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                color: _selectTransactionType == _selectTransactionTypeName[index] ? APP_MainBGColor : Colors.transparent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _selectTransactionType = _selectTransactionTypeName[index];
                                      });
                                    },
                                  );
                                },
                                itemCount: _selectTransactionTypeName.length,
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                child: Container(
                                  child: Icon(_spotWidgetHandicapShow ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 25,),
                                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  setState(() {
                                    _spotWidgetHandicapShow = !_spotWidgetHandicapShow;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      ), //头部选择
                      Offstage(
                        offstage: _selectTransactionType == '买卖盘口' ? false : true,
                        child: WPFuturesView_orderTitle(priceTitle: _selectIndexTradeCurrency!),
                      ),
                      Offstage(
                        offstage: _selectTransactionType == '最新成交' ? false : true,
                        child: WPFuturesView_tradeTitle(priceTitle: _selectIndexTradeCurrency!),
                      ),
                      Expanded(
                        child:_selectTransactionType == '买卖盘口' ?
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _controller8,
                                  reverse : true,
                                  itemBuilder: (context,index){
                                    String _priceNumStr = '-';
                                    double _priceDouble = neverDoubleTryOrZero(_tickAsksQtysList[index]);
                                    _priceNumStr = _transformationNum(_priceDouble);

                                    return Container(
                                      alignment: Alignment.center,
                                      color: APP_MainBGColor,
                                      width: 300,
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickAsksList[index]), 4)).toString(),style: const TextStyle(color: APP_MainRedColor,fontSize: 12),),
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_priceNumStr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: (){
                                          setState(() {
                                            _transactionPriceController.text = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickAsksList[index]), _decSize)).toString();
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  itemCount: _tickAsksList.length,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(1),
                                color: Colors.black,
                                child: Container(
                                  child: const SizedBox(height: 1,),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: _controller9,
                                  itemBuilder: (context,index){

                                    String _priceNumStr = '-';
                                    double _priceDouble = neverDoubleTryOrZero(_tickBidsQtysList[index].toString());
                                    _priceNumStr = _transformationNum(_priceDouble);


                                    return Container(
                                      alignment: Alignment.center,
                                      color: APP_MainBGColor,
                                      width: 300,
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickBidsList[index]), 4)).toString(),style: const TextStyle(color: APP_MainGreenColor,fontSize: 12),),
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Text(_priceNumStr,style:const  TextStyle(color: Colors.white,fontSize: 12),),
                                                alignment: Alignment.centerRight,
                                                padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: (){
                                          setState(() {
                                            _transactionPriceController.text =  (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_tickBidsList[index]), _decSize)).toString();
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  itemCount: _tickBidsList.length,
                                ),
                              ),
                            ],
                          ),
                        ):
                        ListView.builder(
                          controller: _controller10,
                          itemBuilder: (context,index){
                            return Container(
                              alignment: Alignment.center,
                              color: APP_MainBGColor,
                              width: 300,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(_tradesList[index]["price"].toString(),style: const TextStyle(color: Colors.white,fontSize: 11),),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(_tradesList[index]['qty'].toString(),style: const TextStyle(color: Colors.white,fontSize: 11),),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(DateFormat.formatDate(DateTime.fromMillisecondsSinceEpoch(int.tryParse(_tradesList[index]["ts"].toString()) ?? 0),
                                          [DateFormat.HH, ':', DateFormat.nn, ':', DateFormat.ss]),style: const TextStyle(color: Colors.white,fontSize: 11),),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _tradesList.length,
                        ),
                      ),
                    ],
                  ),
                ): Container(
                  margin:const  EdgeInsets.fromLTRB(3, 0, 1, 3),
                  color: APP_MainBarColor,
                  width: 40,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    child: Container(
                      child: Icon(_spotWidgetHandicapShow ? Icons.keyboard_arrow_right_rounded : Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 25,),
                      padding:const  EdgeInsets.fromLTRB(3, 8, 3, 0),
                    ),
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      setState(() {
                        _spotWidgetHandicapShow = !_spotWidgetHandicapShow;
                      });

                    },
                  ),
                )
              ],
            ),
          ),
          flex: 2,
        ),
        _accountWidgetShow ?  _accountWidget() :
        Container(
          padding: const EdgeInsets.fromLTRB(3, 0, 1, 3),
          child: _accountWidgetHead(),
        ),
      ],
    );
  }

  String _transformationNum(double num,{int dec = 0}){
    if(num > 1000000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000000.0, dec)).toString() + 'B';
    }else if(num > 1000000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000000.0, dec)).toString() + 'M';
    }else if(num > 1000){//1,000,000,000
      return (NumUtil.getNumByValueDouble(num/1000.0, dec)).toString() + 'K';
    }else{
      return (NumUtil.getNumByValueDouble(num, dec)).toString();
    }
  }

  //交易面板/合约介绍面板
  int _decSize = 8;//全局小数位数
  Widget _TransactionPanelWidget(){

    String _equity = '-';
    String _available = '-';
    String _balanceToPreBalance = '-';
    String _balanceXpreBalance = "-";
    if(_wpFuturesFundDataList != null && _wpFuturesFundDataList!.isNotEmpty){
      _equity = _wpFuturesFundDataList!.first.equity!;
      _available = _wpFuturesFundDataList!.first.available!;
      _balanceToPreBalance = (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList!.first.balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList!.first.preBalance!), 4)).toString();
      _balanceXpreBalance = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_wpFuturesFundDataList!.first.balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList!.first.preBalance!)) / neverDoubleTryOrZero(_wpFuturesFundDataList!.first.preBalance!) * 100, 4)).toString() + '%';
    }else{
      _equity = '-';
      _available = '-';
      _balanceToPreBalance = '-';
      _balanceXpreBalance = "-";
    }


    String _contractName = '-';//合约名称
    String _commodityContractNo = '-';//合约代码
    String _exchangeNameexchangeNo = '-';//交易所
    String _commodityType = '-';//产品类型
    String _tradeCurrency = '-';//货币
    String _commodityTickSize = '-';//最小变动价位
    String _contractSize = '-';//每手乘数
    String _commodityTimeZone = '-';//品种市区
    String _contractExpDate = '-';//合约时间
    String _firstNoticeDate = '-';//第一通知日
    String _lastTradeDate = '-';//最后交易日

    if(_selectIndexExchangeContractData != null){
      _contractName = _selectIndexExchangeContractData!.contractName!;
      _commodityContractNo = _selectIndexExchangeContractData!.commodityNo! + _selectIndexExchangeContractData!.contractNo1!;
      _exchangeNameexchangeNo = _selectIndexExchangeContractData!.exchangeName! + "(" +  _selectIndexExchangeContractData!.exchangeNo! + ")";
      _commodityType = _findTrans(_bigSummaryInfoTranslate!, "commodityType", _selectIndexExchangeContractData!.commodityType!);
      _tradeCurrency = _selectIndexExchangeContractData!.tradeCurrency!;
      _commodityTickSize = _selectIndexExchangeContractData!.commodityTickSize!;
      if(_commodityTickSize == '0.0'){
        _decSize = 8;
      }else{
        if(_commodityTickSize.contains('.')){
          _decSize = _commodityTickSize.length - _commodityTickSize.indexOf(".") - 1;
          if(_commodityTickSize.endsWith(".0")){
            _decSize = _decSize - 1;
          }
        }else{
          _decSize = 0;
        }
      }
      _contractSize = _selectIndexExchangeContractData!.contractSize!;
      _commodityTimeZone = "UTC " + _selectIndexExchangeContractData!.commodityTimeZone!;
      _contractExpDate = _selectIndexExchangeContractData!.contractExpDate!;
      _firstNoticeDate = _selectIndexExchangeContractData!.firstNoticeDate!;
      _lastTradeDate = _selectIndexExchangeContractData!.lastTradeDate!;
    }else{
      _contractName = '-';
      _commodityContractNo = '-';
      _exchangeNameexchangeNo = '-';
      _commodityType = '-';
      _tradeCurrency = '-';
      _commodityTickSize = '-';
      _contractSize = '-';
      _commodityTimeZone = '-';
      _contractExpDate = '-';
      _firstNoticeDate = '-';
      _lastTradeDate = '-';
      _decSize = 8;
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: APP_MainBGColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: APP_MainBarColor,
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                      controller: _controller11,
                      scrollDirection : Axis.horizontal,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          child: Container(
                            height: 30,
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: _selectTransactionPanelType == _selectTransactionPanelTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                                    child: const Text('',style: TextStyle(color: Colors.transparent),),
                                    alignment: Alignment.topCenter,
                                    height: 4,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(_selectTransactionPanelTypeName[index],style: const TextStyle(color: Colors.white),),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      color: _selectTransactionPanelType == _selectTransactionPanelTypeName[index] ? APP_MainBGColor : Colors.transparent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            padding:const  EdgeInsets.fromLTRB(0, 0, 0, 0),
                          ),
                          onTap: (){
                            setState(() {
                              _selectTransactionPanelType = _selectTransactionPanelTypeName[index];
                              if(_selectTransactionPanelType == '市价委托' || _selectTransactionPanelType == '市价止损'){
                                _transactionPriceController.text = '';
                                _transactionAmountController.text = '';
                              }
                            });
                          },
                        );
                      },
                      itemCount: _selectTransactionPanelTypeName.length,
                    ),
                  ), //头部选择
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: ListView(
                        controller: _controller12,
                        shrinkWrap: true,
                        children: [
                          Container(
                            child: Text("价格(" + _selectIndexTradeCurrency! + ")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          ),
                          Container(
                            height: 30,
                            child: TextField(
                              enabled: (_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损') ? true : false,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                labelStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                                suffixText: '',
                                suffixStyle: const TextStyle(color: Colors.white,fontSize: 11),
                                hintText: (_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损') ? '请输入单价' : '以当前市场最优价格下单',
                                hintStyle: const TextStyle(color: Colors.grey,fontSize: 11),
                              ),
                              controller: _transactionPriceController,
                              autocorrect:false,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal : true,
                              ),
                              inputFormatters: [
                                TextInput_onlyNum(decimalRange: _decSize,integerRange: 14),
                              ],
                              style: const TextStyle(color: Colors.white,fontSize: 11),
                              onChanged: (value){
                                if(value == ''){
                                  _transactionAmountController.text = '';
                                }else{
                                  if(_transactionNumberController.text != ''){
                                    _transactionAmountController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionNumberController.text)), 8)).toString();
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            child: const Text("数量(手)",style: TextStyle(fontSize: 12,color: Colors.grey),),
                            alignment: Alignment.centerLeft,
                            padding:const  EdgeInsets.fromLTRB(0, 20, 0, 10),
                          ),
                          Container(
                            height: 30,
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                                suffixText: '',
                                suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                              ),
                              controller: _transactionNumberController,
                              autocorrect:false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                // TextInput_onlyNum(decimalRange: 0,integerRange: 14),
                              ],
                              style: const TextStyle(color: Colors.white,fontSize: 11),
                              onChanged: (value){
                                //这个是交易数量的变动
                                //1：价格变动 不影响这个的输入变动
                                //2：数量变动 会联动金额变动
                                //3：金额变动 会联动数量变动
                                if(value == ''){
                                  _transactionAmountController.text = '';
                                }else{
                                  if(_transactionPriceController.text != ''){
                                    _transactionAmountController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionPriceController.text)), 8)).toString();
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            child: Text("金额(" + _selectIndexTradeCurrency! + ")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          ),
                          Container(
                            height: 30,
                            child: TextField(
                              enabled: (_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损') ? true : false,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                                suffixText: '',
                                suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                              ),
                              controller: _transactionAmountController,
                              autocorrect:false,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal : true,
                              ),
                              inputFormatters: [
                                TextInput_onlyNum(decimalRange: 8,integerRange: 14),
                              ],
                              style: const TextStyle(color: Colors.white,fontSize: 11),
                              onChanged: (value){
                                if(value == ''){
                                  _transactionNumberController.text = '';
                                }else{
                                  if(_transactionPriceController.text != ''){
                                    _transactionNumberController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) / neverDoubleTryOrZero(_transactionPriceController.text)), 8)).toString();
                                  }
                                }
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("今权益:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding:const  EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_equity,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding:const  EdgeInsets.fromLTRB(0, 15, 0, 5),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("净盈亏:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding:const  EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_balanceToPreBalance,style:const  TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child:const  Text("今可用:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_available,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: const Text("盈利率:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_balanceXpreBalance,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child:Text(_initialMarginTitle,style: const TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_initialMargin,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(_sellInitialMarginTitle,style:const TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_sellInitialMargin,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child:Text(_openFeeTitle,style: const TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_openCloseFee,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Text(_closeFeeTitle,style:const TextStyle(fontSize: 11,color: Colors.grey),),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_openCloseFee,style: const TextStyle(fontSize: 11,color: Colors.white),),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 1,color: Colors.grey,),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child:Container(
                                      decoration: const BoxDecoration(
                                        color: APP_MainGreenColor,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text("买入",style: TextStyle(fontSize: 14,color: Colors.white),),
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){
                                      if(_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损'){
                                        if(_transactionPriceController.text == ''){
                                          showMyCustomText("请输入交易价格");
                                          return;
                                        }
                                        if(neverDoubleTryOrZero(_commodityTickSize) != 0.0){
                                          double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceController.text),neverDoubleTryOrZero(_commodityTickSize))).toDouble();
                                          if(_tokeD != 0.0){
                                            showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                                            return;
                                          }
                                        }
                                      }
                                      if(_transactionNumberController.text == ''){
                                        showMyCustomText("请输入交易数量");
                                        return;
                                      }
                                      String _orderTypeS = '2';
                                      if(_selectTransactionPanelType == '市价委托'){
                                        _orderTypeS = '1';
                                      }else if(_selectTransactionPanelType == '限价委托'){
                                        _orderTypeS = '2';
                                      }else if(_selectTransactionPanelType == '市价止损'){
                                        _orderTypeS = '3';
                                      }else if(_selectTransactionPanelType == '限价止损'){
                                        _orderTypeS = '4';
                                      }else{
                                        return;
                                      }

                                      _WPFuturesWpfuturesOrderInfoInsertOrderHttp(
                                        // accountNo:"RDGJ06",
                                        commodityNo:_selectIndexCommodityNo!,
                                        contractNo:_selectIndexContractNo!,
                                        exchangeNo:_selectIndexExchangeNo!,
                                        orderPrice:_transactionPriceController.text,
                                        orderQty:_transactionNumberController.text,
                                        orderSide:'B',
                                        orderType:_orderTypeS,
                                        timeInForce:"0",
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: GestureDetector(
                                    child:Container(
                                      decoration: const BoxDecoration(
                                        color: APP_MainRedColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      alignment: Alignment.center,
                                      child:const  Text("卖出",style: TextStyle(fontSize: 14,color: Colors.white),),
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){
                                      if(_selectTransactionPanelType == '限价委托' || _selectTransactionPanelType == '限价止损'){
                                        if(_transactionPriceController.text == ''){
                                          showMyCustomText("请输入交易价格");
                                          return;
                                        }
                                        if(neverDoubleTryOrZero(_commodityTickSize) != 0.0){
                                          double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceController.text),neverDoubleTryOrZero(_commodityTickSize))).toDouble();
                                          if(_tokeD != 0.0){
                                            showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                                            return;
                                          }
                                        }
                                      }
                                      if(_transactionNumberController.text == ''){
                                        showMyCustomText("请输入交易数量");
                                        return;
                                      }

                                      String _orderTypeS = '2';
                                      if(_selectTransactionPanelType == '市价委托'){
                                        _orderTypeS = '1';
                                      }else if(_selectTransactionPanelType == '限价委托'){
                                        _orderTypeS = '2';
                                      }else if(_selectTransactionPanelType == '市价止损'){
                                        _orderTypeS = '3';
                                      }else if(_selectTransactionPanelType == '限价止损'){
                                        _orderTypeS = '4';
                                      }else{
                                        return;
                                      }

                                      _WPFuturesWpfuturesOrderInfoInsertOrderHttp(
                                        // accountNo:"RDGJ06",
                                        commodityNo:_selectIndexCommodityNo!,
                                        contractNo:_selectIndexContractNo!,
                                        exchangeNo:_selectIndexExchangeNo!,
                                        orderPrice:_transactionPriceController.text,
                                        orderQty:_transactionNumberController.text,
                                        orderSide:'S',
                                        orderType: _orderTypeS,
                                        timeInForce:"0",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            flex: 20,
          ),
          Expanded(
            child: Container(
              color: APP_MainBGColor,
              margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: APP_MainBarColor,
                    child: const Text("合约信息",style: TextStyle(color: Colors.white,fontSize: 13),),
                    alignment: Alignment.center,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        controller: _controller13,
                        children: [
                          Container(
                            padding:const  EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("合约名称:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_contractName,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child:const  Text("合约代码:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_commodityContractNo,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("交易所:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_exchangeNameexchangeNo,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("产品类型:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_commodityType,style:const  TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("货币:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_tradeCurrency,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("最小变动价位:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_commodityTickSize,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child:const  Text("每手乘数:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_contractSize,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:const  EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("品种时区:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_commodityTimeZone,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:const  EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("合约日期:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_contractExpDate,style:const  TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("第一通知日:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_firstNoticeDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:const  EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child:const  Text("最后交易日:",style: TextStyle(color: Colors.grey,fontSize: 11),),
                                  alignment: Alignment.centerLeft,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_lastTradeDate,style: const TextStyle(color: Colors.white,fontSize: 11),),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            flex: 10,
          ),
        ],
      ),
    );
  }

  //下部面板-当前委托/历史成交/持仓/资产
  Widget _accountWidget(){
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 0, 1, 3),
      height: _accountWidgetHeight,
      child: Container(
        alignment: Alignment.center,
        color: APP_MainBGColor,
        child: Column(
          children: [
            _accountWidgetHead(), //头部选择
            Offstage(
              offstage: _selectAssetEntrustmentType == '当前委托' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("资金账号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托类型",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托数量(手)",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交均价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("反馈信息",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: GestureDetector(
                          child: Container(
                            child: const Text("批量撤单",style: TextStyle(fontSize: 10,color: APP_MainGreenColor),),
                            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            _WPFuturesWpfuturesOrderInfoBatchCancelOrderHttp();
                          },
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),

                  ],
                ),
              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '历史委托' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child:const  Text("资金账号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child:const  Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托类型",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child:const  Text("委托方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托数量(手)",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交均价",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child:const  Text("委托状态",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("委托时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("反馈信息",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '历史成交' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("资金账号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交编号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        child:const  Text("成交方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交价格",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交数量(手)",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("成交时间",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: _selectAssetEntrustmentType == '持仓' ? false : true,
              child: Container(
                color: APP_MainBGColor,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text("资金账号",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("交易所",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("合约",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("品种",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓方向",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓数量(手)",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓价格",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("持仓盈亏",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: const Text("操作",style: TextStyle(fontSize: 10,color: Colors.grey),),
                        alignment: Alignment.centerLeft,
                        padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                      ),
                      flex: 2,
                    ),
                  ],
                ),

              ),
            ),
            Expanded (
              child: _selectAssetEntrustmentType == '资产' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: EasyRefresh(
                  child: ListView.builder(
                    controller: _controller14,
                    itemBuilder: (context,index){
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: const BoxDecoration(
                          color:  APP_MainBarColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5, //阴影范围
                                spreadRadius: 0.1, //阴影浓度
                                color: Colors.black, //阴影颜色
                                offset:Offset(3,3)
                            ),
                          ],
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("资金账号:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].accountNo!,style:const  TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("币种:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].currencyNo!,style:const  TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("风险率:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].accountMaintenanceMargin!) / (neverDoubleTryOrZero(_wpFuturesFundDataList![index].accountMaintenanceMargin!) + neverDoubleTryOrZero(_wpFuturesFundDataList![index].available!)) *100  ,2)).toString() + "%",style: TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                padding:const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:const  Text("资金调整:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].cashAdjustValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("出金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].cashOutValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("入金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].cashInValue!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),

                                  ],
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("今权益:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].equity!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("今可用:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].available!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("今可提:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].canDraw!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("今资金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text(_wpFuturesFundDataList![index].balance!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text(_wpFuturesFundDataList![index].accountIntialMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("维持保证金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text(_wpFuturesFundDataList![index].accountMaintenanceMargin!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("逐笔浮盈:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text(_wpFuturesFundDataList![index].positionProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: const Text("逐笔平盈:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text(_wpFuturesFundDataList![index].closeProfit!,style: const TextStyle(color: Colors.white,fontSize: 13),),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("净盈亏:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!), 2)).toString(),style: TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("权利金:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text((NumUtil.getNumByValueDouble(neverDoubleTryOrZero(_wpFuturesFundDataList![index].premiumIncome!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].premiumPay!), 2)).toString() ,style: TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("盈利率:",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          Container(
                                            child: Text((NumUtil.getNumByValueDouble((neverDoubleTryOrZero(_wpFuturesFundDataList![index].balance!) - neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!)) / neverDoubleTryOrZero(_wpFuturesFundDataList![index].preBalance!) * 100, 2)).toString() + "%",style: TextStyle(color: Colors.white,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text("",style: TextStyle(color: Colors.grey,fontSize: 13),),
                                            alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                        ),

                      );
                    },
                    itemCount: _wpFuturesFundDataList!.length,
                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer:null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _WPFuturesWpfuturesFundDataDataHttp();
                      }
                    });
                  },
                  onLoad: null,
                ),
              ) :
              _selectAssetEntrustmentType == '当前委托' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  child: ListView.builder(
                    controller: _controller15,
                    itemBuilder: (context,index){
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].accountNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].exchangeNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].commodityNo! + _wpFuturesOrderInfoListData![index].contractNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].orderNo! ,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderType",_wpFuturesOrderInfoListData![index].orderType!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderSide",_wpFuturesOrderInfoListData![index].orderSide!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].orderPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].orderQty!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].orderMatchPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderState",_wpFuturesOrderInfoListData![index].orderState!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].orderInsertTime!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 5, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoListData![index].errorText!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Offstage(
                                  child: GestureDetector(
                                    child: Container(
                                      child:const  Text("撤单",style: TextStyle(fontSize: 10,color: APP_MainGreenColor),),
                                      padding:const  EdgeInsets.fromLTRB(3, 2, 0, 2),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){
                                      _WPFuturesWpfuturesOrderInfoCancelOrderHttp(
                                        accountNo: _wpFuturesOrderInfoListData![index].accountNo!,
                                        orderNo: _wpFuturesOrderInfoListData![index].orderNo!,
                                      );
                                    },
                                  ),
                                  offstage: (_wpFuturesOrderInfoListData![index].orderState! == "4" || _wpFuturesOrderInfoListData![index].orderState! == "5") ? false : true,
                                ),
                                alignment: Alignment.centerRight,
                                padding:const  EdgeInsets.fromLTRB(0, 5, 10, 5),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),

                      );
                    },
                    itemCount: _wpFuturesOrderInfoListData!.length,
                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer: _wpFuturesOrderInfohasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _wpFuturesOrderInfoPage = 1;
                          _WPFuturesWpfuturesOrderInfoDataHttp();
                        });
                      }
                    });
                  },
                  onLoad: _wpFuturesOrderInfohasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _wpFuturesOrderInfoPage += 1;
                          _WPFuturesWpfuturesOrderInfoDataHttp();
                        });
                      }
                    });
                  }
                      : null,
                ),
              ) :
              _selectAssetEntrustmentType == '历史委托' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  child: ListView.builder(
                    controller: _controller16,
                    itemBuilder: (context,index){
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].accountNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].exchangeNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].commodityNo! + _wpFuturesOrderInfoHisListData![index].contractNo!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].orderNo! ,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderType",_wpFuturesOrderInfoHisListData![index].orderType!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderSide",_wpFuturesOrderInfoHisListData![index].orderSide!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].orderPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].orderQty!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].orderMatchPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigOrderTranslate!,"orderState",_wpFuturesOrderInfoHisListData![index].orderState!),style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].orderInsertTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesOrderInfoHisListData![index].errorText!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),

                      );
                    },
                    itemCount: _wpFuturesOrderInfoHisListData!.length,
                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer: _wpFuturesOrderInfoHishasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpFuturesOrderInfoHisPage = 1;
                        _WPFuturesWpfuturesOrderInfoHisDataHttp();
                      }
                    });
                  },
                  onLoad: _wpFuturesOrderInfoHishasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpFuturesOrderInfoHisPage += 1;
                        _WPFuturesWpfuturesOrderInfoHisDataHttp();
                      }
                    });
                  }
                      : null,
                ),
              ) :
              _selectAssetEntrustmentType == '历史成交' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: EasyRefresh(
                  child:ListView.builder(
                    controller: _controller17,
                    itemBuilder: (context,index){
                      return Container(
                        color: APP_MainBGColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].accountNo!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].exchangeNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].commodityNo! + _wpFuturesFillInfoList![index].contractNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].matchNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigDealTranslate!,"matchSide",_wpFuturesFillInfoList![index].matchSide!),style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].matchPrice!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].matchQty!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesFillInfoList![index].matchDateTime!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _wpFuturesFillInfoList!.length,
                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer: _wpFuturesFillInfohasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _wpFuturesFillInfoPage = 1;
                          _WPFuturesWpfuturesFillInfoDataHttp();
                        });
                      }
                    });
                  },
                  onLoad: _wpFuturesFillInfohasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          _wpFuturesFillInfoPage += 1;
                          _WPFuturesWpfuturesFillInfoDataHttp();
                        });
                      }
                    });
                  }
                      : null,
                ),
              ) :
              _selectAssetEntrustmentType == '持仓' ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child:EasyRefresh(
                  child:ListView.builder(
                    controller: _controller18,
                    itemBuilder: (context,index){

                      String _todoSell = '';
                      Color _todoSellColor = Colors.white;
                      if(_wpFuturesPositionSummaryInfoList![index].matchSide! == 'S'){
                        _todoSell = '买入平仓';
                        _todoSellColor = APP_MainGreenColor;
                      }else if(_wpFuturesPositionSummaryInfoList![index].matchSide! == 'B'){
                        _todoSell = '卖出平仓';
                        _todoSellColor = APP_MainRedColor;
                      }else{
                        _todoSell = '';
                        _todoSellColor = Colors.white;
                      }



                      return Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].accountNo!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].exchangeNo!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].commodityNo! + '' + _wpFuturesPositionSummaryInfoList![index].contractNo!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigSummaryInfoTranslate!, "commodityType", _wpFuturesPositionSummaryInfoList![index].commodityType!),style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_findTrans(_bigSummaryInfoTranslate!, "matchSide", _wpFuturesPositionSummaryInfoList![index].matchSide!),style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].positionQty!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].positionPrice!,style:const  TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_wpFuturesPositionSummaryInfoList![index].positionProfit!,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,
                                    color: neverDoubleTryOrZero(_wpFuturesPositionSummaryInfoList![index].positionProfit!) >= 0 ? APP_MainGreenColor : APP_MainRedColor),),
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                alignment: Alignment.centerLeft,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  child: Text(_todoSell,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: _todoSellColor),),
                                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                  alignment: Alignment.centerLeft,
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                    dismissOnBackKeyPress:true,
                                    width:MediaQuery.of(context).size.width / 2.5,
                                    dialogType: DialogType.NO_HEADER,
                                    animType: AnimType.BOTTOMSLIDE,
                                    dialogBackgroundColor:APP_MainBarColor,
                                    body: _TransactionPanelSignalWidget(
                                      _wpFuturesPositionSummaryInfoList![index],
                                      todoSell:_todoSell,
                                    ),
                                  ).show();
                                },
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _wpFuturesPositionSummaryInfoList!.length,
                  ),
                  header: ClassicalHeader(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    refreshText: '下拉刷新',
                    refreshReadyText: '松开立即刷新',
                    refreshingText: '正在刷新数据..',
                    refreshedText: "刷新完成",
                    refreshFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  ),
                  footer: _wpFuturesPositionSummaryhasNextPage!
                      ? ClassicalFooter(
                    bgColor: Colors.transparent,
                    textColor: Colors.grey,
                    loadText: '上拉刷新',
                    loadReadyText: '松开立即刷新',
                    loadingText: '正在刷新数据..',
                    loadedText: "刷新完成",
                    loadFailedText: '刷新超时',
                    infoColor: Colors.grey,
                    infoText: "最后更新于:%T",
                  )
                      : null,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpFuturesPositionSummaryPage = 1;
                        _WPFuturesWpfuturesPositionSummaryInfoDataHttp();
                      }
                    });
                  },
                  onLoad: _wpFuturesPositionSummaryhasNextPage!
                      ? () async {
                    await Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _wpFuturesPositionSummaryPage += 1;
                        _WPFuturesWpfuturesPositionSummaryInfoDataHttp();
                      }
                    });
                  }
                      : null,
                ),
              ) :
              Container(),
            ),
          ],
        ),
      ),
    );
  }
  //下部面板-当前委托/历史成交/持仓/资产 的标题面板
  Widget _accountWidgetHead(){
    return GestureDetector(
      child: Container(
          height: 40,
          color: APP_MainBarColor,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller19,
                  scrollDirection : Axis.horizontal,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        height: 30,
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: _selectAssetEntrustmentType == _selectAssetEntrustmentTypeName[index] ? APP_MainGreenColor : Colors.transparent,
                                child: const Text('',style: TextStyle(color: Colors.transparent),),
                                alignment: Alignment.topCenter,
                                height: 4,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(_selectAssetEntrustmentTypeName[index],style: const TextStyle(color: Colors.white),),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  color: _selectAssetEntrustmentType == _selectAssetEntrustmentTypeName[index] ? APP_MainBGColor : Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      onTap: (){
                        setState(() {
                          _selectAssetEntrustmentType = _selectAssetEntrustmentTypeName[index];
                          if(_selectAssetEntrustmentType == '当前委托'){
                            _wpFuturesOrderInfoPage = 1;
                            _WPFuturesWpfuturesOrderInfoDataHttp();
                          }
                          if(_selectAssetEntrustmentType == '历史委托'){
                            _wpFuturesOrderInfoHisPage = 1;
                            _WPFuturesWpfuturesOrderInfoHisDataHttp();
                          }
                          if(_selectAssetEntrustmentType == '历史成交'){
                            _wpFuturesFillInfoPage = 1;
                            _WPFuturesWpfuturesFillInfoDataHttp();
                          }
                          if(_selectAssetEntrustmentType == '持仓'){
                            _wpFuturesPositionSummaryPage = 1;
                            _WPFuturesWpfuturesPositionSummaryInfoDataHttp();
                          }
                          if(_selectAssetEntrustmentType == '资产'){
                            _WPFuturesWpfuturesFundDataDataHttp();
                          }
                        });
                      },
                    );
                  },
                  itemCount: _selectAssetEntrustmentTypeName.length,
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Container(
                    child: RotationTransition(
                      turns: _animation!,
                      child: const Icon(Icons.refresh_rounded,color: Colors.white,size: 25,),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    // 防重复提交
                    if(DateTime.now().difference(_lastPopTime) > Duration(seconds: 2)){
                      _lastPopTime = DateTime.now();
                      _controller!.forward();
                      _refreshEveryWhere();
                    }else{
                    }
                  },
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Container(
                    child: Icon(_accountWidgetShow ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,color: Colors.white,size: 25,),
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    setState(() {
                      _accountWidgetShow = !_accountWidgetShow;
                    });
                  },
                ),
              )
            ],
          )
      ),
      behavior: HitTestBehavior.opaque,
      onVerticalDragDown: (s){
        _accountWidgetHeightT =  _accountWidgetHeight;
      },
      onVerticalDragUpdate: (s){
        _accountWidgetHeadYT = s.localPosition.dy - 20;
        if(_accountWidgetShow){ //
          setState(() {
            double hi = _accountWidgetHeightT - _accountWidgetHeadYT;
            if(hi < 120){
              _accountWidgetHeight = 120;
            }else if (hi > (MediaQuery.of(context).size.height / 2)){
              _accountWidgetHeight = MediaQuery.of(context).size.height / 2;
            }else{
              _accountWidgetHeight = _accountWidgetHeightT - _accountWidgetHeadYT;
            }

          });
        }
      },
      onVerticalDragEnd: (s){
        setState(() {
          _accountWidgetHeightT =  _accountWidgetHeight;
        });
      },
    ); //头部选择
  }


  //到处刷新
  void _refreshEveryWhere(){
    if(_selectAssetEntrustmentType == '历史成交'){
      _wpFuturesFillInfoPage = 1;
      _WPFuturesWpfuturesFillInfoDataHttp();
    }else if(_selectAssetEntrustmentType == '当前委托'){
      _wpFuturesOrderInfoPage = 1;
      _WPFuturesWpfuturesOrderInfoDataHttp();
    }else if(_selectAssetEntrustmentType == '历史委托'){
      _wpFuturesOrderInfoHisPage = 1;
      _WPFuturesWpfuturesOrderInfoHisDataHttp();
    }else if(_selectAssetEntrustmentType == '持仓'){
      _wpFuturesPositionSummaryPage = 1;
      _WPFuturesWpfuturesPositionSummaryInfoDataHttp();
    }else if(_selectAssetEntrustmentType == '资产'){
      _WPFuturesWpfuturesFundDataDataHttp();
    }else{

    }
  }

  //交易面板/合约介绍面板 弹窗版本
  Widget _TransactionPanelSignalWidget(WpFuturesPositionSummaryInfoListData data,{String todoSell = ''}){


    //maker类型
    var _orderPriceType = '2';
    List<DropdownMenuItem<String>> _orderPriceTypeItems =const  [
      DropdownMenuItem(child: Text('限价委托',style: TextStyle(color: Colors.white,fontSize: 13),),value: '2',),
      DropdownMenuItem(child: Text('市价委托',style: TextStyle(color: Colors.white,fontSize: 13),),value: '1',),
    ];

    //交易面板套件
    TextEditingController _transactionPriceInsideController = TextEditingController();
    TextEditingController _transactionNumberInsideController = TextEditingController();
    TextEditingController _transactionAmountInsideController = TextEditingController();

    int _decSize = 8;
    String _insideCommodityTickSize = data.commodityTickSize!;
    if(_insideCommodityTickSize == '0.0'){
      _decSize = 8;
    }else{
      if(_insideCommodityTickSize.contains('.')){
        _decSize = _insideCommodityTickSize.length - _insideCommodityTickSize.indexOf(".") - 1;
        if(_insideCommodityTickSize.endsWith(".0")){
          _decSize = _decSize - 1;
        }
      }else{
        _decSize = 0;
      }
    }


    return StatefulBuilder(
        builder: (tContext, mSetState){
          return Container(
            decoration:const  BoxDecoration(
              color: APP_MainBGColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: ListView(
                controller: _controller20,
                shrinkWrap: true,
                children: [
                  Container(
                    child: Text( "交易所代码: " + data.exchangeNo! + ' 合约代码: ' + data.commodityNo! + data.contractNo! + ' 最小变动价位:' + data.commodityTickSize!,style: const TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color: Colors.white),),
                    padding:const  EdgeInsets.fromLTRB(0, 5, 0, 15),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding:const  EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.centerRight,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        //边框圆角设置
                        borderRadius:const  BorderRadius.all(Radius.circular(3.0)),
                        border: Border.all(color: const Color.fromRGBO(15, 159, 131, 1)),
                      ),
                      child: DropdownButton(
                        items:_orderPriceTypeItems,
                        onChanged: (value) {
                          mSetState(() {
                            _orderPriceType = value.toString();
                            if(_orderPriceType == '1'){
                              _transactionPriceInsideController.text = '';
                            }
                          });
                        },
                        hint: const Text('请选择交易模式',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        value:_orderPriceType == '' ? null : _orderPriceType,
                        elevation: 8, //设置阴影的高度
                        isExpanded: true,
                        dropdownColor: APP_MainBGColor,
                        icon: const Icon(Icons.arrow_drop_down,color: Colors.white,),
                        underline: Container(height: 0),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  ),
                  Container(
                    child: Text("价格(" + data.tradeCurrency! +")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                  Container(
                    height: 30,
                    child: TextField(
                      enabled: _orderPriceType == '2' ? true : false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        suffixText: '',
                        suffixStyle: const TextStyle(color: Colors.white,fontSize: 11),
                        hintText: _orderPriceType == '2' ? '请输入单价' : '以当前市场最优价格下单',
                        hintStyle:const  TextStyle(color: Colors.grey,fontSize: 11),
                      ),
                      controller: _transactionPriceInsideController,
                      autocorrect:false,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal : true,
                      ),
                      inputFormatters: [
                        TextInput_onlyNum(decimalRange: _decSize,integerRange: 14),
                      ],
                      style:const  TextStyle(color: Colors.white,fontSize: 11),
                      onChanged: (value){
                        if(value == ''){
                          _transactionAmountInsideController.text = '';
                        }else{
                          if(_transactionNumberInsideController.text != ''){
                            _transactionAmountInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionNumberInsideController.text)), 8)).toString();
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    child: const Text("数量(手)",style: TextStyle(fontSize: 12,color: Colors.grey),),
                    alignment: Alignment.centerLeft,
                    padding:const  EdgeInsets.fromLTRB(0, 20, 0, 10),
                  ),
                  Container(
                    height: 30,
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        suffixText: '',
                        suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                      ),
                      controller: _transactionNumberInsideController,
                      autocorrect:false,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal : true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // TextInput_onlyNum(decimalRange: 0,integerRange: 14),
                      ],
                      style: const TextStyle(color: Colors.white,fontSize: 11),
                      onChanged: (value){
                        //这个是交易数量的变动
                        //1：价格变动 不影响这个的输入变动
                        //2：数量变动 会联动金额变动
                        //3：金额变动 会联动数量变动
                        if(value == ''){
                          _transactionAmountInsideController.text = '';
                        }else{
                          if(_transactionPriceInsideController.text != ''){
                            _transactionAmountInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) * neverDoubleTryOrZero(_transactionPriceInsideController.text)), 8)).toString();
                          }
                        }
                      },
                    ),
                  ),
                  Offstage(
                    offstage: _orderPriceType == '2' ? false : true,
                    child: Column(
                      children: [
                        Container(
                          child: Text("金额(" + data.tradeCurrency! + ")",style: const TextStyle(fontSize: 12,color: Colors.grey),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        ),
                        Container(
                          height: 30,
                          child: TextField(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(15, 159, 131, 1)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              ),
                              suffixText: '',
                              suffixStyle: TextStyle(color: Colors.white,fontSize: 11),
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey,fontSize: 11),
                            ),
                            controller: _transactionAmountInsideController,
                            autocorrect:false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal : true,
                            ),
                            inputFormatters: [
                              TextInput_onlyNum(decimalRange: 8,integerRange: 14),
                            ],
                            style: const TextStyle(color: Colors.white,fontSize: 11),
                            onChanged: (value){
                              if(value == ''){
                                _transactionNumberInsideController.text = '';
                              }else{
                                if(_transactionPriceInsideController.text != ''){
                                  _transactionNumberInsideController.text = (NumUtil.getNumByValueDouble((neverDoubleTryOrZero(value) / neverDoubleTryOrZero(_transactionPriceInsideController.text)), 8)).toString();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: GestureDetector(
                      child:Container(

                        decoration: BoxDecoration(
                          color: data.matchSide! == 'B' ? APP_MainRedColor : APP_MainGreenColor,
                          borderRadius:const  BorderRadius.all(Radius.circular(5.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(todoSell,style: const TextStyle(fontSize: 14,color: Colors.white),),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        if(_orderPriceType == '2'){
                          if(_transactionPriceInsideController.text == ''){
                            showMyCustomText("请输入交易价格");
                            return;
                          }
                          if(neverDoubleTryOrZero(_insideCommodityTickSize) != 0.0){
                            double _tokeD = (NumUtil.remainder(neverDoubleTryOrZero(_transactionPriceInsideController.text),neverDoubleTryOrZero(_insideCommodityTickSize))).toDouble();
                            if(_tokeD != 0.0){
                              showMyCustomText("请确认输入的价格是最小变动价位的整倍数");
                              return;
                            }
                          }
                        }
                        if(_transactionNumberInsideController.text == ''){
                          showMyCustomText("请输入交易数量");
                          return;
                        }

                        String _direction = '';
                        if(data.matchSide! == 'B') { //2 多头 卖
                          _direction = 'S';
                        }else if(data.matchSide! == 'S') { //3 空头 买
                          _direction = 'B';
                        }else{
                          _direction = '';
                        }

                        // {
                        //   "key":"B",
                        //   "value":"买入"
                        // },
                        // {
                        //   "key":"S",
                        //   "value":"卖出"
                        // }
                        Navigator.pop(tContext);

                        _WPFuturesWpfuturesOrderInfoInsertOrderHttp(
                          // accountNo:"RDGJ06",
                          commodityNo:data.commodityNo!,
                          contractNo:data.contractNo!,
                          exchangeNo:data.exchangeNo!,
                          orderPrice:_transactionPriceInsideController.text,
                          orderQty:_transactionNumberInsideController.text,
                          orderSide:_direction,
                          orderType:_orderPriceType,
                          timeInForce:"0",
                        );

                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}