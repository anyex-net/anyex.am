class NpFuturesSocketTickerModel{
  final String? actionDay;
  final String? averagePrice;
  final String? closePrice;
  final String? currDelta;
  final String? exchangeID;
  final String? exchangeInstID;
  final String? highestPrice;
  final String? instrumentID;
  final String? lastPrice;
  final String? lastVolume;
  final String? longUpdateTime;
  final String? lowerLimitPrice;
  final String? lowestPrice;
  final String? openInterest;
  final String? openPrice;
  final String? preClosePrice;
  final String? preDelta;
  final String? preOpenInterest;
  final String? preSettlementPrice;
  final String? settlementPrice;
  final String? tradingDay;
  final String? turnover;
  final String? updateMillisec;
  final String? updateTime;
  final String? upperLimitPrice;
  final String? volume;

  NpFuturesSocketTickerModel({this.actionDay, this.averagePrice, this.closePrice, this.currDelta, this.exchangeID, this.exchangeInstID, this.highestPrice, this.instrumentID, this.lastPrice, this.lastVolume, this.longUpdateTime, this.lowerLimitPrice, this.lowestPrice, this.openInterest, this.openPrice, this.preClosePrice, this.preDelta, this.preOpenInterest, this.preSettlementPrice, this.settlementPrice, this.tradingDay, this.turnover, this.updateMillisec, this.updateTime, this.upperLimitPrice, this.volume});

  factory NpFuturesSocketTickerModel.fromJson(Map<dynamic, dynamic> json) {
    return NpFuturesSocketTickerModel(
      actionDay : json['actionDay'].toString(),
      averagePrice : json['averagePrice'].toString(),
      closePrice : json['closePrice'].toString(),
      currDelta : json['currDelta'].toString(),
      exchangeID : json['exchangeID'].toString(),
      exchangeInstID : json['exchangeInstID'].toString(),
      highestPrice : json['highestPrice'].toString(),
      instrumentID : json['instrumentID'].toString(),
      lastPrice : json['lastPrice'].toString(),
      lastVolume : json['lastVolume'].toString(),
      longUpdateTime : json['longUpdateTime'].toString(),
      lowerLimitPrice : json['lowerLimitPrice'].toString(),
      lowestPrice : json['lowestPrice'].toString(),
      openInterest : json['openInterest'].toString(),
      openPrice : json['openPrice'].toString(),
      preClosePrice : json['preClosePrice'].toString(),
      preDelta : json['preDelta'].toString(),
      preOpenInterest : json['preOpenInterest'].toString(),
      preSettlementPrice : json['preSettlementPrice'].toString(),
      settlementPrice : json['settlementPrice'].toString(),
      tradingDay : json['tradingDay'].toString(),
      turnover : json['turnover'].toString(),
      updateMillisec : json['updateMillisec'].toString(),
      updateTime : json['updateTime'].toString(),
      upperLimitPrice : json['upperLimitPrice'].toString(),
      volume : json['volume'].toString(),
    );
  }
}
