//外盘交易所
class WpFuturesExchangeInfoResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesExchangeInfoListData>? object;

  WpFuturesExchangeInfoResponseData({this.code, this.message, this.object});

  factory WpFuturesExchangeInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeInfoResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesExchangeInfoListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesExchangeInfoListData{
  final String? id;
  final String? exchangeNo;
  final String? exchangeName;
  final String? exchangeDomain;
  final String? openMarket;

  WpFuturesExchangeInfoListData({this.id, this.exchangeNo, this.exchangeName, this.exchangeDomain, this.openMarket});

  factory WpFuturesExchangeInfoListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeInfoListData(
      id : json['id'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      exchangeName : json['exchangeName'].toString(),
      exchangeDomain : json['exchangeDomain'].toString(),
      openMarket : json['openMarket'].toString(),
    );
  }
}
//外盘期货交易所期货品种信息管理
class WpFuturesExchangeCommodityResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesExchangeCommodityListData>? object;

  WpFuturesExchangeCommodityResponseData({this.code, this.message, this.object});

  factory WpFuturesExchangeCommodityResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeCommodityResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesExchangeCommodityListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesExchangeCommodityListData{
  final String? id;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? commodityName;
  final String? commodityEngName;
  final String? relateExchangeNo;
  final String? relateCommodityType;
  final String? relateCommodityNo;
  final String? relateExchangeNo2;
  final String? relateCommodityType2;
  final String? relateCommodityNo2;
  final String? currencyGroupNo;
  final String? tradeCurrency;
  final String? contractSize;
  final String? openCloseMode;
  final String? strikePriceTimes;
  final String? commodityTickSize;
  final String? commodityDenominator;
  final String? cmbDirect;
  final String? deliveryMode;
  final String? deliveryDays;
  final String? addOneTime;
  final String? commodityTimeZone;
  final String? isAddOne;

  WpFuturesExchangeCommodityListData({this.id, this.exchangeNo, this.commodityType, this.commodityNo, this.commodityName, this.commodityEngName, this.relateExchangeNo, this.relateCommodityType, this.relateCommodityNo, this.relateExchangeNo2, this.relateCommodityType2, this.relateCommodityNo2, this.currencyGroupNo, this.tradeCurrency, this.contractSize, this.openCloseMode, this.strikePriceTimes, this.commodityTickSize, this.commodityDenominator, this.cmbDirect, this.deliveryMode, this.deliveryDays, this.addOneTime, this.commodityTimeZone, this.isAddOne});

  factory WpFuturesExchangeCommodityListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeCommodityListData(
      id : json['id'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      commodityName : json['commodityName'].toString(),
      commodityEngName : json['commodityEngName'].toString(),
      relateExchangeNo : json['relateExchangeNo'].toString(),
      relateCommodityType : json['relateCommodityType'].toString(),
      relateCommodityNo : json['relateCommodityNo'].toString(),
      relateExchangeNo2 : json['relateExchangeNo2'].toString(),
      relateCommodityType2 : json['relateCommodityType2'].toString(),
      relateCommodityNo2 : json['relateCommodityNo2'].toString(),
      currencyGroupNo : json['currencyGroupNo'].toString(),
      tradeCurrency : json['tradeCurrency'].toString(),
      contractSize : json['contractSize'].toString(),
      openCloseMode : json['openCloseMode'].toString(),
      strikePriceTimes : json['strikePriceTimes'].toString(),
      commodityTickSize : json['commodityTickSize'].toString(),
      commodityDenominator : json['commodityDenominator'].toString(),
      cmbDirect : json['cmbDirect'].toString(),
      deliveryMode : json['deliveryMode'].toString(),
      deliveryDays : json['deliveryDays'].toString(),
      addOneTime : json['addOneTime'].toString(),
      commodityTimeZone : json['commodityTimeZone'].toString(),
      isAddOne : json['isAddOne'].toString(),
    );
  }
}
//外盘期货交易所期货合约信息管理
class WpFuturesExchangeContractResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesExchangeContractListData>? object;

  WpFuturesExchangeContractResponseData({this.code, this.message, this.object});

  factory WpFuturesExchangeContractResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeContractResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesExchangeContractListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesExchangeContractListData{
  final String? id;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo1;
  final String? strikePrice1;
  final String? callOrPutFlag1;
  final String? contractNo2;
  final String? strikePrice2;
  final String? callOrPutFlag2;
  final String? contractType;
  final String? quoteUnderlyingContract;
  final String? contractName;
  final String? contractExpDate;
  final String? lastTradeDate;
  final String? firstNoticeDate;
  final String? enableStatus;
  final String? tradeCurrency;
  final String? contractSize;
  final String? commodityTickSize;
  final String? commodityTimeZone;
  final String? exchangeName;

  WpFuturesExchangeContractListData({this.exchangeName,this.commodityTimeZone,this.commodityTickSize,this.contractSize,this.tradeCurrency,this.id, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo1, this.strikePrice1, this.callOrPutFlag1, this.contractNo2, this.strikePrice2, this.callOrPutFlag2, this.contractType, this.quoteUnderlyingContract, this.contractName, this.contractExpDate, this.lastTradeDate, this.firstNoticeDate, this.enableStatus});

  factory WpFuturesExchangeContractListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesExchangeContractListData(
      id : json['id'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo1 : json['contractNo1'].toString(),
      strikePrice1 : json['strikePrice1'].toString(),
      callOrPutFlag1 : json['callOrPutFlag1'].toString(),
      contractNo2 : json['contractNo2'].toString(),
      strikePrice2 : json['strikePrice2'].toString(),
      callOrPutFlag2 : json['callOrPutFlag2'].toString(),
      contractType : json['contractType'].toString(),
      quoteUnderlyingContract : json['quoteUnderlyingContract'].toString(),
      contractName : json['contractName'].toString(),
      contractExpDate : json['contractExpDate'].toString(),
      lastTradeDate : json['lastTradeDate'].toString(),
      firstNoticeDate : json['firstNoticeDate'].toString(),
      enableStatus : json['enableStatus'].toString(),
      tradeCurrency : json['tradeCurrency'].toString(),
      contractSize : json['contractSize'].toString(),
      commodityTickSize : json['commodityTickSize'].toString(),
      commodityTimeZone : json['commodityTimeZone'].toString(),
      exchangeName : json['exchangeName'].toString(),
    );
  }


}
//外盘期货资金账号资金信息
class WpFuturesFundDataResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesFundDataListData>? object;

  WpFuturesFundDataResponseData({this.code, this.message, this.object});

  factory WpFuturesFundDataResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesFundDataResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesFundDataListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesFundDataListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? currencyGroupNo;
  final String? currencyNo;
  final String? tradeRate;
  final String? futureAlg;
  final String? optionAlg;
  final String? preBalance;
  final String? preUnExpProfit;
  final String? preLMEPositionProfit;
  final String? preEquity;
  final String? preAvailable1;
  final String? preMarketEquity;
  final String? cashInValue;
  final String? cashOutValue;
  final String? cashAdjustValue;
  final String? cashPledged;
  final String? frozenFee;
  final String? frozenDeposit;
  final String? accountFee;
  final String? swapInValue;
  final String? swapOutValue;
  final String? premiumIncome;
  final String? premiumPay;
  final String? closeProfit;
  final String? frozenFund;
  final String? unExpProfit;
  final String? expProfit;
  final String? positionProfit;
  final String? lmePositionProfit;
  final String? optionMarketValue;
  final String? accountIntialMargin;
  final String? accountMaintenanceMargin;
  final String? upperInitalMargin;
  final String? upperMaintenanceMargin;
  final String? discount;
  final String? balance;
  final String? equity;
  final String? available;
  final String? canDraw;
  final String? marketEquity;
  final String? authMoney;

  WpFuturesFundDataListData({this.id, this.accountId, this.brokerNo, this.accountNo, this.currencyGroupNo, this.currencyNo, this.tradeRate, this.futureAlg, this.optionAlg, this.preBalance, this.preUnExpProfit, this.preLMEPositionProfit, this.preEquity, this.preAvailable1, this.preMarketEquity, this.cashInValue, this.cashOutValue, this.cashAdjustValue, this.cashPledged, this.frozenFee, this.frozenDeposit, this.accountFee, this.swapInValue, this.swapOutValue, this.premiumIncome, this.premiumPay, this.closeProfit, this.frozenFund, this.unExpProfit, this.expProfit, this.positionProfit, this.lmePositionProfit, this.optionMarketValue, this.accountIntialMargin, this.accountMaintenanceMargin, this.upperInitalMargin, this.upperMaintenanceMargin, this.discount, this.balance, this.equity, this.available, this.canDraw, this.marketEquity, this.authMoney});

  factory WpFuturesFundDataListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesFundDataListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      currencyGroupNo : json['currencyGroupNo'].toString(),
      currencyNo : json['currencyNo'].toString(),
      tradeRate : json['tradeRate'].toString(),
      futureAlg : json['futureAlg'].toString(),
      optionAlg : json['optionAlg'].toString(),
      preBalance : json['preBalance'].toString(),
      preUnExpProfit : json['preUnExpProfit'].toString(),
      preLMEPositionProfit : json['preLMEPositionProfit'].toString(),
      preEquity : json['preEquity'].toString(),
      preAvailable1 : json['preAvailable1'].toString(),
      preMarketEquity : json['preMarketEquity'].toString(),
      cashInValue : json['cashInValue'].toString(),
      cashOutValue : json['cashOutValue'].toString(),
      cashAdjustValue : json['cashAdjustValue'].toString(),
      cashPledged : json['cashPledged'].toString(),
      frozenFee : json['frozenFee'].toString(),
      frozenDeposit : json['frozenDeposit'].toString(),
      accountFee : json['accountFee'].toString(),
      swapInValue : json['swapInValue'].toString(),
      swapOutValue : json['swapOutValue'].toString(),
      premiumIncome : json['premiumIncome'].toString(),
      premiumPay : json['premiumPay'].toString(),
      closeProfit : json['closeProfit'].toString(),
      frozenFund : json['frozenFund'].toString(),
      unExpProfit : json['unExpProfit'].toString(),
      expProfit : json['expProfit'].toString(),
      positionProfit : json['positionProfit'].toString(),
      lmePositionProfit : json['lmePositionProfit'].toString(),
      optionMarketValue : json['optionMarketValue'].toString(),
      accountIntialMargin : json['accountIntialMargin'].toString(),
      accountMaintenanceMargin : json['accountMaintenanceMargin'].toString(),
      upperInitalMargin : json['upperInitalMargin'].toString(),
      upperMaintenanceMargin : json['upperMaintenanceMargin'].toString(),
      discount : json['discount'].toString(),
      balance : json['balance'].toString(),
      equity : json['equity'].toString(),
      available : json['available'].toString(),
      canDraw : json['canDraw'].toString(),
      marketEquity : json['marketEquity'].toString(),
      authMoney : json['authMoney'].toString(),
    );
  }
}
//外盘期货成交 历史成交
class WpFuturesFillInfoResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesFillInfoListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpFuturesFillInfoResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});


  factory WpFuturesFillInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesFillInfoResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpFuturesFillInfoListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpFuturesFillInfoListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo;
  final String? strikePrice;
  final String? callOrPutFlag;
  final String? matchSource;
  final String? matchSide;
  final String? positionEffect;
  final String? serverFlag;
  final String? orderNo;
  final String? orderSystemNo;
  final String? matchNo;
  final String? upperMatchNo;
  final String? exchangeMatchNo;
  final String? matchDateTime;
  final String? upperMatchDateTime;
  final String? upperNo;
  final String? matchPrice;
  final String? matchQty;
  final String? isDeleted;
  final String? isAddOne;
  final String? feeCurrencyGroup;
  final String? feeCurrency;
  final String? feeValue;
  final String? isManualFee;
  final String? closePrositionPrice;

  WpFuturesFillInfoListData({this.id, this.accountId, this.brokerNo, this.accountNo, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo, this.strikePrice, this.callOrPutFlag, this.matchSource, this.matchSide, this.positionEffect, this.serverFlag, this.orderNo, this.orderSystemNo, this.matchNo, this.upperMatchNo, this.exchangeMatchNo, this.matchDateTime, this.upperMatchDateTime, this.upperNo, this.matchPrice, this.matchQty, this.isDeleted, this.isAddOne, this.feeCurrencyGroup, this.feeCurrency, this.feeValue, this.isManualFee, this.closePrositionPrice});

  factory WpFuturesFillInfoListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesFillInfoListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo : json['contractNo'].toString(),
      strikePrice : json['strikePrice'].toString(),
      callOrPutFlag : json['callOrPutFlag'].toString(),
      matchSource : json['matchSource'].toString(),
      matchSide : json['matchSide'].toString(),
      positionEffect : json['positionEffect'].toString(),
      serverFlag : json['serverFlag'].toString(),
      orderNo : json['orderNo'].toString(),
      orderSystemNo : json['orderSystemNo'].toString(),
      matchNo : json['matchNo'].toString(),
      upperMatchNo : json['upperMatchNo'].toString(),
      exchangeMatchNo : json['exchangeMatchNo'].toString(),
      matchDateTime : json['matchDateTime'].toString(),
      upperMatchDateTime : json['upperMatchDateTime'].toString(),
      upperNo : json['upperNo'].toString(),
      matchPrice : json['matchPrice'].toString(),
      matchQty : json['matchQty'].toString(),
      isDeleted : json['isDeleted'].toString(),
      isAddOne : json['isAddOne'].toString(),
      feeCurrencyGroup : json['feeCurrencyGroup'].toString(),
      feeCurrency : json['feeCurrency'].toString(),
      feeValue : json['feeValue'].toString(),
      isManualFee : json['isManualFee'].toString(),
      closePrositionPrice : json['closePrositionPrice'].toString(),
    );
  }
}
//外盘期货所有持仓信息
class WpFuturesPositionSummaryInfoResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesPositionSummaryInfoListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpFuturesPositionSummaryInfoResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});


  factory WpFuturesPositionSummaryInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesPositionSummaryInfoResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpFuturesPositionSummaryInfoListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpFuturesPositionSummaryInfoListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo;
  final String? strikePrice;
  final String? callOrPutFlag;
  final String? matchSide;
  final String? positionPrice;
  final String? positionQty;
  final String? hisPositionQty;
  final String? tradeCurrency;
  final String? positionProfit;
  final String? commodityTickSize;


  WpFuturesPositionSummaryInfoListData({this.commodityTickSize,this.positionProfit,this.tradeCurrency,this.id, this.accountId, this.brokerNo, this.accountNo, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo, this.strikePrice, this.callOrPutFlag, this.matchSide, this.positionPrice, this.positionQty, this.hisPositionQty});

  factory WpFuturesPositionSummaryInfoListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesPositionSummaryInfoListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo : json['contractNo'].toString(),
      strikePrice : json['strikePrice'].toString(),
      callOrPutFlag : json['callOrPutFlag'].toString(),
      matchSide : json['matchSide'].toString(),
      positionPrice : json['positionPrice'].toString(),
      positionQty : json['positionQty'].toString(),
      hisPositionQty : json['hisPositionQty'].toString(),
      tradeCurrency : json['tradeCurrency'].toString(),
      positionProfit : json['positionProfit'].toString(),
      commodityTickSize : json['commodityTickSize'].toString(),
    );
  }

}
//外盘期货委托订单
class WpFuturesOrderInfoResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesOrderInfoListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpFuturesOrderInfoResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});

  factory WpFuturesOrderInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesOrderInfoResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpFuturesOrderInfoListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpFuturesOrderInfoListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo;
  final String? strikePrice;
  final String? callOrPutFlag;
  final String? contractNo2;
  final String? strikePrice2;
  final String? callOrPutFlag2;
  final String? orderType;
  final String? orderSource;
  final String? timeInForce;
  final String? expireTime;
  final String? isRiskOrder;
  final String? orderSide;
  final String? positionEffect;
  final String? positionEffect2;
  final String? inquiryNo;
  final String? hedgeFlag;
  final String? orderPrice;
  final String? orderPrice2;
  final String? stopPrice;
  final String? orderQty;
  final String? orderMinQty;
  final String? refInt;
  final String? refDouble;
  final String? refString;
  final String? minClipSize;
  final String? maxClipSize;
  final String? licenseNo;
  final String? serverFlag;
  final String? orderNo;
  final String? clientOrderNo;
  final String? clientID;
  final String? tacticsType;
  final String? triggerCondition;
  final String? triggerPriceType;
  final String? addOneIsValid;
  final String? clientLocalIP;
  final String? clientMac;
  final String? clientIP;
  final String? orderStreamID;
  final String? upperNo;
  final String? upperChannelNo;
  final String? orderLocalNo;
  final String? upperStreamID;
  final String? orderSystemNo;
  final String? orderExchangeSystemNo;
  final String? orderParentSystemNo;
  final String? orderInsertUserNo;
  final String? orderInsertTime;
  final String? orderCommandUserNo;
  final String? orderUpdateUserNo;
  final String? orderUpdateTime;
  final String? orderState;
  final String? orderMatchPrice;
  final String? orderMatchPrice2;
  final String? orderMatchQty;
  final String? orderMatchQty2;
  final String? errorCode;
  final String? errorText;
  final String? isBackInput;
  final String? isDeleted;
  final String? isAddOne;

  WpFuturesOrderInfoListData({this.id, this.accountId, this.brokerNo, this.accountNo, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo, this.strikePrice, this.callOrPutFlag, this.contractNo2, this.strikePrice2, this.callOrPutFlag2, this.orderType, this.orderSource, this.timeInForce, this.expireTime, this.isRiskOrder, this.orderSide, this.positionEffect, this.positionEffect2, this.inquiryNo, this.hedgeFlag, this.orderPrice, this.orderPrice2, this.stopPrice, this.orderQty, this.orderMinQty, this.refInt, this.refDouble, this.refString, this.minClipSize, this.maxClipSize, this.licenseNo, this.serverFlag, this.orderNo, this.clientOrderNo, this.clientID, this.tacticsType, this.triggerCondition, this.triggerPriceType, this.addOneIsValid, this.clientLocalIP, this.clientMac, this.clientIP, this.orderStreamID, this.upperNo, this.upperChannelNo, this.orderLocalNo, this.upperStreamID, this.orderSystemNo, this.orderExchangeSystemNo, this.orderParentSystemNo, this.orderInsertUserNo, this.orderInsertTime, this.orderCommandUserNo, this.orderUpdateUserNo, this.orderUpdateTime, this.orderState, this.orderMatchPrice, this.orderMatchPrice2, this.orderMatchQty, this.orderMatchQty2, this.errorCode, this.errorText, this.isBackInput, this.isDeleted, this.isAddOne});

  factory WpFuturesOrderInfoListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesOrderInfoListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo : json['contractNo'].toString(),
      strikePrice : json['strikePrice'].toString(),
      callOrPutFlag : json['callOrPutFlag'].toString(),
      contractNo2 : json['contractNo2'].toString(),
      strikePrice2 : json['strikePrice2'].toString(),
      callOrPutFlag2 : json['callOrPutFlag2'].toString(),
      orderType : json['orderType'].toString(),
      orderSource : json['orderSource'].toString(),
      timeInForce : json['timeInForce'].toString(),
      expireTime : json['expireTime'].toString(),
      isRiskOrder : json['isRiskOrder'].toString(),
      orderSide : json['orderSide'].toString(),
      positionEffect : json['positionEffect'].toString(),
      positionEffect2 : json['positionEffect2'].toString(),
      inquiryNo : json['inquiryNo'].toString(),
      hedgeFlag : json['hedgeFlag'].toString(),
      orderPrice : json['orderPrice'].toString(),
      orderPrice2 : json['orderPrice2'].toString(),
      stopPrice : json['stopPrice'].toString(),
      orderQty : json['orderQty'].toString(),
      orderMinQty : json['orderMinQty'].toString(),
      refInt : json['refInt'].toString(),
      refDouble : json['refDouble'].toString(),
      refString : json['refString'].toString(),
      minClipSize : json['minClipSize'].toString(),
      maxClipSize : json['maxClipSize'].toString(),
      licenseNo : json['licenseNo'].toString(),
      serverFlag : json['serverFlag'].toString(),
      orderNo : json['orderNo'].toString(),
      clientOrderNo : json['clientOrderNo'].toString(),
      clientID : json['clientID'].toString(),
      tacticsType : json['tacticsType'].toString(),
      triggerCondition : json['triggerCondition'].toString(),
      triggerPriceType : json['triggerPriceType'].toString(),
      addOneIsValid : json['addOneIsValid'].toString(),
      clientLocalIP : json['clientLocalIP'].toString(),
      clientMac : json['clientMac'].toString(),
      clientIP : json['clientIP'].toString(),
      orderStreamID : json['orderStreamID'].toString(),
      upperNo : json['upperNo'].toString(),
      upperChannelNo : json['upperChannelNo'].toString(),
      orderLocalNo : json['orderLocalNo'].toString(),
      upperStreamID : json['upperStreamID'].toString(),
      orderSystemNo : json['orderSystemNo'].toString(),
      orderExchangeSystemNo : json['orderExchangeSystemNo'].toString(),
      orderParentSystemNo : json['orderParentSystemNo'].toString(),
      orderInsertUserNo : json['orderInsertUserNo'].toString(),
      orderInsertTime : json['orderInsertTime'].toString(),
      orderCommandUserNo : json['orderCommandUserNo'].toString(),
      orderUpdateUserNo : json['orderUpdateUserNo'].toString(),
      orderUpdateTime : json['orderUpdateTime'].toString(),
      orderState : json['orderState'].toString(),
      orderMatchPrice : json['orderMatchPrice'].toString(),
      orderMatchPrice2 : json['orderMatchPrice2'].toString(),
      orderMatchQty : json['orderMatchQty'].toString(),
      orderMatchQty2 : json['orderMatchQty2'].toString(),
      errorCode : json['errorCode'].toString(),
      errorText : json['errorText'].toString(),
      isBackInput : json['isBackInput'].toString(),
      isDeleted : json['isDeleted'].toString(),
      isAddOne : json['isAddOne'].toString(),
    );
  }
}
//外盘期货保证金率
class WpFuturesAccountMarginRentResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesAccountMarginRentListData>? object;

  WpFuturesAccountMarginRentResponseData({this.code, this.message, this.object});

  factory WpFuturesAccountMarginRentResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesAccountMarginRentResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesAccountMarginRentListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesAccountMarginRentListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? contractNo;
  final String? strikePrice;
  final String? callOrPutFlag;
  final String? calculateMode;
  final String? currencyGroupNo;
  final String? currencyNo;
  final String? initialMargin;
  final String? maintenanceMargin;
  final String? sellInitialMargin;
  final String? sellMaintenanceMargin;
  final String? lockMargin;

  WpFuturesAccountMarginRentListData({this.id, this.accountId, this.brokerNo, this.accountNo, this.exchangeNo, this.commodityType, this.commodityNo, this.contractNo, this.strikePrice, this.callOrPutFlag, this.calculateMode, this.currencyGroupNo, this.currencyNo, this.initialMargin, this.maintenanceMargin, this.sellInitialMargin, this.sellMaintenanceMargin, this.lockMargin});

  factory WpFuturesAccountMarginRentListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesAccountMarginRentListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      contractNo : json['contractNo'].toString(),
      strikePrice : json['strikePrice'].toString(),
      callOrPutFlag : json['callOrPutFlag'].toString(),
      calculateMode : json['calculateMode'].toString(),
      currencyGroupNo : json['currencyGroupNo'].toString(),
      currencyNo : json['currencyNo'].toString(),
      initialMargin : json['initialMargin'].toString(),
      maintenanceMargin : json['maintenanceMargin'].toString(),
      sellInitialMargin : json['sellInitialMargin'].toString(),
      sellMaintenanceMargin : json['sellMaintenanceMargin'].toString(),
      lockMargin : json['lockMargin'].toString(),
    );
  }
}
//外盘期货手续费率
class WpFuturesAccountFeeRentResponseData{
  final int? code;
  final String? message;
  final List<WpFuturesAccountFeeRentListData>? object;

