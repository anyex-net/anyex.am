//行情资讯 外盘期货
class MarketWpfuturesQuoteWholeResponseData{
  final int? code;
  final String? message;
  final List<MarketWpfuturesQuoteWholeListData>? object;

  MarketWpfuturesQuoteWholeResponseData({this.code, this.message, this.object});

  factory MarketWpfuturesQuoteWholeResponseData.fromJson(Map<dynamic, dynamic> json) {
    return MarketWpfuturesQuoteWholeResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => MarketWpfuturesQuoteWholeListData.fromJson(i))
          .toList(),
    );
  }
}
class MarketWpfuturesQuoteWholeListData{
  final String? id;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo;
  final String? currencyNo;
  final String? tradingState;
  final String? dateTimeStamp;
  final String? qPreClosingPrice;
  final String? qPreSettlePrice;
  final String? qPrePositionQty;
  final String? qOpeningPrice;
  final String? qLastPrice;
  final String? qHighPrice;
  final String? qLowPrice;
  final String? qHisHighPrice;
  final String? qHisLowPrice;
  final String? qLimitUpPrice;
  final String? qLimitDownPrice;
  final String? qTotalQty;
  final String? qTotalTurnover;
  final String? qPositionQty;
  final String? qAveragePrice;
  final String? qClosingPrice;
  final String? qSettlePrice;
  final String? qLastQty;
  final String? qBidPrice;
  final String? qBidQty;
  final String? qAskPrice;
  final String? qAskQty;
  final String? qImpliedBidPrice;
  final String? qImpliedBidQty;
  final String? qImpliedAskPrice;
  final String? qImpliedAskQty;
  final String? qPreDelta;
  final String? qCurrDelta;
  final String? qInsideQty;
  final String? qOutsideQty;
  final String? qTurnoverRate;
  final String? q5DAvgQty;
  final String? qPERatio;
  final String? qTotalValue;
  final String? qNegotiableValue;
  final String? qPositionTrend;
  final String? qChangeSpeed;
  final String? qChangeRate;
  final String? qChangeValue;
  final String? qSwing;
  final String? qTotalBidQty;
  final String? qTotalAskQty;
  final String? underlyContract;
  final String? changeReason;
  final String? qpreClosingPrice;
  final String? qpreSettlePrice;
  final String? qprePositionQty;
  final String? qopeningPrice;
  final String? qlastPrice;
  final String? qhighPrice;
  final String? qlowPrice;
  final String? qhisHighPrice;
  final String? qhisLowPrice;
  final String? qlimitUpPrice;
  final String? qlimitDownPrice;
  final String? qtotalQty;
  final String? qtotalTurnover;
  final String? qpositionQty;
  final String? qaveragePrice;
  final String? qclosingPrice;
  final String? qsettlePrice;
  final String? qlastQty;
  final String? qbidPrice;
  final String? qbidQty;
  final String? qaskPrice;
  final String? qaskQty;
  final String? qimpliedBidPrice;
  final String? qimpliedBidQty;
  final String? qimpliedAskPrice;
  final String? qimpliedAskQty;
  final String? qpreDelta;
  final String? qcurrDelta;
  final String? qinsideQty;
  final String? qoutsideQty;
  final String? qturnoverRate;
  final String? qperatio;
  final String? qtotalValue;
  final String? qnegotiableValue;
  final String? qpositionTrend;
  final String? qchangeSpeed;
  final String? qchangeRate;
  final String? qchangeValue;
  final String? qswing;
  final String? qtotalBidQty;
  final String? qtotalAskQty;
  final String? contractName;

