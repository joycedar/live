# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from application import db



class Present(db.Model):
    __tablename__ = 'present'

    presentId = db.Column(db.BigInteger, primary_key=True, info='??uid')
    prsentName = db.Column(db.String(100), nullable=False, server_default=db.FetchedValue(), info='????')
    money = db.Column(db.Integer, nullable=False, server_default=db.FetchedValue(), info='???')
