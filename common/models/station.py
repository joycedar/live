# coding: utf-8
from sqlalchemy import Column, Integer, String
from sqlalchemy.schema import FetchedValue
from flask_sqlalchemy import SQLAlchemy
from application import db


class Station(db.Model):
    __tablename__ = 'station'

    id = db.Column(db.Integer, primary_key=True)
    station = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'???')
    category = db.Column(db.String(10), nullable=False, server_default=db.FetchedValue(), info=u'????')
    address = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'????')
    staffId = db.Column(db.String(18), nullable=False, server_default=db.FetchedValue(), info=u'1?? 2?? 0????')
    staffName = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'??')
    phone = db.Column(db.String(20), nullable=False, server_default=db.FetchedValue(), info=u'?????')
