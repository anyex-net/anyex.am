//外盘现货交易所
class WpSpotExchangeInfoResponseData{
  final int? code;
  final String? message;
  final List<WpSpotExchangeInfoListData>? object;

  WpSpotExchangeInfoResponseData({this.code, this.message, this.object});

  factory WpSpotExchangeInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotExchangeInfoResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpSpotExchangeInfoListData.fromJson(i))
          .toList(),
    );
  }
}
class WpSpotExchangeInfoListData{
  final String? id;
  final String? exchangeID;
  final String? exchangeName;
  final String? exchangeProperty;
  final String? exchangeDomain;
  final String? openMarket;
  final String? enableStatus;

  WpSpotExchangeInfoListData({this.id, this.exchangeID,this.exchangeProperty, this.exchangeName, this.exchangeDomain,this.enableStatus, this.openMarket});

  factory WpSpotExchangeInfoListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotExchangeInfoListData(
      id : json['id'].toString(),
      exchangeID : json['exchangeID'].toString(),
      exchangeName : json['exchangeName'].toString(),
      exchangeProperty : json['exchangeProperty'].toString(),
      exchangeDomain : json['exchangeDomain'].toString(),
      openMarket : json['openMarket'].toString(),
      enableStatus : json['enableStatus'].toString(),
    );
  }
}
//外盘现货交易所期货合约表
class WpSpotExchangeInstrumentResponseData{
  final int? code;
  final String? message;
  final List<WpSpotExchangeInstrumentListData>? object;

  WpSpotExchangeInstrumentResponseData({this.code, this.message, this.object});

  factory WpSpotExchangeInstrumentResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotExchangeInstrumentResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpSpotExchangeInstrumentListData.fromJson(i))
          .toList(),
    );
  }
}
class WpSpotExchangeInstrumentListData{
  final String? id;
  final String? instrumentID;
  final String? exchangeID;
  final String? instrumentName;
  final String? exchangeInstID;
  final String? productID;
  final String? productClass;
  final String? deliveryYear;
  final String? deliveryMonth;
  final String? maxMarketOrderVolume;
  final String? minMarketOrderVolume;
  final String? maxLimitOrderVolume;
  final String? minLimitOrderVolume;
  final String? volumeMultiple;
  final String? priceTick;
  final String? createDate;
  final String? openDate;
  final String? expireDate;
  final String? startDelivDate;
  final String? endDelivDate;
  final String? instLifePhase;
  final String? isTrading;
  final String? positionType;
  final String? positionDateType;
  final String? longMarginRatio;
  final String? shortMarginRatio;
  final String? maxMarginSideAlgorithm;
  final String? underlyingInstrID;
  final String? strikePrice;
  final String? optionsType;
  final String? underlyingMultiple;
  final String? combinationType;
  final String? enableStatus;

  WpSpotExchangeInstrumentListData({this.id, this.instrumentID, this.exchangeID, this.instrumentName, this.exchangeInstID, this.productID, this.productClass, this.deliveryYear, this.deliveryMonth, this.maxMarketOrderVolume, this.minMarketOrderVolume, this.maxLimitOrderVolume, this.minLimitOrderVolume, this.volumeMultiple, this.priceTick, this.createDate, this.openDate, this.expireDate, this.startDelivDate, this.endDelivDate, this.instLifePhase, this.isTrading, this.positionType, this.positionDateType, this.longMarginRatio, this.shortMarginRatio, this.maxMarginSideAlgorithm, this.underlyingInstrID, this.strikePrice, this.optionsType, this.underlyingMultiple, this.combinationType, this.enableStatus});


  factory WpSpotExchangeInstrumentListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotExchangeInstrumentListData(
      id : json['id'].toString(),
      instrumentID : json['instrumentID'].toString(),
      exchangeID : json['exchangeID'].toString(),
      instrumentName : json['instrumentName'].toString(),
      exchangeInstID : json['exchangeInstID'].toString(),
      productID : json['productID'].toString(),
      productClass : json['productClass'].toString(),
      deliveryYear : json['deliveryYear'].toString(),
      deliveryMonth : json['deliveryMonth'].toString(),
      maxMarketOrderVolume : json['maxMarketOrderVolume'].toString(),
      minMarketOrderVolume : json['minMarketOrderVolume'].toString(),
      maxLimitOrderVolume : json['maxLimitOrderVolume'].toString(),
      minLimitOrderVolume : json['minLimitOrderVolume'].toString(),
      volumeMultiple : json['volumeMultiple'].toString(),
      priceTick : json['priceTick'].toString(),
      createDate : json['createDate'].toString(),
      openDate : json['openDate'].toString(),
      expireDate : json['expireDate'].toString(),
      startDelivDate : json['startDelivDate'].toString(),
      endDelivDate : json['endDelivDate'].toString(),
      instLifePhase : json['instLifePhase'].toString(),
      isTrading : json['isTrading'].toString(),
      positionType : json['positionType'].toString(),
      positionDateType : json['positionDateType'].toString(),
      longMarginRatio : json['longMarginRatio'].toString(),
      shortMarginRatio : json['shortMarginRatio'].toString(),
      maxMarginSideAlgorithm : json['maxMarginSideAlgorithm'].toString(),
      underlyingInstrID : json['underlyingInstrID'].toString(),
      strikePrice : json['strikePrice'].toString(),
      optionsType : json['optionsType'].toString(),
      underlyingMultiple : json['underlyingMultiple'].toString(),
      combinationType : json['combinationType'].toString(),
      enableStatus : json['enableStatus'].toString(),
    );
  }
}
//外盘现货账户
class WpSpotTradingAccountResponseData{
  final int? code;
  final String? message;
  final List<WpSpotTradingAccountListData>? object;

  WpSpotTradingAccountResponseData({this.code, this.message, this.object});

  factory WpSpotTradingAccountResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotTradingAccountResponseData(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WpSpotTradingAccountListData.fromJson(i))
          .toList(),
    );
  }
}
class WpSpotTradingAccountListData{
  final String? id;
  final String? accountId;
  final String? brokerID;
  final String? investorID;
  final String? preMortgage;
  final String? preCredit;
  final String? preDeposit;
  final String? preBalance;
  final String? preMargin;
  final String? interestBase;
  final String? interest;
  final String? deposit;
  final String? withdraw;
  final String? frozenMargin;
  final String? frozenCash;
  final String? frozenCommission;
  final String? currMargin;
  final String? cashIn;
  final String? commission;
  final String? closeProfit;
  final String? positionProfit;
  final String? balance;
  final String? available;
  final String? withdrawQuota;
  final String? reserve;
  final String? tradingDay;
  final String? settlementID;
  final String? credit;
  final String? mortgage;
  final String? exchangeMargin;
  final String? deliveryMargin;
  final String? exchangeDeliveryMargin;
  final String? reserveBalance;
  final String? currencyID;
  final String? preFundMortgageIn;
  final String? preFundMortgageOut;
  final String? fundMortgageIn;
  final String? fundMortgageOut;
  final String? fundMortgageAvailable;
  final String? mortgageableFund;
  final String? specProductMargin;
  final String? specProductFrozenMargin;
  final String? specProductCommission;
  final String? specProductFrozenCommission;
  final String? specProductPositionProfit;
  final String? specProductCloseProfit;
  final String? specProductPositionProfitByAlg;
  final String? specProductExchangeMargin;
  final String? bizType;
  final String? frozenSwap;
  final String? remainSwap;

  WpSpotTradingAccountListData({this.id, this.accountId, this.brokerID, this.investorID, this.preMortgage, this.preCredit, this.preDeposit, this.preBalance, this.preMargin, this.interestBase, this.interest, this.deposit, this.withdraw, this.frozenMargin, this.frozenCash, this.frozenCommission, this.currMargin, this.cashIn, this.commission, this.closeProfit, this.positionProfit, this.balance, this.available, this.withdrawQuota, this.reserve, this.tradingDay, this.settlementID, this.credit, this.mortgage, this.exchangeMargin, this.deliveryMargin, this.exchangeDeliveryMargin, this.reserveBalance, this.currencyID, this.preFundMortgageIn, this.preFundMortgageOut, this.fundMortgageIn, this.fundMortgageOut, this.fundMortgageAvailable, this.mortgageableFund, this.specProductMargin, this.specProductFrozenMargin, this.specProductCommission, this.specProductFrozenCommission, this.specProductPositionProfit, this.specProductCloseProfit, this.specProductPositionProfitByAlg, this.specProductExchangeMargin, this.bizType, this.frozenSwap, this.remainSwap});

