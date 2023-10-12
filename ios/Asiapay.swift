//import Material
import AP_PaySDK
import PassKit

@objc(Asiapay)
class Asiapay: NSObject, PaySDKDelegate, PKPaymentAuthorizationViewControllerDelegate {
    var environment: EnvType = EnvType.SANDBOX
    var merchantId: String = ""
    var paySDK = PaySDK.shared
    var currentResolve: RCTPromiseResolveBlock?
    var currentReject: RCTPromiseRejectBlock?
    var completion: ((PKPaymentAuthorizationResult) -> Void)? = nil
    var nativePayDetails: [String: Any]? = nil

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

        makePayment(channelType: PayChannel.DIRECT, method: "ALIPAYHKAPP", amount: amount, currency: currency, orderRef: orderRef, remark: remark, closePrompt: "", showCloseButton: true, showToolbar: true, lang: Language.ENGLISH, resolve: resolve, reject: reject)
    }

    @objc(octopus:withOrderRef:withRemark:withResolve:withReject:)
    func octopus(amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        makePayment(channelType: PayChannel.DIRECT, method: "OCTOPUS", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, closePrompt: "", showCloseButton: true, showToolbar: true, lang: Language.ENGLISH, resolve: resolve, reject: reject)
    }

    @objc(creditCard:withCurrency:withMethod:withOrderRef:withRemark:withCardDetails:withExtraData:withPayType:withResolve:withReject:)
    func creditCard(amount: String, currency: String, method: String, orderRef: String, remark: String, cardDetails: [String: String]?, extraData: [String: Any], payType: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        var card: CardDetails? = nil
        if (cardDetails != nil) {
            card = CardDetails(cardHolderName: cardDetails!["cardHolder"]!, cardNo: cardDetails!["cardNo"]!, expMonth: cardDetails!["month"]!, expYear: cardDetails!["year"]!, securityCode: cardDetails!["cvc"]!)
        }

        makePayment(channelType: PayChannel.DIRECT, method: method, amount: amount, currency: currency, orderRef: orderRef, remark: remark, closePrompt: "", showCloseButton: true, showToolbar: true, lang: Language.ENGLISH, resolve: resolve, reject: reject, extraData: extraData, payType: getPayType(payTypeStr: payType), cardDetails: card)
    }

    @objc(webView:withCurrency:withMethod:withOrderRef:withRemark:withExtraData:withPayType:withShowCloseButton:withShowToolbar:withClosePrompt:withResolve:withReject:)
    func webView(amount: String, currency: String, method: String, orderRef: String, remark: String,  extraData: [String: Any], payType: String, showCloseButton: Bool, showToolbar: Bool, closePrompt: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        makePayment(channelType: PayChannel.WEBVIEW, method: method, amount: amount, currency: currency, orderRef: orderRef, remark: remark, closePrompt: closePrompt, showCloseButton: showCloseButton, showToolbar: showToolbar, lang: Language.ENGLISH, resolve: resolve, reject: reject, extraData: extraData, payType: getPayType(payTypeStr: payType))
    }

    @objc(nativePay:withCurrency:withCountryCode:withPriceLabel:withOrderRef:withRemark:withPayType:withNativePayMerchantId:withGooglePayAuth:withResolve:withReject:)
    func nativePay(amount: String, currency: String, countryCode: String, priceLabel: String, orderRef: String, remark: String, payType: String, nativePayMerchantId: String, googlePayAuth: String,resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
      self.currentResolve = resolve
      self.currentReject = reject
      
      self.nativePayDetails = [
            "amount": amount,
            "currCode": getCurrencyCode(currencyCode: currency),
            "payType": getPayType(payTypeStr: payType),
            "orderRef": orderRef,
            "remark": remark
        ]

        if PKPaymentAuthorizationViewController.canMakePayments() {
            let req = PKPaymentRequest()
            req.currencyCode = currency
            req.countryCode = countryCode
            req.merchantIdentifier = nativePayMerchantId
            req.merchantCapabilities = PKMerchantCapability.capability3DS
            req.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
            req.paymentSummaryItems = [PKPaymentSummaryItem(label: priceLabel, amount: NSDecimalNumber(string: amount))]
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: req) else {
                reject("cannot start apple pay", nil, nil)
                return
            }
            paymentVC.delegate = self
            let viewController = RCTPresentedViewController()
            if (viewController != nil) {
                DispatchQueue.main.async {
                    viewController!.present(paymentVC, animated: true, completion: nil)
                }
            } else {
                reject("something went wrong", nil, nil)
            }
        } else {
            reject("noNativePay", nil, nil)
        }
    }

    func makePayment(channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, closePrompt: String, showCloseButton: Bool, showToolbar: Bool, lang: Language, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT, cardDetails: CardDetails? = nil) -> Void {
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
                                        lang: lang,
                                        merchantId: self.merchantId,
                                        remark: remark,
                                        payRef: "",
                                        resultpage: "F",
                                        showCloseButton: showCloseButton,
                                        showToolbar: showToolbar,
                                        webViewClosePrompt: closePrompt,
                                        extraData: extraData)
        if let unwrappedCard = cardDetails {
            paySDK.paymentDetails.cardDetails = unwrappedCard
        }

        paySDK.process()
    }

    func getPayChannel(channelType: String) -> PayChannel {
        var payChannel: PayChannel = PayChannel.DIRECT
        switch channelType {
        case "webview":
            payChannel = PayChannel.WEBVIEW
        case "direct":
            payChannel = PayChannel.DIRECT
        case "easypaymentfrom":
            payChannel = PayChannel.EASYPAYMENTFORM
        case "none":
            payChannel = PayChannel.NONE
        default:
            payChannel = PayChannel.DIRECT
        }
        return payChannel
    }

    func getLanguage(lang: String) -> Language {
        var language: Language = Language.ENGLISH
        switch lang {
        case "en":
            language = Language.ENGLISH
        case "zh_tw":
            language = Language.CHINESE_TRADITIONAL
        case "zh_cn":
            language = Language.CHINESE_SIMPLIFIED
        case "ja":
            language = Language.JAPANESE
        case "th":
            language = Language.THAI
        case "fr":
            language = Language.FRENCH
        case "de":
            language = Language.GERMAN
        case "ru":
            language = Language.RUSSIAN
        case "es":
            language = Language.SPANISH
        case "vi":
            language = Language.VIETNAMESE
        default:
            language = Language.ENGLISH
        }
        return language
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
        let dictResult = self.toDict(result: result)
        if (result.successCode != "0" && self.completion != nil) {
            self.completion!(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
        if (result.successCode == "0" && self.completion != nil) {
            self.completion!(PKPaymentAuthorizationResult(status: .success, errors: nil))
        }

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

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.completion = completion
        do {
            let paymentDataDic = try JSONSerialization.jsonObject(with: payment.token.paymentData, options:[]) as! [String : Any]
            let paymentDataJson = ["token": ["paymentData":paymentDataDic,
                                             "transactionIdentifier":payment.token.transactionIdentifier,
                                             "paymentMethod" : [
                                             "displayName":payment.token.paymentMethod.displayName,
                                             "network":payment.token.paymentMethod.network?.rawValue,
                                             "type":"\(payment.token.paymentMethod.type.rawValue)"]]] as [String : Any]

            let b64TokenStr = try! JSONSerialization.data(withJSONObject: paymentDataJson, options: []).base64EncodedString()
            if (b64TokenStr == "" && self.currentReject != nil) {
                self.currentReject!("failed authorize", nil, nil)
                return
            }

            if (self.nativePayDetails != nil) {
                self.paySDK.paymentDetails = PayData(channelType: PayChannel.DIRECT,
                                                     envType: self.environment,
                                                     amount: self.nativePayDetails!["amount"] as! String,
                                                     payGate: PayGate.PAYDOLLAR,
                                                     currCode: self.nativePayDetails!["currCode"] as! CurrencyCode,
                                                     payType: self.nativePayDetails!["payType"] as! payType,
                                                     orderRef: self.nativePayDetails!["orderRef"] as! String,
                                                     payMethod: "ALL",
                                                     lang: Language.ENGLISH,
                                                     merchantId: self.merchantId,
                                                     remark: self.nativePayDetails!["remark"] as! String,
                                                     payRef: "",
                                                     resultpage: "F",
                                                     showCloseButton: false,
                                                     showToolbar: false,
                                                     webViewClosePrompt: "",
                                                     extraData: [
                                                        "eWalletPaymentData" : b64TokenStr,
                                                        "eWalletService": "T",
                                                        "eWalletBrand": "APPLEPAY"
                                                     ])

                self.paySDK.process()
            }
       } catch _ {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            if let currentReject = self.currentReject {
                currentReject("failed authorize", nil, nil)
            }
       }
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        let viewController = RCTPresentedViewController()
        viewController?.dismiss(animated: true)
    }
}
