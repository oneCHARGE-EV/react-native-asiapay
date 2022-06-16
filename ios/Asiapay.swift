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

        makePayment(channelType: PayChannel.DIRECT, method: "ALIPAYHKAPP", amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

    @objc(octopus:withOrderRef:withRemark:withResolve:withReject:)
    func octopus(amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        makePayment(channelType: PayChannel.DIRECT, method: "OCTOPUS", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

    @objc(creditCard:withCurrency:withMethod:withOrderRef:withRemark:withCardDetails:withExtraData:withPayType:withResolve:withReject:)
    func creditCard(amount: String, currency: String, method: String, orderRef: String, remark: String, cardDetails: [String: String]?, extraData: [String: Any], payType: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        var card: CardDetails? = nil
        if (cardDetails != nil) {
            card = CardDetails(cardHolderName: cardDetails!["cardHolder"]!, cardNo: cardDetails!["cardNo"]!, expMonth: cardDetails!["month"]!, expYear: cardDetails!["year"]!, securityCode: cardDetails!["cvc"]!)
        }

        makePayment(channelType: PayChannel.DIRECT, method: method, amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject, extraData: extraData, payType: getPayType(payTypeStr: payType), cardDetails: card)
    }
    
    @objc(webView:withCurrency:withMethod:withOrderRef:withRemark:withExtraData:withPayType:withShowCloseButton:withShowToolbar:withClosePrompt:withResolve:withReject:)
    func webView(amount: String, currency: String, method: String, orderRef: String, remark: String,  extraData: [String: Any], payType: String, showCloseButton: Bool, showToolbar: Bool, closePrompt: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        makePayment(channelType: PayChannel.WEBVIEW, method: method, amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject, extraData: extraData, payType: getPayType(payTypeStr: payType))
    }

    func makePayment(channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT, cardDetails: CardDetails? = nil) -> Void {
        print("Pay \(method), order ref \(orderRef)")
        self.currentResolve = resolve
        self.currentReject = reject

        paySDK.paymentDetails = PayData(channelType: channelType,
                                        envType: self.environment,
                                        amount: amount,
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: getCurrencyCode(currencyCode: currency),
                                        payType: payType,
                                        orderRef: orderRef,
                                        payMethod: method,
                                        lang: Language.ENGLISH,
                                        merchantId: self.merchantId,
                                        remark: remark,
                                        payRef: "",
                                        resultpage: "F", showCloseButton: true,
                                        extraData: extraData)
        if let unwrappedCard = cardDetails {
            paySDK.paymentDetails.cardDetails = unwrappedCard
        }

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

    func getPayType(payTypeStr: String) -> payType {
        if (payTypeStr == "N") {
            return payType.NORMAL_PAYMENT
        }
        return payType.HOLD_PAYMENT
    }

    func paymentResult(result: PayResult) {
        print(result)
        let dictResult = self.toDict(result: result)
        print(dictResult)
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
