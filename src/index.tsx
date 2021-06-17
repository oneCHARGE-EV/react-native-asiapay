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
  octopus(amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
};

export default Asiapay as AsiapayType;
