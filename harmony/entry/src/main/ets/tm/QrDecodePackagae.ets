import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { QrDecodeModule } from './QrDecodeModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class QrDecodeModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeQrDecode.NAME) {
      return new QrDecodeModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeQrDecode.NAME
  }
}

export class QrDecodePackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new QrDecodeModulesFactory(ctx)
  }
}