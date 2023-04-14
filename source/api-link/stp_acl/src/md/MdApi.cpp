////
//// Created by root on 8/18/21.
////
//
//#include "quote/MdApi.h"
//
//MdApi::MdApi() {}
//
//MdApi::~MdApi() {
//
//}
//
//CTORATstpMdApi *MdApi::CreateTstpMdApi(const TTORATstpMDSubModeType &eMDSubMode, const TTORATstpMDSubModeType &eDeriveMDSubMode) {
//    return nullptr;
//}
//
//const char *MdApi::GetApiVersion() {
//    return nullptr;
//}
//
//
//
//void MdApi::Release() {
//
//}
//
//void MdApi::Init() {
//
//}
//
//int MdApi::Join() {
//    return 0;
//}
//
//void MdApi::RegisterFront(char *pszFrontAddress) {
//
//}
//
//void MdApi::RegisterNameServer(char *pszNsAddress) {
//
//}
//
//void MdApi::RegisterMulticast(char *pszMulticastAddress, char *pszInterfaceIP, char *pszSourceIp) {
//
//}
//
//void MdApi::RegisterDeriveServer(char *pszDeriveAddress) {
//
//}
//
//void MdApi::RegisterDeriveMulticast(char *pszMulticastAddress, char *pszInterfaceIP, char *pszSourceIp) {
//
//}
//
//void MdApi::RegisterSpi(CTORATstpMdSpi *pSpi) {
//
//}
//
//int MdApi::ReqGetConnectionInfo(int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqUserLogin(CTORATstpReqUserLoginField *pReqUserLoginField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqUserLogout(CTORATstpUserLogoutField *pUserLogout, int nRequestID) {
//    return 0;
//}
//
//int MdApi::SubscribeMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribePHMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribePHMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeSpecialMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeSpecialMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::ReqInquiryMarketDataMirror(CTORATstpInquiryMarketDataField *pInquiryMarketDataField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqInquiryPHMarketDataMirror(CTORATstpInquiryMarketDataField *pInquiryMarketDataField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqInquirySpecialMarketDataMirror(CTORATstpInquirySpecialMarketDataField *pInquirySpecialMarketDataField,
//                                             int nRequestID) {
//    return 0;
//}
//
//int MdApi::SubscribeRapidMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeRapidMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeFundsFlowMarketData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeFundsFlowMarketData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeIndustryIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeIndustryIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeConceptionIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeConceptionIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeRegionIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::UnSubscribeRegionIndexData(char **ppInstrumentID, int nCount, TTORATstpExchangeIDType ExchageID) {
//    return 0;
//}
//
//int MdApi::SubscribeEffectOrderDetail(TTORATstpExchangeIDType ExchangeID, char *SecurityID, TTORATstpRatioType Ratio) {
//    return 0;
//}
//
//int MdApi::UnSubscribeEffectOrderDetail(TTORATstpExchangeIDType ExchangeID, char *SecurityID) {
//    return 0;
//}
//
//int MdApi::SubscribeEffectTradeDetail(TTORATstpExchangeIDType ExchangeID, char *SecurityID, TTORATstpRatioType Ratio) {
//    return 0;
//}
//
//int MdApi::UnSubscribeEffectTradeDetail(TTORATstpExchangeIDType ExchangeID, char *SecurityID) {
//    return 0;
//}
//
//int
//MdApi::ReqQryRightsAdjustmentInfo(CTORATstpQryRightsAdjustmentInfoField *pQryRightsAdjustmentField, int nRequestID) {
//    return 0;
//}
//
//int
//MdApi::ReqQryHistoryFundsFlowInfo(CTORATstpQryHistoryFundsFlowInfoField *pQryHistoryFundsFlowField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryFinancialIndicatorInfo(CTORATstpQryFinancialIndicatorInfoField *pQryFinancialIndicatorField,
//                                        int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryDividendInfo(CTORATstpQryDividendInfoField *pQryDividendInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryRightIssueInfo(CTORATstpQryRightIssueInfoField *pQryRightIssueInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryCompanyDescriptionInfo(CTORATstpQryCompanyDescriptionInfoField *pQryCompanyDescriptionInfoField,
//                                        int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQrySalesSegmentInfo(CTORATstpQrySalesSegmentInfoField *pQrySalesSegmentInfoField, int nRequestID) {
//    return 0;
//}
//
//int
//MdApi::ReqQryEquityStructureInfo(CTORATstpQryEquityStructureInfoField *pQryEquityStructureInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryTopTenHoldersInfo(CTORATstpQryTopTenHoldersInfoField *pQryTopTenHoldersInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryTopTenFloatHoldersInfo(CTORATstpQryTopTenFloatHoldersInfoField *pQryTopTenFloatHoldersInfoField,
//                                        int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryIndustryInfo(CTORATstpQryIndustryInfoField *pQryIndustryInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryConceptionInfo(CTORATstpQryConceptionInfoField *pQryConceptionInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryRegionInfo(CTORATstpQryRegionInfoField *pQryRegionInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryIndexDescriptionInfo(CTORATstpQryIndexDescriptionInfoField *pQryIndexDescriptionInfoField,
//                                      int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryIndustryConstituentsInfo(CTORATstpQryIndustryConstituentsInfoField *pQryIndustryConstituentsInfoField,
//                                          int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryConceptionConstituentsInfo(
//        CTORATstpQryConceptionConstituentsInfoField *pQryConceptionConstituentsInfoField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryRegionConstituentsInfo(CTORATstpQryRegionConstituentsInfoField *pQryRegionConstituentsInfoField,
//                                        int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryIndustryCodeList(CTORATstpQryIndustryCodeListField *pQryIndustryCodeListField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryConceptionCodeList(CTORATstpQryConceptionCodeListField *pQryConceptionCodeListField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryRegionCodeList(CTORATstpQryRegionCodeListField *pQryRegionCodeListField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryFreeFloatSharesInfo(CTORATstpQryFreeFloatSharesInfoField *pQryFreeFloatSharesField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryQueueingOrders(CTORATstpInquiryQueueingOrdersField *pInquiryQueueingOrdersField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryPriceDistributionInfo(CTORATstpQryPriceDistributionInfoField *pQryPriceDistributionField, int nRequestID) {
//    return 0;
//}
//
//int MdApi::ReqQryPriceExtremumInfo(CTORATstpQryPriceExtremumInfoField *pQryPriceExtremumField, int nRequestID) {
//    return 0;
//}
