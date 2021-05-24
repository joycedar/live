from flask import Blueprint,request,jsonify,make_response,g,redirect,render_template
from common.libs.Helper import ops_render,iPagination,getCurrentDate
from common.libs.Helper import ( ops_render )
from common.libs.UrlManager import ( UrlManager )
from application import app,db
from common.models.User import User
from common.models.present import Present
from common.models.room import Room
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

@route_admin.route( "/login",methods = [ "GET" ] )
def llogin():

    resp = {'code': 200, 'msg': '登录成功', 'data': {}}
    req = request.values
    login_name = req['login_name'] if 'login_name' in req else ''
    login_pwd = req['login_pwd'] if 'login_pwd' in req else ''

    info = User.query.filter_by( nickname = login_name ).first()

    if not info:
        resp['code'] = 1
        resp['msg'] = "不存在该账户信息"
        return jsonify(resp)

    if info.password != login_pwd:
        resp['code'] = 2
        resp['msg'] = "请输入正确的密码"
        return jsonify(resp)

    if info.status != 3:
        resp['code'] = -1
        resp['msg'] = "账号已被禁用，请联系管理员处理"
        return jsonify(resp)

    resp['data'] = info
    return jsonify(resp)

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
    print(followId)
    print(userId)

    follower = User.query.filter_by(uid=followId).first()
    user = User.query.filter_by(uid=userId).first()

    if follower.fans != None :
        followFansList = json.loads(follower.fans)
        if userId in followFansList:
            resp_data['msg'] = "follower already in the follower"
            return jsonify(resp_data)
    else :
        followFansList = []
    followFansList.append(user.uid)
    follower.fansNumber += 1
    follower.fans = json.dumps(followFansList).encode('utf8')

    if user.follows != None :
        userFollowList = json.loads(user.follows)
        if followId in userFollowList:
            resp_data['msg'] = "fans already in fanslist"
            return jsonify(resp_data)
    else :
        userFollowList = []
    userFollowList.append(follower.uid)
    user.followNumber += 1
    user.follows = json.dumps(userFollowList).encode('utf8')


    db.session.add(follower)
    db.session.add(user)
    db.session.commit()

    return jsonify(resp_data)


@route_admin.route( "/presentList",methods =  ["GET","POST"] )
def presentList():
    resp_data = {}
    req = request.values
    page = int(req['p']) if ('p' in req and req['p']) else 1
    query = Present.query

    if 'mix_kw' in req:
        rule = or_(Present.presentId.ilike("%{0}%".format(req['mix_kw'])),
                   )
        query = query.filter(rule)

    if 'status' in req and int(req['status']) > -1:
        query = query.filter(Present.status == int(req['status']))

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

    list = query.order_by(Present.presentId).all()[offset:limit]

    resp_data['list'] = list
    resp_data['pages'] = pages
    resp_data['search_con'] = req
    resp_data['status_mapping'] = app.config['STATUS_MAPPING']

    return ops_render("admin/presentList.html", resp_data)
    return


@route_admin.route( "/presentOps",methods =  ["POST"] )
def presentOps():
    resp = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values

    presentId = req['presentId'] if 'presentId' in req else 0
    act = req['act'] if 'act' in req else ''

    if not presentId:
        resp['code'] = -1
        resp['msg'] = "请选择要操作的礼物"
        return jsonify(resp)

    if act not in ['remove', 'recover']:
        resp['code'] = -1
        resp['msg'] = "操作有误，请重试"
        return jsonify(resp)

    present_info = Present.query.filter_by(presentId=presentId).first()

    if not present_info:
        resp['code'] = -1
        resp['msg'] = "指定账号不存在"
        return jsonify(resp)

    if act == "remove":
        present_info.status = 0
    elif act == "recover":
        present_info.status = 1

    db.session.add(present_info)
    db.session.commit()
    return jsonify(resp)
    return


