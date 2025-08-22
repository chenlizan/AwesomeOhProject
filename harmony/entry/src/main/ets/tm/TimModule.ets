import { buffer, util } from "@kit.ArkTS"
import dayjs from "dayjs"
import { TurboModule } from "@rnoh/react-native-openharmony"
import { TM } from "@rnoh/react-native-openharmony/generated/ts"
import {
  V2TIMAdvancedMsgListener,
  V2TIMConversationListFilter,
  V2TIMConversationType,
  V2TIMElemType,
  V2TIMGroupInfo,
  V2TIMGroupInfoResult,
  V2TIMGroupListener,
  V2TIMImage,
  V2TIMManager,
  V2TIMMessage,
  V2TIMMessageGetType,
  V2TIMMessageListGetOption,
  V2TIMMessagePriority,
  V2TIMSDKListener,
  V2TIMUserFullInfo
} from "@tencentcloud/imsdk"

interface LISTENER_TYPE_MODEL {
  CUSTOM_MESSAGE: string
  TEXT_MESSAGE: string
  FACE_MESSAGE: string
  IMAGE_MESSAGE: string
  Revoked_MESSAGE: string
  Group_MESSAGE: string
  KICKED_OFFLINE: string
  USER_SIG_EXPIRED: string
  SUCCESS: string
  FAIL: string
  WAIT: string
}

export const LISTENER_TYPE: LISTENER_TYPE_MODEL = {
  CUSTOM_MESSAGE: 'im.msg.onRecvCustomMessage',
  TEXT_MESSAGE: 'im.msg.onRecvTextMessage',
  FACE_MESSAGE: 'im.msg.onRecvFaceMessage',
  IMAGE_MESSAGE: 'im.msg.onRecvImageMessage',
  Revoked_MESSAGE: 'im.msg.onRecvMessageRevoked',
  Group_MESSAGE: 'im.msg.onRecvMessageGroup',
  KICKED_OFFLINE: 'im.connect.onKickedOffline',
  USER_SIG_EXPIRED: 'im.connect.onUserSigExpired',
  SUCCESS: 'im.connect.onSuccess',
  FAIL: 'im.connect.onFail',
  WAIT: 'im.connect.onWait',
}

