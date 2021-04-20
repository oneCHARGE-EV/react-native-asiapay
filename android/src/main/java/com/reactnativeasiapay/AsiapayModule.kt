package com.reactnativeasiapay

import android.util.Log
import com.asiapay.sdk.PaySDK
import com.asiapay.sdk.integration.*
import com.facebook.react.bridge.*

class AsiapayModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  private val currencyMap: HashMap<String, EnvBase.Currency> = HashMap<String, EnvBase.Currency>()

  private var paySDK: PaySDK = PaySDK(reactContext)
  private var payData: PayData = PayData()

  init {
    setCurrencyHashMap()
  }

  override fun getName(): String {
    return "Asiapay"
  }

  @ReactMethod
  fun sampleMethod(stringArgument: String, numberArgument: Int, callback: Callback) {
    // TODO: Implement some actually useful functionality
    callback.invoke("Received numberArgument: $numberArgument stringArgument: $stringArgument")
  }

  // Only Alipay , wechat pay and octupus

  // Only Alipay , wechat pay and octupus
  @ReactMethod
  fun setup(envType: String) {
    val receivedEnvType: String = envType.toUpperCase()
    if (envType.equals("PRODUCTION")) {
      payData.setEnvType(EnvBase.EnvType.PRODUCTION)
    } else {
      payData.setEnvType(EnvBase.EnvType.SANDBOX)
    }
  }

  @ReactMethod
  fun aliPay(amount: String?, currency: String, orderRef: String?, merchantId: String?, remark: String?) {
    val receivedString: String = currency.toUpperCase()
    val selectedCurrency: EnvBase.Currency = currencyMap[receivedString] ?: throw error("No such currency")
    payData = PayData()
    payData.setChannel(EnvBase.PayChannel.DIRECT)
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(selectedCurrency)
    payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.setAmount(amount)
    payData.setPayMethod("ALIPAYAPP")
    payData.setMerchantId(merchantId)
    payData.setOrderRef(orderRef)
    payData.setRemark("test remark")
    payData.setActivity(getCurrentActivity())
    paySDK.setRequestData(payData)
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        Log.d("TAG", "payResult: " + payResult.getSuccessMsg())
      }

      override fun onError(data: Data) {
        Log.d("TAG", "error returned : " + data.getError())
      }
    })
    /*
         payData.setChannel(EnvBase.PayChannel.DIRECT);
        payData.setAmount(amount);
        payData.setPayGate(EnvBase.PayGate.PAYDOLLAR);
        payData.setCurrCode(selectedCurrency);
        payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT);
        payData.setOrderRef(orderRef);
        //payData.setPayMethod(paymentMethod);
        payData.setPayMethod("ALIPAYHKAPP"); // FOR ALIPAY HK

        payData.setLang(EnvBase.Language.ENGLISH);
        payData.setMerchantId(merchantId);
        payData.setRemark(remark);
        payData.setActivity(getCurrentActivity());
        paySDK.setRequestData(payData);

        paySDK.process();
        paySDK.responseHandler(new PaymentResponse() {
            @Override
            public void getResponse(PayResult payResult) {
                Log.d("TAG","payResult: "+payResult.getSuccessMsg());
            }

            @Override
            public void onError(Data data) {
                Log.d("TAG","error returned : "+ data.getError());
            }
        });*/
  }


  @ReactMethod
  fun wechat(amount: String?, orderRef: String?, payMethod: String?, merchantId: String?, remark: String?) {
    // Toast.makeText(this, "okay", Toast.LENGTH_SHORT).show();
    val paySDK = PaySDK(reactContext)
    val payData = PayData()
    payData.setChannel(EnvBase.PayChannel.DIRECT)
    payData.setAmount(amount)
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.HKD)
    payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT)
    payData.setActivity(getCurrentActivity())
    payData.setOrderRef(orderRef)
    payData.setPayMethod(payMethod)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.setMerchantId(merchantId)
    payData.setRemark(remark)
    paySDK.setRequestData(payData)
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult?) {
        //payment Result
      }

      override fun onError(data: Data?) {
        //errror
      }
    })
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
  private fun setCurrencyHashMap() {
    currencyMap.put("HKD", EnvBase.Currency.HKD)
    currencyMap.put("GBP", EnvBase.Currency.GBP)
    currencyMap.put("EUR", EnvBase.Currency.EUR)
    currencyMap.put("USD", EnvBase.Currency.USD)
    currencyMap.put("AUD", EnvBase.Currency.AUD)
    currencyMap.put("CAD", EnvBase.Currency.CAD)
    currencyMap.put("SGD", EnvBase.Currency.SGD)
    currencyMap.put("JPY", EnvBase.Currency.JPY)
  }

