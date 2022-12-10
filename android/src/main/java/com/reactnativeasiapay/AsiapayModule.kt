package com.reactnativeasiapay

import com.asiapay.sdk.PaySDK
import com.asiapay.sdk.integration.*
import com.facebook.react.bridge.*

class AsiapayModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
  private var paySDK: PaySDK = PaySDK(reactContext)
  private var merchantId: String? = null
  private var environment: EnvBase.EnvType = EnvBase.EnvType.SANDBOX

  override fun getName(): String {
    return "Asiapay"
  }

  // Only Alipay , wechat pay and octupus
  @ReactMethod
  fun setup(envType: String, mId: String) {
    val receivedEnvType: String = envType.toUpperCase()
    merchantId = mId
    if (envType == "Production") {
      environment = EnvBase.EnvType.PRODUCTION
    }
  }

  @ReactMethod
  fun alipay(amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(EnvBase.PayChannel.DIRECT,"ALIPAYHKAPP", amount, currency, orderRef, remark, promise, null)
  }


  @ReactMethod
  fun wechat(amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(EnvBase.PayChannel.DIRECT,"WECHAT", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun octopus(amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(EnvBase.PayChannel.DIRECT,"OCTOPUS", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun creditCard(amount: String, currency: String, method: String, orderRef: String, remark: String, cardDetails: ReadableMap?, extraData: ReadableMap, payType: String, promise: Promise) {
    var card = null
    if (cardDetails != null) {
      val cd = cardDetails.toHashMap()
      card = CardDetails()
      card.cardNo = cd["cardNo"] as String
      card.epMonth = cd["month"] as String
      card.epYear = cd["year"] as String
      card.securityCode = cd["cvc"] as String
      card.cardHolder = cd["cardHolder"] as String
    }

    makePayment(EnvBase.PayChannel.DIRECT, method, amount, currency, orderRef, remark, promise, card, payType, toHashMapString(extraData))
  }


  @ReactMethod
  fun webView(amount: String?, currency: String, method: String, orderRef: String, remark: String, extraData: ReadableMap, payType: String, showCloseButton: Boolean, showToolbar: Boolean, closePrompt: String, promise: Promise) {
    makePayment(EnvBase.PayChannel.WEBVIEW, method, amount, currency, orderRef, remark, promise, null, payType, toHashMapString(extraData))
  }

  private fun makePayment(channel: EnvBase.PayChannel, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = channel
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity
    payData.extraData = extraData

    if (cardDetails != null) {
      payData.cardDetails = cardDetails
    }

    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        if (payResult.successCode == "0") {
          val map: WritableMap = WritableNativeMap()
          map.putString("prc", payResult.prc)
          map.putString("ord", payResult.ord)
          map.putString("cur", payResult.cur)
          map.putString("authId", payResult.authId)
          map.putString("ref", payResult.ref)
          map.putString("src", payResult.src)
          map.putString("holder", payResult.holder)
          map.putString("txTime", payResult.txTime)
          map.putString("errMsg", payResult.errMsg)
          map.putString("payRef", payResult.payRef)
          map.putString("amount", payResult.amt)
          map.putString("successCode", payResult.successCode)
          map.putString("maskedCardNo", payResult.maskedCardNo)
          map.putString("payMethod", payResult.payMethod)
          map.putBoolean("isSuccess", payResult.isSuccess)
          promise.resolve(map)
        } else {
          promise.reject("${payResult.prc}:${payResult.src}", payResult.errMsg)
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })
  }

  fun toHashMap(map: ReadableMap?): HashMap<String, Any?>? {
    val hashMap: HashMap<String, Any?> = HashMap()
    val iterator = map!!.keySetIterator()
    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      when (map.getType(key)) {
        ReadableType.Null -> hashMap[key] = null
        ReadableType.Boolean -> hashMap[key] = map.getBoolean(key).toString()
        ReadableType.Number -> hashMap[key] = map.getDouble(key)
        ReadableType.String -> hashMap[key] = map.getString(key)
        ReadableType.Map -> hashMap[key] = toHashMap(map.getMap(key))
        ReadableType.Array -> hashMap[key] = toArrayList(map.getArray(key))
        else -> throw IllegalArgumentException("Could not convert object with key: $key.")
      }
    }
    return hashMap
  }

  fun toHashMapString(map: ReadableMap?): HashMap<String, String> {
    val hashMap: HashMap<String, String> = HashMap()
    val iterator = map!!.keySetIterator()
    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      when (map.getType(key)) {
        ReadableType.Null -> hashMap[key] = ""
        ReadableType.Boolean -> hashMap[key] = map.getBoolean(key).toString()
        ReadableType.Number -> hashMap[key] = map.getDouble(key).toString()
        ReadableType.String -> hashMap[key] = map.getString(key)!!
        else -> throw IllegalArgumentException("Could not convert object with key: $key.")
      }
    }
    return hashMap
  }

  fun toArrayList(array: ReadableArray?): ArrayList<Any?>? {
    val arrayList: ArrayList<Any?> = ArrayList(array!!.size())
    var i = 0
    val size = array!!.size()
    while (i < size) {
      when (array.getType(i)) {
        ReadableType.Null -> arrayList.add(null)
        ReadableType.Boolean -> arrayList.add(array.getBoolean(i))
        ReadableType.Number -> arrayList.add(array.getDouble(i))
        ReadableType.String -> arrayList.add(array.getString(i))
        ReadableType.Map -> arrayList.add(toHashMap(array.getMap(i)))
        ReadableType.Array -> arrayList.add(toArrayList(array.getArray(i)))
        else -> throw java.lang.IllegalArgumentException("Could not convert object at index: $i.")
      }
      i++
    }
    return arrayList
  }
  /*   @ReactMethod
    public void octupus(String amount, String merchantId, String orderRef, String remark) {
        PayData payData = new PayData();
        payData = new PayData();
        payData.setChannel(EnvBase.PayChannel.DIRECT);
        payData.setPayGate(EnvBase.PayGate.PAYDOLLAR);
        payData.setCurrCode(EnvBase.Currency.HKD);
        payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT);
        payData.setLang(EnvBase.Language.ENGLISH);
        payData.setAmount(textAmount.getEditText().getText().toString());
        payData.setPayMethod("OCTOPUS");
        payData.setMerchantId(textMerchantId.getEditText().getText().toString());
        payData.setOrderRef(getOrderRef());
        payData.setRemark("test remark");
        payData.setActivity(reactContext);

        paySDK.setRequestData(payData);
        paySDK.process();

        paySDK.responseHandler(new PaymentResponse() {
            @Override
            public void getResponse(PayResult payResult) {

                cancelProgressDialog();

                try {

                    // method to get the URI
                    String octopusuri = paySDK.decodeData(payResult.getErrMsg());

                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri
                            .parse(octopusuri));
                    startActivityForResult(intent, OCTOPUS_APP_REQUEST_CODE);

                }catch (Exception e){

                    Log.d(TAG, "octopus: exp "+e.getMessage());
                }

            }

            @Override
            public void onError(Data data) {

                cancelProgressDialog();
                //showAlert(data.getMessage()+data.getError());
            }
        });
    }*/

  /*   @ReactMethod
    public void octupus(String amount, String merchantId, String orderRef, String remark) {
        PayData payData = new PayData();
        payData = new PayData();
        payData.setChannel(EnvBase.PayChannel.DIRECT);
        payData.setPayGate(EnvBase.PayGate.PAYDOLLAR);
        payData.setCurrCode(EnvBase.Currency.HKD);
        payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT);
        payData.setLang(EnvBase.Language.ENGLISH);
        payData.setAmount(textAmount.getEditText().getText().toString());
        payData.setPayMethod("OCTOPUS");
        payData.setMerchantId(textMerchantId.getEditText().getText().toString());
        payData.setOrderRef(getOrderRef());
        payData.setRemark("test remark");
        payData.setActivity(reactContext);

        paySDK.setRequestData(payData);
        paySDK.process();

        paySDK.responseHandler(new PaymentResponse() {
            @Override
            public void getResponse(PayResult payResult) {

                cancelProgressDialog();

                try {

                    // method to get the URI
                    String octopusuri = paySDK.decodeData(payResult.getErrMsg());

                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri
                            .parse(octopusuri));
                    startActivityForResult(intent, OCTOPUS_APP_REQUEST_CODE);

                }catch (Exception e){

                    Log.d(TAG, "octopus: exp "+e.getMessage());
                }

            }

            @Override
            public void onError(Data data) {

                cancelProgressDialog();
                //showAlert(data.getMessage()+data.getError());
            }
        });
    }*/

}

