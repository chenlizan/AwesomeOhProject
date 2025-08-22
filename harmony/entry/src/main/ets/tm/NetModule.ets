import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { connection } from "@kit.NetworkKit";

enum NetType {
  'cellular' = 0,
  'wifi' = 1,
  'bluetooth' = 2,
  'ethernet' = 3,
  'vpn' = 4
}

export class NetModule extends TurboModule implements TM.NativeNet.Spec {
  getCurrentNetStatus(): Promise<TM.NativeNet.ResultModel> {
    const netHandle = connection.getDefaultNetSync()
    const netCapabilities = connection.getNetCapabilitiesSync(netHandle)
    return new Promise((resolve) => resolve({ status: NetType[netCapabilities.bearerTypes[0]] } as TM.NativeNet.ResultModel))
  }
}