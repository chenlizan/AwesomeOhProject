import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
  openSystemSettings(): Promise<void>;
  openWifiSettings(): Promise<void>;
  openNetworkSettings(): Promise<void>;
}
export const SettingModule =
  TurboModuleRegistry.getEnforcing<Spec>('NativeSetting');