  MarketWpfuturesQuoteWholeListData({this.contractName,this.id, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo, this.currencyNo, this.tradingState, this.dateTimeStamp, this.qPreClosingPrice, this.qPreSettlePrice, this.qPrePositionQty, this.qOpeningPrice, this.qLastPrice, this.qHighPrice, this.qLowPrice, this.qHisHighPrice, this.qHisLowPrice, this.qLimitUpPrice, this.qLimitDownPrice, this.qTotalQty, this.qTotalTurnover, this.qPositionQty, this.qAveragePrice, this.qClosingPrice, this.qSettlePrice, this.qLastQty, this.qBidPrice, this.qBidQty, this.qAskPrice, this.qAskQty, this.qImpliedBidPrice, this.qImpliedBidQty, this.qImpliedAskPrice, this.qImpliedAskQty, this.qPreDelta, this.qCurrDelta, this.qInsideQty, this.qOutsideQty, this.qTurnoverRate, this.q5DAvgQty, this.qPERatio, this.qTotalValue, this.qNegotiableValue, this.qPositionTrend, this.qChangeSpeed, this.qChangeRate, this.qChangeValue, this.qSwing, this.qTotalBidQty, this.qTotalAskQty, this.underlyContract, this.changeReason, this.qpreClosingPrice, this.qpreSettlePrice, this.qprePositionQty, this.qopeningPrice, this.qlastPrice, this.qhighPrice, this.qlowPrice, this.qhisHighPrice, this.qhisLowPrice, this.qlimitUpPrice, this.qlimitDownPrice, this.qtotalQty, this.qtotalTurnover, this.qpositionQty, this.qaveragePrice, this.qclosingPrice, this.qsettlePrice, this.qlastQty, this.qbidPrice, this.qbidQty, this.qaskPrice, this.qaskQty, this.qimpliedBidPrice, this.qimpliedBidQty, this.qimpliedAskPrice, this.qimpliedAskQty, this.qpreDelta, this.qcurrDelta, this.qinsideQty, this.qoutsideQty, this.qturnoverRate, this.qperatio, this.qtotalValue, this.qnegotiableValue, this.qpositionTrend, this.qchangeSpeed, this.qchangeRate, this.qchangeValue, this.qswing, this.qtotalBidQty, this.qtotalAskQty});


