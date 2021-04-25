from flask import Blueprint,request,jsonify,make_response,g,redirect,render_template
from common.libs.Helper import ops_render,iPagination,getCurrentDate
from common.libs.Helper import ( ops_render )
from common.libs.UrlManager import ( UrlManager )
from application import app,db
from common.models.User import User
from common.models.groupVoteRecord import GroupVoteRecord
from common.models.userVoteRecord import UserVoteRecord
import datetime
from common.libs.Helper import getFormatDate
from sqlalchemy import  or_
from sqlalchemy import  and_
import base64
import pickle

import json

route_admin = Blueprint( 'admin_page',__name__ )

@route_admin.route( "/analysis",methods = [ "GET","POST" ] )
def analysis():
    # -*- coding: utf-8 -*-
    if request.method == "GET":
        route_index = Blueprint('analysis_page', __name__)
    resp_data = {}
    return ops_render("admin/analysis.html", resp_data)



@route_admin.route( "/accountList",methods = [ "GET","POST" ] )
def accountList():
    resp_data = {}
    req = request.values
    page = int(req['p']) if ('p' in req and req['p']) else 1
    query = User.query

    if 'mix_kw' in req:
        rule = or_(User.nickname.ilike("%{0}%".format(req['mix_kw'])),
                   )
        query = query.filter(rule)

    if 'status' in req and int(req['status']) > -1:
        query = query.filter(User.status == int(req['status']))

    page_params = {
        'total': query.count(),#
        'page_size': app.config['PAGE_SIZE'],
        'page': page,
        'display': app.config['PAGE_DISPLAY'],
        'url': request.full_path.replace("&p={}".format(page), "")
    }

    pages = iPagination(page_params)
    offset = (page - 1) * app.config['PAGE_SIZE']
    limit = app.config['PAGE_SIZE'] * page

    list = query.order_by(User.uid.desc()).all()[offset:limit]

    resp_data['list'] = list
    resp_data['pages'] = pages
    resp_data['search_con'] = req
    resp_data['status_mapping'] = app.config['STATUS_MAPPING']

    return ops_render("admin/accountList.html", resp_data)

@route_admin.route( "/accountOps",methods = [ "GET","POST" ] )
def deleteAccount():
    resp = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values

    uid = req['uid'] if 'uid' in req else 0
    act = req['act'] if 'act' in req else ''

    if not uid:
        resp['code'] = -1
        resp['msg'] = "请选择要操作的账号"
        return jsonify(resp)

    if act not in ['remove', 'recover']:
        resp['code'] = -1
        resp['msg'] = "操作有误，请重试"
        return jsonify(resp)

    user_info = User.query.filter_by(uid=uid).first()

    if not user_info:
        resp['code'] = -1
        resp['msg'] = "指定账号不存在"
        return jsonify(resp)

    if act == "remove":
        user_info.status = 0
    elif act == "recover":
        user_info.status = 1

    db.session.add(user_info)
    db.session.commit()
    return jsonify(resp)

#查询个人信息
@route_admin.route( "/getUserInfoByUid" ,methods = [ "GET" ])
def getUserInfoById():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values
    uid = req['uid']
    userList = User.query.filter_by(uid=uid,status=1).first()

    if userList.follows != None :
        userList.follows = pickle.dumps(userList.follows)
    if userList.fans != None :
        userList.fans = pickle.dumps(userList.fans)

    list = {
        'name':userList.nickname,
        'fansCount':userList.fansNumber,
        'followsCount':userList.followNumber,
    }

    resp_data['data'] = list

    if not userList:
        resp_data['code'] = 201
        resp_data['msg'] = "note such user"
        return jsonify(resp_data)
    return jsonify(resp_data)


@route_admin.route( "/followUserById",methods = [ "GET","POST" ] )
def followUserById():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values
    followId = req['followId']
    userId = req['userId']

    follower = User.query.filter_by(uid=followId).first()
    user = User.query.filter_by(uid=userId).first()


    if follower.fans != None :
        followFansList = json.loads(follower.fans)
    else :
        followFansList = []
    followFansList.append(user.uid)
    follower.fansNumber += 1
    follower.fans = json.dumps(followFansList).encode('utf8')

    if user.follows != None :
        userFollowList = json.loads(user.follows)
    else :
        userFollowList = []
    userFollowList.append(follower.uid)
    user.followNumber += 1
    user.follows = json.dumps(userFollowList).encode('utf8')


    db.session.add(follower)
    db.session.commit()
    db.session.add(user)
    db.session.commit()

    return jsonify(resp_data)

#关注页页面
@route_admin.route( "/getAllUserListForRecommend",methods = [ "GET","POST" ] )
def getAllUserListForRecommend():
    resp_data = {'code': 200, 'msg': 'sucess for getAllUserListForRecommend'}
    userList = User.query.order_by(User.fansNumber.desc()).all()
    targetUserInfoList = []
    if userList:
        for user in userList :
            targetUserInfoList.append({
                'name': user.nickname,
                'introduction': user.introduction,
                'avatarUrl': user.avatar
            })
    resp_data['data'] = targetUserInfoList
    print(resp_data)
    return jsonify(resp_data)


