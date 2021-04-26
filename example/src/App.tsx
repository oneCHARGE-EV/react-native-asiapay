import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import Asiapay from 'react-native-asiapay';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    Asiapay.setup('sandbox', '88149885');
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button
        title="Test me"
        onPress={() => {
          Asiapay.alipay("10", "HKD", Date.now().toString(), "Test");
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
