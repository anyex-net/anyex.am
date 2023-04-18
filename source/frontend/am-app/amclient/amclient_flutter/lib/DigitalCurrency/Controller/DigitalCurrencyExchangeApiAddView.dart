import 'package:amclient_flutter/Base/Global.dart';
import 'package:amclient_flutter/Base/MyBotTextToast.dart';
import 'package:amclient_flutter/DigitalCurrency/Http/DigitalCurrencyHttpRequest.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:neveruseless/neveruseless.dart';
class DigitalCurrencyExchangeApiAddView extends StatefulWidget {
  final arguments;
  const DigitalCurrencyExchangeApiAddView({Key? key, this.arguments}) : super(key: key);

  @override
  _DigitalCurrencyExchangeApiAddViewState createState() => _DigitalCurrencyExchangeApiAddViewState();
}

class _DigitalCurrencyExchangeApiAddViewState extends State<DigitalCurrencyExchangeApiAddView> {

  //交易所
  String _exchangeName = '';
  String _exchangeShowName = '---';

  //权限
  String _tradeType = 'trade';

  //账户号
  String _accountNum = '';

  //API KEY
  final TextEditingController _apiKeyController = TextEditingController();

  //API Secret KEY
  final TextEditingController _apiSecretKeyController = TextEditingController();

  //Passphrase
  final TextEditingController _passphraseController = TextEditingController();

  //remark
  final TextEditingController _remarkController = TextEditingController();

  //divisor
  final TextEditingController _divisorController = TextEditingController();

