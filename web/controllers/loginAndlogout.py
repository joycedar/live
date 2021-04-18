# -*- coding: utf-8 -*-
from flask import Blueprint,request,jsonify,make_response,g,redirect
from common.libs.Helper import ( ops_render )
from common.libs.UrlManager import ( UrlManager )
from application import app,db
from  common.models.User import User
from common.libs.user.UserService import ( UserService )
from common.libs.Helper import ( ops_render )
from common.libs.UrlManager import ( UrlManager )
import json

route_loginAndlogout = Blueprint( 'loginAndlogout_page',__name__ )

@route_loginAndlogout.route( "/login",methods = [ "GET","POST" ] )
def login():
    if request.method == "GET":
        return ops_render( "admin/login.html" )

    resp = {'code': 200, 'msg': '登录成功', 'data': {}}
    req = request.values
    login_name = req['login_name'] if 'login_name' in req else ''
    login_pwd = req['login_pwd'] if 'login_pwd' in req else ''

    if  login_name is None or len( login_name ) < 1:
        resp['code'] = -1
        resp['msg'] = "请校验输入格式"
        return jsonify( resp )

    if  login_pwd is None or len( login_pwd ) < 1:
        resp['code'] = -1
        resp['msg'] = "请校验输入格式"
        return jsonify(resp)

    info = User.query.filter_by( nickname = login_name ).first()

    if not info:
        resp['code'] = -1
        resp['msg'] = "不存在该账户信息"
        return jsonify(resp)

    if info.password != login_pwd:
        resp['code'] = -1
        resp['msg'] = "请输入正确的密码"
        return jsonify(resp)

    if info.status != 1:
        resp['code'] = -1
        resp['msg'] = "账号已被禁用，请联系管理员处理"
        return jsonify(resp)

    response = make_response(json.dumps({'code': 200, 'msg': '登录成功'}))
    return response


@route_loginAndlogout.route( "/edit",methods = [ "GET","POST" ] )
def edit():
    if request.method == "GET":
        return ops_render( "user/edit.html",{ 'current':'edit' } )

    resp = { 'code':200,'msg':'操作成功~','data':{} }
    req = request.values
    nickname = req['nickname'] if 'nickname' in req else ''

    if nickname is None or len( nickname ) < 1:
        resp['code'] = -1
        resp['msg'] = "请输入符合规范的姓名~~"
        return jsonify( resp )

    user_info = g.current_user
    user_info.nickname = nickname

    db.session.add( user_info )
    db.session.commit()
    return jsonify(resp)


@route_loginAndlogout.route( "/reset-pwd",methods = [ "GET","POST" ] )
def resetPwd():
    if request.method == "GET":
        return ops_render( "user/reset_pwd.html",{ 'current':'reset-pwd' } )

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

    db.session.add( user_info )
    db.session.commit()

    response = make_response(json.dumps( resp ))
    response.set_cookie(app.config['AUTH_COOKIE_NAME'], '%s#%s' % (
        UserService.geneAuthCode(user_info), user_info.uid), 60 * 60 * 24 * 120)  # 保存120天
    return response


@route_loginAndlogout.route( "/logout" )
def logout():
    response = make_response(redirect(UrlManager.buildUrl("/user/login")))
    return response