  factory MarketWpfuturesQuoteWholeListData.fromJson(Map<dynamic, dynamic> json) {
    return MarketWpfuturesQuoteWholeListData(
      id : json['id'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo : json['contractNo'].toString(),
      currencyNo : json['currencyNo'].toString(),
      tradingState : json['tradingState'].toString(),
      dateTimeStamp : json['dateTimeStamp'].toString(),
      qPreClosingPrice : json['qPreClosingPrice'].toString(),
      qPreSettlePrice : json['qPreSettlePrice'].toString(),
      qPrePositionQty : json['qPrePositionQty'].toString(),
      qOpeningPrice : json['qOpeningPrice'].toString(),
      qLastPrice : json['qLastPrice'].toString(),
      qHighPrice : json['qHighPrice'].toString(),
      qLowPrice : json['qLowPrice'].toString(),
      qHisHighPrice : json['qHisHighPrice'].toString(),
      qHisLowPrice : json['qHisLowPrice'].toString(),
      qLimitUpPrice : json['qLimitUpPrice'].toString(),
      qLimitDownPrice : json['qLimitDownPrice'].toString(),
      qTotalQty : json['qTotalQty'].toString(),
      qTotalTurnover : json['qTotalTurnover'].toString(),
      qPositionQty : json['qPositionQty'].toString(),
      qAveragePrice : json['qAveragePrice'].toString(),
      qClosingPrice : json['qClosingPrice'].toString(),
      qSettlePrice : json['qSettlePrice'].toString(),
      qLastQty : json['qLastQty'].toString(),
      qBidPrice : json['qBidPrice'].toString(),
      qBidQty : json['qBidQty'].toString(),
      qAskPrice : json['qAskPrice'].toString(),
      qAskQty : json['qAskQty'].toString(),
      qImpliedBidPrice : json['qImpliedBidPrice'].toString(),
      qImpliedBidQty : json['qImpliedBidQty'].toString(),
      qImpliedAskPrice : json['qImpliedAskPrice'].toString(),
      qImpliedAskQty : json['qImpliedAskQty'].toString(),
      qPreDelta : json['qPreDelta'].toString(),
      qCurrDelta : json['qCurrDelta'].toString(),
      qInsideQty : json['qInsideQty'].toString(),
      qOutsideQty : json['qOutsideQty'].toString(),
      qTurnoverRate : json['qTurnoverRate'].toString(),
      q5DAvgQty : json['q5DAvgQty'].toString(),
      qPERatio : json['qPERatio'].toString(),
      qTotalValue : json['qTotalValue'].toString(),
      qNegotiableValue : json['qNegotiableValue'].toString(),
      qPositionTrend : json['qPositionTrend'].toString(),
      qChangeSpeed : json['qChangeSpeed'].toString(),
      qChangeRate : json['qChangeRate'].toString(),
      qChangeValue : json['qChangeValue'].toString(),
      qSwing : json['qSwing'].toString(),
      qTotalBidQty : json['qTotalBidQty'].toString(),
      qTotalAskQty : json['qTotalAskQty'].toString(),
      underlyContract : json['underlyContract'].toString(),
      changeReason : json['changeReason'].toString(),
      qpreClosingPrice : json['qpreClosingPrice'].toString(),
      qpreSettlePrice : json['qpreSettlePrice'].toString(),
      qprePositionQty : json['qprePositionQty'].toString(),
      qopeningPrice : json['qopeningPrice'].toString(),
      qlastPrice : json['qlastPrice'].toString(),
      qhighPrice : json['qhighPrice'].toString(),
      qlowPrice : json['qlowPrice'].toString(),
      qhisHighPrice : json['qhisHighPrice'].toString(),
      qhisLowPrice : json['qhisLowPrice'].toString(),
      qlimitUpPrice : json['qlimitUpPrice'].toString(),
      qlimitDownPrice : json['qlimitDownPrice'].toString(),
      qtotalQty : json['qtotalQty'].toString(),
      qtotalTurnover : json['qtotalTurnover'].toString(),
      qpositionQty : json['qpositionQty'].toString(),
      qaveragePrice : json['qaveragePrice'].toString(),
      qclosingPrice : json['qclosingPrice'].toString(),
      qsettlePrice : json['qsettlePrice'].toString(),
      qlastQty : json['qlastQty'].toString(),
      qbidPrice : json['qbidPrice'].toString(),
      qbidQty : json['qbidQty'].toString(),
      qaskPrice : json['qaskPrice'].toString(),
      qaskQty : json['qaskQty'].toString(),
      qimpliedBidPrice : json['qimpliedBidPrice'].toString(),
      qimpliedBidQty : json['qimpliedBidQty'].toString(),
      qimpliedAskPrice : json['qimpliedAskPrice'].toString(),
      qimpliedAskQty : json['qimpliedAskQty'].toString(),
      qpreDelta : json['qpreDelta'].toString(),
      qcurrDelta : json['qcurrDelta'].toString(),
      qinsideQty : json['qinsideQty'].toString(),
      qoutsideQty : json['qoutsideQty'].toString(),
      qturnoverRate : json['qturnoverRate'].toString(),
      qperatio : json['qperatio'].toString(),
      qtotalValue : json['qtotalValue'].toString(),
      qnegotiableValue : json['qnegotiableValue'].toString(),
      qpositionTrend : json['qpositionTrend'].toString(),
      qchangeSpeed : json['qchangeSpeed'].toString(),
      qchangeRate : json['qchangeRate'].toString(),
      qchangeValue : json['qchangeValue'].toString(),
      qswing : json['qswing'].toString(),
      qtotalBidQty : json['qtotalBidQty'].toString(),
      qtotalAskQty : json['qtotalAskQty'].toString(),
        contractName:json['contractName'].toString(),
    );
  }
}
//行情资讯 内盘期货
class MarketNpfuturesDepthMarketResponseData{
  final int? code;
  final String? message;
  final List<MarketNpfuturesDepthMarketListData>? object;

  MarketNpfuturesDepthMarketResponseData({this.code, this.message, this.object});

  factory MarketNpfuturesDepthMarketResponseData.fromJson(Map<dynamic, dynamic> json) {
    return MarketNpfuturesDepthMarketResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => MarketNpfuturesDepthMarketListData.fromJson(i))
          .toList(),
    );
  }
}
class MarketNpfuturesDepthMarketListData{
  final String? id;
  final String? tradingDay;
  final String? instrumentID;
  final String? exchangeID;
  final String? exchangeInstID;
  final String? lastPrice;
  final String? preSettlementPrice;
  final String? preClosePrice;
  final String? preOpenInterest;
  final String? openPrice;
  final String? highestPrice;
  final String? lowestPrice;
  final String? volume;
  final String? turnover;
  final String? openInterest;
  final String? closePrice;
  final String? settlementPrice;
  final String? upperLimitPrice;
  final String? lowerLimitPrice;
  final String? preDelta;
  final String? currDelta;
  final String? updateTime;
  final String? updateMillisec;
  final String? bidPrice1;
  final String? bidVolume1;
  final String? askPrice1;
  final String? askVolume1;
  final String? bidPrice2;
  final String? bidVolume2;
  final String? askPrice2;
  final String? askVolume2;
  final String? bidPrice3;
  final String? bidVolume3;
  final String? askPrice3;
  final String? askVolume3;
  final String? bidPrice4;
  final String? bidVolume4;
  final String? askPrice4;
  final String? askVolume4;
  final String? bidPrice5;
  final String? bidVolume5;
  final String? askPrice5;
  final String? askVolume5;
  final String? averagePrice;
  final String? actionDay;
  final String? changeReason;
  final String? lastVolume;
  final String? longUpdateTime;
  final String? instrumentName;