#获取关注页面的人
@route_admin.route( "/getFollowListById",methods = [ "GET","POST" ] )
def getFollowListById():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values
    uid = req['uid']
    user = User.query.filter_by(uid=uid).first()
    targetFollowList = []
    #获取关注人的序列号
    followerUids = json.loads(user.follows)

    # 获取关注人的信息
    for followerUid in followerUids:
        follower = User.query.filter_by(uid=followerUid).first()
        targetFollowList.append({
            'name':follower.nickname,
            'introduction':follower.introduction,
            'avatarUrl':follower.avatar
        })
    resp_data['data'] = targetFollowList
    return jsonify(resp_data)


#获取粉丝列表
@route_admin.route("/getFansListById", methods=["GET", "POST"])
def getFansListById():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values
    uid = req['uid']
    user = User.query.filter_by(uid=uid).first()
    targetFansList = []
    #获取关注人的序列号
    fansUids = json.loads(user.fans)

    # 获取关注人的信息
    for followerUid in fansUids:
        follower = User.query.filter_by(uid=followerUid).first()
        targetFansList.append({
            'name':follower.nickname,
            'introduction':follower.introduction,
            'avatarUrl':follower.avatar
        })
    resp_data['data'] = targetFansList
    return jsonify(resp_data)


#获取房间列表
@route_admin.route("/getAllRoomList", methods=["GET", "POST"])
def getAllRoomList():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values

    allRoomList = User.query.order_by(User.roomWatchingNumber.desc()).all()
    roomWithUrlList = []
    for room in allRoomList:
        if room.roomUrl != None:
            roomWithUrlList.append(room)

    roomList = []

    if roomWithUrlList:
        for user in roomWithUrlList:
           # if follower.liveRoom == None:
           roomList.append({
               'name':user.nickname,
               'roomImage':user.roomImage,
               'roomUrl':user.roomUrl,
               'roomName':user.roomName
           })
    else:
        resp_data['code'] = 201
        resp_data['msg']= "not live Room at all "
        return resp_data

    resp_data['data'] = roomList
    return jsonify(resp_data)


#获取关注人的房间列表
@route_admin.route("/getFollwerRoomListById", methods=["GET", "POST"])
def getFollwerRoomListById():
    resp_data = {}
    req = request.values
    uid = req['uid']

    user = User.query.filter_by(uid = uid).first()
    if user.follows:
        followerIdList = json.loads(user.follows)
    else:
        resp_data['code'] = 202
        resp_data['msg'] = "now FollowerList"
        return jsonify(resp_data)

    targetFollowInfoList = []

    for followId in followerIdList:
        follow = User.query.filter_by(uid = followId).first()
        if follow.roomUrl != None :
            targetFollowInfoList.append({
                'nickName':follow.nickname,
                'avatar':follow.avatar,
                'roomName':follow.roomName,
                'roomImage':follow.roomImage,
                'roomUrl':follow.roomUrl
            })

    if targetFollowInfoList:
        resp_data = {'code': 200, 'msg': 'sucuess', 'data': {}}
        resp_data['data'] = targetFollowInfoList
    else:
        resp_data['code'] = 201
        resp_data['msg']= "not follower's live Room at all "
        return resp_data

    return jsonify(resp_data)




@route_admin.route("/createLiveRoombyUid", methods=["GET", "POST"])
def createLiveRoombyUid():
    resp_data = {}
    req = request.values
    uid = req['uid']

    roomUrl = req['roomUrl']
    roomImage = req['roomIamge']
    roomImage = json.dump(roomImage)
    roomName = req['roomName']

    user = User.query.filter_by(uid = uid).first()
    user.roomUrl = roomUrl
    user.roomImage = roomImage
    user.roomName = roomName

    db.session.add(user)
    db.session.commit()

    resp_data['code'] = 200
    resp_data['msg'] = "sucess to create"
    return jsonify(resp_data)


@route_admin.route("/assignManagerListByUserId", methods=["GET", "POST"])
def assignManagerListById():
    resp_data = {}
    req = request.values
    userId = req['uid']
    toAuthorId = req['toAuthorId']

    user = User.query.filter_by(uid=userId).first()
    if user.managerIdentification:
        managerList = json.loads(user.managerIdentification)
    else:
        managerList = []
    managerList.append(toAuthorId)
    managerList = json.dumps(managerList)

    user.managerIdentification = managerList

    db.session.add(user)
    db.session.commit()

    resp_data['code'] = 200
    resp_data['msg'] = "sucess to create"
    return jsonify(resp_data)


