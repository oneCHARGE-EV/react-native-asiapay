import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  setup(envType: string, mId: string): void;
  alipay(
    amount: string,
    currency: string,
    orderRef: string,
    remark: string
  ): Promise<Map<string, string>>;
  octopus(
    amount: string,
    orderRef: string,
    remark: string
  ): Promise<Map<string, string>>;
  creditCard(
    amount: string,
    currency: string,
    method: string,
    orderRef: string,
    remark: string,
    cardDetails: { [key: string]: string } | null,
    extraData: { [key: string]: string | boolean | number },
    payType: string
  ): Promise<Map<string, string>>;
  webView(
    amount: string,
    currency: string,
    method: string,
    orderRef: string,
    remark: string,
    extraData: { [key: string]: string | boolean | number },
    payType: string,
    showCloseButton: boolean,
    showToolbar: boolean,
    webViewClosePrompt: string
  ): Promise<Map<string, string>>;
  nativePay(
    amount: string,
    currency: string,
    countryCode: string,
    priceLabel: string,
    orderRef: string,
    remark: string,
    payType: string,
    nativePayMerchantId: string
  ): Promise<Map<string, string>>;
  canMakeNativePay(): Promise<boolean>;
};

export default Asiapay as AsiapayType;
