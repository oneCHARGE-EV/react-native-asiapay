# react-native-asiapay

Asiapay react native library

## Installation

```sh
npm install react-native-asiapay
```

```sh
yarn add react-native-asiapay
```

# Requirements

React Native 0.60.0+

# PaySDK version

__iOS:__ 2.4.1
__Android:__ 2.2.7

# iOS installation

`pod install`

# Android installation

No configuration is needed, React Native will auto link the library

# Add pay sdk public key file

__Android__

Put your public key file in `android/app/src/main/assets/paysdk.properties`

__iOS__

Put your public key file in `android/app/src/main/assets/paysdk.properties`

## Usage

### JS Code
```js
import Asiapay from "react-native-asiapay";

// Config environment and merchant id at the beginning of your app
Asiapay.setup('Production' | 'Sandbox', 'merchant id');

// Make payment
Asiapay.alipay('price', 'HKD', 'transaction id', 'Remark')
.then(s => {
  // Successfully capture payment from Alipay
})
.catch(({ code, message }) => {
  // Failed with error
});
```