@route_admin.route( "/presentAdd",methods =  ["GET","POST"] )
def presentAdd():
    if request.method == "GET":
        resp_data = {}
        req = request.args
        presentId = req["presentId"]
        info = None
        if presentId :
            presentInfo = Present.query.filter_by( presentId = presentId ).first()
        else:
            presentInfo = Present()
        resp_data['info'] = presentInfo
        return ops_render( "admin/presentAdd.html",resp_data )

    resp = { 'code':200,'msg':'操作成功~~','data':{} }
    req = request.values

    presentId = req['presentId'] if 'presentId' in req else 0
    presentName = req['presentName'] if 'presentName' in req else ''
    money = req['money'] if 'money' in req else ''


    if presentName is None or len( presentName ) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的礼物~~"
        return jsonify( resp )

    if money is None or len( money ) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入合理的金钱数目"
        return jsonify( resp )



    present_info = Present.query.filter_by( presentId = presentId ).first()
    if present_info:
        new_model = present_info
    else:
        new_model = Present()

    new_model.prsentName = presentName
    new_model.money = money
    print("已经创建了一个礼物记录了～🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸🌸")
    print(new_model.prsentName)
    print(new_model.money)

    db.session.add( new_model )
    db.session.commit()
    return jsonify(resp)



@route_admin.route( "/roomList",methods =  ["GET","POST"] )
def roomList():
    resp_data = {}
    req = request.values
    page = int(req['p']) if ('p' in req and req['p']) else 1
    query = Room.query

    if 'mix_kw' in req:
        rule = or_(Room.roomId.ilike("%{0}%".format(req['mix_kw'])),
                   )
        query = query.filter(rule)

    if 'status' in req and int(req['status']) > -1:
        query = query.filter(Room.status == int(req['status']))

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

    list = query.order_by(Room.uid).all()[offset:limit]

    resp_data['list'] = list
    resp_data['pages'] = pages
    resp_data['search_con'] = req
    resp_data['status_mapping'] = app.config['STATUS_MAPPING']

    return ops_render("admin/roomList.html", resp_data)
    return


@route_admin.route( "/roomOps",methods =  ["GET","POST"] )
def roomOps():

    resp = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values

    roomId = req['roomId'] if 'roomId' in req else 0
    act = req['act'] if 'act' in req else ''
    print("roomId")
    if not roomId:
        resp['code'] = -1
        resp['msg'] = "请选择要操作的房间"
        return jsonify(resp)

    if act not in ['remove', 'recover']:
        resp['code'] = -1
        resp['msg'] = "操作有误，请重试"
        return jsonify(resp)

    room_info = Room.query.filter_by(roomId=roomId).first()

    if not room_info:
        resp['code'] = -1
        resp['msg'] = "指定账号不存在"
        return jsonify(resp)

    if act == "remove":
        room_info.status = 0
    elif act == "recover":
        room_info.status = 1

    print("删除啦～～～🔥删除啦～～～🔥删除啦～～～🔥删除啦～～～🔥删除啦～～～🔥删除啦～～～🔥")
    db.session.add(room_info)
    db.session.commit()
    return jsonify(resp)
    return

#关注页页面
@route_admin.route( "/getAllUserListForRecommendByUid",methods = [ "GET","POST" ] )
def getAllUserListForRecommend():
    resp_data = {'code': 200, 'msg': 'sucess for getAllUserListForRecommend'}
    req = request.values
    print(req)
    uid = req['uid']
    print(uid)
    userList = User.query.order_by(User.fansNumber.desc()).all()
    targetUserInfoList = []

    #获取自己关注的列表
    user = User.query.filter_by(uid=uid).first()
    followerUids = json.loads(user.follows)


    if userList:
        for user in userList :
            if user.uid == uid:
                continue
            if user.uid in followerUids:
                continue
            targetUserInfoList.append({
                'uid':user.uid,
                'name': user.nickname,
                'introduction': user.introduction,
                'avatarUrl': user.avatar
            })
    resp_data['data'] = targetUserInfoList
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

    allRoomListWithCCTV = Room.query.filter(Room.status != 3)
    allRoomList = allRoomListWithCCTV.order_by(Room.roomWatchingNumber.desc()).all()


    roomWithUrlList = []
    for room in allRoomList:
        if room.roomUrl != None:
            roomWithUrlList.append(room)
    roomList = []

    if roomWithUrlList:
        for room in roomWithUrlList:
           roomList.append({
               'uid':room.uid,
               'name':room.name,
               'roomUrl':room.roomUrl,
               'roomName':room.roomName,
               'roomDescription':room.roomDescription
           })
    else:
        resp_data['code'] = 201
        resp_data['msg']= "not live Room at all "
        return resp_data

    resp_data['data'] = roomList
    return jsonify(resp_data)

