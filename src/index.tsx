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
    cardDetails: { [key: string]: string },
    extraData: { [key: string]: string | boolean | number },
    payType: string
  ): Promise<Map<string, string>>;
};

export default Asiapay as AsiapayType;
