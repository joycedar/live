# coding: utf-8
from sqlalchemy import Column, Date, Float, Integer, String, Time
from sqlalchemy.schema import FetchedValue
from flask_sqlalchemy import SQLAlchemy
from application import db


class Ticket(db.Model):
    __tablename__ = 'ticket'

    id = db.Column(db.Integer, primary_key=True, info=u'??uid')
    identification = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'???')
    name = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'????')
    trainId = db.Column(db.String(10), nullable=False, server_default=db.FetchedValue(), info=u'????')
    leaveTime = db.Column(db.Time, nullable=False)
    date = db.Column(db.Date, nullable=False)
    fromStationId = db.Column(db.String(8), nullable=False, server_default=db.FetchedValue(), info=u'?????')
    fromStation = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'????')
    terminalId = db.Column(db.String(8), nullable=False, server_default=db.FetchedValue(), info=u'???????????')
    terminal = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'1??? 0???')
    seatCategory = db.Column(db.String(10), nullable=False, server_default=db.FetchedValue(), info=u'1??? 0???')
    seatId = db.Column(db.String(20), nullable=False, server_default=db.FetchedValue(), info=u'1??? 0???')
    price = db.Column(db.Float, nullable=False, server_default=db.FetchedValue(), info=u'1??? 0???')
    buyDate = db.Column(db.Date, nullable=False)
    buyTime = db.Column(db.Time, nullable=False)
    uid = db.Column(db.String(10), nullable=False)
    status = db.Column(db.Integer, server_default=db.FetchedValue())
