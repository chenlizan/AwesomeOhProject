/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useState, useRef} from 'react';
import {
  Dimensions,
  View,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
} from 'react-native';
import NativeVideo from './src/turboModule/NativeVideo';

const {height} = Dimensions.get('screen');
function App(): JSX.Element {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.container}>
        <NativeVideo style={styles.video} />
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  video: {
    width: '100%',
    height: height,
  },
  container: {
    width: '100%',
    height: '100%',
    backgroundColor: '#f8f8f8',
  },
});

export default App;