@route_admin.route("/resignManagerListByUserId", methods=["GET", "POST"])
def resignManagerListByUserId():
    resp_data = {}
    req = request.values
    userId = req['userId']
    toResignId = req['toResignId']

    user = User.query.filter_by(uid=toResignId).first()
    managerList = json.loads(user.managerIdentification)

    for (index,managerId) in enumerate(managerList) :
        if managerId == userId:
            print("🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠")
            print(index)
            print(managerId)
            managerList.remove(index)
    #删除某个值
    managerList = json.dumps(managerList)

    user.managerIdentification = managerList

    db.session.add(user)
    db.session.commit()

    resp_data['code'] = 200
    resp_data['msg'] = "sucess to create"
    return jsonify(resp_data)


#发布群投票
@route_admin.route( "/postVote",methods = ["POST" ] )
def postVote():
    resp = {}
    req = request.values

    group_id = req['group_id'] if 'group_id' in req else ''
    topic = req['topic'] if 'topic' in req else ''
    options = req['options'] if 'options' in req else ''
    is_mult_select = req['is_mult_select'] if 'is_mult_select' in req else ''

    groupVote = GroupVoteRecord()

    groupVote.group_id = group_id
    groupVote.topic = topic
    groupVote.options = options
    groupVote.is_mult_select = is_mult_select


    db.session.add(groupVote)
    db.session.commit()
    resp = {'code': 200, 'msg': 'sucess to creat groupVote', 'data': {}}
    return jsonify(resp)

#查看投票详情
@route_admin.route( "/getGroupVoteDetailById",methods = [ "GET","POST" ] )
def getGroupVoteDetailById():
    resp = {}
    req = request.values

    group_id = req['id'] if 'id' in req else ''

    groupVoteDetail = {}
    groupVoteInfo = GroupVoteRecord.query.filter_by(id=id).first()
    if groupVoteInfo:
        groupVoteDetail = {
            'id': groupVoteInfo.id,
            'create_user_name':  groupVoteInfo.create_user_name,
            'create_user_avatar': groupVoteInfo.create_user_avatar,
            'topic': groupVoteInfo.topic,
            'options':groupVoteInfo.options,
            'is_multSelect':groupVoteInfo.is_multSelect,
            'is_anonymous':groupVoteInfo.is_anonymous,
            'is_vote':groupVoteInfo.is_vote
        }
    else:
        resp = {'code': 201,
                'msg': 'not find any group match id',
                'data': {}}

    resp = {'code': 200,
            'msg': 'sucess to getDetail groupVote',
            'data': groupVoteDetail}
    return jsonify(resp)

#参与投票
@route_admin.route( "/userVote",methods = [ "GET","POST" ] )
def trainInfoSet():
    req = request.values

    vote_id = req['vote_id'] if 'vote_id' in req else ''
    group_id = req['group_id'] if 'group_id' in req else ''
    userOptions = req['options'] if 'options' in req else ''

    userVoteRecord = UserVoteRecord()
    #userOptions
    # {
    #     "id": "1",
    #     "option": "雅诗兰黛"
    # }
    userVoteRecord.vote_id = vote_id
    userVoteRecord.group_id = group_id
    userVoteRecord.options = userOptions
    db.session.add(userVoteRecord)
    db.session.commit()

    # {
    #     "id": 1,
    #     "option": "雅诗兰黛",
    #     "vote_num": 0,
    #     "is_vote": false
    # }

    groupVoteInfo = GroupVoteRecord.query.filter_by(group_id=group_id)

    userOptions = json.loads(userOptions)
    vote_num = groupVoteInfo.vote_num + 1
    option_id = userOptions['id']
    GroupOptions = {
        'id':userOptions['id'],
        'option':userOptions['options']['option'],
        'vote_num': vote_num
    }

    for (index,groupOption) in enumerate(json.loads(groupVoteInfo.options)):
        if groupOption['id'] == userOptions['id']:
            groupOption['vote_num'] += 1
            #替换
            groupVoteInfo[index] = json.dumps(groupOption)

    db.session.add(groupVoteInfo)
    db.session.commit()

    resp = {'code': 200, 'msg': 'sucess to Vote'}
    return jsonify(resp)



#查看投票详情
@route_admin.route( "/getAllGroupListByGroupId",methods = [ "GET","POST" ] )
def getAllGroupListByGroupId():
    resp = {}
    req = request.values

    group_id = req['group_id'] if 'group_id' in req else ''

    targetGroupVoteList = {}
    groupVoteInfoList = GroupVoteRecord.query.filter_by(group_id=group_id).all()
    if groupVoteInfoList:
        for groupVoteInfo in groupVoteInfoList:
            targetGroupVoteList.append({
                'id': groupVoteInfo.id,
                'create_user_name':  groupVoteInfo.create_user_name,
                'create_user_avatar': groupVoteInfo.create_user_avatar,
                'topic': groupVoteInfo.topic,
                'options':groupVoteInfo.options,
                'is_multSelect':groupVoteInfo.is_multSelect,
                'is_anonymous':groupVoteInfo.is_anonymous,
                'is_vote':groupVoteInfo.is_vote
            })
    else:
        resp = {'code': 201,
                'msg': 'not find any group match id',
                'data': {}}

    resp = {'code': 200,
            'msg': 'sucess to getDetail groupVote',
            'data': targetGroupVoteList}
    return jsonify(resp)