  //isDivisor
  String _isDivisor = 'yes';


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
                  child: const Text('交易所',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//交易所
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    alignment: Alignment.centerRight,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //边框圆角设置
                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                      border: Border.all(color: const Color.fromRGBO(15, 159, 131, 1)),
                    ),
                    child: DropdownButton(
                      items: const [
                        DropdownMenuItem(child: Text('Huobi',style: TextStyle(color: Colors.black,fontSize: 13),),value: 'Huobi',),
                        DropdownMenuItem(child: Text('OKEx',style: TextStyle(color: Colors.black,fontSize: 13),),value: 'OKEx',),
                        DropdownMenuItem(child: Text('Binance',style: TextStyle(color: Colors.black,fontSize: 13),),value: 'Binance',),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _exchangeName = value.toString();
                          _theExchangeAndTypeChange();
                        });
                      },
                      hint: const Text('请选择交易所',style: TextStyle(color: Colors.grey,fontSize: 13),),
                      value:_exchangeName == '' ? null : _exchangeName,
                      elevation: 8, //设置阴影的高度
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                      underline: Container(height: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('API编号',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//API编号
                Row(
                  children: [
                    Text(_exchangeShowName, style: const TextStyle(fontSize: 13),),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          alignment: Alignment.centerLeft,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //边框圆角设置
                            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                            border: Border.all(color: const Color.fromRGBO(15, 159, 131, 1)),
                          ),
                          child: DropdownButton(
                            items: const [
                              DropdownMenuItem(child: Text('01',style: TextStyle(color: Colors.black,fontSize: 13),),value: '01',),
                              DropdownMenuItem(child: Text('02',style: TextStyle(color: Colors.black,fontSize: 13),),value: '02',),
                              DropdownMenuItem(child: Text('03',style: TextStyle(color: Colors.black,fontSize: 13),),value: '03',),
                              DropdownMenuItem(child: Text('04',style: TextStyle(color: Colors.black,fontSize: 13),),value: '04',),
                              DropdownMenuItem(child: Text('05',style: TextStyle(color: Colors.black,fontSize: 13),),value: '05',),
                              DropdownMenuItem(child: Text('06',style: TextStyle(color: Colors.black,fontSize: 13),),value: '06',),
                              DropdownMenuItem(child: Text('07',style: TextStyle(color: Colors.black,fontSize: 13),),value: '07',),
                              DropdownMenuItem(child: Text('08',style: TextStyle(color: Colors.black,fontSize: 13),),value: '08',),
                              DropdownMenuItem(child: Text('09',style: TextStyle(color: Colors.black,fontSize: 13),),value: '09',),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _accountNum = value.toString();
                              });
                            },
                            hint: const Text('请选择账户号,可任意选,但不能重复',style: TextStyle(color: Colors.grey,fontSize: 13),),
                            value:_accountNum== '' ? null : _accountNum,
                            elevation: 8, //设置阴影的高度
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                            underline: Container(height: 0),
                          ),
                        ),
                      ),
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
                Offstage(
                  offstage:_exchangeName == 'OKEx' ? false : true,
                  child: Container(
                    child: const Text('Passphrase',style: TextStyle(fontSize: 13,color: Colors.black),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  ),
                ),//Passphrase
                Offstage(
                  offstage: _exchangeName == 'OKEx' ? false : true,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    height: 40,
                    child: TextField(
                      obscureText:true,
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
                        hintText: '仅OKEx绑定时添加Passphrase',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                      ),
                      controller: _passphraseController,
                      style: const TextStyle(color: Colors.black,fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Offstage(
                  offstage:  _tradeType != 'trade',
                  child: Container(
                    child: const Text('API加密因子',style: TextStyle(fontSize: 13,color: Colors.black),),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  ),
                ), //API加密因子
                Offstage(
                  offstage:  _isDivisor != 'yes',
                  child: Offstage(
                    offstage: _tradeType != 'trade',
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            height: 40,
                            child: TextField(
                              obscureText: true,
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
                                hintText: '请输入API加密因子',
                                hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                              ),
                              controller: _divisorController,
                              style: const TextStyle(color: Colors.black,fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          child: Container(
                            child: const Icon(Icons.error,color: APP_MainGreenColor,),
                            padding: const EdgeInsets.all(5),
                          ),
                          onTap: (){
                            showMyCustomHelpText('API加密因子为您的API私钥进行安全加密,服务器不存储,只在策略启动时使用,不可逆,不可找回,请牢记。如万一忘记,请到安全中心重置。');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage:  _isDivisor != 'no',
                  child: Offstage(
                    offstage: _tradeType != 'trade',
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //边框圆角设置
                              border: Border.all(width: 1, color:const  Color.fromRGBO(15, 159, 131, 1)),
                              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                            ),
                            height: 40,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                // Navigator.pushNamed(context, '/AccountSecurityApiEncryptionViewController').then((value) => _getQuantAccountConfigInfoHttp());
                              },
                              child: Container(
                                child: const Text('请点击前往安全中心设置API独立加密因子',style: TextStyle(fontSize: 12,color: Colors.black),),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          child: Container(
                            child: const Icon(Icons.error,color: APP_MainGreenColor,),
                            padding: const EdgeInsets.all(5),
                          ),
                          onTap: (){
                            showMyCustomHelpText('API加密因子为您的API私钥进行安全加密,服务器不存储,只在策略启动时使用,不可逆,不可找回,请牢记。如万一忘记,请到安全中心重置。');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: const Text('API备注名',style: TextStyle(fontSize: 13,color: Colors.black),),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                ),//备注名
                Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  height: 40,
                  child: TextField(
                    autocorrect:false,
                    decoration:const InputDecoration(
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
                      hintText: '请输入备注名(可不填,限5个字符)',
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    ),
                    controller: _remarkController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20,),
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
                          FocusScope.of(context).requestFocus(FocusNode());
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

                          FocusScope.of(context).requestFocus(FocusNode());
                          if(_exchangeName == ''){
                            showMyCustomText('请选择交易所');
                            return;
                          }
                          if(_tradeType == ''){
                            showMyCustomText("请选择账户用途");
                            return;
                          }
                          if(_accountNum == ''){
                            showMyCustomText('请选择账户号,可任意选,但不能重复');
                            return;
                          }
                          if(_apiKeyController.text == ''){
                            showMyCustomText('请输入API Key');
                            return;
                          }
                          if(_apiSecretKeyController.text == ''){
                            showMyCustomText('请输入API Secret');
                            return;
                          }

                          if(_exchangeName == 'OKEx'){//仅OKEx时需要输入
                            if(_passphraseController.text == ''){
                              showMyCustomText('请输入Passphrase');
                              return;
                            }
                          }

                          if(_tradeType == 'trade'){//仅交易权限时需要输入
                            if(_divisorController.text == ''){
                              showMyCustomText('请输入API加密因子');
                              return;
                            }
                          }

                          if(_remarkController.text.length > 5){
                            showMyCustomText('备注名最多为5个字符');
                            return;
                          }
                          var response = await DigitalcurrencyExchangeapiSave(
                            exchange: _exchangeName.toString(),
                            exchangeAccount: _accountNum.toString(),
                            apiKey: _apiKeyController.text.toString(),
                            apiSecret: _apiSecretKeyController.text.toString(),
                            passPhrase:_passphraseController.text.toString(),
                            purpose:_tradeType.toString(),
                            remark: _remarkController.text.toString(),
                            divisor: _divisorController.text.toString(),
                          );
                          if (response is Map) {
                            if(!mounted){
                              return;
                            }
                            if(response['code'] == 200){
                              showMyCustomText(_tradeType == 'trade' ? '新增交易API成功' : '新增统计API成功');
                              neverBus.emit('DigitalCurrencyExchangeApiUpdate');
                              Navigator.pop(context);
                            }else{
                              showMyCustomText(response['message']);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    decoration:const  BoxDecoration(
                      color: Color.fromRGBO(251, 250, 218, 1),
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                    child:Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10 , 0),
                          child: const Icon(Icons.error_outline,color: Color.fromRGBO(15, 159, 131, 1),size: 17,),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                              alignment: Alignment.centerLeft,
                              child:const Text('注意事项:\n您正在进行量化策略交易API绑定,请确保在交易所新增的API仅拥有读取和交易权限,并绑定以下IP: 47.244.215.70 ',
                                style: TextStyle(color: Color.fromRGBO(215, 85, 82,  1),fontSize: 11),)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10 , 0),
                        child: const Icon(Icons.error_outline,color: Color.fromRGBO(15, 159, 131, 1),size: 17,),
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                            alignment: Alignment.center,
                            child:const Text('当用途选项中选择资产统计监控(需只读权限)时，您需填入仅拥有查询权限的API，否则将绑定不成功；当用途选项中选择量化策略交易(需交易权限)时，您需填入仅拥有读取和交易权限的API，否则将绑定不成功，另外策略交易API无法提供资产统计功能，原因在于为了确保具有交易权限的API的安全，我们采取了服务器不存储API密钥方案，您填入的API密钥将会通过唯一您掌握加密因子进行加密，该加密因子服务器不会存储，策略运行时系统会要求您填入该因子进行解密运行，每次每条策略运行后都是不可逆的，策略停止后如果重启依然需要您重新解密，而资产统计对API访问是一个连续长效的过程，不同于单条策略运行，由于系统没有解密因子的情况下，无法对您的资产进行读取访问。',
                              style: TextStyle(color: Colors.grey,fontSize: 11),)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _theExchangeAndTypeChange(){
    if(_exchangeName == ''){
      _exchangeShowName = '---';
    }else if (_exchangeName == 'Huobi'){
      if(_tradeType == ''){
        _exchangeShowName = 'HB-';
      }else if(_tradeType == 'trade'){
        _exchangeShowName = 'HB-T-';
      }else if(_tradeType == 'readonly'){
        _exchangeShowName = 'HB-R-';
      }else{
        _exchangeShowName = 'HB-';
      }
    }else if (_exchangeName == 'OKEx'){
      if(_tradeType == ''){
        _exchangeShowName = 'OK-';
      }else if(_tradeType == 'trade'){
        _exchangeShowName = 'OK-T-';
      }else if(_tradeType == 'readonly'){
        _exchangeShowName = 'OK-R-';
      }else{
        _exchangeShowName = 'OK-';
      }
    }else if (_exchangeName == 'Binance'){
      if(_tradeType == ''){
        _exchangeShowName = 'BN-';
      }else if(_tradeType == 'trade'){
        _exchangeShowName = 'BN-T-';
      }else if(_tradeType == 'readonly'){
        _exchangeShowName = 'BN-R-';
      }else{
        _exchangeShowName = 'BN-';
      }
    }else{
      _exchangeShowName = '---';
    }
  }
}


