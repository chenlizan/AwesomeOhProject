import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { NetModule } from './NetModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class NetModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeNet.NAME) {
      return new NetModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeNet.NAME
  }
}

export class NetPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new NetModulesFactory(ctx)
  }
}