export class TimModule extends TurboModule implements TM.NativeTim.Spec {
  private lastV2TIMMessage: V2TIMMessage[] = []
  private advancedMsgListener: V2TIMAdvancedMsgListener = {
    onRecvNewMessage: (message: V2TIMMessage) => {
      switch (message.elemType) {
        case V2TIMElemType.V2TIM_ELEM_TYPE_TEXT: {
          this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.TEXT_MESSAGE,
            { groupID: message.groupID, userID: message.userID, message: message.textElem?.text })
          break
        }
        case V2TIMElemType.V2TIM_ELEM_TYPE_CUSTOM: {
          let custom_elem = message.customElem
          if (custom_elem && custom_elem.data) {
            this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.CUSTOM_MESSAGE, buffer.from(custom_elem.data).toString())
          }
          break
        }
        case V2TIMElemType.V2TIM_ELEM_TYPE_IMAGE: {
          let image_elem = message.imageElem
          if (image_elem && image_elem.imageList) {
            const messageMap: Record<string, number | string>[] = []
            image_elem.imageList.forEach((image: V2TIMImage) => {
              messageMap.push({
                'size': image.size,
                'type': image.type,
                'url': image.url,
                'uuid': image.uuid
              })
            })
            this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.IMAGE_MESSAGE,
              { groupID: message.groupID, userID: message.userID, message: messageMap })
          }
          break
        }
        case V2TIMElemType.V2TIM_ELEM_TYPE_FACE: {
          this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.FACE_MESSAGE,
            { groupID: message.groupID, userID: message.userID, message: message.faceElem?.index })
        }
          break
      }
    },
    onRecvMessageRevoked: (msgID: string, operateUser: V2TIMUserFullInfo, reason: string) => {
      this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.Revoked_MESSAGE, { msgID: msgID })
    }
  }
  private groupListener: V2TIMGroupListener = {
    onMemberInfoChanged: (groupId: string) => {
      this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.Group_MESSAGE, { groupId: groupId })
    },

    onAllGroupMembersMuted: (groupId: string) => {
      this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.Group_MESSAGE, { groupId: groupId })
    },

    onGroupInfoChanged: (groupId: string) => {
      this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.Group_MESSAGE, { groupId: groupId })
    },
  }

  init(sdkAppID: number): void {
    V2TIMManager.getInstance().initSDK(getContext().getApplicationContext(), sdkAppID)
    V2TIMManager.getInstance().addSDKListener({
      onConnecting: () => {
        this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.WAIT, null)
      },
      onConnectSuccess: () => {
        this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.SUCCESS, null)
      },
      onConnectFailed: (code: number, message: string) => {
        this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.FAIL, { errCode: code, errMsg: message })
      },
      onKickedOffline: () => {
        this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.KICKED_OFFLINE, null)
      },
      onUserSigExpired: () => {
        this.ctx.rnInstance.emitDeviceEvent(LISTENER_TYPE.USER_SIG_EXPIRED, null)
      }
    } as V2TIMSDKListener)
    this.addEventListener()
  }

  unInit(): void {
    V2TIMManager.getInstance().unInitSDK()
    this.removeEventListener()
  }

  login(userID: string, userSig: string): Promise<void> {
    return V2TIMManager.getInstance().login(userID, userSig)
  }

  logout(): Promise<void> {
    return V2TIMManager.getInstance().logout()
  }

  getLoginStatus(): Promise<string> {
    return new Promise((resolve) => resolve(V2TIMManager.getInstance().getLoginStatus().toString()))
  }

  sendTextMessage(text: string, receiver_userID: string, receiver_groupID: string, customData: string): Promise<void> {
    const v2TIMMessage = V2TIMManager.getMessageManager().createTextMessage(text)
    return V2TIMManager.getMessageManager()
      .sendMessage(v2TIMMessage,
        {
          receiver: receiver_userID,
          groupID: receiver_groupID,
          priority: V2TIMMessagePriority.V2TIM_PRIORITY_NORMAL,
          onlineUserOnly: false,
          offlinePushInfo: null
        })
      .promise
      .then(() => {
        return
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  sendFaceMessage(faceIndex: number, receiver_userID: string, receiver_groupID: string,
    customData: string): Promise<void> {
    const v2TIMMessage = V2TIMManager.getMessageManager().createFaceMessage(faceIndex, null)
    return V2TIMManager.getMessageManager()
      .sendMessage(v2TIMMessage,
        {
          receiver: receiver_userID,
          groupID: receiver_groupID,
          priority: V2TIMMessagePriority.V2TIM_PRIORITY_NORMAL,
          onlineUserOnly: false,
          offlinePushInfo: null
        })
      .promise
      .then(() => {
        return
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  sendImageMessage(imagePath: string, receiver_userID: string, receiver_groupID: string,
    customData: string): Promise<void> {
    const decoder = util.TextDecoder.create('utf-8')
    const v2TIMMessage = V2TIMManager.getMessageManager()
      .createImageMessage(decoder.decodeToString(new Uint8Array(buffer.from(imagePath, 'utf-8').buffer)))
    return V2TIMManager.getMessageManager()
      .sendMessage(v2TIMMessage,
        {
          receiver: receiver_userID,
          groupID: receiver_groupID,
          priority: V2TIMMessagePriority.V2TIM_PRIORITY_NORMAL,
          onlineUserOnly: false,
          offlinePushInfo: null
        })
      .promise
      .then(() => {
        return
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  sendFileMessage(filePath: string, fileName: string, receiver_userID: string, receiver_groupID: string,
    customData: string): Promise<void> {
    const decoder = util.TextDecoder.create('utf-8')
    const v2TIMMessage = V2TIMManager.getMessageManager()
      .createFileMessage(decoder.decodeToString(new Uint8Array(buffer.from(filePath, 'utf-8').buffer)), fileName)
    return V2TIMManager.getMessageManager()
      .sendMessage(v2TIMMessage,
        {
          receiver: receiver_userID,
          groupID: receiver_groupID,
          priority: V2TIMMessagePriority.V2TIM_PRIORITY_NORMAL,
          onlineUserOnly: false,
          offlinePushInfo: null
        })
      .promise
      .then(() => {
        return
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  revokeMessage(msgId: string): Promise<void> {
    const lastMsg = this.lastV2TIMMessage.filter(message => message.msgID === msgId)[0]
    if (lastMsg !== null) {
      return V2TIMManager.getMessageManager().revokeMessage(lastMsg)
    } else {
      return new Promise((resolve) => resolve())
    }
  }

  previewFile(msgId: string): Promise<string> {
    const lastMsg = this.lastV2TIMMessage.filter(message => message.msgID === msgId)[0]
    if (lastMsg !== null) {
      return lastMsg.fileElem?.getUrl() || new Promise((resolve) => resolve(''))
    } else {
      return new Promise((resolve) => resolve(''))
    }
  }

  getHistoryMessageList(lastMsgID: string, count: number, receiver_userID: string,
    receiver_groupID: string): Promise<TM.NativeTim.HistoryMessageModel[]> {
    const option: V2TIMMessageListGetOption = {
      getType: V2TIMMessageGetType.V2TIM_GET_CLOUD_OLDER_MSG,
      userID: receiver_userID !== null ? receiver_userID : receiver_groupID,
      count: count,
    }
    if (lastMsgID !== null) {
      const lastMsg = this.lastV2TIMMessage.filter(message => message.msgID === lastMsgID)[0]
      if (lastMsg !== null) {
        option.lastMsg = lastMsg
      }
    }
    return V2TIMManager.getMessageManager().getHistoryMessageList(option)
      .then((resultList: V2TIMMessage[]) => {
        if (lastMsgID === null) {
          this.lastV2TIMMessage = []
        }
        this.lastV2TIMMessage = resultList
        const list = resultList.map(item => {
          let imageMap: Record<string, number | string> = {}
          let image_elem = item.imageElem
          if (image_elem && image_elem.imageList && image_elem.imageList.length > 0) {
            const image = image_elem.imageList[0]
            imageMap = {
              'width': image.width,
              'height': image.height,
              'url': image.url,
            }
          }

          let fileMap: Record<string, number | string> = {}
          let file_elem = item.fileElem
          if (file_elem) {
            fileMap = {
              'fileName': file_elem.filename,
              'fileSize': file_elem.fileSize,
              'uuid': file_elem.uuid
            }
          }

          let tipsMap: Record<string, number | Record<string, number | string>[]> = {}
          let group_tips_elem = item.groupTipsElem
          if (group_tips_elem) {
            if (group_tips_elem.type === 7) {
              tipsMap = {
                'type': 7
              }
            } else if (group_tips_elem.type === 8) {
              const memberChanges =
                group_tips_elem.memberChangeInfoList.map(item => {
                  return {
                    'userID': item.userID,
                    'muteTime': item.muteTime
                  } as Record<string, number | string>
                })
              tipsMap = {
                'type': 8,
                'memberChanges': memberChanges
              }
            }
          }
          return {
            msgID: item.msgID,
            userID: item.userID,
            groupID: item.groupID,
            timestamp: dayjs(item.timestamp * 1000).format('YYYY-MM-DD HH:mm:ss'),
            elemType: item.elemType,
            msgStatus: item.status,
            textElem: item.textElem?.text,
            faceElem: item.faceElem?.index,
            sender: item.sender,
            nickName: item.nickName,
            customData: buffer.from(item.cloudCustomData).toString(),
            customElem: buffer.from(item.customElem?.data).toString(),
            imageElem: imageMap,
            fileElem: fileMap,
            groupTipsElem: tipsMap
          } as TM.NativeTim.HistoryMessageModel
        })
        return list
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  getConversationList(isC2C: boolean): Promise<TM.NativeTim.ConversationModel[]> {
    return new Promise((resolve) => resolve([]))
  }

  deleteConversation(conversationID: string): Promise<void> {
    return V2TIMManager.getConversationManager().deleteConversation(conversationID)
  }

  cleanConversationUnreadMessageCount(conversationID: string): Promise<void> {
    return V2TIMManager.getConversationManager().cleanConversationUnreadMessageCount(conversationID)
  }

  getUnreadMessageCountByFilter(isC2C: boolean): Promise<number> {
    const info: V2TIMConversationListFilter = {
      type: V2TIMConversationType.V2TIM_GROUP,
    }
    if (isC2C) {
      info.type = V2TIMConversationType.V2TIM_C2C
    }
    return V2TIMManager.getConversationManager().getUnreadMessageCountByFilter(info)
  }

  deleteConversationList(array: string[], clearMessage: boolean): Promise<void> {
    return V2TIMManager.getConversationManager().deleteConversationList(array, clearMessage)
      .then(() => {
        return
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  getJoinedGroupList(): Promise<TM.NativeTim.JoinedGroupModel[]> {
    return V2TIMManager.getGroupManager()
      .getJoinedGroupList()
      .then((resultList: V2TIMGroupInfo[]) => {
        const list = resultList.map(item => {
          return {
            groupID: item.groupID,
            groupName: item.groupName,
            faceUrl: item.faceURL,
            createTime: item.createTime.toString()
          } as TM.NativeTim.JoinedGroupModel
        })
        return list
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  getTotalUnreadMessageCount(): Promise<number> {
    return V2TIMManager.getConversationManager().getTotalUnreadMessageCount()
  }

  getGroupsInfo(array: string[]): Promise<TM.NativeTim.GroupInfo[]> {
    return V2TIMManager.getGroupManager()
      .getGroupsInfo(array)
      .then((resultList: V2TIMGroupInfoResult[]) => {
        const list = resultList.map(item => {
          return {
            groupID: item.info.groupID,
            groupName: item.info.groupName,
            faceUrl: item.info.faceURL,
          } as TM.NativeTim.GroupInfo
        })
        return list
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  getUsersInfo(array: string[]): Promise<TM.NativeTim.UsersInfo[]> {
    return V2TIMManager.getInstance()
      .getUsersInfo(array)
      .then((resultList: V2TIMUserFullInfo[]) => {
        const list = resultList.map(item => {
          const decoder = util.TextDecoder.create('utf-8')
          return {
            studentN: decoder.decodeToString(new Uint8Array(item.customInfo.get('studentN'))),
          } as TM.NativeTim.UsersInfo
        })
        return list
      })
      .catch((error: Error) => {
        return Promise.reject(error)
      })
  }

  muteGroupMember(groupID: string, userID: string, muteTime: number): Promise<void> {
    return V2TIMManager.getGroupManager().muteGroupMember(groupID, userID, muteTime)
  }

  muteAllGroupMembers(groupID: string, isMute: boolean): Promise<void> {
    return V2TIMManager.getGroupManager().muteAllGroupMembers(groupID, isMute)
  }

  addEventListener() {
    V2TIMManager.getMessageManager().addAdvancedMsgListener(this.advancedMsgListener)
    V2TIMManager.getInstance().addGroupListener(this.groupListener)
  }

  removeEventListener() {
    V2TIMManager.getMessageManager().removeAdvancedMsgListener(this.advancedMsgListener)
    V2TIMManager.getInstance().removeGroupListener(this.groupListener)
  }
}