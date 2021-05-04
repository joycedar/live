//
//  KKLApiConfig.swift
//
//  Created by liwei on 16/12/25.
//  Copyright © 2016年 live. All rights reserved.
//  接口API

import UIKit

//业务服务器地址
let SERVER_HOST = "http://39.106.61.73:5000/admin"
//let SERVER_HOST = "http://10.238.29.176:5000/admin"

//图片服务器地址
let IMAGE_HOST = "http://img.meelive.cn/"

//热门直播
let API_HotLive = "rtmp://58.200.131.2:1935/livetv/cctv2"

//附近的人
let API_NearLive = "api/live/near_recommend"

//广告地址
let API_Advertise = "advertise/get"

//直播地址
let SW_RTMPSEVER = "rtmp://121.5.251.174:1935/live"


//1.0个人信息页面的接口
let  API_userProfileInfo = "getUserInfoByUid"


//2关注
//2.1返回用户的所有关注列表
let API_getAllUserListForRecommendByUid = "getAllUserListForRecommendByUid"
let API_getAllUserListForRecommend = "getAllUserListForRecommend"
//2.2关注用户
let API_followUserById = "followUserById"
//2.3关注主播的接口
let API_getFollwerRoomListById = "getFollwerRoomListById"

//3直播页面
let  API_getAllRoomList = "getAllRoomList"

//4动作

//4.2查询用户信息

let RTMPLIST = [
    "rtmp://58.200.131.2:1935/livetv/cctv1",
    "rtmp://58.200.131.2:1935/livetv/cctv2",
    "rtmp://58.200.131.2:1935/livetv/cctv3",
    "rtmp://58.200.131.2:1935/livetv/cctv4",
    "rtmp://58.200.131.2:1935/livetv/cctv5",
    "rtmp://58.200.131.2:1935/livetv/cctv6",
    "rtmp://58.200.131.2:1935/livetv/cctv7"
]


let CCTVNameList = [
    "CCTV1",
    "CCTV2",
    "CCTV3",
    "CCTV4",
    "CCTV5",
    "CCTV6",
    "CCTV7"
]
