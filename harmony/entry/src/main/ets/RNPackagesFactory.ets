import { RNPackageContext, RNPackage } from '@rnoh/react-native-openharmony/ts';
import { FastImagePackage } from '@react-native-oh-tpl/react-native-fast-image';
import GestureHandlerPackage from '@react-native-oh-tpl/react-native-gesture-handler';
import { ViewPagerPackage } from '@react-native-oh-tpl/react-native-pager-view';
import { ReanimatedPackage } from '@react-native-oh-tpl/react-native-reanimated/ts';
import { SafeAreaViewPackage } from '@react-native-oh-tpl/react-native-safe-area-context';
import { SvgPackage } from '@react-native-oh-tpl/react-native-svg';
import { DeviceInfoPackage } from "./tm/DeviceInfoPackage";
import { SettingPackage } from './tm/SettingPackage';
import { NetPackage } from './tm/NetPackage'
import { VodUploadPackage } from './tm/VodUploadPackage'
import { RSAPackage } from './tm/RSAPackage'
import { TimPackage } from './tm/TimPackage'

export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
    new FastImagePackage(ctx),
    new GestureHandlerPackage(ctx),
    new ReanimatedPackage(ctx),
    new SafeAreaViewPackage(ctx),
    new SvgPackage(ctx),
    new ViewPagerPackage(ctx),
    new DeviceInfoPackage(ctx),
    new SettingPackage(ctx),
    new NetPackage(ctx),
    new VodUploadPackage(ctx),
    new RSAPackage(ctx),
    new TimPackage(ctx),
  ];
}
