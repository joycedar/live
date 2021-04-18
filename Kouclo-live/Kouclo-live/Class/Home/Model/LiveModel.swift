//
//  LiveModel.swift
//  Kouclo-live
//
//  Created by liwei on 16/12/25.
//  Copyright © 2016年 live. All rights reserved.

import UIKit

class LiveModel: NSObject {

    var creator : KKLCreator?
    var group : NSNumber?
    var ID : String?
    var image : String?
    var link : NSNumber?
    var multi : NSNumber?
    var name : String?
    var online_users : NSNumber?
    var optimal : NSNumber?
    var pub_stat : NSNumber?
    var room_id : NSNumber?
    var rotate : NSNumber?
    var share_addr : String?
    var slot : NSNumber?
    var status : NSNumber?
    var stream_addr : String?
    var version : NSNumber?
    var portrait : String?
    
    ///是否已经加载过了
    var isShow : Bool = false
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["ID":"id"]
    }
}


class CCTVModel: NSObject {
    var avatarIamge : String?
    var name : String?
    var nameDetail : String?
    var content : String?
    
    init(avatarImage:String,name:String,nameDetail:String,content:String) {
        self.avatarIamge = avatarImage
        self.name = name
        self.nameDetail = nameDetail
        self.content = content
    }
    
    override init() {
        self.avatarIamge = nil
        self.name = nil
        self.nameDetail = nil
        self.content = nil
    }
}
