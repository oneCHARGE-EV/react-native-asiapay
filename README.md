# react-native-asiapay

Asiapay react native library

# Requirements

React Native 0.60.0+
XCode 12+
iOS 10+
Android SDK 17+

# PaySDK version

__iOS:__ 2.6.02
__Android:__ 2.2.7

# Installation

```sh
npm install react-native-asiapay
```

```sh
yarn add react-native-asiapay
```
## iOS installation

`pod install`

## Android installation

Add `flatDir { dirs "$rootDir/../node_modules/react-native-asiapay/android/libs" }` to `android/build.gradle`

Inside 
```
allprojects {
    repositories {
      ....
    }
}
```

## Add pay sdk public key file

**Android**

Put your public key file in `android/app/src/main/assets/paysdk.properties`

**iOS**

Put your public key file in `android/app/src/main/assets/paysdk.properties`

## Usage

#### JS Code
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

# Others

Check https://github.com/asiapay-lib/ for more details

# Contribution

#### **Did you find a bug?**

- Ensure the bug was not already reported by searching on Gihub under https://github.com/onecharge-ev/react-native-asiapay/issues
- If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/onecharge-ev/react-native-asiapay/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.
#### **Did you write a patch that fixes a bug?**

- Open a new GitHub pull request with the patch.
- Ensure the PR description clearly describes the problem and solution. Include the relevant issue number if applicable.
#### **Do you intend to add a new feature or change an existing one?**
- Open a new GitHub pull request with the new updates.
