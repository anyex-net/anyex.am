import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/Setting/Http/SettingHttpRequest.dart';
import 'package:amclient_flutter/Setting/Model/SettingHistoryResponseModel.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class SettingHistoryView extends StatefulWidget {
  final arguments;
  const SettingHistoryView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingHistoryViewState createState() => _SettingHistoryViewState();
}

class _SettingHistoryViewState extends State<SettingHistoryView> {

  String _selectIndexType = "0";//0 最近登录历史 1安全设置历史

  late List<SettingHistorySettingLogsListModel> _settingLogsList = [];
  late List<SettingHistorySettingLogsListModel> _loginLogsList = [];

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _SettingAccountSecurityLoginLogsHttp();
  }

  @override
  void dispose() {
    super.dispose();
  }


  //登录记录
  Future _SettingAccountSecurityLoginLogsHttp() async{//{String email = '',String emailCode = '',String smsCode = ''}
    var response = await SettingAccountSecurityLoginLogs();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          _loginLogsList = SettingHistorySettingLogsResponseModel.fromJson(response).object!;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取登录记录]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取登录记录]遇到问题，请检查网络或重新刷新');
      }
    }
  }

  //安全历史设置
  Future _SettingAccountSecuritySettingLogsHttp() async{//{String email = '',String emailCode = '',String smsCode = ''}
    var response = await SettingAccountSecuritySettingLogs();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200) {
        setState(() {
          _settingLogsList = SettingHistorySettingLogsResponseModel.fromJson(response).object!;

        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[获取安全历史设置记录]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[获取安全历史设置记录]遇到问题，请检查网络或重新刷新');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return _desktopView();
  }

  Widget _desktopView(){
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        backgroundColor: APP_MainBGColor,
        body:Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _selectIndexItemView("0","最近登录历史"),
                ),
                Expanded(
                  child: _selectIndexItemView("1","安全设置历史"),
                ),
              ],
            ),
            _selectIndexType == "0" ?
            Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: const Text('HKT时间',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: const Text('IP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            ),
                          )
                        ],
                      ),
                      Divider(height: 5,color: Colors.grey[700],),
                      Expanded(
                        child: ListView.builder(
                          controller: _controller1,
                          itemBuilder: (context,index){
                            return Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(_loginLogsList[index].createDate!),
                                        [yyyy ,'-', mm, '-', dd, ' ',HH, ':', nn, ':', ss]),style: const TextStyle(color: Colors.white),),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(_loginLogsList[index].ipAddr!,style: const TextStyle(color: Colors.white),),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: _loginLogsList == null ? 0 :_loginLogsList.length,
                        ),
                      )
                    ],
                  ),
                ) :
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: const Text('HKT时间',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: const Text('安全设置历史',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: const Text('IP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                      )
                    ],
                  ),
                  Divider(height: 5,color: Colors.grey[700],),
                  Expanded(
                    child: ListView.builder(
                      controller: _controller2,
                      itemBuilder: (context,index){
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(formatDate(DateTime.fromMillisecondsSinceEpoch(_settingLogsList[index].createDate!),
                                    [yyyy ,'-', mm, '-', dd, ' ',HH, ':', nn, ':', ss]),style: const TextStyle(color: Colors.white),),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_settingLogsList[index].content!,style: const TextStyle(color: Colors.white),),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(_settingLogsList[index].ipAddr!,style: const TextStyle(color: Colors.white),),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: _settingLogsList == null ? 0 :_settingLogsList.length,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mobileView(){
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("个人信息"),
        ),
        body:Container(
        ),
      ),
    );
  }

  Widget _selectIndexItemView(String type,String typeName){
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Text(typeName,style: const TextStyle(color: Colors.white),),
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Container(
              color: _selectIndexType == type ? APP_MainGreenColor : Colors.transparent,
              child: Text(typeName,style: const TextStyle(color: Colors.white),),
              alignment: Alignment.center,
              height: 1,
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      ),
      behavior: HitTestBehavior.opaque,
      onTap: (){
        setState(() {
          if(type == "0" && _selectIndexType == '1'){
            _SettingAccountSecurityLoginLogsHttp();
          }
          if(type == "1" && _selectIndexType == '0'){
            _SettingAccountSecuritySettingLogsHttp();
          }
          _selectIndexType = type;
        });
      },
    );
  }
}

