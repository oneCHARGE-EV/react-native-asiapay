//import Material
 import AP_PaySDK

@objc(Asiapay)
class Asiapay: NSObject, PaySDKDelegate {
    func paymentResult(result: PayResult) {
        print(result.successCode!)
        print(result.errMsg!)
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

    var environment: EnvType = EnvType.SANDBOX
    var merchantId: String = ""
    var paySDK = PaySDK.shared

    @objc(setup:withMId:)
    func setup(environment: String, mId: String) -> Void {
        if (environment == "Production") {
            self.environment = EnvType.PRODUCTION
        }
        self.merchantId = mId
        self.paySDK.delegate = self
        print("init paysdk \(environment) \(self.merchantId)")
    }

    @objc(alipay:withCurrency:withOrderRef:withRemark:)
    func alipay(amount: String, currency: String, orderRef: String, remark: String) -> Void {
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: self.environment,
                                        amount: amount,
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: getCurrencyCode(currencyCode: currency),
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: orderRef,
                                        payMethod: "ALIPAYHKAPP",
                                        lang: Language.ENGLISH,
                                        merchantId: self.merchantId,
                                        remark: remark,
                                        payRef: "",
                                        resultpage: "F",
                                        extraData: ["":""])
        paySDK.process()
    }

    @objc(octopus:withOrderRef:withRemark:)
    func octopus(amount: String, orderRef: String, remark: String) -> Void {
        paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                        envType: self.environment,
                                        amount: amount,
                                        payGate: PayGate.PAYDOLLAR,
                                        currCode: CurrencyCode.HKD,
                                        payType: payType.NORMAL_PAYMENT,
                                        orderRef: orderRef,
                                        payMethod: "OCTOPUS",
                                        lang: Language.ENGLISH,
                                        merchantId: self.merchantId,
                                        remark: remark,
                                        payRef: "",
                                        resultpage: "F",
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

}
