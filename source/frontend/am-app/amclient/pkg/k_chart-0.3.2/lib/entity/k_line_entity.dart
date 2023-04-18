import '../entity/k_entity.dart';

class KLineEntity extends KEntity {
  late double open;
  late double high;
  late double low;
  late double close;
  late double vol;
  late double amount;
  double? change;
  double? ratio;
  String? timeType;
  int? time;
  String? exchange;
  String? commodityCode;
  String? contractCode;


  KLineEntity.fromCustom({
    required this.amount,
    required this.open,
    required this.close,
    this.change,
    this.ratio,
    this.timeType,
    required this.time,
    required this.high,
    required this.low,
    required this.vol,
  });

  KLineEntity.fromJson(Map<String, dynamic> json) {
    open = json['open']?.toDouble() ?? 0;
    high = json['high']?.toDouble() ?? 0;
    low = json['low']?.toDouble() ?? 0;
    close = json['close']?.toDouble() ?? 0;
    vol = json['vol']?.toDouble() ?? 0;
    amount = json['amount']?.toDouble() ?? 0;
    int? tempTime = json['time']?.toInt();
    //兼容火币数据
    if (tempTime == null) {
      tempTime = json['id']?.toInt() ?? 0;
      tempTime = tempTime! * 1000;
    }
    time = tempTime;
    ratio = json['ratio']?.toDouble() ?? 0;
    change = json['change']?.toDouble() ?? 0;
  }

  KLineEntity.okexfromJson(List json) {
    open = double.parse(json[1].toString());
    high = double.parse(json[2].toString());
    low = double.parse(json[3].toString());
    close = double.parse(json[4].toString());
    vol = double.parse(json[5].toString());
    time = int.tryParse(json[0].toString()) ?? 0;
    amount = 0.0;
  }

  KLineEntity.wpfromJson(Map<String, dynamic> json) {
    open = json['openPrice']?.toDouble() ?? 0;
    high = json['highPrice']?.toDouble() ?? 0;
    low = json['lowPrice']?.toDouble() ?? 0;
    close = json['closePrice']?.toDouble() ?? 0;
    vol = json['sumBal']?.toDouble() ?? 0;
    amount = json['sumAmt']?.toDouble() ?? 0;
    int? tempTime = json['displayTime']?.toInt();
    //兼容火币数据
    if (tempTime == null) {
      tempTime = json['id']?.toInt() ?? 0;
      tempTime = tempTime! * 1000;
    }
    time = tempTime;
    timeType = json['timeType']?.toString() ?? "2";
    exchange = json['exchange']?.toString() ?? "";
    commodityCode = json['commodityCode']?.toString() ?? "";
    contractCode = json['contractCode']?.toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['open'] = this.open;
    data['close'] = this.close;
    data['high'] = this.high;
    data['low'] = this.low;
    data['vol'] = this.vol;
    data['amount'] = this.amount;
    data['ratio'] = this.ratio;
    data['change'] = this.change;
    return data;
  }

  @override
  String toString() {
    return 'MarketModel{open: $open, high: $high, low: $low, close: $close, vol: $vol, time: $time, amount: $amount, ratio: $ratio, change: $change}';
  }
}