import 'package:amclient_flutter/Base/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget WPSpotView_tradeTitle({String priceTitle = 'USD'}){
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
          flex: 2,
        ),
        Expanded(
          child: Container(
            child: Text("数量(手)",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding:const  EdgeInsets.fromLTRB(3, 5, 0, 5),
          ),
        ),
        Expanded(
          child: Container(
            child: Text("时间",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding:const  EdgeInsets.fromLTRB(3, 5, 10, 5),
          ),
          flex: 2,
        ),
      ],
    ),
  );
}

Widget WPSpotView_orderTitle({String priceTitle = 'USD'}){
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
            child: Text("数量(手)",style: TextStyle(color: Colors.grey[300],fontSize: 11),),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(3, 5, 10, 5),
          ),
        ),
      ],
    ),
  );
}