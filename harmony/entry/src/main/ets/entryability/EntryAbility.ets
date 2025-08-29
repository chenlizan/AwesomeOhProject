import {
  Permissions, Want
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { RNAbility } from '@rnoh/react-native-openharmony';
import { BusinessError } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;

const permissions: Array<Permissions> = ['ohos.permission.GET_NETWORK_INFO'];

export default class EntryAbility extends RNAbility {
  override onCreate(want: Want): void {
    super.onCreate(want);
    hilog.info(0x0000, 'testTag', '%{public}s', 'EntryAbility onCreate');
  }

  onDestroy(): void {
    super.onDestroy()
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  getPagePath() {
    return 'pages/Index';
  }
}