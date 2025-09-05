import React, {useRef, useState} from 'react';
import {Dimensions, StyleSheet, View, NativeSyntheticEvent} from 'react-native';
import NativeVideo, {
  StatusEvent,
  VideoComponentType,
} from './src/turboModule/NativeVideo';

const {width} = Dimensions.get('window');
const videoHeight = width * (9 / 16); // 16:9 比例

const VideoPlayer: React.FC = () => {
  const nativeViewRef = useRef<React.ElementRef<VideoComponentType>>(null);
  const [isFullScreen, setIsFullScreen] = useState(false);

  const handleFullScreenChange = (e: NativeSyntheticEvent<StatusEvent>) => {
    setIsFullScreen(e.nativeEvent.status);
    console.log('全屏状态:', e.nativeEvent.status ? '进入' : '退出');
  };

  return (
    <View style={styles.container}>
      <NativeVideo
        ref={nativeViewRef}
        style={[styles.video, isFullScreen && styles.fullScreenVideo]}
        data={{
          isPrivate: true,
          private_url:
            'https://res.vmallres.com/uomcdn/CN/cms/202210/C75C7E20060F3E909F2998E13C3ABC03.mp4',
          video_id: '',
          play_auth: '',
          played: 0,
          referer: '',
        }}
        onFullScreenChange={handleFullScreenChange}
        onError={e => console.error('视频错误:', e.nativeEvent)}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f8f8',
  },
  video: {
    width: '100%',
    height: videoHeight,
  },
  fullScreenVideo: {
    height: '100%',
  },
});

export default VideoPlayer;
