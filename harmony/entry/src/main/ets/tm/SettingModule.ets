import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { common } from "@kit.AbilityKit"

export class SettingModule extends TurboModule implements TM.NativeSetting.Spec {
  openSystemSettings(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        pushParams: context.abilityInfo.bundleName
      }
    })
    return new Promise((resolve) => resolve())
  }

  openWifiSettings(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'wifi_entry',
      parameters: {
        pushParams: context.abilityInfo.bundleName
      }
    })
    return new Promise((resolve) => resolve())
  }

  openNetworkSettings(): Promise<void> {
    const context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'mobile_network_entry',
      parameters: {
        pushParams: context.abilityInfo.bundleName
      }
    })
    return new Promise((resolve) => resolve())
  }
}