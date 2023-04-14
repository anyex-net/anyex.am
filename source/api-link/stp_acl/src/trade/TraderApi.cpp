////
//// Created by root on 8/17/21.
////
//
//#include <cstring>
//#include <iostream>
//#include "trade/TraderApi.h"
//
//CTORATstpTraderApi *TraderApi::CreateTstpTraderApi(const char *pszFlowPath, bool bEncrypt) {
//    return m_pApi = CTORATstpTraderApi::CreateTstpTraderApi(pszFlowPath);
//}
//
//const char *TraderApi::GetApiVersion() {
//    return m_pApi->GetApiVersion();
//}
//
//////////////////////////////////////////////////////////////////////////////////////////////////
//
//void TraderApi::Release() {
//    m_pApi->Release();
//}
//
//void TraderApi::Init() {
//    printf("Init\r\n");
//    m_pApi->Init();
//}
//
//int TraderApi::Join() {
//    printf("Join\r\n");
//    return m_pApi->Join();
//}
//
//void TraderApi::RegisterFront(char *pszFrontAddress) {
////    printf("RegisterFront");
//    m_pApi->RegisterFront(pszFrontAddress);
//}
//
//void TraderApi::RegisterNameServer(char *pszNsAddress) {
//    m_pApi->RegisterNameServer(pszNsAddress);
//}
//
//void TraderApi::RegisterDeriveServer(char *pszDeriveAddress) {
//    m_pApi->RegisterDeriveServer(pszDeriveAddress);
//}
//
//void TraderApi::RegisterSpi(CTORATstpTraderSpi *pSpi) {
//    printf("RegisterSpi\r\n");
//    m_pApi->RegisterSpi(pSpi);
//}
//
//void TraderApi::SubscribePrivateTopic(TORA_TE_RESUME_TYPE nResumeType) {
//    m_pApi->SubscribePrivateTopic(nResumeType);
//}
//
//void TraderApi::SubscribePublicTopic(TORA_TE_RESUME_TYPE nResumeType) {
//    m_pApi->SubscribePublicTopic(nResumeType);
//}
//
//int TraderApi::ReqGetConnectionInfo(int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqUserLogin(CTORATstpReqUserLoginField *pUserLogInField, int nRequestID) {
//    printf("ReqUserLogin\r\n");
//    CTORATstpReqUserLoginField req;
//    memset(&req, 0, sizeof(req));
//    strcpy(req.LogInAccount, "00318289");
//    req.LogInAccountType = TORA_TSTP_LACT_UserID;
//    strcpy(req.Password, "34263091");
//    req.AuthMode = TORA_TSTP_AM_Password; //
//    int reqId = 0;
//    return m_pApi->ReqUserLogin(&req, reqId);
//}
//
//int TraderApi::ReqUserLogout(CTORATstpUserLogoutField *pUserLogoutField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqUserPasswordUpdate(CTORATstpUserPasswordUpdateField *pUserPasswordUpdateField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInputDeviceSerial(CTORATstpReqInputDeviceSerialField *pReqInputDeviceSerialField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqOrderInsert(CTORATstpInputOrderField *pInputOrderField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqOrderAction(CTORATstpInputOrderActionField *pInputOrderActionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInputNodeFundAssignment(CTORATstpInputNodeFundAssignmentField *pInputNodeFundAssignmentField,
//                                          int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryNodeFundAssignment(CTORATstpReqInquiryNodeFundAssignmentField *pReqInquiryNodeFundAssignmentField,
//                                            int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryJZFund(CTORATstpReqInquiryJZFundField *pReqInquiryJZFundField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqTransferCollateral(CTORATstpInputTransferCollateralField *pInputTransferCollateralField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryBankAccountFund(CTORATstpReqInquiryBankAccountFundField *pReqInquiryBankAccountFundField,
//                                         int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqModifyOpenPosCost(CTORATstpReqModifyOpenPosCostField *pReqModifyOpenPosCostField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryTradeConcentration(CTORATstpInquiryTradeConcentrationField *pInquiryTradeConcentrationField,
//                                            int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryMaxOrderVolume(CTORATstpReqInquiryMaxOrderVolumeField *pReqInquiryMaxOrderVolumeField,
//                                        int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryHistoryOrder(CTORATstpQryHistoryOrderField *pQryHistoryOrderField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryHistoryTrade(CTORATstpQryHistoryTradeField *pQryHistoryTradeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInputRemarkEvent(CTORATstpInputRemarkEventField *pInputRemarkEventField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqUpdateRemarkEvent(CTORATstpUpdateRemarkEventField *pUpdateRemarkEventField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqDeleteRemarkEvent(CTORATstpDeleteRemarkEventField *pDeleteRemarkEventField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqInquiryHistoryRemarkEvent(CTORATstpQryRemarkEventField *pQryRemarkEventField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryExchange(CTORATstpQryExchangeField *pQryExchangeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryMarketData(CTORATstpQryMarketDataField *pQryMarketDataField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQrySecurity(CTORATstpQrySecurityField *pQrySecurityField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryETFFile(CTORATstpQryETFFileField *pQryETFFileField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryETFBasket(CTORATstpQryETFBasketField *pQryETFBasketField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryIPOInfo(CTORATstpQryIPOInfoField *pQryIPOInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryBUProxy(CTORATstpQryBUProxyField *pQryBUProxyField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryUser(CTORATstpQryUserField *pQryUserField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryInvestor(CTORATstpQryInvestorField *pQryInvestorField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryShareholderAccount(CTORATstpQryShareholderAccountField *pQryShareholderAccountField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryOrder(CTORATstpQryOrderField *pQryOrderField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryOrderAction(CTORATstpQryOrderActionField *pQryOrderActionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryTrade(CTORATstpQryTradeField *pQryTradeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryTradingAccount(CTORATstpQryTradingAccountField *pQryTradingAccountField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPosition(CTORATstpQryPositionField *pQryPositionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryTradingFee(CTORATstpQryTradingFeeField *pQryTradingFeeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryInvestorTradingFee(CTORATstpQryInvestorTradingFeeField *pQryInvestorTradingFeeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryIPOQuota(CTORATstpQryIPOQuotaField *pQryIPOQuotaField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryMarket(CTORATstpQryMarketField *pQryMarketField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryOrderFundDetail(CTORATstpQryOrderFundDetailField *pQryOrderFundDetailField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryFundTransferDetail(CTORATstpQryFundTransferDetailField *pQryFundTransferDetailField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPositionTransferDetail(CTORATstpQryPositionTransferDetailField *pQryPositionTransferDetailField,
//                                            int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPledgePosition(CTORATstpQryPledgePositionField *pQryPledgePositionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPledgeInfo(CTORATstpQryPledgeInfoField *pQryPledgeInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryConversionBondInfo(CTORATstpQryConversionBondInfoField *pQryConversionBondInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryBondPutbackInfo(CTORATstpQryBondPutbackInfoField *pQryBondPutbackInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryStandardBondPosition(CTORATstpQryStandardBondPositionField *pQryStandardBondPositionField,
//                                          int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPrematurityRepoOrder(CTORATstpQryPrematurityRepoOrderField *pQryPrematurityRepoOrderField,
//                                          int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryShareholderParam(CTORATstpQryShareholderParamField *pQryShareholderParamField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPeripheryPositionTransferDetail(
//        CTORATstpQryPeripheryPositionTransferDetailField *pQryPeripheryPositionTransferDetailField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryInvestorCondOrderLimitParam(
//        CTORATstpQryInvestorCondOrderLimitParamField *pQryInvestorCondOrderLimitParamField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryCondOrder(CTORATstpQryCondOrderField *pQryCondOrderField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryCondOrderAction(CTORATstpQryCondOrderActionField *pQryCondOrderActionField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryTradingNotice(CTORATstpQryTradingNoticeField *pQryTradingNoticeField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryIPONumberResult(CTORATstpQryIPONumberResultField *pQryIPONumberResultField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryIPOMatchNumberResult(CTORATstpQryIPOMatchNumberResultField *pQryIPOMatchNumberResultField,
//                                          int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQrySZSEImcParams(CTORATstpQrySZSEImcParamsField *pQrySZSEImcParamsField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQrySZSEImcExchangeRate(CTORATstpQrySZSEImcExchangeRateField *pQrySZSEImcExchangeRateField,
//                                         int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQrySZSEHKPriceTickInfo(CTORATstpQrySZSEHKPriceTickInfoField *pQrySZSEHKPriceTickInfoField,
//                                         int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryShareholderSpecPrivilege(CTORATstpQryShareholderSpecPrivilegeField *pQryShareholderSpecPrivilegeField,
//                                              int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryInvestorPositionLimit(CTORATstpQryInvestorPositionLimitField *pQryInvestorPositionLimitField,
//                                           int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPHMarketData(CTORATstpQryPHMarketDataField *pQryPHMarketDataField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryRationalInfo(CTORATstpQryRationalInfoField *pQryRationalInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryPeripheryFundTransferDetail(
//        CTORATstpQryPeripheryFundTransferDetailField *pQryPeripheryFundTransferDetailField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQrySystemNodeInfo(CTORATstpQrySystemNodeInfoField *pQrySystemNodeInfoField, int nRequestID) {
//    return 0;
//}
//
//int TraderApi::ReqQryLofFundInfo(CTORATstpQryLofFundInfoField *pQryLofFundInfoField, int nRequestID) {
//    return 0;
//}
//
