import 'dart:io';
import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/WPFutures/Controller/WPFuturesAccountInfoAddView.dart';
import 'package:amclient_flutter/WPFutures/Http/WPFuturesHttpRequest.dart';
import 'package:amclient_flutter/WPFutures/Model/WPFuturesAccountInfoResponseModel.dart';
import 'package:amclient_flutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neveruseless/never/neverBus.dart';
class WPFuturesAccountInfoView extends StatefulWidget {
  final arguments;
  const WPFuturesAccountInfoView({Key? key, this.arguments}) : super(key: key);

  @override
  _WPFuturesAccountInfoViewState createState() => _WPFuturesAccountInfoViewState();
}

class _WPFuturesAccountInfoViewState extends State<WPFuturesAccountInfoView> {


  late List<WPFuturesAccountInfoResponseData> _accountInfoList = [];

  @override
  void initState() {
    super.initState();
    _WPFuturesWpfuturesAccountInfoDataHttp();

    neverBus.on('WPFuturesAccountInfoUpdate', (object) {
      if(mounted){
        _WPFuturesWpfuturesAccountInfoDataHttp();
      }
    });

  }

  @override
  void dispose() {
    neverBus.off("WPFuturesAccountInfoUpdate");
    super.dispose();
  }

  //外盘期货 查询外盘期货资金账号
  Future _WPFuturesWpfuturesAccountInfoDataHttp() async{
    var response = await WPFuturesWpfuturesAccountInfoData();
    if (response is Map) {
      if(!mounted){
        return;
      }
      if(response['code'] == 200){
        setState(() {
          _accountInfoList = WPFuturesAccountInfoResponseModel.fromJson(response).object!;
        });
      }else {
        if(response.containsKey('message')){
          showMyCustomText(response["message"]);
        }else{
          showMyCustomText('[查询外盘期货资金账号]遇到问题，请检查网络或重新刷新');
        }
      }
    }else {
      try{
        showMyCustomText(response.error.toString());
      }catch(e){
        showMyCustomText('[查询外盘期货资金账号]遇到问题，请检查网络或重新刷新');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: APP_MainBGColor,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              child: Container(
                decoration: const BoxDecoration(
                  color: APP_MainGreenColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, //阴影范围
                        spreadRadius: 0.1, //阴影浓度
                        color: Colors.black, //阴影颜色
                        offset:Offset(1,3)
                    ),
                  ],
                ),
                child: const Text('新增外盘期货API',style: TextStyle(color: Colors.white,fontSize: 12),softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 1,),
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: 130,
                alignment: Alignment.center,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
            ),
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
              AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dismissOnBackKeyPress:false,
                width:MediaQuery.of(context).size.width / 1.5,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.BOTTOMSLIDE,
                body:const  WPFuturesAccountInfoAddView(),
              ).show();
            },
          ),
          const Divider(height: 1,color: Colors.grey,),
          Container(
            color: APP_MainBarColor,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('经纪商编码',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('资金账号',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('账户类型',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('账户状态',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const  VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('行情前置机地址',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('交易前置机地址',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text('行情资金账号',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 2,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                  Expanded(
                    child: Container(
                      padding:const  EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text('操作',style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.w500),),
                      alignment: Alignment.center,
                    ),
                    flex: 1,
                  ),
                  const VerticalDivider(width: 1,color: Colors.grey,),
                ],
              ),
            ),
          ),
          const Divider(height: 1,color: Colors.grey,),
          Expanded(
            child:EasyRefresh(
              behavior: MyCustomScrollBehavior(),
              child:ListView.builder(
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      Offstage(
                        child: const Divider(height: 1,color: Colors.grey),
                        offstage: index != 0,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  padding:const  EdgeInsets.fromLTRB(0, 10, 0,10),
                                  child: Text(_accountInfoList[index].brokerNo!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].accountNo!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].accountType!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].accountState!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].quoteApiAddr!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].tradeApiAddr!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child: Container(
                                  child: Text(_accountInfoList[index].quoteAccountNo!,style: const TextStyle(fontSize: 12,color: Colors.white),),
                                  alignment: Alignment.center,
                                ),
                                flex: 2,
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                              Expanded(
                                child:Container(
                                  child: GestureDetector(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: APP_MainRedColor,
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      child: const Text('删除',style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.w500),),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async{
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      var response = await WPFuturesWpfuturesAccountInfoDel(id: _accountInfoList[index].id!);
                                      if (response is Map) {
                                        if(!mounted){
                                          return;
                                        }
                                        if(response['code'] == 200){
                                          showMyCustomText("删除成功");
                                          neverBus.emit('WPFuturesAccountInfoUpdate');
                                        }else {
                                          if(response.containsKey('message')){
                                            showMyCustomText(response["message"]);
                                          }else{
                                            showMyCustomText('遇到问题，请检查网络或重新刷新');
                                          }
                                        }
                                      }else {
                                        try{
                                          showMyCustomText(response.error.toString());
                                        }catch(e){
                                          showMyCustomText('遇到问题，请检查网络或重新刷新');
                                        }
                                      }
                                    },
                                  ),
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  alignment: Alignment.center,
                                ),
                              ),
                              const VerticalDivider(width: 1,color: Colors.grey,),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1,color: Colors.grey,),
                    ],
                  );
                },
                itemCount: _accountInfoList.length,
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
                    _WPFuturesWpfuturesAccountInfoDataHttp();
                  }
                });
              },
              onLoad:null,
            ),
          )
        ],
      ),
    );
  }





}

