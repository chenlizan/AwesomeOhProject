import { TurboModule, TurboModulesFactory } from '@rnoh/react-native-openharmony/ts'
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { DeviceInfoModule } from './DeviceInfoModule'
import { RNPackage, UITurboModuleContext } from '@rnoh/react-native-openharmony'

class DeviceInfoModulesFactory extends TurboModulesFactory {
  createTurboModule(name: string): TurboModule | null {
    if (name === TM.NativeDeviceInfo.NAME) {
      return new DeviceInfoModule(this.ctx)
    }
    return null
  }

  hasTurboModule(name: string): boolean {
    return name === TM.NativeDeviceInfo.NAME
  }
}

export class DeviceInfoPackage extends RNPackage {
  createTurboModulesFactory(ctx: UITurboModuleContext): TurboModulesFactory {
    return new DeviceInfoModulesFactory(ctx)
  }
}