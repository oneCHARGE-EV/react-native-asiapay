/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';

import {
  SafeAreaView,
  Button,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';
import Asiapay from 'react-native-asiapay';

import {Colors} from 'react-native/Libraries/NewAppScreen';

function App(): JSX.Element {
  const [result, setResult] = useState<number | undefined>();

  useEffect(() => {
    Asiapay.setup('Sandbox', '88149885');
  });

  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <View>
        <Text>Result: {result}</Text>
        <Button
          title="Test Alipay"
          onPress={() => {
            Asiapay.alipay('1', 'HKD', Date.now().toString(), 'Test')
              .then(s => {
                console.log(s);
              })
              .catch(({code, message}) => {
                console.log(code, message);
              });
          }}
        />
        <Button
          title="Test Octopus"
          onPress={() => {
            Asiapay.octopus('10', Date.now().toString(), 'Test');
          }}
        />
        <Button
          title="Test Credit Card"
          onPress={() => {
            Asiapay.creditCard(
              '1',
              'HKD',
              'VISA',
              Date.now().toString(),
              'Test',
              {
                cardNo: '4335900000140045',
                month: '7',
                year: '2030',
                cardHolder: 'testing card',
                cvc: '123',
              },
              {
                addNewMember: true,
                memberPay_service: 'T',
                memberPay_memberId: 'm2',
                memberId: 'm2',
              },
              'N',
            )
              .then(s => {
                console.log(s);
              })
              .catch(({code, message}) => {
                console.log(code, message);
              });
          }}
        />

        <Button
          title="Test Web view"
          onPress={() => {
            Asiapay.webView(
              '1',
              'HKD',
              'VISA',
              Date.now().toString(),
              'Test',
              {
                addNewMember: true,
                memberPay_service: 'T',
                memberPay_memberId: 'm2',
                memberId: 'm2',
              },
              'N',
              true,
              true,
              'Do you want to close?',
            )
              .then(s => {
                console.log(s);
              })
              .catch(({code, message}) => {
                console.log(code, message);
              });
          }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

export default App;
