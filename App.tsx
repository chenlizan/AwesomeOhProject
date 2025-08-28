/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useRef} from 'react';
import {
  Dimensions,
  View,
  ScrollView,
  StyleSheet,
  SafeAreaView,
  Button,
} from 'react-native';
import NativeVideo, {
  Commands,
  VideoComponentType,
} from './src/turboModule/NativeVideo';
import {NetModule} from './src/turboModule/NativeNet';

const {height} = Dimensions.get('screen');

NetModule.init();

function App(): JSX.Element {
  const nativeViewRef = useRef<React.ElementRef<VideoComponentType>>(null);

  const pausePlay = () => {
    if (nativeViewRef.current) {
      Commands.pausePlay(nativeViewRef.current);
    }
  };

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView style={styles.container}>
        <View style={styles.container}>
          <Button title={'测试'} onPress={pausePlay} />
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
        </View>
      </ScrollView>
    </SafeAreaView>
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
  safe: {
    flex: 1,
    paddingTop: 0,
    paddingBottom: 0,
  },
});

export default App;