@route_admin.route("/closeRoom", methods=["GET", "POST"])
def closeRoom():
    resp_data = {'code': 200, 'msg': '操作成功', 'data': {}}
    req = request.values

    allRoomList = Room.query.order_by(Room.roomWatchingNumber.desc()).all()
    roomWithUrlList = []
    for room in allRoomList:
        if room.roomUrl != None:
            roomWithUrlList.append(room)

    roomList = []

    if roomWithUrlList:
        for room in roomWithUrlList:
           # if follower.liveRoom == None:
           roomList.append({
               'uid':room.uid,
               'name':room.name,
               'roomImage':room.roomImage,
               'roomUrl':room.roomUrl,
               'roomName':room.roomName,
               'roomDescription':room.introduction
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
                'roomUrl':follow.roomUrl,
                'uid':follow.uid
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



@route_admin.route( "/postBarrageById",methods = [ "GET","POST" ] )
def postBarrange():
    resp = {}
    req = request.values
    barrage = req['barrage'] if 'barrage' in req else ''
    #实现敏感词过滤,实现
    resp['code'] = 200
    return jsonify(resp)


@route_admin.route("/searchRoomListByName", methods=["GET", "POST"])
def searchRoomListByName():
    resp_data = {}
    req = request.values
    #模糊查找
    query = Room.query
    rule = or_(Room.roomName.ilike("%{0}%".format(req['keyword'])),
               )
    rooms = query.filter(rule)
    searchResult = rooms.order_by(Room.roomWatchingNumber.desc()).all()

    #生成返回对象
    targetRoomList = []
    for room in searchResult:
        targetRoomList.append({
            'uid': room.uid,
            'name': room.name,
            'roomUrl': room.roomUrl,
            'roomName': room.roomName,
            'roomDescription': room.roomDescription
        })

    if targetRoomList:
        resp_data = {'code': 200, 'msg': 'sucuess', 'data': {}}
        resp_data['data'] = targetRoomList
    else:
        resp_data['code'] = 201
        resp_data['msg']= "not follower's live Room at all "
        return resp_data
    return resp_data


@route_admin.route( "/register",methods =  ["GET","POST"] )
def register():
    resp = { 'code':200,'msg':'操作成功~','data':{} }
    req = request.values

    name = req['name'] if 'name' in req else ''
    password = req['password'] if 'password' in req else ''

    user_info  = User()

    user_info.nickname = name
    user_info.password = password

    db.session.add( user_info )
    db.session.commit()

    return jsonify(resp)


@route_admin.route( "/getUserInfoByNameAndPasword",methods =  ["GET","POST"] )
def getUserInfoByNameAndPasword():
    resp = { 'code':200,'msg':'操作成功~','data':{} }
    req = request.values
    name = req['name'] if 'name' in req else ''
    password = req['password'] if 'password' in req else ''
    user_info = User.query.filter_by(nickname = name,password=password).first()

    resp['data']=user_info
    return jsonify(resp)


@route_admin.route( "/createRoom",methods = ["POST" ] )
def postVote():
    resp = {}
    req = request.values

    uid = req['uid'] if 'uid' in req else ''
    roomName = req['roomName'] if 'roomName' in req else ''
    roomDescrption = req['roomDescrption'] if 'roomDescrption' in req else ''
    roomUrl = ""
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