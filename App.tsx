/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useRef, useState} from 'react';
import {
  Dimensions,
  View,
  ScrollView,
  StyleSheet,
  SafeAreaView,
  Button,
  useWindowDimensions,
} from 'react-native';
import {NativeBaseProvider, Select} from 'native-base';
import NativeVideo, {
  Commands,
  VideoComponentType,
} from './src/turboModule/NativeVideo';
import {NetModule} from './src/turboModule/NativeNet';

NetModule.init();

function App(): JSX.Element {
  const nativeViewRef = useRef<React.ElementRef<VideoComponentType>>(null);
  const [service5, setService5] = useState('ux');
  // const {height, width} = useWindowDimensions();
  const pausePlay = () => {
    const width = Dimensions.get('window').width;
    const height = Dimensions.get('window').height;
    console.log("Dimensions.get('window').width:", width);
    console.log("Dimensions.get('height').height:", height);
    if (nativeViewRef.current) {
      Commands.pausePlay(nativeViewRef.current);
    }
  };

  return (
    <NativeBaseProvider>
      <SafeAreaView style={styles.safe}>
        <ScrollView style={styles.container}>
          <View style={styles.container}>
            <Button title={'测试 Dimensions'} onPress={pausePlay} />
            <Select
              selectedValue={service5}
              minWidth="200"
              defaultValue={'ux'}
              accessibilityLabel="accessibilityLabel"
              _selectedItem={{
                bg: 'teal.600',
              }}
              variant="rounded"
              onValueChange={itemValue => {
                setService5(itemValue);
              }}
              mt={1}>
              <Select.Item label="UX Research" value="ux" />
              <Select.Item label="Web Development" value="web" />
              <Select.Item label="Cross Platform Development" value="cross" />
              <Select.Item label="UI Designing" value="ui" />
              <Select.Item label="Backend Development" value="backend" />
            </Select>
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
                const {height} = Dimensions.get('window');
                console.log(height);
              }}
            />
          </View>
        </ScrollView>
      </SafeAreaView>
    </NativeBaseProvider>
  );
}

const styles = StyleSheet.create({
  video: {
    width: '100%',
    height: 375,
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
