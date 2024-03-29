//import Material
 import AP_PaySDK

@objc(Asiapay)
class Asiapay: NSObject, PaySDKDelegate {
    var environment: EnvType = EnvType.SANDBOX
    var merchantId: String = ""
    var paySDK = PaySDK.shared
    var currentResolve: RCTPromiseResolveBlock?
    var currentReject: RCTPromiseRejectBlock?

    @objc(setup:withMId:)
    func setup(environment: String, mId: String) -> Void {
        if (environment == "Production") {
            self.environment = EnvType.PRODUCTION
        }
        self.merchantId = mId
        self.paySDK.delegate = self
        print("init paysdk \(environment) \(self.merchantId)")
    }

    @objc(alipay:withCurrency:withOrderRef:withRemark:withResolve:withReject:)
    func alipay(amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        makePayment(method: "ALIPAYHKAPP", amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

    @objc(octopus:withOrderRef:withRemark:withResolve:withReject:)
    func octopus(amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        makePayment(method: "OCTOPUS", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

    func makePayment(method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        print("Pay \(method), order ref \(orderRef)")
        self.currentResolve = resolve
        self.currentReject = reject
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: self.environment,
                                        amount: amount,
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: getCurrencyCode(currencyCode: currency),
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: orderRef,
                                        payMethod: method,
                                        lang: Language.ENGLISH,
                                        merchantId: self.merchantId,
                                        remark: remark,
                                        payRef: "",
                                        resultpage: "F", showCloseButton: true,
                                        extraData: ["":""])
        paySDK.process()
    }

    func getCurrencyCode(currencyCode: String) -> CurrencyCode {
        let payCurrencyCode: CurrencyCode;

        switch currencyCode {
        case "HKD":
            payCurrencyCode = CurrencyCode.HKD
        case "USD":
            payCurrencyCode = CurrencyCode.USD
        case "SGD":
            payCurrencyCode = CurrencyCode.SGD
        case "RMB":
            payCurrencyCode = CurrencyCode.RMB
        case "CNY":
            payCurrencyCode = CurrencyCode.CNY
        case "YEN":
            payCurrencyCode = CurrencyCode.YEN
        case "JPY":
            payCurrencyCode = CurrencyCode.JPY
        case "TWD":
            payCurrencyCode = CurrencyCode.TWD
        case "AUD":
            payCurrencyCode = CurrencyCode.AUD
        case "EUR":
            payCurrencyCode = CurrencyCode.EUR
        case "GBP":
            payCurrencyCode = CurrencyCode.GBP
        case "CAD":
            payCurrencyCode = CurrencyCode.CAD
        case "MOP":
            payCurrencyCode = CurrencyCode.MOP
        case "PHP":
            payCurrencyCode = CurrencyCode.PHP
        case "THB":
            payCurrencyCode = CurrencyCode.THB
        case "IDR":
            payCurrencyCode = CurrencyCode.IDR
        case "BND":
            payCurrencyCode = CurrencyCode.BND
        case "MYR":
            payCurrencyCode = CurrencyCode.MYR
        case "BRL":
            payCurrencyCode = CurrencyCode.BRL
        case "INR":
            payCurrencyCode = CurrencyCode.INR
        case "TRY":
            payCurrencyCode = CurrencyCode.TRY
        case "ZAR":
            payCurrencyCode = CurrencyCode.ZAR
        case "VND":
            payCurrencyCode = CurrencyCode.VND
        case "LKR":
            payCurrencyCode = CurrencyCode.LKR
        case "KWD":
            payCurrencyCode = CurrencyCode.KWD
        case "NZD":
            payCurrencyCode = CurrencyCode.NZD
        default:
            payCurrencyCode = CurrencyCode.HKD
        }

        return payCurrencyCode
    }

    func paymentResult(result: PayResult) {
        let dictResult = self.toDict(result: result)
        if (result.successCode != "0" && self.currentReject != nil) {
            self.currentReject!("\(result.prc ?? ""):\(result.src ?? "")", result.errMsg, nil)
        }

        if (result.successCode == "0" && self.currentResolve != nil) {
            self.currentResolve!(dictResult)
        }

        self.currentReject = nil
        self.currentResolve = nil
    }

    func transQueryResults(result: TransQueryResults) {
        print(result)
    }

    func payMethodOptions(method: PaymentOptionsDetail) {
        print(method)
    }

    func showProgress() {
    }

    func hideProgress() {
    }

    func toJson(result: PayResult) -> String {
        let dic = [
            "amount":result.amount,
            "successCode":result.successCode,
            "maskedCardNo":result.maskedCardNo,
            "authId":result.authId,
            "cardHolder":result.cardHolder,
            "currencyCode":result.currencyCode,
            "errMsg":result.errMsg,
            "ord":result.ord,
            "payRef":result.payRef,
            "prc":result.prc,
            "ref":result.ref,
            "src":result.src,
            "transactionTime":result.transactionTime,
            "descriptionStr":result.descriptionStr
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
        return jsonStr
    }

    func toDict(result: PayResult) -> [String: String?] {
        return [
            "amount":result.amount,
            "successCode":result.successCode,
            "maskedCardNo":result.maskedCardNo,
            "authId":result.authId,
            "cardHolder":result.cardHolder,
            "currencyCode":result.currencyCode,
            "errMsg":result.errMsg,
            "ord":result.ord,
            "payRef":result.payRef,
            "prc":result.prc,
            "ref":result.ref,
            "src":result.src,
            "transactionTime":result.transactionTime,
            "descriptionStr":result.descriptionStr
        ]
    }
}
