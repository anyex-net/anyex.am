

import 'package:amclient_flutter/AccountAssets/Controller/AccountAssetsView.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiAddView.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiEncryptionView.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyExchangeApiView.dart';
import 'package:amclient_flutter/DigitalCurrency/Controller/DigitalCurrencyView.dart';
import 'package:amclient_flutter/Index/Desktop/IndexViewForDesktopView.dart';
import 'package:amclient_flutter/Login/Controller/ForgetPasswordViewController.dart';
import 'package:amclient_flutter/Login/Controller/LoginViewController.dart';
import 'package:amclient_flutter/Login/Controller/RegisterViewController.dart';
import 'package:amclient_flutter/Market/Controller/MarketView.dart';
import 'package:amclient_flutter/NPFutures/Controller/NPFuturesAccountInfoAddView.dart';
import 'package:amclient_flutter/NPFutures/Controller/NPFuturesAccountInfoView.dart';
import 'package:amclient_flutter/NPFutures/Controller/NPFuturesIndexView.dart';
import 'package:amclient_flutter/NPSpot/Controller/NPSpotAccountInfoAddView.dart';
import 'package:amclient_flutter/NPSpot/Controller/NPSpotAccountInfoView.dart';
import 'package:amclient_flutter/NPSpot/Controller/NPSpotIndexView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordCashPasswordView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordLoginPasswordView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingChangePasswordView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingHistoryView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingKYCView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoBindGAView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoBindPhoneView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingPersonalInfoView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoBindEmailView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingSecurityInfoView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingViewController.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesAccountInfoAddView.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesAccountInfoView.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesIndexView.dart';
import 'package:amclient_flutter/WPSpot/Controller/WPSpotAccountInfoAddView.dart';
import 'package:amclient_flutter/WPSpot/Controller/WPSpotAccountInfoView.dart';
import 'package:amclient_flutter/WPSpot/Controller/WPSpotIndexView.dart';


import 'package:flutter/material.dart';

final routes = {

  // '/StrategicEditPageHedgeViewController': (context, {arguments}) =>StrategicEditPageHedgeViewController(arguments: arguments),

  '/indexViewForDesktopController': (context, {arguments}) =>indexViewForDesktopController(arguments: arguments),
  //登录页面
  '/LoginViewController': (context, {arguments}) =>LoginViewController(arguments: arguments),
  //注册页面
  '/RegisterViewController': (context, {arguments}) =>RegisterViewController(arguments: arguments),
  //忘记密码
  '/ForgetPasswordViewController': (context, {arguments}) =>ForgetPasswordViewController(arguments: arguments),


  //行情页面
  '/MarketView': (context, {arguments}) =>MarketView(arguments: arguments),


  //账户设置
  '/SettingViewController': (context, {arguments}) =>SettingViewController(arguments: arguments),
  //账户设置 - 个人信息
  '/SettingPersonalInfoView': (context, {arguments}) =>SettingPersonalInfoView(arguments: arguments),
  //账户设置 - 安全设置
  '/SettingSecurityInfoView': (context, {arguments}) =>SettingSecurityInfoView(arguments: arguments),
  //账户设置 - 安全设置 - 绑定邮箱
  '/SettingSecurityInfoBindEmailView': (context, {arguments}) =>SettingSecurityInfoBindEmailView(arguments: arguments),
  //账户设置 - 安全设置 - 绑定手机
  '/SettingSecurityInfoBindPhoneView': (context, {arguments}) =>SettingSecurityInfoBindPhoneView(arguments: arguments),
  //账户设置 - 安全设置 - 绑定GA
  '/SettingSecurityInfoBindGAView': (context, {arguments}) =>SettingSecurityInfoBindGAView(arguments: arguments),
  //账户设置 - 身份认证
  '/SettingKYCView': (context, {arguments}) =>SettingKYCView(arguments: arguments),
  //账户设置 - 密码设置
  '/SettingChangePasswordView': (context, {arguments}) =>SettingChangePasswordView(arguments: arguments),
  //账户设置 - 密码设置 - 登录密码
  '/SettingChangePasswordLoginPasswordView': (context, {arguments}) =>SettingChangePasswordLoginPasswordView(arguments: arguments),
  //账户设置 - 密码设置 - 资金密码
  '/SettingChangePasswordCashPasswordView': (context, {arguments}) =>SettingChangePasswordCashPasswordView(arguments: arguments),
  //账户设置 - 历史记录
  '/SettingHistoryView': (context, {arguments}) =>SettingHistoryView(arguments: arguments),



  //外盘期货
  '/WPFuturesIndexView': (context, {arguments}) =>WPFuturesIndexView(arguments: arguments),
  //外盘期货 - API
  '/WPFuturesAccountInfoView': (context, {arguments}) =>WPFuturesAccountInfoView(arguments: arguments),
  //外盘期货 - API - 新增
  '/WPFuturesAccountInfoAddView': (context, {arguments}) =>WPFuturesAccountInfoAddView(arguments: arguments),

  //外盘现货
  '/WPSpotIndexView': (context, {arguments}) =>WPSpotIndexView(arguments: arguments),
  //外盘现货 - API
  '/WPSpotAccountInfoView': (context, {arguments}) =>WPSpotAccountInfoView(arguments: arguments),
  //外盘现货 - API - 新增
  '/WPSpotAccountInfoAddView': (context, {arguments}) =>WPSpotAccountInfoAddView(arguments: arguments),

  //内盘期货
  '/NPFuturesIndexView': (context, {arguments}) =>NPFuturesIndexView(arguments: arguments),
  //内盘期货 - API
  '/NPFuturesAccountInfoView': (context, {arguments}) =>NPFuturesAccountInfoView(arguments: arguments),
  //内盘期货 - API - 新增
  '/NPFuturesAccountInfoAddView': (context, {arguments}) =>NPFuturesAccountInfoAddView(arguments: arguments),

  //内盘现货
  '/NPSpotIndexView': (context, {arguments}) =>NPSpotIndexView(arguments: arguments),
  //内盘现货 - API
  '/NPSpotAccountInfoView': (context, {arguments}) =>NPSpotAccountInfoView(arguments: arguments),
  //内盘现货 - API - 新增
  '/NPSpotAccountInfoAddView': (context, {arguments}) =>NPSpotAccountInfoAddView(arguments: arguments),


  //数字货币
  '/DigitalCurrencyView' : (context, {arguments}) =>DigitalCurrencyView(arguments: arguments),
  //数字货币 - API
  '/DigitalCurrencyExchangeApiView': (context, {arguments}) =>DigitalCurrencyExchangeApiView(arguments: arguments),
  //数字货币 - API - 新增
  '/DigitalCurrencyExchangeApiAddView': (context, {arguments}) =>DigitalCurrencyExchangeApiAddView(arguments: arguments),
  //数字货币 - 设置加密因子
  '/DigitalCurrencyExchangeApiEncryptionView': (context, {arguments}) =>DigitalCurrencyExchangeApiEncryptionView(arguments: arguments),


  //账户资产
  '/AccountAssetsView' : (context, {arguments}) =>AccountAssetsView(arguments: arguments),
};

// ignore: top_level_function_literal_block, missing_return
var onGenerateRoute = (RouteSettings settings){
  final String? name = settings.name;

  final Function? pageContentBuilder = routes[name];

  if (settings.arguments != null) {
    final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder!(context, arguments: settings.arguments),
    );
    return route;
  } else {
    final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder!(context));
    return route;
  }
};