  MarketNpfuturesDepthMarketListData({this.id, this.tradingDay, this.instrumentID, this.exchangeID, this.exchangeInstID, this.lastPrice, this.preSettlementPrice, this.preClosePrice, this.preOpenInterest, this.openPrice, this.highestPrice, this.lowestPrice, this.volume, this.turnover, this.openInterest, this.closePrice, this.settlementPrice, this.upperLimitPrice, this.lowerLimitPrice, this.preDelta, this.currDelta, this.updateTime, this.updateMillisec, this.bidPrice1, this.bidVolume1, this.askPrice1, this.askVolume1, this.bidPrice2, this.bidVolume2, this.askPrice2, this.askVolume2, this.bidPrice3, this.bidVolume3, this.askPrice3, this.askVolume3, this.bidPrice4, this.bidVolume4, this.askPrice4, this.askVolume4, this.bidPrice5, this.bidVolume5, this.askPrice5, this.askVolume5, this.averagePrice, this.actionDay, this.changeReason, this.lastVolume, this.longUpdateTime, this.instrumentName});

  factory MarketNpfuturesDepthMarketListData.fromJson(Map<dynamic, dynamic> json) {
    return MarketNpfuturesDepthMarketListData(
      id : json['id'].toString(),
      tradingDay : json['tradingDay'].toString(),
      instrumentID : json['instrumentID'].toString(),
      exchangeID : json['exchangeID'].toString(),
      exchangeInstID : json['exchangeInstID'].toString(),
      lastPrice : json['lastPrice'].toString(),
      preSettlementPrice : json['preSettlementPrice'].toString(),
      preClosePrice : json['preClosePrice'].toString(),
      preOpenInterest : json['preOpenInterest'].toString(),
      openPrice : json['openPrice'].toString(),
      highestPrice : json['highestPrice'].toString(),
      lowestPrice : json['lowestPrice'].toString(),
      volume : json['volume'].toString(),
      turnover : json['turnover'].toString(),
      openInterest : json['openInterest'].toString(),
      closePrice : json['closePrice'].toString(),
      settlementPrice : json['settlementPrice'].toString(),
      upperLimitPrice : json['upperLimitPrice'].toString(),
      lowerLimitPrice : json['lowerLimitPrice'].toString(),
      preDelta : json['preDelta'].toString(),
      currDelta : json['currDelta'].toString(),
      updateTime : json['updateTime'].toString(),
      updateMillisec : json['updateMillisec'].toString(),
      bidPrice1 : json['bidPrice1'].toString(),
      bidVolume1 : json['bidVolume1'].toString(),
      askPrice1 : json['askPrice1'].toString(),
      askVolume1 : json['askVolume1'].toString(),
      bidPrice2 : json['bidPrice2'].toString(),
      bidVolume2 : json['bidVolume2'].toString(),
      askPrice2 : json['askPrice2'].toString(),
      askVolume2 : json['askVolume2'].toString(),
      bidPrice3 : json['bidPrice3'].toString(),
      bidVolume3 : json['bidVolume3'].toString(),
      askPrice3 : json['askPrice3'].toString(),
      askVolume3 : json['askVolume3'].toString(),
      bidPrice4 : json['bidPrice4'].toString(),
      bidVolume4 : json['bidVolume4'].toString(),
      askPrice4 : json['askPrice4'].toString(),
      askVolume4 : json['askVolume4'].toString(),
      bidPrice5 : json['bidPrice5'].toString(),
      bidVolume5 : json['bidVolume5'].toString(),
      askPrice5 : json['askPrice5'].toString(),
      askVolume5 : json['askVolume5'].toString(),
      averagePrice : json['averagePrice'].toString(),
      actionDay : json['actionDay'].toString(),
      changeReason : json['changeReason'].toString(),
      lastVolume : json['lastVolume'].toString(),
      longUpdateTime : json['longUpdateTime'].toString(),
      instrumentName : json['instrumentName'].toString(),
    );
  }
}
//行情资讯 数字货币
class MarketDigitalcurrencyResponseData{
  final List<MarketDigitalcurrencyListData>? swap;
  final List<MarketDigitalcurrencyListData>? spot;
  final List<MarketDigitalcurrencyListData>? options;
  final List<MarketDigitalcurrencyListData>? futures;