  WpFuturesAccountFeeRentResponseData({this.code, this.message, this.object});

  factory WpFuturesAccountFeeRentResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesAccountFeeRentResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpFuturesAccountFeeRentListData.fromJson(i))
          .toList(),
    );
  }
}
class WpFuturesAccountFeeRentListData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? exchangeNo;
  final String? commodityType;
  final String? commodityNo;
  final String? matchSource;
  final String? calculateMode;
  final String? currencyGroupNo;
  final String? currencyNo;
  final String? openCloseFee;
  final String? closeTodayFee;

  WpFuturesAccountFeeRentListData({this.id, this.accountId, this.brokerNo, this.accountNo, this.exchangeNo, this.commodityType, this.commodityNo, this.matchSource, this.calculateMode, this.currencyGroupNo, this.currencyNo, this.openCloseFee, this.closeTodayFee});

  factory WpFuturesAccountFeeRentListData.fromJson(Map<dynamic, dynamic> json) {
    return WpFuturesAccountFeeRentListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      exchangeNo : json['exchangeNo'].toString(),
      commodityType : json['commodityType'].toString(),
      commodityNo : json['commodityNo'].toString(),
      matchSource : json['matchSource'].toString(),
      calculateMode : json['calculateMode'].toString(),
      currencyGroupNo : json['currencyGroupNo'].toString(),
      currencyNo : json['currencyNo'].toString(),
      openCloseFee : json['openCloseFee'].toString(),
      closeTodayFee : json['closeTodayFee'].toString(),
    );
  }
}





