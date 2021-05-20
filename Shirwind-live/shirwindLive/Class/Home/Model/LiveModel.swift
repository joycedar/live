

import UIKit

class SWCCTVModel: NSObject {
    var avatarIamge : String?
    var name : String?
    var nameDetail : String?
    var content : String?
    var url:String?
    
    init(avatarImage:String,name:String,nameDetail:String,content:String,url:String) {
        self.avatarIamge = avatarImage
        self.name = name
        self.nameDetail = nameDetail
        self.content = content
        self.url = url
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

