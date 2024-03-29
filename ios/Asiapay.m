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
RCT_EXTERN_METHOD(nativePay: (NSString)amount
                  withCurrency: (NSString)currency
                  withCountryCode: (NSString)countryCode
                  withPriceLabel: (NSString)priceLabel
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withPayType: (NSString)payType
                  withNativePayMerchantId: (NSString)nativePayMerchantId
                  withGooglePayAuth: (NSString)googlePayAuth
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
@end
