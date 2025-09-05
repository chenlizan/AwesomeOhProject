import NativeAudio from './src/turboModule/NativeAudio';
import React, {useState} from 'react';
import {Button, StyleSheet, Text, View} from 'react-native';

const AudioPlayer: React.FC = () => {
  const [isPlaying, setIsPlaying] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const togglePlay = () => {
    setIsPlaying(!isPlaying);
  };

  return (
    <View style={styles.container}>
      <NativeAudio
        source={{
          uri: 'https://oss.ai-augmented.com/transcode/ccnu/audio/6655435411256514480.mp3?OSSAccessKeyId=LTAIOOB8tIOg2Q4O&Expires=1756957154834&Signature=E8jm3jw4U0GScuy76w0lQADS434%3D&response-content-disposition=filename=%22%E9%98%BF%E9%B8%A3%20-%20%E7%9C%9F%E7%9B%B8%E6%98%AF%E7%9C%9F%20(%E5%8E%9F%E5%94%B1_%E6%B4%AA%E5%8D%93%E7%AB%8B)_6655435411256514480.mp3%22;filename*=utf-8%27%27%25E9%2598%25BF%25E9%25B8%25A3%2520-%2520%25E7%259C%259F%25E7%259B%25B8%25E6%2598%25AF%25E7%259C%259F%2520(%25E5%258E%259F%25E5%2594%25B1_%25E6%25B4%25AA%25E5%258D%2593%25E7%25AB%258B)_6655435411256514480.mp3',
        }}
        paused={!isPlaying}
        onLoad={() => setIsLoading(false)}
        onError={(err: any) => {
          setIsLoading(false);
          setError(err.message || '播放失败');
        }}
      />

      {isLoading && <Text>加载中...</Text>}
      {error && <Text style={{color: 'red'}}>错误: {error}</Text>}
      <Button title={isPlaying ? '暂停' : '播放'} onPress={togglePlay} />
      <Text>当前状态: {isPlaying ? '播放中' : '已暂停'}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f8f8',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default AudioPlayer;
