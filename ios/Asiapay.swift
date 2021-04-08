//import Material
 import AP_PaySDK

@objc(Asiapay)
class Asiapay: NSObject {
//    func paymentResult(result: PayResult) {
//        print(result)
//    }
//
//    func transQueryResults(result: TransQueryResults) {
//        print(result)
//    }
//
//    func payMethodOptions(method: PaymentOptionsDetail) {
//        print(method)
//    }

    var environment: String = ""
     var paySDK = PaySDK.shared

    @objc(init:)
    func setup(environment: String) -> Void {
        self.environment = environment
//        self.paySDK.delegate = self
        print("init paysdk")
    }

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        resolve(a*b)
    }

    @objc(alipay:withCurrency:withOrderRef:withRemark:)
    func alipay(amount: Int, currency: String, orderRef: String, remark: String) -> Void {
        print(amount)
    }


}
