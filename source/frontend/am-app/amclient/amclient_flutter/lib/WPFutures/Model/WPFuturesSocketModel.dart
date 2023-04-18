//Socket Ticker模型
import 'dart:io';

class WpFuturesSocketTickerModel{
  final String? commodityNo;
  final String? commodityType;
  final String? dateTimeStamp;
  final String? exchangeNo;
  final String? q5DAvgQty;
  final String? qAveragePrice;
  final String? qChangeRate;
  final String? qChangeSpeed;
  final String? qChangeValue;
  final String? qClosingPrice;
  final String? qCurrDelta;
  final String? qHighPrice;
  final String? qHisHighPrice;
  final String? qHisLowPrice;
  final String? qImpliedAskPrice;
  final String? qImpliedAskQty;
  final String? qImpliedBidPrice;
  final String? qImpliedBidQty;
  final String? qInsideQty;
  final String? qLastPrice;
  final String? qLastQty;
  final String? qLimitDownPrice;
  final String? qLimitUpPrice;
  final String? qLowPrice;
  final String? qNegotiableValue;
  final String? qOpeningPrice;
  final String? qOutsideQty;
  final String? qPERatio;
  final String? qPositionQty;
  final String? qPositionTrend;
  final String? qPreClosingPrice;
  final String? qPreDelta;
  final String? qPrePositionQty;
  final String? qPreSettlePrice;
  final String? qSettlePrice;
  final String? qSwing;
  final String? qTotalAskQty;
  final String? qTotalBidQty;
  final String? qTotalQty;
  final String? qTotalTurnover;
  final String? qTotalValue;
  final String? qTurnoverRate;
  final String? tradingState;

  WpFuturesSocketTickerModel({this.commodityNo, this.commodityType, this.dateTimeStamp, this.exchangeNo, this.q5DAvgQty, this.qAveragePrice, this.qChangeRate, this.qChangeSpeed, this.qChangeValue, this.qClosingPrice, this.qCurrDelta, this.qHighPrice, this.qHisHighPrice, this.qHisLowPrice, this.qImpliedAskPrice, this.qImpliedAskQty, this.qImpliedBidPrice, this.qImpliedBidQty, this.qInsideQty, this.qLastPrice, this.qLastQty, this.qLimitDownPrice, this.qLimitUpPrice, this.qLowPrice, this.qNegotiableValue, this.qOpeningPrice, this.qOutsideQty, this.qPERatio, this.qPositionQty, this.qPositionTrend, this.qPreClosingPrice, this.qPreDelta, this.qPrePositionQty, this.qPreSettlePrice, this.qSettlePrice, this.qSwing, this.qTotalAskQty, this.qTotalBidQty, this.qTotalQty, this.qTotalTurnover, this.qTotalValue, this.qTurnoverRate, this.tradingState});

  factory WpFuturesSocketTickerModel.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesSocketTickerModel(
      commodityNo : json['commodityNo'].toString(),
      commodityType : json['commodityType'].toString(),
      dateTimeStamp : json['dateTimeStamp'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      q5DAvgQty : json['q5DAvgQty'].toString(),
      qAveragePrice : json['qAveragePrice'].toString(),
      qChangeRate : json['qChangeRate'].toString(),
      qChangeSpeed : json['qChangeSpeed'].toString(),
      qChangeValue : json['qChangeValue'].toString(),
      qClosingPrice : json['qClosingPrice'].toString(),
      qCurrDelta : json['qCurrDelta'].toString(),
      qHighPrice : json['qHighPrice'].toString(),
      qHisHighPrice : json['qHisHighPrice'].toString(),
      qHisLowPrice : json['qHisLowPrice'].toString(),
      qImpliedAskPrice : json['qImpliedAskPrice'].toString(),
      qImpliedAskQty : json['qImpliedAskQty'].toString(),
      qImpliedBidPrice : json['qImpliedBidPrice'].toString(),
      qImpliedBidQty : json['qImpliedBidQty'].toString(),
      qInsideQty : json['qInsideQty'].toString(),
      qLastPrice : json['qLastPrice'].toString(),
      qLastQty : json['qLastQty'].toString(),
      qLimitDownPrice : json['qLimitDownPrice'].toString(),
      qLimitUpPrice : json['qLimitUpPrice'].toString(),
      qLowPrice : json['qLowPrice'].toString(),
      qNegotiableValue : json['qNegotiableValue'].toString(),
      qOpeningPrice : json['qOpeningPrice'].toString(),
      qOutsideQty : json['qOutsideQty'].toString(),
      qPERatio : json['qPERatio'].toString(),
      qPositionQty : json['qPositionQty'].toString(),
      qPositionTrend : json['qPositionTrend'].toString(),
      qPreClosingPrice : json['qPreClosingPrice'].toString(),
      qPreDelta : json['qPreDelta'].toString(),
      qPrePositionQty : json['qPrePositionQty'].toString(),
      qPreSettlePrice : json['qPreSettlePrice'].toString(),
      qSettlePrice : json['qSettlePrice'].toString(),
      qSwing : json['qSwing'].toString(),
      qTotalAskQty : json['qTotalAskQty'].toString(),
      qTotalBidQty : json['qTotalBidQty'].toString(),
      qTotalQty : json['qTotalQty'].toString(),
      qTotalTurnover : json['qTotalTurnover'].toString(),
      qTotalValue : json['qTotalValue'].toString(),
      qTurnoverRate : json['qTurnoverRate'].toString(),
      tradingState : json['tradingState'].toString(),
    );
  }
}

//Socket Kline 模型
class WpFuturesSocketKlineModel{
  final String? closePrice;
  final String? commodityCode;
  final String? contractCode;
  final int? createTime;
  final String? delFlag;
  final int? displayTime;
  final String? exchange;
  final String? highPrice;
  final String? id;
  final String? lowPrice;
  final String? marketType;
  final String? openPrice;
  final String? sumAmt;
  final String? sumBal;
  final String? timeType;
  final String? version;

  WpFuturesSocketKlineModel({this.closePrice, this.commodityCode, this.contractCode, this.createTime, this.delFlag, this.displayTime, this.exchange, this.highPrice, this.id, this.lowPrice, this.marketType, this.openPrice, this.sumAmt, this.sumBal, this.timeType, this.version});

  factory WpFuturesSocketKlineModel.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesSocketKlineModel(
      closePrice : json['closePrice'].toString(),
      commodityCode : json['commodityCode'].toString(),
      contractCode : json['contractCode'].toString(),
      createTime : json['createTime'],
      delFlag : json['delFlag'].toString(),
      displayTime : json['displayTime'],
      exchange : json['exchange'].toString(),
      highPrice : json['highPrice'].toString(),
      id : json['id'].toString(),
      lowPrice : json['lowPrice'].toString(),
      marketType : json['marketType'].toString(),
      openPrice : json['openPrice'].toString(),
      sumAmt : json['sumAmt'].toString(),
      sumBal : json['sumBal'].toString(),
      timeType : json['timeType'].toString(),
      version : json['version'].toString(),
    );
  }
}