from flask import Blueprint,request,jsonify,make_response,g,redirect,render_template,json
from common.libs.Helper import ops_render,iPagination,getCurrentDate
from common.libs.Helper import ( ops_render )
from common.libs.UrlManager import ( UrlManager )
from application import app,db
from common.models.Admin import Admin
from common.models.User import User
from common.models.ticket import  Ticket
from common.models.TrainInfo import TrainInfo
from sqlalchemy import  and_
from common.libs.user.UserService import *
import datetime

route_user = Blueprint( 'user_page',__name__ )

@route_user.route( "/register",methods =  ["POST"] )
def register():
    resp = { 'code':200,'msg':'操作成功~','data':{} }
    req = request.values

    name = req['name'] if 'name' in req else ''
    password = req['password'] if 'password' in req else ''
    identification = req['identification'] if 'identification' in req else ''
    gender = req['gender'] if 'gender' in req else ''

    if name is None or len( name ) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的姓名"
        return jsonify( resp )

    if password  is None or len(password) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的密码"
        return jsonify(resp)

    if identification  is None or len(identification) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的身份证号码"
        return jsonify(resp)

    if gender  is None or len(password) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的性别"
        return jsonify(resp)

    user_info  = User()

    user_info.name = name
    user_info.password = password
    user_info.identification = identification
    user_info.sex = gender

    db.session.add( user_info )
    db.session.commit()
    return jsonify(resp)


@route_user.route( "/reset-pwd",methods = ["POST"] )
def resetPwd():
    resp = {'code': 200, 'msg': '操作成功~', 'data': {}}
    req = request.values

    old_password = req['old_password'] if 'old_password' in req else ''
    new_password = req['new_password'] if 'new_password' in req else ''

    if old_password is None or len( old_password ) < 6:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的原密码~~"
        return jsonify(resp)

    if new_password is None or len( new_password ) < 6:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的新密码~~"
        return jsonify(resp)

    if old_password == new_password:
        resp['code'] = -1
        resp['msg'] = "请重新输入一个吧，新密码和原密码不能相同哦~~"
        return jsonify(resp)

    user_info = g.current_user

    if user_info.uid == 1:
        resp['code'] = -1
        resp['msg'] = "该用户是演示账号，不准修改密码和登录用户名~~"
        return jsonify(resp)

    user_info.password = new_password

    db.session.add( user_info )
    db.session.commit()

    response = make_response(json.dumps( resp ))
    return response

#查询个人信息
@route_user.route( "/getUserInfoByUid" ,methods = [ "GET" ])
def getUserInfoById():
    resp_data = {}
    req = request.values
    uid = req['uid']
    userList = User.query.filter_by(uid=uid,status=1).first()

    resp_data['list'] = userList
    return resp_data


    if not userInfo:
        resp['code'] = -1
        resp['msg'] = "指定的账户不存在"
        return jsonify(resp)
    db.session.commit()
    return jsonify(resp)