  MarketDigitalcurrencyResponseData({this.swap, this.spot, this.options, this.futures});

  factory MarketDigitalcurrencyResponseData.fromJson(Map<dynamic, dynamic> json) {
    return MarketDigitalcurrencyResponseData(
      swap: (json['swap'] as List).map((i) => MarketDigitalcurrencyListData.fromJson(i)).toList(),
      spot: (json['spot'] as List).map((i) => MarketDigitalcurrencyListData.fromJson(i)).toList(),
      options: (json['option'] as List).map((i) => MarketDigitalcurrencyListData.fromJson(i)).toList(),
      futures: (json['futures'] as List).map((i) => MarketDigitalcurrencyListData.fromJson(i)).toList(),
    );
  }
}
class MarketDigitalcurrencyListData{
  final String? last;
  final String? lastSz;
  final String? open24h;
  final String? askSz;
  final String? low24h;
  final String? askPx;
  final String? volCcy24h;
  final String? instType;
  final String? instId;
  final String? bidSz;
  final String? bidPx;
  final String? high24h;
  final String? sodUtc0;
  final String? vol24h;
  final String? sodUtc8;
  final String? ts;

  MarketDigitalcurrencyListData({this.last, this.lastSz, this.open24h, this.askSz, this.low24h, this.askPx, this.volCcy24h, this.instType, this.instId, this.bidSz, this.bidPx, this.high24h, this.sodUtc0, this.vol24h, this.sodUtc8, this.ts});

  factory MarketDigitalcurrencyListData.fromJson(Map<dynamic, dynamic> json) {
    return MarketDigitalcurrencyListData(
      last : json['last'].toString(),
      lastSz : json['lastSz'].toString(),
      open24h : json['open24h'].toString(),
      askSz : json['askSz'].toString(),
      low24h : json['low24h'].toString(),
      askPx : json['askPx'].toString(),
      volCcy24h : json['volCcy24h'].toString(),
      instType : json['instType'].toString(),
      instId : json['instId'].toString(),
      bidSz : json['bidSz'].toString(),
      bidPx : json['bidPx'].toString(),
      high24h : json['high24h'].toString(),
      sodUtc0 : json['sodUtc0'].toString(),
      vol24h : json['vol24h'].toString(),
      sodUtc8 : json['sodUtc8'].toString(),
      ts : json['ts'].toString(),
    );
  }
}
//行情资讯 公告类
class MarketCommonNoticeResponseData{
  final int? code;
  final String? message;
  final List<MarketCommonNoticeListData>? object;

  MarketCommonNoticeResponseData({this.code, this.message, this.object});

  factory MarketCommonNoticeResponseData.fromJson(Map<dynamic, dynamic> json) {
    return MarketCommonNoticeResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => MarketCommonNoticeListData.fromJson(i))
          .toList(),
    );
  }
}
class MarketCommonNoticeListData{
  final String? id;
  final String? langType;
  final String? title;
  final String? content;
  final String? remark;
  final String? status;
  final String? createBy;
  final String? createDate;
  final String? updateBy;
  final String? updateDate;
  final String? publicBy;
  final int? publicDate;

  MarketCommonNoticeListData({this.id, this.langType, this.title, this.content, this.remark, this.status, this.createBy, this.createDate, this.updateBy, this.updateDate, this.publicBy, this.publicDate});

  factory MarketCommonNoticeListData.fromJson(Map<dynamic, dynamic> json) {
    return MarketCommonNoticeListData(
      id : json['id'].toString(),
      langType : json['langType'].toString(),
      title : json['title'].toString(),
      content : json['content'].toString(),
      remark : json['remark'].toString(),
      status : json['status'].toString(),
      createBy : json['createBy'].toString(),
      createDate : json['createDate'].toString(),
      updateBy : json['updateBy'].toString(),
      updateDate : json['updateDate'].toString(),
      publicBy : json['publicBy'].toString(),
      publicDate : json['publicDate'],
    );
  }

}