/*        currencyMap.put("RMB", EnvBase.Currency.RMB);
        currencyMap.put("YEN", EnvBase.Currency.YEN);
        currencyMap.put("TWD", EnvBase.Currency.TWD);
        currencyMap.put("MOP", EnvBase.Currency.MOP);
        currencyMap.put("PHP", EnvBase.Currency.PHP);
        currencyMap.put("THB", EnvBase.Currency.THB);
        currencyMap.put("MYR", EnvBase.Currency.MYR);
        currencyMap.put("IDR", EnvBase.Currency.IDR);
        currencyMap.put("KRW", EnvBase.Currency.KRW);
        currencyMap.put("BND", EnvBase.Currency.BND);
        currencyMap.put("NZD", EnvBase.Currency.BND);
        currencyMap.put("SAR", EnvBase.Currency.SAR);
        currencyMap.put("AED", EnvBase.Currency.AED);
        currencyMap.put("BRL", EnvBase.Currency.BRL);
        currencyMap.put("INR", EnvBase.Currency.INR);
        currencyMap.put("TRY", EnvBase.Currency.TRY);
        currencyMap.put("ZAR", EnvBase.Currency.ZAR);
        currencyMap.put("VND", EnvBase.Currency.VND);
        currencyMap.put("DKK", EnvBase.Currency.DKK);
        currencyMap.put("ILS", EnvBase.Currency.ILS);
        currencyMap.put("NOK", EnvBase.Currency.NOK);
        currencyMap.put("RUB", EnvBase.Currency.RUB);
        currencyMap.put("SEK", EnvBase.Currency.SEK);
        currencyMap.put("CHF", EnvBase.Currency.CHF);
        currencyMap.put("ARS", EnvBase.Currency.ARS);
        currencyMap.put("CLP", EnvBase.Currency.CLP);
        currencyMap.put("COP", EnvBase.Currency.COP);
        currencyMap.put("CZK", EnvBase.Currency.CZK);
        currencyMap.put("EGP", EnvBase.Currency.EGP);
        currencyMap.put("HUF", EnvBase.Currency.HUF);
        currencyMap.put("KZT", EnvBase.Currency.KZT);
        currencyMap.put("LBP", EnvBase.Currency.LBP);
        currencyMap.put("MXN", EnvBase.Currency.MXN);
        currencyMap.put("NGN", EnvBase.Currency.NGN);
        currencyMap.put("PKR", EnvBase.Currency.PKR);
        currencyMap.put("PEN", EnvBase.Currency.PEN);
        currencyMap.put("PLN", EnvBase.Currency.PLN);
        currencyMap.put("QAR", EnvBase.Currency.QAR);
        currencyMap.put("RON", EnvBase.Currency.RON);
        currencyMap.put("UAH", EnvBase.Currency.UAH);
        currencyMap.put("VEF", EnvBase.Currency.VEF);
        currencyMap.put("LKR", EnvBase.Currency.LKR);
        currencyMap.put("LKR", EnvBase.Currency.LKR);
        currencyMap.put("KWD", EnvBase.Currency.KWD);*/


}