  factory WpSpotTradingAccountListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotTradingAccountListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerID : json['brokerID'].toString(),
      investorID : json['investorID'].toString(),
      preMortgage : json['preMortgage'].toString(),
      preCredit : json['preCredit'].toString(),
      preDeposit : json['preDeposit'].toString(),
      preBalance : json['preBalance'].toString(),
      preMargin : json['preMargin'].toString(),
      interestBase : json['interestBase'].toString(),
      interest : json['interest'].toString(),
      deposit : json['deposit'].toString(),
      withdraw : json['withdraw'].toString(),
      frozenMargin : json['frozenMargin'].toString(),
      frozenCash : json['frozenCash'].toString(),
      frozenCommission : json['frozenCommission'].toString(),
      currMargin : json['currMargin'].toString(),
      cashIn : json['cashIn'].toString(),
      commission : json['commission'].toString(),
      closeProfit : json['closeProfit'].toString(),
      positionProfit : json['positionProfit'].toString(),
      balance : json['balance'].toString(),
      available : json['available'].toString(),
      withdrawQuota : json['withdrawQuota'].toString(),
      reserve : json['reserve'].toString(),
      tradingDay : json['tradingDay'].toString(),
      settlementID : json['settlementID'].toString(),
      credit : json['credit'].toString(),
      mortgage : json['mortgage'].toString(),
      exchangeMargin : json['exchangeMargin'].toString(),
      deliveryMargin : json['deliveryMargin'].toString(),
      exchangeDeliveryMargin : json['exchangeDeliveryMargin'].toString(),
      reserveBalance : json['reserveBalance'].toString(),
      currencyID : json['currencyID'].toString(),
      preFundMortgageIn : json['preFundMortgageIn'].toString(),
      preFundMortgageOut : json['preFundMortgageOut'].toString(),
      fundMortgageIn : json['fundMortgageIn'].toString(),
      fundMortgageOut : json['fundMortgageOut'].toString(),
      fundMortgageAvailable : json['fundMortgageAvailable'].toString(),
      mortgageableFund : json['mortgageableFund'].toString(),
      specProductMargin : json['specProductMargin'].toString(),
      specProductFrozenMargin : json['specProductFrozenMargin'].toString(),
      specProductCommission : json['specProductCommission'].toString(),
      specProductFrozenCommission : json['specProductFrozenCommission'].toString(),
      specProductPositionProfit : json['specProductPositionProfit'].toString(),
      specProductCloseProfit : json['specProductCloseProfit'].toString(),
      specProductPositionProfitByAlg : json['specProductPositionProfitByAlg'].toString(),
      specProductExchangeMargin : json['specProductExchangeMargin'].toString(),
      bizType : json['bizType'].toString(),
      frozenSwap : json['frozenSwap'].toString(),
      remainSwap : json['remainSwap'].toString(),
    );
  }
}
//外盘现货当前委托
class WpSpotOrderResponseData{
  final int? code;
  final String? message;
  final List<WpSpotOrderListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpSpotOrderResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});

  factory WpSpotOrderResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotOrderResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpSpotOrderListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpSpotOrderListData{

  final String? id;
  final String? accountId;
  final String? brokerID;
  final String? investorID;
  final String? instrumentID;
  final String? orderRef;
  final String? userID;
  final String? orderPriceType;
  final String? direction;
  final String? combOffsetFlag;
  final String? combHedgeFlag;
  final String? limitPrice;
  final String? volumeTotalOriginal;
  final String? timeCondition;
  final String? gTDDate;
  final String? volumeCondition;
  final String? minVolume;
  final String? contingentCondition;
  final String? stopPrice;
  final String? forceCloseReason;
  final String? isAutoSuspend;
  final String? businessUnit;
  final String? requestID;
  final String? orderLocalID;
  final String? exchangeID;
  final String? participantID;
  final String? clientID;
  final String? exchangeInstID;
  final String? traderID;
  final String? installID;
  final String? orderSubmitStatus;
  final String? notifySequence;
  final String? tradingDay;
  final String? settlementID;
  final String? orderSysID;
  final String? orderSource;
  final String? orderStatus;
  final String? orderType;
  final String? volumeTraded;
  final String? volumeTotal;
  final String? insertDate;
  final String? insertTime;
  final String? activeTime;
  final String? suspendTime;
  final String? updateTime;
  final String? cancelTime;
  final String? activeTraderID;
  final String? clearingPartID;
  final String? sequenceNo;
  final String? frontID;
  final String? sessionID;
  final String? userProductInfo;
  final String? statusMsg;
  final String? userForceClose;
  final String? activeUserID;
  final String? brokerOrderSeq;
  final String? relativeOrderSysID;
  final String? zCETotalTradedVolume;
  final String? isSwapOrder;
  final String? branchID;
  final String? investUnitID;
  final String? accountNo;
  final String? currencyID;
  final String? iPAddress;
  final String? macAddress;
  final String? errorID;
  final String? errorMsg;
  final String? orderActionRef;
  final String? actionFlag;
  final String? volumeChange;
  final String? actionDate;
  final String? actionTime;
  final String? actionLocalID;
  final String? orderActionStatus;
  final String? ipaddress;
  final String? zcetotalTradedVolume;
  final String? gtddate;

  WpSpotOrderListData({this.id, this.accountId, this.brokerID, this.investorID, this.instrumentID, this.orderRef, this.userID, this.orderPriceType, this.direction, this.combOffsetFlag, this.combHedgeFlag, this.limitPrice, this.volumeTotalOriginal, this.timeCondition, this.gTDDate, this.volumeCondition, this.minVolume, this.contingentCondition, this.stopPrice, this.forceCloseReason, this.isAutoSuspend, this.businessUnit, this.requestID, this.orderLocalID, this.exchangeID, this.participantID, this.clientID, this.exchangeInstID, this.traderID, this.installID, this.orderSubmitStatus, this.notifySequence, this.tradingDay, this.settlementID, this.orderSysID, this.orderSource, this.orderStatus, this.orderType, this.volumeTraded, this.volumeTotal, this.insertDate, this.insertTime, this.activeTime, this.suspendTime, this.updateTime, this.cancelTime, this.activeTraderID, this.clearingPartID, this.sequenceNo, this.frontID, this.sessionID, this.userProductInfo, this.statusMsg, this.userForceClose, this.activeUserID, this.brokerOrderSeq, this.relativeOrderSysID, this.zCETotalTradedVolume, this.isSwapOrder, this.branchID, this.investUnitID, this.accountNo, this.currencyID, this.iPAddress, this.macAddress, this.errorID, this.errorMsg, this.orderActionRef, this.actionFlag, this.volumeChange, this.actionDate, this.actionTime, this.actionLocalID, this.orderActionStatus, this.ipaddress, this.zcetotalTradedVolume, this.gtddate});

  factory WpSpotOrderListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotOrderListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerID : json['brokerID'].toString(),
      investorID : json['investorID'].toString(),
      instrumentID : json['instrumentID'].toString(),
      orderRef : json['orderRef'].toString(),
      userID : json['userID'].toString(),
      orderPriceType : json['orderPriceType'].toString(),
      direction : json['direction'].toString(),
      combOffsetFlag : json['combOffsetFlag'].toString(),
      combHedgeFlag : json['combHedgeFlag'].toString(),
      limitPrice : json['limitPrice'].toString(),
      volumeTotalOriginal : json['volumeTotalOriginal'].toString(),
      timeCondition : json['timeCondition'].toString(),
      gTDDate : json['gTDDate'].toString(),
      volumeCondition : json['volumeCondition'].toString(),
      minVolume : json['minVolume'].toString(),
      contingentCondition : json['contingentCondition'].toString(),
      stopPrice : json['stopPrice'].toString(),
      forceCloseReason : json['forceCloseReason'].toString(),
      isAutoSuspend : json['isAutoSuspend'].toString(),
      businessUnit : json['businessUnit'].toString(),
      requestID : json['requestID'].toString(),
      orderLocalID : json['orderLocalID'].toString(),
      exchangeID : json['exchangeID'].toString(),
      participantID : json['participantID'].toString(),
      clientID : json['clientID'].toString(),
      exchangeInstID : json['exchangeInstID'].toString(),
      traderID : json['traderID'].toString(),
      installID : json['installID'].toString(),
      orderSubmitStatus : json['orderSubmitStatus'].toString(),
      notifySequence : json['notifySequence'].toString(),
      tradingDay : json['tradingDay'].toString(),
      settlementID : json['settlementID'].toString(),
      orderSysID : json['orderSysID'].toString(),
      orderSource : json['orderSource'].toString(),
      orderStatus : json['orderStatus'].toString(),
      orderType : json['orderType'].toString(),
      volumeTraded : json['volumeTraded'].toString(),
      volumeTotal : json['volumeTotal'].toString(),
      insertDate : json['insertDate'].toString(),
      insertTime : json['insertTime'].toString(),
      activeTime : json['activeTime'].toString(),
      suspendTime : json['suspendTime'].toString(),
      updateTime : json['updateTime'].toString(),
      cancelTime : json['cancelTime'].toString(),
      activeTraderID : json['activeTraderID'].toString(),
      clearingPartID : json['clearingPartID'].toString(),
      sequenceNo : json['sequenceNo'].toString(),
      frontID : json['frontID'].toString(),
      sessionID : json['sessionID'].toString(),
      userProductInfo : json['userProductInfo'].toString(),
      statusMsg : json['statusMsg'].toString(),
      userForceClose : json['userForceClose'].toString(),
      activeUserID : json['activeUserID'].toString(),
      brokerOrderSeq : json['brokerOrderSeq'].toString(),
      relativeOrderSysID : json['relativeOrderSysID'].toString(),
      zCETotalTradedVolume : json['zCETotalTradedVolume'].toString(),
      isSwapOrder : json['isSwapOrder'].toString(),
      branchID : json['branchID'].toString(),
      investUnitID : json['investUnitID'].toString(),
      accountNo : json['accountNo'].toString(),
      currencyID : json['currencyID'].toString(),
      iPAddress : json['iPAddress'].toString(),
      macAddress : json['macAddress'].toString(),
      errorID : json['errorID'].toString(),
      errorMsg : json['errorMsg'].toString(),
      orderActionRef : json['orderActionRef'].toString(),
      actionFlag : json['actionFlag'].toString(),
      volumeChange : json['volumeChange'].toString(),
      actionDate : json['actionDate'].toString(),
      actionTime : json['actionTime'].toString(),
      actionLocalID : json['actionLocalID'].toString(),
      orderActionStatus : json['orderActionStatus'].toString(),
      ipaddress : json['ipaddress'].toString(),
      zcetotalTradedVolume : json['zcetotalTradedVolume'].toString(),
      gtddate : json['gtddate'].toString(),
    );
  }
}
//外盘现货历史成交
class WpSpotTradeResponseData{
  final int? code;
  final String? message;
  final List<WpSpotTradeListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpSpotTradeResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});

  factory WpSpotTradeResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotTradeResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpSpotTradeListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpSpotTradeListData{
  final String? id;
  final String? accountId;
  final String? brokerID;
  final String? investorID;
  final String? instrumentID;
  final String? orderRef;
  final String? userID;
  final String? exchangeID;
  final String? tradeID;
  final String? direction;
  final String? orderSysID;
  final String? participantID;
  final String? clientID;
  final String? tradingRole;
  final String? exchangeInstID;
  final String? offsetFlag;
  final String? hedgeFlag;
  final String? price;
  final String? volume;
  final String? tradeDate;
  final String? tradeTime;
  final String? tradeType;
  final String? priceSource;
  final String? traderID;
  final String? orderLocalID;
  final String? clearingPartID;
  final String? businessUnit;
  final String? sequenceNo;
  final String? tradingDay;
  final String? settlementID;
  final String? brokerOrderSeq;
  final String? tradeSource;
  final String? investUnitID;

  WpSpotTradeListData({this.id, this.accountId, this.brokerID, this.investorID, this.instrumentID, this.orderRef, this.userID, this.exchangeID, this.tradeID, this.direction, this.orderSysID, this.participantID, this.clientID, this.tradingRole, this.exchangeInstID, this.offsetFlag, this.hedgeFlag, this.price, this.volume, this.tradeDate, this.tradeTime, this.tradeType, this.priceSource, this.traderID, this.orderLocalID, this.clearingPartID, this.businessUnit, this.sequenceNo, this.tradingDay, this.settlementID, this.brokerOrderSeq, this.tradeSource, this.investUnitID});


  factory WpSpotTradeListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotTradeListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerID : json['brokerID'].toString(),
      investorID : json['investorID'].toString(),
      instrumentID : json['instrumentID'].toString(),
      orderRef : json['orderRef'].toString(),
      userID : json['userID'].toString(),
      exchangeID : json['exchangeID'].toString(),
      tradeID : json['tradeID'].toString(),
      direction : json['direction'].toString(),
      orderSysID : json['orderSysID'].toString(),
      participantID : json['participantID'].toString(),
      clientID : json['clientID'].toString(),
      tradingRole : json['tradingRole'].toString(),
      exchangeInstID : json['exchangeInstID'].toString(),
      offsetFlag : json['offsetFlag'].toString(),
      hedgeFlag : json['hedgeFlag'].toString(),
      price : json['price'].toString(),
      volume : json['volume'].toString(),
      tradeDate : json['tradeDate'].toString(),
      tradeTime : json['tradeTime'].toString(),
      tradeType : json['tradeType'].toString(),
      priceSource : json['priceSource'].toString(),
      traderID : json['traderID'].toString(),
      orderLocalID : json['orderLocalID'].toString(),
      clearingPartID : json['clearingPartID'].toString(),
      businessUnit : json['businessUnit'].toString(),
      sequenceNo : json['sequenceNo'].toString(),
      tradingDay : json['tradingDay'].toString(),
      settlementID : json['settlementID'].toString(),
      brokerOrderSeq : json['brokerOrderSeq'].toString(),
      tradeSource : json['tradeSource'].toString(),
      investUnitID : json['investUnitID'].toString(),
    );
  }
}
//外盘现货持仓
class WpSpotInvestorPositionResponseData{
  final int? code;
  final String? message;
  final List<WpSpotInvestorPositionListData>? rows;
  final String? total;
  final String? pages;
  final String? totalPage;
  final bool? hasNext;
  final bool? hasPrevious;

