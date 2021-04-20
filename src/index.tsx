import { NativeModules } from 'react-native';

type AsiapayType = {
  // multiply(a: number, b: number): Promise<number>;
  setup(envType: string): void;
};

const { Asiapay } = NativeModules;

export default Asiapay as AsiapayType;
