

import UIKit

class LiveModel: NSObject {
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



class KKLLive: NSObject {

    var distance : String?
    var city : String?
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


class SWCCTVModel: NSObject {
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


class SWFollowerLiveRoom: NSObject {
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

class SWRoomModel:NSObject {
    var uid:Int?
    var roomCoverImageUrl: String?
    var roomImage: String?
    var roomDescription: String?
    var roomUrl:String?
    var avatarIamgeUrl: String?
    var name:String?
    
    override init() {
        self.uid = nil
        self.avatarIamgeUrl = nil
        self.roomCoverImageUrl = nil
        self.roomDescription = nil
        self.name = nil
        self.roomUrl = nil
    }
}

