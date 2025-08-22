import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { TimModule } from './TimModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class TimModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeTim.NAME) {
      return new TimModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeTim.NAME
  }
}

export class TimPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new TimModulesFactory(ctx)
  }
}