import 'package:amclient_flutter/Base/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DigitalCurrencyExchangeApiEncryptionView extends StatefulWidget {
  final arguments;
  const DigitalCurrencyExchangeApiEncryptionView({Key? key, this.arguments}) : super(key: key);

  @override
  _DigitalCurrencyExchangeApiEncryptionViewState createState() => _DigitalCurrencyExchangeApiEncryptionViewState();
}

class _DigitalCurrencyExchangeApiEncryptionViewState extends State<DigitalCurrencyExchangeApiEncryptionView> {


  //API KEY
  final TextEditingController _apiKeyController = TextEditingController();

  //API Secret KEY
  final TextEditingController _apiSecretKeyController = TextEditingController();



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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Text('新增交易所API',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        child: const Icon(Icons.close,color: Colors.black,),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('API KEY',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//API KEY
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 40,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: APP_MainGreenColor),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Color.fromRGBO(15, 159, 131, 1),fontSize: 12),
                      hintText: '请输入API Key (Access Key)',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    ),
                    controller: _apiKeyController,
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('API Secret',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//API Secret
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 40,
                  child: TextField(
                    autocorrect:false,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: APP_MainGreenColor),
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      suffixText: '',
                      suffixStyle: TextStyle(color: Color.fromRGBO(15, 159, 131, 1),fontSize: 12),
                      hintText: '请输入API Secret(Secret Key)',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    ),
                    controller: _apiSecretKeyController,
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          ),
                          child: const Text('取消',style: TextStyle(color: Colors.white),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                        onTap :(){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(15, 159, 131, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          ),
                          child: const Text('提交',style: TextStyle(color: Colors.white),),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        ),
                        onTap :() async{

                          // var response = await getQuantApiSave(exchange: _exchangeName ,exchangeAccount: _accountNum,
                          //     apiKey: _apiKeyController.text.toString(),apiSecret: _apiSecretKeyController.text.toString(),
                          //     passphrase:_passphraseController.text.toString(),purpose:'trade',remark: _remarkController.text.toString(),
                          //     divisor: _divisorController.text.toString()
                          // );
                          // if (response is Map) {
                          //   if(!mounted){
                          //     return;
                          //   }
                          //   if(response['code'] == 200){
                          //     showMyCustomText('新增交易API成功');
                          //     Navigator.pop(context);
                          //   }else{
                          //     showMyCustomText(response['message']);
                          //   }
                          // }
                        },
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }


}

