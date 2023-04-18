
class DigitalCurrencyListResponseModel{
  List<DigitalCurrencyUnifiedModel>? margin;
  List<DigitalCurrencyUnifiedModel>? swap;
  List<DigitalCurrencyUnifiedModel>? spot;
  List<DigitalCurrencyUnifiedModel>? options;
  List<DigitalCurrencyUnifiedModel>? futures;

  DigitalCurrencyListResponseModel({this.margin, this.swap, this.spot, this.options, this.futures});

  factory DigitalCurrencyListResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyListResponseModel(
      margin: (json['margin'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList(),
      swap: (json['swap'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList(),
      spot: (json['spot'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList(),
      options: (json['options'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList(),
      futures: (json['futures'] as List).map((i) => DigitalCurrencyUnifiedModel.fromJson(i)).toList(),
    );
  }
}

class DigitalCurrencyUnifiedModel{
  String? uly;
  String? baseCcy;
  String? quoteCcy;
  String? expTime;
  String? minSz;
  String? lever;
  String? stk;
  String? tickSz;
  String? instType;
  String? optType;
  String? ctType;
  final String? instId;
  String? settleCcy;
  String? ctMult;
  String? ctValCcy;
  String? alias;
  String? ctVal;
  String? state;
  String? category;
  String? lotSz;
  String? listTime;
  String? last;
  String? lastSz;
  String? askPx;
  String? askSz;
  String? bidPx;
  String? bidSz;
  String? open24h;
  String? high24h;
  String? low24h;
  String? sodUtc0;
  String? sodUtc8;
  String? volCcy24h;
  String? vol24h;
  String? ts;

  DigitalCurrencyUnifiedModel({this.ts,this.vol24h,this.volCcy24h,this.sodUtc8,this.sodUtc0,this.low24h,this.high24h,this.open24h,this.bidSz,this.bidPx,this.askSz,this.askPx,this.lastSz,this.last,this.uly, this.baseCcy, this.quoteCcy, this.expTime, this.minSz, this.lever, this.stk, this.tickSz, this.instType, this.optType, this.ctType, this.instId, this.settleCcy, this.ctMult, this.ctValCcy, this.alias, this.ctVal, this.state, this.category, this.lotSz, this.listTime});

  factory DigitalCurrencyUnifiedModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyUnifiedModel(
      uly : json['uly'].toString(),
      baseCcy : json['baseCcy'].toString(),
      quoteCcy : json['quoteCcy'].toString(),
      expTime : json['expTime'].toString(),
      minSz : json['minSz'].toString(),
      lever : json['lever'].toString(),
      stk : json['stk'].toString(),
      tickSz : json['tickSz'].toString(),
      instType : json['instType'].toString(),
      optType : json['optType'].toString(),
      ctType : json['ctType'].toString(),
      instId : json['instId'].toString(),
      settleCcy : json['settleCcy'].toString(),
      ctMult : json['ctMult'].toString(),
      ctValCcy : json['ctValCcy'].toString(),
      alias : json['alias'].toString(),
      ctVal : json['ctVal'].toString(),
      state : json['state'].toString(),
      category : json['category'].toString(),
      lotSz : json['lotSz'].toString(),
      listTime : json['listTime'].toString(),
      last : json['last'].toString(),
      lastSz : json['lastSz'].toString(),
      askPx : json['askPx'].toString(),
      askSz : json['askSz'].toString(),
      bidPx : json['bidPx'].toString(),
      bidSz : json['bidSz'].toString(),
      open24h : json['open24h'].toString(),
      high24h : json['high24h'].toString(),
      low24h : json['low24h'].toString(),
      sodUtc0 : json['sodUtc0'].toString(),
      sodUtc8 : json['sodUtc8'].toString(),
      volCcy24h : json['volCcy24h'].toString(),
      vol24h : json['vol24h'].toString(),
      ts : json['ts'].toString(),
    );
  }
}

//最新成交Model
class DigitalCurrencyTradesSocketModel{
  final String? instId;
  final String? tradeId;
  final String? px;
  final String? sz;
  final String? side;
  final String? ts;

  DigitalCurrencyTradesSocketModel({this.instId, this.tradeId, this.px, this.sz, this.side, this.ts});

  factory DigitalCurrencyTradesSocketModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyTradesSocketModel(
      instId : json['instId'].toString(),
      tradeId : json['tradeId'].toString(),
      px : json['px'].toString(),
      sz : json['sz'].toString(),
      side : json['side'].toString(),
      ts : json['ts'].toString(),
    );
  }
}

//私有类 账户权益模型
class DigitalCurrencyAccountSocketModel{

  String? adjEq;
  List<DigitalCurrencyAccountDetailsSocketModel>? details;
  String? imr;
  String? isoEq;
  String? mgnRatio;
  String? mmr;
  String? notionalUsd;
  String? ordFroz;
  String? totalEq;
  String? uTime;

  DigitalCurrencyAccountSocketModel({this.adjEq, this.details, this.imr, this.isoEq, this.mgnRatio, this.mmr, this.notionalUsd, this.ordFroz, this.totalEq, this.uTime});

  factory DigitalCurrencyAccountSocketModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyAccountSocketModel(
      adjEq : json['adjEq'].toString(),
      imr : json['imr'].toString(),
      isoEq : json['isoEq'].toString(),
      mgnRatio : json['mgnRatio'].toString(),
      mmr : json['mmr'].toString(),
      notionalUsd : json['notionalUsd'].toString(),
      ordFroz : json['ordFroz'].toString(),
      totalEq : json['totalEq'].toString(),
      uTime : json['uTime'].toString(),
      details: (json['details'] as List).map((i) => DigitalCurrencyAccountDetailsSocketModel.fromJson(i)).toList(),
    );
  }

}

class DigitalCurrencyAccountDetailsSocketModel{
  String? availBal;
  String? availEq;
  String? cashBal;
  String? ccy;
  String? coinUsdPrice;
  String? crossLiab;
  String? disEq;
  String? eq;
  String? eqUsd;
  String? frozenBal;
  String? interest;
  String? isoEq;
  String? isoLiab;
  String? liab;
  String? maxLoan;
  String? mgnRatio;
  String? notionalLever;
  String? ordFrozen;
  String? twap;
  String? uTime;
  String? upl;

  DigitalCurrencyAccountDetailsSocketModel({this.availBal, this.availEq, this.cashBal, this.ccy, this.coinUsdPrice, this.crossLiab, this.disEq, this.eq, this.eqUsd, this.frozenBal, this.interest, this.isoEq, this.isoLiab, this.liab, this.maxLoan, this.mgnRatio, this.notionalLever, this.ordFrozen, this.twap, this.uTime, this.upl});

  factory DigitalCurrencyAccountDetailsSocketModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyAccountDetailsSocketModel(
      availBal : json['availBal'].toString(),
      availEq : json['availEq'].toString(),
      cashBal : json['cashBal'].toString(),
      ccy : json['ccy'].toString(),
      coinUsdPrice : json['coinUsdPrice'].toString(),
      crossLiab : json['crossLiab'].toString(),
      disEq : json['disEq'].toString(),
      eq : json['eq'].toString(),
      eqUsd : json['eqUsd'].toString(),
      frozenBal : json['frozenBal'].toString(),
      interest : json['interest'].toString(),
      isoEq : json['isoEq'].toString(),
      isoLiab : json['isoLiab'].toString(),
      liab : json['liab'].toString(),
      maxLoan : json['maxLoan'].toString(),
      mgnRatio : json['mgnRatio'].toString(),
      notionalLever : json['notionalLever'].toString(),
      ordFrozen : json['ordFrozen'].toString(),
      twap : json['twap'].toString(),
      uTime : json['uTime'].toString(),
      upl : json['upl'].toString(),
    );
  }
}

//私有类 仓位 信息模型
class DigitalCurrencyPositionsSocketModel{
  final String? adl;
  final String? availPos;
  final String? avgPx;
  final String? cTime;
  final String? ccy;
  final String? deltaBS;
  final String? deltaPA;
  final String? gammaBS;
  final String? gammaPA;
  final String? imr;
  final String? instId;
  final String? instType;
  final String? interest;
  final String? last;
  final String? lever;
  final String? liab;
  final String? liabCcy;
  final String? liqPx;
  final String? margin;
  final String? mgnMode;
  final String? mgnRatio;
  final String? mmr;
  final String? notionalUsd;
  final String? optVal;
  final String? pTime;
  final String? pos;
  final String? posCcy;
  final String? posId;
  final String? posSide;
  final String? thetaBS;
  final String? thetaPA;
  final String? tradeId;
  final String? uTime;
  final String? upl;
  final String? uplRatio;
  final String? vegaBS;
  final String? vegaPA;

  DigitalCurrencyPositionsSocketModel({this.adl, this.availPos, this.avgPx, this.cTime, this.ccy, this.deltaBS, this.deltaPA, this.gammaBS, this.gammaPA, this.imr, this.instId, this.instType, this.interest, this.last, this.lever, this.liab, this.liabCcy, this.liqPx, this.margin, this.mgnMode, this.mgnRatio, this.mmr, this.notionalUsd, this.optVal, this.pTime, this.pos, this.posCcy, this.posId, this.posSide, this.thetaBS, this.thetaPA, this.tradeId, this.uTime, this.upl, this.uplRatio, this.vegaBS, this.vegaPA});

  factory DigitalCurrencyPositionsSocketModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyPositionsSocketModel(
      adl : json['adl'].toString(),
      availPos : json['availPos'].toString(),
      avgPx : json['avgPx'].toString(),
      cTime : json['cTime'].toString(),
      ccy : json['ccy'].toString(),
      deltaBS : json['deltaBS'].toString(),
      deltaPA : json['deltaPA'].toString(),
      gammaBS : json['gammaBS'].toString(),
      gammaPA : json['gammaPA'].toString(),
      imr : json['imr'].toString(),
      instId : json['instId'].toString(),
      instType : json['instType'].toString(),
      interest : json['interest'].toString(),
      last : json['last'].toString(),
      lever : json['lever'].toString(),
      liab : json['liab'].toString(),
      liabCcy : json['liabCcy'].toString(),
      liqPx : json['liqPx'].toString(),
      margin : json['margin'].toString(),
      mgnMode : json['mgnMode'].toString(),
      mgnRatio : json['mgnRatio'].toString(),
      mmr : json['mmr'].toString(),
      notionalUsd : json['notionalUsd'].toString(),
      optVal : json['optVal'].toString(),
      pTime : json['pTime'].toString(),
      pos : json['pos'].toString(),
      posCcy : json['posCcy'].toString(),
      posId : json['posId'].toString(),
      posSide : json['posSide'].toString(),
      thetaBS : json['thetaBS'].toString(),
      thetaPA : json['thetaPA'].toString(),
      tradeId : json['tradeId'].toString(),
      uTime : json['uTime'].toString(),
      upl : json['upl'].toString(),
      uplRatio : json['uplRatio'].toString(),
      vegaBS : json['vegaBS'].toString(),
      vegaPA : json['vegaPA'].toString(),
    );
  }

}

//账户类 历史委托
class DigitalCurrencyTradeGetOrderHistory{
  final String? accFillSz;
  final String? avgPx;
  final String? cTime;
  final String? category;
  final String? ccy;
  final String? clOrdId;
  final String? fee;
  final String? feeCcy;
  final String? fillPx;
  final String? fillSz;
  final String? fillTime;
  final String? instId;
  final String? instType;
  final String? lever;
  final String? ordId;
  final String? ordType;
  final String? pnl;
  final String? posSide;
  final String? px;
  final String? rebate;
  final String? rebateCcy;
  final String? side;
  final String? slOrdPx;
  final String? slTriggerPx;
  final String? state;
  final String? sz;
  final String? tag;
  final String? tdMode;
  final String? tpOrdPx;
  final String? tpTriggerPx;
  final String? tradeId;
  final String? uTime;
  final String? tgtCcy;


  DigitalCurrencyTradeGetOrderHistory({this.tgtCcy,this.accFillSz, this.avgPx, this.cTime, this.category, this.ccy, this.clOrdId, this.fee, this.feeCcy, this.fillPx, this.fillSz, this.fillTime, this.instId, this.instType, this.lever, this.ordId, this.ordType, this.pnl, this.posSide, this.px, this.rebate, this.rebateCcy, this.side, this.slOrdPx, this.slTriggerPx, this.state, this.sz, this.tag, this.tdMode, this.tpOrdPx, this.tpTriggerPx, this.tradeId, this.uTime});

  factory DigitalCurrencyTradeGetOrderHistory.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyTradeGetOrderHistory(
      accFillSz : json['accFillSz'].toString(),
      avgPx : json['avgPx'].toString(),
      cTime : json['cTime'].toString(),
      category : json['category'].toString(),
      ccy : json['ccy'].toString(),
      clOrdId : json['clOrdId'].toString(),
      fee : json['fee'].toString(),
      feeCcy : json['feeCcy'].toString(),
      fillPx : json['fillPx'].toString(),
      fillSz : json['fillSz'].toString(),
      fillTime : json['fillTime'].toString(),
      instId : json['instId'].toString(),
      instType : json['instType'].toString(),
      lever : json['lever'].toString(),
      ordId : json['ordId'].toString(),
      ordType : json['ordType'].toString(),
      pnl : json['pnl'].toString(),
      posSide : json['posSide'].toString(),
      px : json['px'].toString(),
      rebate : json['rebate'].toString(),
      rebateCcy : json['rebateCcy'].toString(),
      side : json['side'].toString(),
      slOrdPx : json['slOrdPx'].toString(),
      slTriggerPx : json['slTriggerPx'].toString(),
      state : json['state'].toString(),
      sz : json['sz'].toString(),
      tag : json['tag'].toString(),
      tdMode : json['tdMode'].toString(),
      tpOrdPx : json['tpOrdPx'].toString(),
      tpTriggerPx : json['tpTriggerPx'].toString(),
      tradeId : json['tradeId'].toString(),
      uTime : json['uTime'].toString(),
      tgtCcy : json['tgtCcy'].toString(),
    );
  }
}