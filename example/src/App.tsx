import React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import Asiapay from 'react-native-asiapay';

export default class App extends React.Component {
  constructor(props) {
    super(props);
console.log('-----')
    Asiapay.setup('sandbox');
    // console.log(;
  }


    // paySDK.alipay(100, 'hkd', 'test', '');


  render() {
    return (
      <View style={styles.container}>
        <Text>Result: </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
