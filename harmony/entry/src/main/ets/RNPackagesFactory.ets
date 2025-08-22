import { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony/ts';
import { FastImagePackage } from '@react-native-oh-tpl/react-native-fast-image';
import { DeviceInfoPackage } from "./tm/DeviceInfoPackage";
import { SettingPackage } from './tm/SettingPackage';
import { NetPackage } from './tm/NetPackage'
import { VodUploadPackage } from './tm/VodUploadPackage'
import { RSAPackage } from './tm/RSAPackage'
import { TimPackage } from './tm/TimPackage'

export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    new FastImagePackage(ctx),
    new DeviceInfoPackage(ctx),
    new SettingPackage(ctx),
    new NetPackage(ctx),
    new VodUploadPackage(ctx),
    new RSAPackage(ctx),
    new TimPackage(ctx),
  ];
}