@route_user.route( "/ticketOps" ,methods = [ "GET","POST" ])
def ticketManager():
    if request.method == "GET":
        resp_data = {}
        req = request.values
        query = Ticket.query

        # 查询所有订单信息
        ticketList = Ticket.query.filter_by(uid=g.current_user.uid,status=0).all()
        rule  = and_(Ticket.uid==g.current_user.uid,
                     Ticket.status==0)
        query = query.filter(rule)

        page = int(req['p']) if ('p' in req and req['p']) else 1
        page_params = {
            'total': query.count(),
            'page_size': app.config['PAGE_SIZE'],
            'page': page,
            'display': app.config['PAGE_DISPLAY'],
            'url': request.full_path.replace("&p={}".format(page), "")
        }
        pages = iPagination(page_params)
        offset = (page - 1) * app.config['PAGE_SIZE']
        limit = app.config['PAGE_SIZE'] * page
        resp_data['list'] = ticketList
        resp_data['pages'] = pages
        resp_data['search_con'] = req
        resp_data['status_mapping'] = app.config['STATUS_MAPPING']
        return ops_render("user/ticketOps.html",resp_data)
    #下面是删除订单信息
    resp = {'code': 200, 'msg': '操作成功~~', 'data': {}}
    req = request.values
    id = req['id'] if 'id' in req else 0
    act = req['act'] if 'act' in req else ''

    if not id:
        resp['code'] = -1
        resp['msg'] = "请选择要操作的订单编号~~"
        return jsonify(resp)

    if act not in ['remove']:
        resp['code'] = -1
        resp['msg'] = "操作有误，请重试~~"
        return jsonify(resp)

    ticket = Ticket.query.filter_by(id=id).first()

    if not ticket:
        resp['code'] = -1
        resp['msg'] = "指定的票不存在"
        return jsonify(resp)
    #删除订单
    ticket.status = 1


    db.session.add(ticket)
    db.session.commit()



    trainId = ticket.trainId
    seatCategory = ticket.seatCategory
    trainInfo = TrainInfo.query.filter_by(id=trainId).first()
    if seatCategory=="一等座":
        trainInfo.restFirstClassSeat = trainInfo.restFirstClassSeat+1
    elif seatCategory == "二等座":
        trainInfo.restSecondClassSeat = trainInfo.restSecondClassSeat+1
    elif seatCategory =="硬卧":
        trainInfo.restHardSeat = trainInfo.restHardSeat+1
    else:
        trainInfo.restSoftSeat = trainInfo.restSoftSeat+1

    db.session.add(trainInfo)
    db.session.commit()

    return jsonify(resp)


@route_user.route("/ticketBook",methods = ["GET","POST"])
def ticketList():
    if request.method == "GET":
        req = request.values
        id =  req['id']
        query = TrainInfo.query
        resp_data={}
        list = query.filter(TrainInfo.id==id).first()
        resp_data['list'] = list
        return ops_render("user/ticketBook.html", resp_data)

    resp = {'code': 200, 'msg': '操作成功~', 'data': {}}
    req = request.values

    trainId = req['trainId'] if 'trainId' in req else ''
    date = req['date'] if 'date' in req else ''
    fromStation = req['fromStation'] if 'fromStation' in req else ''
    terminal = req['terminal'] if 'terminal' in req else ''
    identification = req['identification'] if 'identification' in req else ''
    name = req['name'] if 'name' in req else ''
    phone = req['phone'] if 'phone' in req else ''
    category = req['category'] if 'category' in req else ''
    leaveTime = req['leaveTime'] if 'leaveTime' in req else ''
    seatCategory = req['seatCategory'] if 'seatCategory' in req else ''

    if trainId is None or len(trainId) < 1:
        resp['code'] = -1
        resp['msg'] = "请选择正确的车次号~"
        return jsonify(resp)
    if date is None or len(date) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的日期~~"
        return jsonify(resp)
    if category is None or len(category) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的火车类型~~"
        return jsonify(resp)
    if fromStation is None or len(fromStation) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的起始站~~"
        return jsonify(resp)
    if terminal is None or len(terminal)<1:
        resp['code'] = -1
        resp['msg'] = "请输入终点站~~"
        return jsonify(resp)
    if seatCategory is None:
        resp['code'] = -1
        resp['msg'] = "请座位类别~~"
        return jsonify(resp)

    #车票减少1
    trainInfo = TrainInfo.query.filter_by(id = trainId).first()

    if seatCategory == "一等座":
        trainInfo.restFirstClassSeat=trainInfo.restFirstClassSeat-1;
        if trainInfo.restFirstClassSeat<0:
            resp['code'] = -1
            resp['msg'] = "一等座已被订购完"
            return jsonify(resp)
    if seatCategory == "二等座":
        trainInfo.restSecondClassSeat=trainInfo.restSecondClassSeat-1;
        if trainInfo.restSecondClassSeat<0:
            resp['code'] = -1
            resp['msg'] = "二等座已被订购完"
            return jsonify(resp)
    if seatCategory == "硬卧":
        trainInfo.restHardSeat=trainInfo.restHardSeat-1;
        if trainInfo.restHardSeat<0:
            resp['code'] = -1
            resp['msg'] = "硬座已被订购完"
            return jsonify(resp)
    if seatCategory == "软卧":
        trainInfo.restSoftSeat=trainInfo.restSoftSeat-1;
        if trainInfo.restSoftSeat<0:
            resp['code'] = -1
            resp['msg'] = "软座已被订购完"
            return jsonify(resp)
    # 添加车票
    ticket = Ticket()
    ticket.trainId = trainId
    ticket.identification = identification
    ticket.name = name
    ticket.leaveTime = leaveTime
    ticket.date = date
    ticket.fromStation = fromStation
    ticket.terminal = terminal
    ticket.seatCategory = seatCategory
    ticket.buyDate = datetime.date.today()
    ticket.buyTime = datetime.datetime.now().strftime('%H:%M:%S')
    ticket.price = 100
    ticket.uid = g.current_user.uid
    db.session.add(ticket)
    db.session.commit()

    db.session.add(trainInfo)
    db.session.commit()
    return jsonify(resp)