  WpSpotInvestorPositionResponseData({this.code, this.message, this.rows, this.total, this.pages, this.totalPage, this.hasNext, this.hasPrevious});

  factory WpSpotInvestorPositionResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotInvestorPositionResponseData(
      code : json['code'],
      message : json['message'].toString(),
      rows: (json['rows'] as List)
          .map((i) => WpSpotInvestorPositionListData.fromJson(i))
          .toList(),
      total : json['total'].toString(),
      pages : json['pages'].toString(),
      totalPage : json['totalPage'].toString(),
      hasNext : json['hasNext'],
      hasPrevious : json['hasPrevious'],
    );
  }
}
class WpSpotInvestorPositionListData{
  final String? id;
  final String? accountId;
  final String? instrumentID;
  final String? brokerID;
  final String? investorID;
  final String? posiDirection;
  final String? hedgeFlag;
  final String? positionDate;
  final String? ydPosition;
  final String? position;
  final String? longFrozen;
  final String? shortFrozen;
  final String? longFrozenAmount;
  final String? shortFrozenAmount;
  final String? openVolume;
  final String? closeVolume;
  final String? openAmount;
  final String? closeAmount;
  final String? positionCost;
  final String? preMargin;
  final String? useMargin;
  final String? frozenMargin;
  final String? frozenCash;
  final String? frozenCommission;
  final String? cashIn;
  final String? commission;
  final String? closeProfit;
  final String? positionProfit;
  final String? preSettlementPrice;
  final String? settlementPrice;
  final String? tradingDay;
  final String? settlementID;
  final String? openCost;
  final String? exchangeMargin;
  final String? combPosition;
  final String? combLongFrozen;
  final String? combShortFrozen;
  final String? closeProfitByDate;
  final String? closeProfitByTrade;
  final String? todayPosition;
  final String? marginRateByMoney;
  final String? marginRateByVolume;
  final String? strikeFrozen;
  final String? strikeFrozenAmount;
  final String? abandonFrozen;
  final String? exchangeID;
  final String? ydStrikeFrozen;
  final String? investUnitID;
  final String? positionCostOffset;
  final String? tasPosition;
  final String? tasPositionCost;
  final String? priceTick;
  final String? lastPrice;

