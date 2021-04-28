package com.reactnativeasiapay

import android.util.Log
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
    if (envType == "PRODUCTION") {
      environment = EnvBase.EnvType.PRODUCTION
    }
  }

  @ReactMethod
  fun alipay(amount: String?, currency: String, orderRef: String?, remark: String?) {
    Log.d("test", EnvBase.Currency.valueOf("HKD").toString())
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = "ALIPAYHKAPP"
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity

    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        Log.d("TAG", "payResult: " + payResult.getSuccessMsg())
      }

      override fun onError(data: Data) {
        Log.d("TAG", "error returned : " + data.getError())
      }
    })
  }


  @ReactMethod
  fun wechat(amount: String?, orderRef: String?, payMethod: String?, remark: String?) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.amount = amount
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.HKD)
    payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT)
    payData.activity = currentActivity
    payData.orderRef = orderRef
    payData.payMethod = payMethod
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.merchantId = merchantId!!
    payData.remark = remark

    paySDK.requestData = payData
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

  @ReactMethod
  fun octopus(String amount, String orderRef, String remark) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.HKD)
    payData.setPayType(EnvBase.PayType.NORMAL_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = "OCTOPUS"
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity

    paySDK.requestData = payData
    paySDK.process()

    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        Log.d("TAG", "payResult: " + payResult.getSuccessMsg())
      }

      override fun onError(data: Data) {
        Log.d("TAG", "error returned : " + data.getError())
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

}

