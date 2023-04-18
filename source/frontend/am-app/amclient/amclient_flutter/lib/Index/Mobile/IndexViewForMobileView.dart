import 'dart:convert';
import 'package:amclient_flutter/Market/Controller/MarketView.dart';
import 'package:amclient_flutter/Setting/Controller/SettingViewController.dart';
import 'package:amclient_flutter/main.dart';
import 'package:flutter/material.dart';


class indexViewForMobileView extends StatefulWidget {
  final arguments;

  const indexViewForMobileView({Key? key, this.arguments}) : super(key: key);
  @override
  _indexViewForMobileViewState createState() => _indexViewForMobileViewState();
}

class _indexViewForMobileViewState extends State<indexViewForMobileView>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int currentIndex = 0;
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    PagePick.nowPageName = '/indexViewForMobileView';
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  void deactivate() {
    var bool = ModalRoute.of(context)!.isCurrent;
    if (bool) {
      print('返回主页');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final pages = [
    MarketView(),

    SettingViewController(),
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "行情资讯",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "账户资产",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "数字货币",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "外盘期货",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "内盘期货",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,color: Colors.grey,),
              alignment: Alignment.center,
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(5),
              child: Image(image: AssetImage('image/Market.png'),fit: BoxFit.contain,),
              alignment: Alignment.center,
            ),
            label: "账户设置",//title: Text("消息",style: TextStyle(color: currentIndex == 0 ? Colors.white : Colors.grey),),
          ),
        ],
        currentIndex: currentIndex,
        backgroundColor: Color.fromRGBO(37, 50, 58, 1),
        type: BottomNavigationBarType.fixed,
        selectedFontSize :10.0,
        selectedItemColor: Colors.white,
        unselectedFontSize : 10.0,
        unselectedItemColor: Colors.grey,
        onTap: onTap,
      ),
    );
  }
}
