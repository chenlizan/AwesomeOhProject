/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useState} from 'react';
import {SafeAreaView, Button, Text, View ,DeviceEventEmitter} from 'react-native';
import {NetModule} from './src/turboModule/NativeNet';
import {TimModule, LISTENER_TYPE} from './src/turboModule/NativeTim';

function App(): JSX.Element {
  const [info, setInfo] = useState('');

  DeviceEventEmitter.addListener(LISTENER_TYPE.SUCCESS, e => {
    // 添加事件处理
    // setInfo('LISTENER_TYPE.SUCCESS');
  });

  const handleTest = async() => {
    TimModule.init(1400481918);
    const result = await NetModule.getCurrentNetStatus();
    setInfo(result.status);
  };

  return (
    <View style={{backgroundColor: 'white'}}>
      <SafeAreaView>
        <Button onPress={handleTest} title={'测试组件'}/>
        <Text>输出结果：</Text>
        <Text>{info}</Text>
      </SafeAreaView>
    </View>
  );
}

export default App;
