import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { SettingModule } from './SettingModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class SettingModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeSetting.NAME) {
      return new SettingModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeSetting.NAME
  }
}

export class SettingPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new SettingModulesFactory(ctx)
  }
}