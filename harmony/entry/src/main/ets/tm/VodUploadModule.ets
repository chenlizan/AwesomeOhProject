import { TurboModule } from "@rnoh/react-native-openharmony";
import { TM } from "@rnoh/react-native-openharmony/generated/ts";
import { common } from "@kit.AbilityKit";
import { VodInfo, VODUploadCallback, VODUploadClient, VODUploadClientImpl } from "@aliyun_video_cloud/vod-upload-sdk";

let uiAbilityContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
let uploader: VODUploadClient | null = null
let uploadCallback: VODUploadCallback

let uploadAuth: string
let uploadAddress: string

let promiseResolve: (value: void | PromiseLike<void>) => void
let promiseReject: (reason?: string) => void

uploader = new VODUploadClientImpl(uiAbilityContext)

uploadCallback = {
  onUploadSucceed: (info, result) => {
    promiseResolve()
  },
  onUploadFailed: (info, code, message) => {
    promiseReject(code)
  },
  onUploadProgress: (info, uploadedSize, totalSize) => {
  },
  onUploadTokenExpired: () => {
  },
  onUploadRetry: (code, message) => {
  },
  onUploadRetryResume: () => {
  },
  onUploadStarted: (info) => {
    uploader?.setUploadAuthAndAddress(info, uploadAuth, uploadAddress)
  }
}

uploader.init(uploadCallback)

export class VodUploadModule extends TurboModule implements TM.NativeVodUpload.Spec {
  uploadVod(auth: string, address: string, files: TM.NativeVodUpload.FilesModel): Promise<void> {
    return new Promise((resolve, reject) => {
      promiseResolve = resolve
      promiseReject = reject
      const vodInfo = new VodInfo()
      vodInfo.setTitle(files.name)
      uploadAuth = auth
      uploadAddress = address
      uploader?.addFile(files.uri, vodInfo)
      uploader?.start()
    })
  }
}