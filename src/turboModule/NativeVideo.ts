import React from 'react';
import {HostComponent, View, ViewProps} from 'react-native';
import {
  DirectEventHandler,
  Double,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

type DataModal = {
  isPrivate: boolean;
  private_url: string;
  video_id: string;
  play_auth: string;
  played: Int32;
  referer: string;
};

type ErrorEvent = {
  code: Int32;
  message: string;
};

type StatusEvent = {
  status: boolean;
};

type DurationEvent = {
  progress: Double;
};

type ProgressEvent = {
  progress: Double;
};

type RateEvent = {
  rate: Double;
};

export interface NativeProps extends ViewProps {
  data: DataModal;
  onError?: DirectEventHandler<ErrorEvent> | null;
  onFullScreenChange?: DirectEventHandler<StatusEvent> | null;
  onPrepareDone?: DirectEventHandler<DurationEvent> | null;
  onPlayingProgress?: DirectEventHandler<ProgressEvent> | null;
  onRateChange?: DirectEventHandler<RateEvent> | null;
  onPlayPause?: DirectEventHandler<null> | null;
  onPlayCompleted?: DirectEventHandler<null> | null;
  onPlayerStop?: DirectEventHandler<null> | null;
  onPlayFirstStarted?: DirectEventHandler<null> | null;
  onPlayResume?: DirectEventHandler<null> | null;
}

export type VideoComponentType = HostComponent<NativeProps>;

interface NativeCommands {
  startPlay: (viewRef: React.ElementRef<VideoComponentType>) => void;
  stopPlay: (viewRef: React.ElementRef<VideoComponentType>) => void;
  pausePlay: (viewRef: React.ElementRef<VideoComponentType>) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['startPlay', 'stopPlay', 'pausePlay'],
});

export default codegenNativeComponent<NativeProps>(
  'NativeVideo',
) as HostComponent<NativeProps>;
