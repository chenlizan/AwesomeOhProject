import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
  encryptWithOAEPSHA256(publicKey: string, plan: string): Promise<string>;
}
export const RSAModule = TurboModuleRegistry.getEnforcing<Spec>('NativeRSA');
