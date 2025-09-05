import React from 'react';
import {HostComponent, ViewProps} from 'react-native';
import {
  DirectEventHandler,
  Double,
  Float,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

type DataModal = {
  uri: string;
};

type LoadEvent = {
  currentTime: Double;
  duration: Double;
};

type ProgressEvent = {
  currentTime: Double;
};

export interface NativeProps extends ViewProps {
  source: DataModal;
  paused?: boolean;
  onLoad?: DirectEventHandler<LoadEvent> | null;
  onEnd?: DirectEventHandler<null> | null;
  onProgress?: DirectEventHandler<ProgressEvent> | null;
  onError?: DirectEventHandler<null> | null;
}

export type AudioComponentType = HostComponent<NativeProps>;

interface NativeCommands {
  seek: (viewRef: React.ElementRef<AudioComponentType>, time: Float) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: ['seek'],
});

export default codegenNativeComponent<NativeProps>(
  'NativeAudio',
) as HostComponent<NativeProps>;
