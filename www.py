# -*- coding: utf-8 -*-
from application import app
from web.controllers.admin.admin import route_admin
from web.controllers.user.user import route_user
from web.controllers.static import route_static
from web.controllers.loginAndlogout import route_loginAndlogout

"""
拦截器shenme
"""
from web.interceptors.AuthInterceptor import  *

app.register_blueprint( route_loginAndlogout,url_prefix = "/" )
app.register_blueprint( route_static,url_prefix = "/static" )
app.register_blueprint( route_admin,url_prefix = "/admin" )


