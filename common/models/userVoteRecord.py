# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from application import db



class UserVoteRecord(db.Model):
    __tablename__ = 'user_vote_record'

    id = db.Column(db.BigInteger, primary_key=True)
    user_id = db.Column(db.String(64), server_default=db.FetchedValue(), info='??ID')
    group_id = db.Column(db.BigInteger, nullable=False, info='?ID')
    vote_id = db.Column(db.BigInteger, nullable=False, info='??ID')
    options = db.Column(db.LargeBinary, info='?????')
