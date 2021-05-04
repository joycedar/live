//
//  SWMacro.swift
//
//  Created by cedar on 2021/5/3.
//  Copyright © 2021 live. All rights reserved.
//

import UIKit

class SWMacro: NSObject {

}


//
//  EMDefines.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2019/2/11.
//  Copyright © 2019 XieYajie. All rights reserved.
//




//appkey
let DEF_APPKEY = "1137210426091189#demo"


let RTC_BUTTON_WIDTH =  65
let RTC_BUTTON_HEIGHT =  90

let EMSYSTEMNOTIFICATIONID = "emsystemnotificationid"

//会话
let CONVERSATION_STICK = "stick"
let CONVERSATION_ID = "conversationId"
let CONVERSATION_OBJECT = "conversationObject"

//账号状态
let ACCOUNT_LOGIN_CHANGED  = "loginStateChange"
let NOTIF_NAVICONTROLLER = "EMNaviController"
let NOTIF_ID = "EMNotifId"

//聊天
let CHAT_PUSHVIEWCONTROLLER = "EMPushChatViewController"
let CHAT_CLEANMESSAGES = "EMChatCleanMessages"
let CHAT_BACKOFF = "EMChatBackOff"

//通话
let EMCOMMMUNICATE_RECORD = "EMCommunicateRecord" //本地通话记录
let EMCOMMMUNICATE = "EMCommunicate" //远端通话记录
let EMCOMMUNICATE_TYPE = "EMCommunicateType"
let EMCOMMUNICATE_TYPE_VOICE = "EMCommunicateTypeVoice"
let EMCOMMUNICATE_TYPE_VIDEO = "EMCommunicateTypeVideo"
let EMCOMMUNICATE_DURATION_TIME = "EMCommunicateDurationTime"

//通话状态
let EMCOMMUNICATE_MISSED_CALL = "EMCommunicateMissedCall" //（通话取消）
let EMCOMMUNICATE_CALLER_MISSEDCALL = "EMCommunicateCallerMissedCall" //（我方取消通话）
let EMCOMMUNICATE_CALLED_MISSEDCALL = "EMCommunicateCalledMissedCall" //（对方拒绝接通）
//发起邀请
let EMCOMMUNICATE_CALLINVITE = "EMCommunicateCallInvite" //（发起通话邀请）
//通话发起方
let EMCOMMUNICATE_DIRECTION = "EMCommunicateDirection"
let EMCOMMUNICATE_DIRECTION_CALLEDPARTY = "EMCommunicateDirectionCalledParty"
let EMCOMMUNICATE_DIRECTION_CALLINGPARTY = "EMCommunicateDirectionCallingParty"

//消息动图
let MSG_EXT_GIF_ID = "em_expression_id"
let MSG_EXT_GIF = "em_is_big_expression"

let MSG_EXT_READ_RECEIPT = "em_read_receipt"

//消息撤回
let MSG_EXT_RECALL = "em_recall"

//新通知
let MSG_EXT_NEWNOTI = "em_noti"

//加群/好友 成功
let NOTIF_ADD_SOCIAL_CONTACT = "EMAddSocialContact"

//加群/好友 类型
let NOTI_EXT_ADDFRIEND = "add_friend"
let NOTI_EXT_ADDGROUP = "add_group"

//多人会议邀请
let MSG_EXT_CALLOP = "em_conference_op"
let MSG_EXT_CALLID = "em_conference_id"
let MSG_EXT_CALLPSWD = "em_conference_password"

//
//群组消息ext的字段，用于存放被的环信id数组
let MSG_EXT_AT = "em_at_list"
//群组消息ext字典中，kGroupMessageAtList字段的值，用于所有人
let MSG_EXT_ATALL = "all"

//Typing
let MSG_TYPING_BEGIN = "TypingBegin"
let MSG_TYPING_END = "TypingEnd"

let kHaveUnreadAtMessage   = "kHaveAtMessage"
let kAtYouMessage  =  1
let kAtAllMessage  =  2

//实时音视频
let CALL_CHATTER = "chatter"
let CALL_TYPE = "type"
let CALL_PUSH_VIEWCONTROLLER = "EMPushCallViewController"
//实时音视频1v1呼叫
let CALL_MAKE1V1 = "EMMake1v1Call"
//实时音视频多人
let CALL_MODEL = "EMCallForModel"
let CALL_MAKECONFERENCE = "EMMakeConference"
let CALL_SELECTCONFERENCECELL = "EMSelectConferenceCell"
let CALL_INVITECONFERENCEVIEW = "EMInviteConverfenceView"

//用户黑名单
let CONTACT_BLACKLIST_UPDATE = "EMContactBlacklistUpdate"
let CONTACT_BLACKLIST_RELOAD = "EMContactReloadBlacklist"

//群组
let GROUP_LIST_PUSHVIEWCONTROLLER = "EMPushGroupsViewController"
let GROUP_INFO_UPDATED = "EMGroupInfoUpdated"
let GROUP_SUBJECT_UPDATED = "EMGroupSubjectUpdated"
let GROUP_INFO_REFRESH = "EMGroupInfoRefresh"
let GROUP_INFO_PUSHVIEWCONTROLLER = "EMPushGroupInfoViewController"
let GROUP_INFO_CLEARRECORD = "EMGroupInfoClearRecord"
let GROUP_LIST_FETCHFINISHED = "EMGroupListFetchFinished"

//聊天室
let CHATROOM_LIST_PUSHVIEWCONTROLLER = "EMPushChatroomsViewController"
let CHATROOM_INFO_UPDATED = "EMChatroomInfoUpdated"
let CHATROOM_INFO_PUSHVIEWCONTROLLER = "EMPushChatroomInfoViewController"

//用户属性更新
let USERINFO_UPDATE = "EMUserInfoUpdated"

//确认发送名片消息
let CONFIRM_USERCARD = "EMUserCardConfirm"


