import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { RNAbility } from '@rnoh/react-native-openharmony';

const DOMAIN = 0x0000;

export default class EntryAbility extends RNAbility {
  override onCreate(want: Want): void {
    super.onCreate(want);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'EntryAbility onCreate');
  }

  onDestroy(): void {
    super.onDestroy()
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  getPagePath() {
    return 'pages/Index';
  }
}