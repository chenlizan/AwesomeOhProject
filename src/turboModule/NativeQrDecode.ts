import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface OptionsModel {
  codeTypes: string[];
}
export interface Spec extends TurboModule {
  decode(base64Data: string, options: OptionsModel): Promise<string>;
}
export const QrDecodeModule =
  TurboModuleRegistry.getEnforcing<Spec>('NativeQrDecode');