  WpSpotInvestorPositionListData({this.lastPrice,this.priceTick,this.id, this.accountId, this.instrumentID, this.brokerID, this.investorID, this.posiDirection, this.hedgeFlag, this.positionDate, this.ydPosition, this.position, this.longFrozen, this.shortFrozen, this.longFrozenAmount, this.shortFrozenAmount, this.openVolume, this.closeVolume, this.openAmount, this.closeAmount, this.positionCost, this.preMargin, this.useMargin, this.frozenMargin, this.frozenCash, this.frozenCommission, this.cashIn, this.commission, this.closeProfit, this.positionProfit, this.preSettlementPrice, this.settlementPrice, this.tradingDay, this.settlementID, this.openCost, this.exchangeMargin, this.combPosition, this.combLongFrozen, this.combShortFrozen, this.closeProfitByDate, this.closeProfitByTrade, this.todayPosition, this.marginRateByMoney, this.marginRateByVolume, this.strikeFrozen, this.strikeFrozenAmount, this.abandonFrozen, this.exchangeID, this.ydStrikeFrozen, this.investUnitID, this.positionCostOffset, this.tasPosition, this.tasPositionCost});

  factory WpSpotInvestorPositionListData.fromJson(Map<dynamic, dynamic> json) {
    return WpSpotInvestorPositionListData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      instrumentID : json['instrumentID'].toString(),
      brokerID : json['brokerID'].toString(),
      investorID : json['investorID'].toString(),
      posiDirection : json['posiDirection'].toString(),
      hedgeFlag : json['hedgeFlag'].toString(),
      positionDate : json['positionDate'].toString(),
      ydPosition : json['ydPosition'].toString(),
      position : json['position'].toString(),
      longFrozen : json['longFrozen'].toString(),
      shortFrozen : json['shortFrozen'].toString(),
      longFrozenAmount : json['longFrozenAmount'].toString(),
      shortFrozenAmount : json['shortFrozenAmount'].toString(),
      openVolume : json['openVolume'].toString(),
      closeVolume : json['closeVolume'].toString(),
      openAmount : json['openAmount'].toString(),
      closeAmount : json['closeAmount'].toString(),
      positionCost : json['positionCost'].toString(),
      preMargin : json['preMargin'].toString(),
      useMargin : json['useMargin'].toString(),
      frozenMargin : json['frozenMargin'].toString(),
      frozenCash : json['frozenCash'].toString(),
      frozenCommission : json['frozenCommission'].toString(),
      cashIn : json['cashIn'].toString(),
      commission : json['commission'].toString(),
      closeProfit : json['closeProfit'].toString(),
      positionProfit : json['positionProfit'].toString(),
      preSettlementPrice : json['preSettlementPrice'].toString(),
      settlementPrice : json['settlementPrice'].toString(),
      tradingDay : json['tradingDay'].toString(),
      settlementID : json['settlementID'].toString(),
      openCost : json['openCost'].toString(),
      exchangeMargin : json['exchangeMargin'].toString(),
      combPosition : json['combPosition'].toString(),
      combLongFrozen : json['combLongFrozen'].toString(),
      combShortFrozen : json['combShortFrozen'].toString(),
      closeProfitByDate : json['closeProfitByDate'].toString(),
      closeProfitByTrade : json['closeProfitByTrade'].toString(),
      todayPosition : json['todayPosition'].toString(),
      marginRateByMoney : json['marginRateByMoney'].toString(),
      marginRateByVolume : json['marginRateByVolume'].toString(),
      strikeFrozen : json['strikeFrozen'].toString(),
      strikeFrozenAmount : json['strikeFrozenAmount'].toString(),
      abandonFrozen : json['abandonFrozen'].toString(),
      exchangeID : json['exchangeID'].toString(),
      ydStrikeFrozen : json['ydStrikeFrozen'].toString(),
      investUnitID : json['investUnitID'].toString(),
      positionCostOffset : json['positionCostOffset'].toString(),
      tasPosition : json['tasPosition'].toString(),
      tasPositionCost : json['tasPositionCost'].toString(),
      priceTick : json['priceTick'].toString(),
      lastPrice : json['lastPrice'].toString(),
    );
  }
}
