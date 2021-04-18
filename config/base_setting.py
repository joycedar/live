# -*- coding: utf-8 -*-
SERVER_PORT = 5000

DEBUG = True
SQLALCHEMY_ECHO = True
SQLALCHEMY_DATABASE_URI = 'mysql://root:123456@39.106.61.73/liveModel?charset=utf8mb4'
SQLALCHEMY_TRACK_MODIFICATIONS = False
SQLALCHEMY_ENCODING = "utf8mb4"


AUTH_COOKIE_NAME = "joyCedar"

SEO_TITLE = "joyCedar's Live BackGround"

IGNORE_URLS = [
    "^/login",
    "^/user/home",
    "^/admin/analysis",
    "^/admin/accountList",
    "^/admin/accountOps",
    "^/admin/ticketChange",
    "^/admin/ticketList",
    "^/admin/ticketOps",
    "^/admin/trainInfoChange",
    "^/admin/trainInfoList",
    "^/admin/trainInfoSet",
    "^/admin/trainInfoOps",
    "^/user/register"
]

IGNORE_CHECK_LOGIN_URLS = [
    "^/static",
    "^/login",
    "^/user/home",
    "^/favicon.ico",
    "^/admin/analysis",
    "^/admin/accountOps",
    "^/admin/accountList",
    "^/admin/ticketChange",
    "^/admin/ticketList",
    "^/admin/ticketOps",
    "^/admin/trainInfoChange",
    "^/admin/trainInfoList",
    "^/admin/trainInfoSet",
    "^/admin/trainInfoOps",
    "^/admin/getUserInfoByUid",
    "^/admin/followUserById"
]

API_IGNORE_URLS = [
    "^/api"

]

PAGE_SIZE = 50
PAGE_DISPLAY = 10
#
STATUS_MAPPING = {
    "1":"已删除",
    "0":"正常"
}
#
MINA_APP = {
    'appid':'',
    'appkey':'',
    'paykey':'',
    'mch_id':'',
    'callback_url':'/api/order/callback'
}


UPLOAD = {
    'ext':[ 'jpg','gif','bmp','jpeg','png' ],
    'prefix_path':'/web/static/upload/',
    'prefix_url':'/static/upload/'
}

APP = {
    'domain':'http://192.168.50.238:5000'
}

PAY_STATUS_MAPPING = {
    "1":"已支付",
    "-8":"待支付",
    "0":"已关闭"
}

PAY_STATUS_DISPLAY_MAPPING = {
    "0":"订单关闭",
    "1":"支付成功",
    "-8":"待支付",
    "-7":"待发货",
    "-6":"待确认",
    "-5":"待评价"
}

