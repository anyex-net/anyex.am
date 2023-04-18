import 'package:amclient_flutter/Base/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
class SettingKYCView extends StatefulWidget {
  final arguments;
  const SettingKYCView({Key? key, this.arguments}) : super(key: key);

  @override
  _SettingKYCViewState createState() => _SettingKYCViewState();
}

class _SettingKYCViewState extends State<SettingKYCView> {


  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _desktopView();
  }



  Widget _desktopView(){
    return Container(
      color: APP_MainBGColor,
      alignment: Alignment.center,
      child: ListView(
        controller: _controller1,
        children: [
          Container(
            child: const Text('身份认证',style: TextStyle(fontSize: 18,color: Colors.white,),),
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                children: [
                  const Icon(Icons.error,color: Colors.orange,),
                  Expanded(
                    child: Container(
                      child:const Text("您填写的信息必须与证件信息保持一致",style: TextStyle(fontSize: 12,color: Colors.white),),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    ),
                  )
                ],
              )
          ),
        ],
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
          iconTheme:const IconThemeData(
              color: Colors.white
          ),
          title: const Text("身份认证"),
        ),
        body:Container(
          color: APP_MainBGColor,
          alignment: Alignment.center,
          child: ListView(
            controller: _controller2,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.error,color: Colors.orange,),
                      Expanded(
                        child: Container(
                          child:const Text("您填写的信息必须与证件信息保持一致",style: TextStyle(fontSize: 12,color: Colors.white),),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        ),
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }


}

