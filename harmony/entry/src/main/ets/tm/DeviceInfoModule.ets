import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { deviceInfo } from "@kit.BasicServicesKit"

export class DeviceInfoModule extends TurboModule implements TM.NativeDeviceInfo.Spec {
  getDeviceInfo(): Promise<string> {
    const info: string =
      `品牌：${deviceInfo.brand} \n制造商：${deviceInfo.manufacture} \n版本：${deviceInfo.displayVersion} \nAPI：${deviceInfo.osFullName}`
    return new Promise((resolve) => resolve(info))
  }
}