import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { RSAModule } from './RSAModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class RSAModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeRSA.NAME) {
      return new RSAModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeRSA.NAME
  }
}

export class RSAPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new RSAModulesFactory(ctx)
  }
}