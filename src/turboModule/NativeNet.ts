import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface ResultModel {
  status: string;
}
export interface Spec extends TurboModule {
  getCurrentNetStatus(): Promise<ResultModel>;
}
export const NetModule = TurboModuleRegistry.getEnforcing<Spec>('NativeNet');
