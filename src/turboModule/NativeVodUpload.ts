import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface FilesModel {
  name: string;
  uri: string;
}
export interface Spec extends TurboModule {
  uploadVod(auth: string, address: string, files: FilesModel): Promise<void>;
}
export const VodUploadModule =
  TurboModuleRegistry.getEnforcing<Spec>('NativeVodUpload');
