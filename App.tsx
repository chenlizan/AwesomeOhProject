/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useRef, useState} from 'react';
import {
  Button,
  Dimensions,
  View,
  StyleSheet,
  DeviceEventEmitter,
} from 'react-native';
import NativeVideo, {
  Commands,
  VideoComponentType,
} from './src/turboModule/NativeVideo';
import {NET_CONNECT_STATUS} from './src/turboModule/NativeNet';

const {width} = Dimensions.get('window');

function App(): JSX.Element {
  const nativeViewRef = useRef<React.ElementRef<VideoComponentType>>(null);

  DeviceEventEmitter.addListener(NET_CONNECT_STATUS, data => {
    console.log(data?.status);
  });
  const pausePlay = () => {
    if (nativeViewRef.current) {
      Commands.pausePlay(nativeViewRef.current);
    }
  };

  return (
    <View style={styles.container}>
      <NativeVideo
        ref={nativeViewRef}
        style={styles.video}
        data={{
          isPrivate: true,
          private_url:
            'https://res.vmallres.com//uomcdn/CN/cms/202210/C75C7E20060F3E909F2998E13C3ABC03.mp4',
          video_id: '',
          play_auth: '',
          played: 0,
          referer: '',
        }}
        onFullScreenChange={async e => {
          console.log(e.nativeEvent.status);
        }}
      />
      <Button title={'测试'} onPress={pausePlay} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
    backgroundColor: '#f8f8f8',
  },
  video: {
    width: '100%',
    height: width,
  },
});

export default App;
