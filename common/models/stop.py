# coding: utf-8
from sqlalchemy import Column, Integer, String, Time
from sqlalchemy.schema import FetchedValue
from flask_sqlalchemy import SQLAlchemy
from application import db

class Stop(db.Model):
    __tablename__ = 'stop'

    id = db.Column(db.Integer, primary_key=True, nullable=False)
    order = db.Column(db.String(4), primary_key=True, nullable=False, server_default=db.FetchedValue(), info=u'???')
    stationId = db.Column(db.String(8), nullable=False, server_default=db.FetchedValue(), info=u'????')
    stationName = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'????')
    duringTime = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue(), info=u'1?? 2?? 0????')
    arriveTime = db.Column(db.Time, nullable=False)
    setOffTime = db.Column(db.Time, nullable=False)
