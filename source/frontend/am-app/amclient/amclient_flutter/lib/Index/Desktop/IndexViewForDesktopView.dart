
import 'dart:async';
import 'dart:ui';
import 'package:amclient_flutter/AccountAssets/Controller/AccountAssetsView.dart';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/UserManager.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyView.dart';
import 'package:amclient_flutter/Login/Http/LoginHttpRequest.dart';
import 'package:amclient_flutter/Market/Controller/MarketView.dart';
import 'package:amclient_flutter/NPFutures/Controller/NPFuturesIndexView.dart';
import 'package:amclient_flutter/NPSpot/Controller/NPSpotIndexView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingViewController.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesIndexView.dart';
import 'package:amclient_flutter/WPSpot/Controller/WPSpotIndexView.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:amclient_flutter/Base/UserManager.dart' as UnlockManager;
import 'package:neveruseless/neveruseless.dart';
import '../../main.dart';

class indexViewForDesktopController extends StatefulWidget {
  final arguments;

  const indexViewForDesktopController({Key? key, this.arguments}) : super(key: key);
  @override
  _indexViewForDesktopControllerState createState() => _indexViewForDesktopControllerState();
}

class _indexViewForDesktopControllerState extends State<indexViewForDesktopController> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  final pageController = PageController();
  int _selectedIndex = 0;

  //计时器
  Timer? _timer;
  String _prcTime = '';//utc+8
  String _usaTime = '';//utc-5

  String _cNHExchangeTradeStatus = '';
  String _uSAExchangeTradeStatus = '';

  String _indexUserName = '-';

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  //计时器
  Timer? _exchangeTimer;

  @override
  void initState() {
    // doWhenWindowReady(() {
    //   final initialSize = Size(window.physicalSize.width * (0.8), window.physicalSize.height);
    //   appWindow.size = initialSize;
    //   appWindow.alignment = Alignment.topCenter;
    //   // appWindow.show();
    // });
    super.initState();
    PagePick.nowPageName = '/indexViewForDesktopController';
    getTimeNowUTC();
    getUserInfoMap();
    _CommonServerExchangeTradeStatusHttp();
  }

  void getUserInfoMap() async{
    var _idVar = await neverLocalStorageRead("kUserDefaultsKeyID");
    _indexUserName = UnlockManager.personMap['accountName'];
    String _id = _idVar.toString();
    await getUserUnlockInfoWithUnid(unid:_id,);
    if(_timer != null){
      _timer!.cancel();
    }
    _timer = null;
    if(_exchangeTimer != null){
      _exchangeTimer!.cancel();
    }
    _exchangeTimer = null;
    _startTimer();
    _startExchangeTimer();
  }

  Future _CommonServerExchangeTradeStatusHttp() async{
    var response = await CommonServerExchangeTradeStatus();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          String _c = response['object']['CNHExchangeTradeStatus'].toString();
          if(_c == 'Open'){
            _cNHExchangeTradeStatus = '交易中';
          }else if (_c == 'Close'){
            _cNHExchangeTradeStatus = '未开盘';
          }else{
            _cNHExchangeTradeStatus = '-';
          }

          String _u = response['object']['USAExchangeTradeStatus'].toString();
          if(_u == 'Open'){
            _uSAExchangeTradeStatus = '交易中';
          }else if (_u == 'Close'){
            _uSAExchangeTradeStatus = '未开盘';
          }else{
            _uSAExchangeTradeStatus = '-';
          }
        });
      }else {

      }
    }else {

    }
  }

  void getTimeNowUTC(){
    String utcTime = DateTime.now().toUtc().toString().substring(0,19);
    _prcTime = formatDate(DateTime.parse("$utcTime-0800"), [ mm, '/', dd, ' ',HH, ':', nn, ':', ss]);
    _usaTime = formatDate(DateTime.parse("$utcTime+0500"), [ mm, '/', dd, ' ',HH, ':', nn, ':', ss]);
  }


  @override
  void deactivate() {
    var bool = ModalRoute.of(context)!.isCurrent;
    if (bool) {

    }
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    if(_exchangeTimer != null){
      _exchangeTimer!.cancel();
    }
    super.dispose();
  }

  final pages = const [
    MarketView(),
    DigitalCurrencyView(),
    WPFuturesIndexView(),
    WPSpotIndexView(),
    NPFuturesIndexView(),
    NPSpotIndexView(),
    AccountAssetsView(),
    SettingViewController(),
  ];

  final pagesName = const [
    "/MarketView",
    "/DigitalCurrencyView",
    "/WPFuturesIndexView",
    "/WPSpotIndexView",
    "/NPFuturesIndexView",
    "/NPSpotIndexView",
    "/AccountAssetsView",
    "/SettingViewController",
  ];



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldkey,
      body: Row(
        children: <Widget>[
          IntrinsicWidth(
            child:Column(
              children: [
                Expanded(
                  child: NavigationRail(
                    backgroundColor: const Color.fromRGBO(0, 37, 65, 1),
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      pageController.jumpToPage(index);
                      print("打开" + pagesName[index]);
                      neverBus.emit('pageController', pagesName[index]);
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    leading: GestureDetector(
                      child: Container(
                        child: const Image(image: AssetImage('image/Login_MainLogo.png'),fit: BoxFit.contain,width: 35,),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                      ),
                      onTap: (){
                        // navigatorKey.currentState!.pushNamedAndRemoveUntil('/LoginViewController',(route) => false);

                        // navigatorKey.currentState!.push(MaterialPageRoute(
                        //   builder: (context) => LoginViewController(),
                        //   fullscreenDialog: true,
                        // ),);
                      },
                    ),
                    labelType: NavigationRailLabelType.all,
                    selectedLabelTextStyle: const TextStyle(fontSize: 11,color: Colors.white),
                    unselectedLabelTextStyle: const TextStyle(fontSize: 11,color: Colors.grey),
                    destinations: [
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_Market_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_Market_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('行情资讯'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_DigitalCurrency_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_DigitalCurrency_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('数字货币'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_WpFutures_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_WpFutures_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('外盘期货'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_WpFutures_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_WpFutures_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('外盘现货'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_NpFutures_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_NpFutures_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('内盘期货'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_NpFutures_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_NpFutures_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('内盘现货'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_AccountAssets_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_AccountAssets_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('账户资产'),
                      ),
                      NavigationRailDestination(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_Setting_off.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        selectedIcon: Container(
                          padding: const EdgeInsets.all(5),
                          child: const Image(image: AssetImage('image/Tab_Setting_on.png'),fit: BoxFit.contain,width: 30,),
                          alignment: Alignment.center,
                        ),
                        label: const Text('账户设置'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: pages,
                    onPageChanged: (int index){
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: const Image(image: AssetImage('image/index_prc.png'),height: 20,fit: BoxFit.contain,),
                                alignment: Alignment.center,
                              ),
                              Container(
                                child: Text(_cNHExchangeTradeStatus,style: const TextStyle(color: Colors.white,fontSize: 10),),
                                padding:const  EdgeInsets.fromLTRB(5, 0, 20, 2),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: const Image(image: AssetImage('image/index_usa.png'),height: 20,fit: BoxFit.contain,),
                                alignment: Alignment.center,
                              ),
                              Container(
                                child: Text(_uSAExchangeTradeStatus,style: const TextStyle(color: Colors.white,fontSize: 10),),
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 2),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                child: const VerticalDivider(width: 1,color: Colors.grey,),
                                padding: const EdgeInsets.fromLTRB(20, 3, 3, 3),
                              ),
                            ],
                          )
                      ),
                      Container(
                        child: const VerticalDivider(width: 1,color: Colors.grey,),
                        padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                      ),
                      Container(
                        child: Text("当前账户:" + _indexUserName,style: const TextStyle(color: Colors.white,fontSize: 11),),
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        alignment: Alignment.centerRight,
                      ),
                      Container(
                        child: const VerticalDivider(width: 1,color: Colors.grey,),
                        padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                      ),
                      Container(
                        child: Text("北京时间(CST) " + _prcTime,style: const TextStyle(color: Colors.white,fontSize: 11),),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        alignment: Alignment.center,
                        width:170,
                      ),
                      Container(
                        child: Text("美东时间(EST) " +_usaTime,style: const TextStyle(color: Colors.white,fontSize: 11),),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        alignment: Alignment.center,
                        width:170,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  height: 36,
                  color: APP_MainBarColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }



  void _startTimer() { //累加1
    const oneSec = Duration(seconds: 1);//间隔1秒
    _timer = Timer.periodic(oneSec, (Timer timer){
      if(!mounted){
        return;
      }
      setState(() {
        getTimeNowUTC();
      });
    }
    );
  }

  void _startExchangeTimer() { //累加1
    const oneSec = Duration(seconds: 15);//间隔15秒 拉取一次交易所状态
    _exchangeTimer = Timer.periodic(oneSec, (Timer timer){
      if(!mounted){
        return;
      }
      _CommonServerExchangeTradeStatusHttp();
    }
    );
  }
}
