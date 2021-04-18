# coding: utf-8
from sqlalchemy import Column, Date, Integer, String, Time
from sqlalchemy.schema import FetchedValue
from flask_sqlalchemy import SQLAlchemy
from application import db


class TrainInfo(db.Model):
    __tablename__ = 'trainInfo'

    id = db.Column(db.String(10), primary_key=True, nullable=False)
    date = db.Column(db.Date, primary_key=True, nullable=False)
    category = db.Column(db.String(50), nullable=False)
    leaveTime = db.Column(db.Time, nullable=False)
    fromStation = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'1?? 2?? 0????')
    terminal = db.Column(db.String(50), nullable=False, server_default=db.FetchedValue(), info=u'??')
    hardSeat = db.Column(db.Integer, nullable=False)
    restHardSeat = db.Column(db.Integer, nullable=False)
    softSeat = db.Column(db.Integer, nullable=False)
    restSoftSeat = db.Column(db.Integer, nullable=False)
    firstClassSeat = db.Column(db.Integer, nullable=False)
    restFirstClassSeat = db.Column(db.Integer, nullable=False)
    secondClassSeat = db.Column(db.Integer, nullable=False)
    restSecondClassSeat = db.Column(db.Integer, nullable=False)
    status = db.Column(db.Integer, server_default=db.FetchedValue())
