import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  multiply(a: number, b: number): Promise<number>;
  init(environment: string): AsiapayType;
  alipay(amount: number, currency: string, orderRef: string, remark: string): void;
};

export default Asiapay as AsiapayType;
