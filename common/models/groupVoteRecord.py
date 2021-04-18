# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from application import db



class GroupVoteRecord(db.Model):
    __tablename__ = 'group_vote_record'

    id = db.Column(db.BigInteger, primary_key=True)
    group_id = db.Column(db.BigInteger, nullable=False, index=True, info='?ID')
    topic = db.Column(db.String(256), nullable=False, server_default=db.FetchedValue(), info='??')
    options = db.Column(db.LargeBinary, info='??')
    is_mult_select = db.Column(db.Integer, server_default=db.FetchedValue(), info='?????0???1???')
    end_time = db.Column(db.DateTime, info='??????')
    is_anonymous = db.Column(db.Integer, server_default=db.FetchedValue(), info='?????0???1???')
    create_time = db.Column(db.DateTime, nullable=False, server_default=db.FetchedValue(), info='????')
    create_user = db.Column(db.String(64), server_default=db.FetchedValue(), info='???')
    is_delete = db.Column(db.Integer, server_default=db.FetchedValue(), info='?????0???1???')
