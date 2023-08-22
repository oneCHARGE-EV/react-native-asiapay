#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Asiapay, NSObject)

RCT_EXTERN_METHOD(setup: (NSString) environment withMId: (NSString) mId)
RCT_EXTERN_METHOD(alipay: (NSString)amount
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(octopus: (NSString)amount
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(creditCard: (NSString)amount
                  withCurrency: (NSString)currency
                  withMethod: (NSString)method
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withCardDetails: (NSDictionary)cardDetails
                  withExtraData: (NSDictionary)extraData
                  withPayType: (NSString)payType
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(webView: (NSString)amount
                  withCurrency: (NSString)currency
                  withMethod: (NSString)method
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withExtraData: (NSDictionary)extraData
                  withPayType: (NSString)payType
                  withShowCloseButton: (BOOL)showCloseButton
                  withShowToolbar: (BOOL)showToolbar
                  withClosePrompt: (BOOL)webViewClosePrompt
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(payment: (NSString)amount
                  withChannelType: (NSString)channelType
                  withPayGate: (NSString)payGate
                  withCurrency: (NSString)currency
                  withMethod: (NSString)method
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withMId: (NSString)mId
                  withPayType: (NSString)payType
                  withPayRef: (NSString)payRef
                  withResultPage: (NSString)resultPage
                  withLang: (NSString)lang
                  withShowCloseButton: (BOOL)showCloseButton
                  withShowToolbar: (BOOL)showToolbar
                  withClosePrompt: (BOOL)webViewClosePrompt
                  withExtraData: (NSDictionary)extraData
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
@end
