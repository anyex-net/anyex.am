import 'package:amclient_flutter/Base/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///这里仅存放不涉及 setState()的部分代码，作为静态资源调用。

//币币 和 杠杆 的标题栏
Widget DigitalCurrencyView_SpotAndMarginTitle(){
  return Container(
    child:Row(
      children: [
        Expanded(
          child:Container(
            child: Text("币对",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          ),
          flex: 2,
        ),
        Expanded(
          child:Container(
            child: Text("最新价",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("涨跌幅",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          ),
        )
      ],
    ),
    padding: const EdgeInsets.all(0),
    alignment: Alignment.center,

  );
}

//永续 和 交割 的标题栏
Widget DigitalCurrencyView_PerpetualAndFuturesTitle(){
  return Container(
    child:Row(
      children: [
        Expanded(
          child:Container(
            child: Text("合约",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          ),
          flex: 2,
        ),
        Expanded(
          child:Container(
            child: Text("最新价",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
        ),
        Expanded(
          child:Container(
            child: Text("涨跌幅",style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          ),
        )
      ],
    ),
    padding: const EdgeInsets.all(0),
    alignment: Alignment.center,

  );
}

//期权 的标题栏
Widget DigitalCurrencyView_OptionsTitle() {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: Text("行权价", style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("类型", style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("标记价格", style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("涨跌幅", style: TextStyle(color: Colors.grey[400]),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          ),
        )
      ],
    ),
    padding: const EdgeInsets.all(0),
    alignment: Alignment.center,

  );
}

Widget DigitalCurrencyView_tradeTitle({String priceTitle = 'USDT',String numTitle = ''}){
  return Container(
    alignment: Alignment.center,
    color: APP_MainBGColor,
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: Text("价格(" + priceTitle + ")",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("数量("+ numTitle + ")",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("时间",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
          ),
        ),
      ],
    ),
  );
}

Widget DigitalCurrencyView_orderTitle({String priceTitle = 'USD',String numTitle = ''}){
  return Container(
    alignment: Alignment.center,
    color: APP_MainBGColor,
    child: Row(
      children: [
        Expanded(
          child: Container(
            child: Text("价格(" + priceTitle + ")",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("数量("+ numTitle + ")",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("合计("+ numTitle + ")",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
          ),
        ),
      ],
    ),
  );
}