@route_user.route( "/search" ,methods = [ "GET","POST" ])
def search():
    # 基本参数
    resp_data = {}
    req = request.values
    page = int(req['p']) if ('p' in req and req['p']) else 1
    query = TrainInfo.query

    date = req['date'] if 'date' in req else 0
    category = req['category'] if 'category' in req else ''
    fromStation = req['fromStation'] if 'fromStation' in req else ''
    terminal = req['terminal'] if 'terminal' in req else ''


    if date or category or fromStation or terminal:
        rule = and_(TrainInfo.date == date,
                    TrainInfo.category ==category,
                    TrainInfo.fromStation == fromStation,
                    TrainInfo.terminal == terminal
                    )
        query = query.filter(rule)


    page_params = {
        'total': query.count(),
        'page_size': app.config['PAGE_SIZE'],
        'page': page,
        'display': app.config['PAGE_DISPLAY'],
        'url': request.full_path.replace("&p={}".format(page), "")
    }

    pages = iPagination(page_params)
    offset = (page - 1) * app.config['PAGE_SIZE']
    limit = app.config['PAGE_SIZE'] * page
    list = query.order_by(TrainInfo.id.desc()).all()[offset:limit]

    resp_data['list'] = list
    resp_data['pages'] = pages
    resp_data['search_con'] = req
    resp_data['status_mapping'] = app.config['STATUS_MAPPING']

    return ops_render("user/ticketList.html", resp_data)


@route_user.route( "/home" ,methods = [ "GET","POST" ])
def home():
    resp_data = {}
    req = request.values
    query = TrainInfo.query
    page = int(req['p']) if ('p' in req and req['p']) else 1
    page_params = {
        'total': query.count(),
        'page_size': app.config['PAGE_SIZE'],
        'page': page,
        'display': app.config['PAGE_DISPLAY'],
        'url': request.full_path.replace("&p={}".format(page), "")
    }
    pages = iPagination(page_params)
    offset = (page - 1) * app.config['PAGE_SIZE']
    limit = app.config['PAGE_SIZE'] * page
    date = req['date'] if 'date' in req else 0
    category = req['category'] if 'category' in req else ''
    fromStation = req['fromStation'] if 'fromStation' in req else ''
    terminal = req['terminal'] if 'terminal' in req else ''

    if date or category or fromStation or terminal:
        rule = and_(TrainInfo.date == date,
                    TrainInfo.category ==category,
                    TrainInfo.fromStation == fromStation,
                    TrainInfo.terminal == terminal
                    )
        query = query.filter(rule)
    #给出所有查询
    list = query.order_by(TrainInfo.id.desc()).all()[offset:limit]
    resp_data['list'] = list
    resp_data['pages'] = pages
    resp_data['search_con'] = req
    resp_data['status_mapping'] = app.config['STATUS_MAPPING']
    return ops_render("user/home.html", resp_data)

