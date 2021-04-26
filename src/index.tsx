import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  multiply(a: number, b: number): Promise<number>;
  setup(envType: string, mId: string): void;
  alipay(amount: string, currency: string, orderRef: string, remark: string): void;
};

export default Asiapay as AsiapayType;
