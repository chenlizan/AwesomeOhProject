import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { VodUploadModule } from './VodUploadModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class VodUploadModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeVodUpload.NAME) {
      return new VodUploadModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeVodUpload.NAME
  }
}

export class VodUploadPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new VodUploadModulesFactory(ctx)
  }
}