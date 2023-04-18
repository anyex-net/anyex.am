
import 'package:flutter/material.dart';

const String EMAIL_VALID_REGISTER  = "email_register";
// 登录类型短信码
const String EMAIL_VALID_LOGIN  = "email_login";
// 忘记密码邮箱码
const String EMAIL_VALID_FORGETPASS  = "email_forgetpass";
// 修改密码邮箱码
const String EMAIL_VALID_MODIFYPASS  = "email_modifypass";
// 其它类型邮箱码
const String EMAIL_VALID_OTHER  = "email_other";
// 注册类型短信码
const String SMS_VALID_REGISTER  = "sms_register";
// 登录类型短信码
const String SMS_VALID_LOGIN  = "sms_login";
// 忘记密码短信码
const String SMS_VALID_FORGETPASS  = "sms_forgetpass";
// 修改密码短信码
const String SMS_VALID_MODIFYPASS  = "sms_modifypass";
// 其它类型短信码
const String SMS_VALID_OTHER  = "sms_other";
// 默认安全验证策略
const String SECURITY_POLICY_DEFAULT = "0";
// 安全验证策略启用SMS
const String SECURITY_POLICY_NEEDSMS  = "1";
// 安全验证策略启用GA
const String SECURITY_POLICY_NEEDGA = "2";
// 安全验证策略启用SMS或GA
const String SECURITY_POLICY_NEEDGAORSMS = "3";
// 安全验证策略启用SMS和GA
const String SECURITY_POLICY_NEEDGAANDSMS = "4";



//统一阴影
const MyButtonBoxShadow = BoxShadow(blurRadius: 8, spreadRadius: 1, color: Colors.grey,offset:Offset(3,3));

//全局颜色定义
//标准绿色
const APP_MainGreenColor = Color.fromRGBO(66, 178, 182, 1);
//标准红色
const APP_MainRedColor = Color.fromRGBO(215, 85, 82,  1);
//标准背景色
const APP_MainBGColor = Color.fromRGBO(21, 51, 81,  1);
//标准背景色
const APP_MainViewColor = Color.fromRGBO(5, 51, 84, 1);
//标准标题栏颜色
const APP_MainBarColor = Color.fromRGBO(0, 37, 65, 1);


