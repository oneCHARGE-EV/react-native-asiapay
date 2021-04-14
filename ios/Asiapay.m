#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Asiapay, NSObject)

RCT_EXTERN_METHOD(setup: (NSString) environment)
RCT_EXTERN_METHOD(alipay: (float)amount
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark)
RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
