/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {View, StyleSheet, DeviceEventEmitter} from 'react-native';
import {NET_CONNECT_STATUS} from './src/turboModule/NativeNet';
import NativeAudioPaper from './NativeAudioPaper';
import NativeVideoPaper from './NativeVideoPaper';

function App(): JSX.Element {
  DeviceEventEmitter.addListener(NET_CONNECT_STATUS, data => {
    console.log(data?.status);
  });

  return (
    <View style={styles.container}>
      <NativeAudioPaper />
      <NativeVideoPaper />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
    backgroundColor: '#f8f8f8',
  },
});

export default App;
