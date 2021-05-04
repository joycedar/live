

import UIKit
import MJExtension

class UserProfileModel: Decodable {
    var uid:Int = 2
    var name:String = ""
    var fansCount:Int = 0
    var followsCount:Int = 0
    var fanList:[Int]?
    var followList:[Int]?
    var avaterUrL:String?
    var introduction:String?
    var roomUrl:String?
    var roomImage:String?
    var roomName:String?
    var roomWatchingNumber:Int?
    var managerIdentification:[Int]?
    var roomId:Int?
    
    private enum CodingKeys: String , CodingKey {
        case name,followsCount,fansCount,fanList,followList,avaterUrL,introduction,roomUrl,roomImage,roomName,roomWatchingNumber,managerIdentification,roomId
    }
    
    init() {
        
    }
}
