import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  setup(envType: string, mId: string): void;
  alipay(
    amount: string,
    currency: string,
    orderRef: string,
    remark: string
  ): void;
  octopus(amount: string, orderRef: string, remark: string): void;
};

export default Asiapay as AsiapayType;
