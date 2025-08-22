import {
  abilityAccessCtrl,
  AbilityConstant, ConfigurationConstant,
  PermissionRequestResult,
  Permissions, UIAbility, Want } from '@kit.AbilityKit';
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
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(this.context, permissions).then((result: PermissionRequestResult) => {
      console.info(`get Permission success, result: ${JSON.stringify(result)}`);
    }).catch((error: BusinessError) => {
      console.error(`get Permission error, error. Code: ${error.code}, message: ${error.message}`);
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  getPagePath() {
    return 'pages/Index';
  }
}