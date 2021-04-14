import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  multiply(a: number, b: number): Promise<number>;
  setup(environment: string): void;
  alipay(amount: number, currency: string, orderRef: string, remark: string): void;
};

export default Asiapay as AsiapayType;
