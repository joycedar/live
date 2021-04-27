# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from application import db



class User(db.Model):
    __tablename__ = 'user'

    uid = db.Column(db.BigInteger, primary_key=True, info='??uid')
    nickname = db.Column(db.String(100), nullable=False, server_default=db.FetchedValue(), info='???')
    password = db.Column(db.String(32), nullable=False, server_default=db.FetchedValue(), info='????')
    sex = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue(), info='1?? 2?? 0????')
    avatar = db.Column(db.String(64), info='??')
    follows = db.Column(db.LargeBinary, info='????')
    followNumber = db.Column(db.Integer, info='????')
    fans = db.Column(db.LargeBinary, info='????')
    fansNumber = db.Column(db.Integer, info='????')
    status = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue(), info='1??? 0???')
    introduction = db.Column(db.String(50))
    roomUrl = db.Column(db.String(200), info='????')
    roomImage = db.Column(db.String(100), info='??????')
    roomName = db.Column(db.String(100), info='??????')
    roomWatchingNumber = db.Column(db.Integer)
    managerIdentification = db.Column(db.LargeBinary)
