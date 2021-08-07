import * as React from 'react';

import { StyleSheet, View, Text, Button, Linking } from 'react-native';
import Asiapay from 'react-native-asiapay';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    Asiapay.setup('Production', '88624174');

    const getUrlAsync = async () => {
      // Get the deep link used to open the app
      const initialUrl = await Linking.getInitialURL();
      console.log(initialUrl);
    };

    getUrlAsync();
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
              debugger;
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
