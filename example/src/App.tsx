import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import Asiapay from 'react-native-asiapay';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    Asiapay.setup('Sandbox', '88149885');
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button
        title="Test Alipay"
        onPress={() => {
          Asiapay.alipay('1', 'HKD', Date.now().toString(), 'Test')
            .then((s) => {
              console.log(s);
            })
            .catch(({ code, message }) => {
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
            'N'
          )
            .then((s) => {
              console.log(s);
            })
            .catch(({ code, message }) => {
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
            'Do you want to close?'
          )
            .then((s) => {
              console.log(s);
            })
            .catch(({ code, message }) => {
              console.log(code, message);
            });
        }}
      />
    </View>
  );
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
