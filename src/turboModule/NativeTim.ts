import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export const LISTENER_TYPE = {
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
};

export const MESSAGE_ELEM_TYPE = {
  TEXT: 1,
  CUSTOM: 2,
  IMAGE: 3,
  FILE: 6,
  FACE: 8,
  TIPS: 9,
};

export const MESSAGE_STATUS = {
  SENDING: 1, // 消息发送中
  SEND_SUCC: 2, // 消息发送成功
  SEND_FAIL: 3, // 消息发送失败
  HAS_DELETED: 4, // 消息被删除
  LOCAL_IMPORTED: 5, // 导入到本地的消息
  LOCAL_REVOKED: 6, // 被撤销的消息
};

export const MESSAGE_TYPE_ELEM = {
  TEXT: 'TIMTextElem',
  IMAGE: 'TIMImageElem',
  FACE: 'TIMFaceElem',
  FILE: 'TIMFileElem',
  CUSTOM: 'TIMCustomElem',
};
export interface HistoryMessageModel {
  msgID: string;
  userID: string;
  groupID: string;
  timestamp: string;
  elemType: number;
  msgStatus: number;
  textElem: string;
  faceElem: number;
  sender: string;
  nickName: string;
  customData: string;
  customElem: string;
  imageElem: {
    url: string;
    width: number;
    height: number;
  };
  fileElem: {
    fileName: string;
    fileSize: number;
    uuid: string;
  };
  groupTipsElem: {
    type: number;
    memberChanges: Array<{
      userID: string;
      muteTime: number;
    }>;
  };
}

export interface ConversationModel {
  conversationID: string;
  userID: string;
  groupID: string;
  showName: string;
  faceUrl: string;
  unreadCount: number;
  orderKey: number;
  timestamp: string;
  elemType: number;
  msgStatus: number;
  sender: string;
  nickName: string;
  textElem: string;
}

export interface JoinedGroupModel {
  groupID: string;
  groupName: string;
  faceUrl: string;
  createTime: string;
}

export interface GroupInfo {
  groupID: string;
  groupName: string;
  faceUrl: string;
}

export interface UsersInfo {
  studentN: string;
}

export interface Spec extends TurboModule {
  init(sdkAppID: number): void;

  unInit(): void;

  login(userID: string, userSig: string): Promise<void>;

  logout(): Promise<void>;

  getLoginStatus(): Promise<string>;

  sendTextMessage(
    text: string,
    receiver_userID: string,
    receiver_groupID: string,
    customData: string,
  ): Promise<void>;

  sendFaceMessage(
    faceIndex: number,
    receiver_userID: string,
    receiver_groupID: string,
    customData: string,
  ): Promise<void>;

  sendImageMessage(
    imagePath: string,
    receiver_userID: string,
    receiver_groupID: string,
    customData: string,
  ): Promise<void>;

  sendFileMessage(
    filePath: string,
    fileName: string,
    receiver_userID: string,
    receiver_groupID: string,
    customData: string,
  ): Promise<void>;

  revokeMessage(msgId: string): Promise<void>;

  previewFile(msgId: string): Promise<string>;

  getHistoryMessageList(
    lastMsgID: string,
    count: number,
    receiver_userID: string,
    receiver_groupID: string,
  ): Promise<HistoryMessageModel[]>;

  getConversationList(isC2C: boolean): Promise<ConversationModel[]>;

  deleteConversation(conversationID: string): Promise<void>;

  cleanConversationUnreadMessageCount(conversationID: string): Promise<void>;

  getUnreadMessageCountByFilter(isC2C: boolean): Promise<number>;

  deleteConversationList(array: string[], clearMessage: boolean): Promise<void>;

  getJoinedGroupList(): Promise<JoinedGroupModel[]>;

  getTotalUnreadMessageCount(): Promise<number>;

  getGroupsInfo(array: string[]): Promise<GroupInfo[]>;

  getUsersInfo(array: string[]): Promise<UsersInfo[]>;

  muteGroupMember(
    groupID: string,
    userID: string,
    muteTime: number,
  ): Promise<void>;

  muteAllGroupMembers(groupID: string, isMute: boolean): Promise<void>;
}

export const TimModule = TurboModuleRegistry.getEnforcing<Spec>('NativeTim');
