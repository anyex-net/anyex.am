import 'dart:convert';
import 'dart:ui';
import 'package:amclient_flutter/Base/HttpRequest.dart';
import 'package:amclient_flutter/Login/Controller/LoginViewController.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:neveruseless/neveruseless.dart';
import 'Base/Global.dart';
import 'Base/routes.dart';


Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _checkURL();
  Future.delayed(const Duration(milliseconds: 100)).then((onValue) async{
    runApp(MyApp());
  });
}

void _checkURL() async{

  // Map _userUrlMap = {
  //   'kUserAddress' : _kUserAddress.text.toString(),
  //   'kUserWPFuturesAddress' : _kUserWPFuturesAddress.text.toString(),
  //   'kUserWPFuturesSocketAddress' : _kUserWPFuturesSocketAddress.text.toString(),
  //   'kUserNPFuturesAddress' : _kUserNPFuturesAddress.text.toString(),
  //   'kUserNPFuturesSocketAddress' : _kUserNPFuturesSocketAddress.text.toString(),
  //   'kUserDigitalAddress' : _kUserDigitalAddress.text.toString(),
  //   'kUserDigitalSocketAddress' : _kUserDigitalSocketAddress.text.toString(),
  //   'kUserDigitalSocketPrivateAddress' : _kUserDigitalSocketPrivateAddress.text.toString(),
  // };

  var _userUrlStrT = await neverLocalStorageRead("kUserUrlMap");

  if(_userUrlStrT != null){
    String _userUrlStr = _userUrlStrT.toString();
    Map _userUrlMap = jsonDecode(_userUrlStr);
    print(_userUrlMap);

    var _kUserAddressTemp = _userUrlMap["kUserAddress"].toString();
    if(_kUserAddressTemp.toString() == '' || _kUserAddressTemp.toString() == "null"){
    }else{
      kAddress = _kUserAddressTemp;
    }

    var _kUserWPFuturesAddressTemp = _userUrlMap["kUserWPFuturesAddress"].toString();
    if(_kUserWPFuturesAddressTemp.toString() == '' || _kUserWPFuturesAddressTemp.toString() == "null"){
    }else{ //
      kWPFuturesAddress = _kUserWPFuturesAddressTemp;
    }

    var _kUserWPFuturesSocketAddressTemp = _userUrlMap["kUserWPFuturesSocketAddress"].toString();
    if(_kUserWPFuturesSocketAddressTemp.toString() == '' || _kUserWPFuturesSocketAddressTemp.toString() == "null"){
    }else{ //
      kWPFuturesSocketAddress = _kUserWPFuturesSocketAddressTemp;
    }

    var _kUserNPFuturesAddressTemp = _userUrlMap["kUserNPFuturesAddress"].toString();
    if(_kUserNPFuturesAddressTemp.toString() == '' || _kUserNPFuturesAddressTemp.toString() == "null"){
    }else{ //
      kNPFuturesAddress = _kUserNPFuturesAddressTemp;
    }

    var _kUserNPFuturesSocketAddressTemp = _userUrlMap["kUserNPFuturesSocketAddress"].toString();
    if(_kUserNPFuturesSocketAddressTemp.toString() == '' || _kUserNPFuturesSocketAddressTemp.toString() == "null"){
    }else{ //
      kNPFuturesSocketAddress = _kUserNPFuturesSocketAddressTemp;
    }

    var _kUserDigitalAddressTemp = _userUrlMap["kUserDigitalAddress"].toString();
    if(_kUserDigitalAddressTemp.toString() == '' || _kUserDigitalAddressTemp.toString() == "null"){
    }else{ //
      kDigitalAddress = _kUserDigitalAddressTemp;
    }

    var _kUserDigitalSocketAddressTemp = _userUrlMap["kUserDigitalSocketAddress"].toString();
    if(_kUserDigitalSocketAddressTemp.toString() == '' || _kUserDigitalSocketAddressTemp.toString() == "null"){
    }else{ //
      kDigitalSocketAddress = _kUserDigitalSocketAddressTemp;
    }

    var _kUserDigitalSocketPrivateAddressTemp = _userUrlMap["kUserDigitalSocketPrivateAddress"].toString();
    if(_kUserDigitalSocketPrivateAddressTemp.toString() == '' || _kUserDigitalSocketPrivateAddressTemp.toString() == "null"){
    }else{ //
      kDigitalSocketPrivateAddress = _kUserDigitalSocketPrivateAddressTemp;
    }
  }

}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {


  ThemeMode _themeMode = ThemeMode.light;


  @override
  initState() {
    WidgetsBinding.instance!.addObserver(this);


    neverBus.on('balck', (object) {
      setState(() {
        if(_themeMode == ThemeMode.light){
          _themeMode = ThemeMode.dark;
        }else{
          _themeMode = ThemeMode.light;
        }
      });
    });

  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
    }
  }



  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        // S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      // 讲zh设置为第一项,没有适配语言时，英语为首选项
      // supportedLocales: S.delegate.supportedLocales,
      title: 'Anyex.GAMS',
      // showPerformanceOverlay: true,
      navigatorKey: navigatorKey,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        cardColor: Colors.white,//为了弹窗
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        canvasColor: Colors.white,//页面背景色
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: APP_MainBarColor,
          iconTheme:IconThemeData(
            color: Colors.black
          ),
          elevation: 0.0,//隐藏底部阴影分割线
          centerTitle: true,//标题是否居中 安卓上有效ios默认居中
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          minWidth: 0,
          height: 0,
          padding: EdgeInsets.all(0),
          buttonColor: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black,fontSize: 13),
        ),
      ),
      home: const LoginViewController(),//indexViewForDesktopController(),//LoginViewController(),//
    );
  }
}

//全局临时参数
class PagePick {
  static String nowPageName = '';
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.unknown
    // etc.
  };
}