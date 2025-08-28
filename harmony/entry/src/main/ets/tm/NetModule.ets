import { TurboModule, UITurboModuleContext } from "@rnoh/react-native-openharmony"
import { TM } from '@rnoh/react-native-openharmony/generated/ts'
import { connection } from "@kit.NetworkKit";
import { BusinessError } from "@kit.BasicServicesKit";

enum NetType {
  'cellular' = 0,
  'wifi' = 1,
  'bluetooth' = 2,
  'ethernet' = 3,
  'vpn' = 4
}

export const NET_CONNECT_STATUS = 'net.connect.status';

export class NetModule extends TurboModule implements TM.NativeNet.Spec {
  init(): void {
    let netCon: connection.NetConnection = connection.createNetConnection();
    netCon.register((error: BusinessError) => {
      console.error(JSON.stringify(error));
    });
    netCon.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      console.info("Succeeded to get data: " + JSON.stringify(data));
      const netHandle = connection.getDefaultNetSync()
      const netCapabilities = connection.getNetCapabilitiesSync(netHandle)
      this.ctx.rnInstance.emitDeviceEvent(NET_CONNECT_STATUS, { status: NetType[netCapabilities.bearerTypes[0]] })
    });
  }

  getCurrentNetStatus(): Promise<TM.NativeNet.ResultModel> {
    const netHandle = connection.getDefaultNetSync()
    const netCapabilities = connection.getNetCapabilitiesSync(netHandle)
    return new Promise((resolve) => resolve({
      status: NetType[netCapabilities.bearerTypes[0]]
    } as TM.NativeNet.ResultModel))
  }
}