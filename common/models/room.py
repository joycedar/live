# coding: utf-8
from flask_sqlalchemy import SQLAlchemy


db = SQLAlchemy()



class Room(db.Model):
    __tablename__ = 'room'

    uid = db.Column(db.BigInteger, nullable=False, info='??uid')
    roomUrl = db.Column(db.String(100), nullable=False, server_default=db.FetchedValue(), info='??url')
    roomName = db.Column(db.String(32), nullable=False, server_default=db.FetchedValue(), info='????')
    roomImageUrl = db.Column(db.String(32), nullable=False, server_default=db.FetchedValue(), info='??url')
    status = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue(), info='1??? 0???')
    roomId = db.Column(db.BigInteger, primary_key=True, info='??uid')
    roomWatchingNumber = db.Column(db.Integer, server_default=db.FetchedValue(), info='????')
    watchingList = db.Column(db.LargeBinary, info='????')
    sensitiveWord = db.Column(db.LargeBinary)
    name = db.Column(db.String(11))
    roomDescription = db.Column(db.String(100))
