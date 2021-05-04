

import Foundation


class HomeViewModel {
    var liveRoomList  = [SWRoomModel]()
    var SWCCTVModelList = [SWCCTVModel]()
    var shouldShowEmptyView: Bool
    
    init() {
        SWCCTVModelList = [
            SWCCTVModel(avatarImage: "CCTV1", name: "CCTV1", nameDetail: "中央电视台综合频道", content: "是以新闻为主的综合类电视频道，于1978年5月1日开播 ，有《新闻联播》，《星光大道》，《新闻联播天气预报》，《挑战不可…"),
            SWCCTVModel(avatarImage: "CCTV2", name: "CCTV2", nameDetail: "中央电视台财经频道", content: "是以财经资讯节目为核心、生活服务节目为辅助的电视频道，于1987年2月1日开播"),
            SWCCTVModel(avatarImage: "CCTV3", name: "CCTV3", nameDetail: "中央电视台综艺频道", content: "是以播出音乐及歌舞节目为主的专业电视频道, 于1986年1月1日开播。1995年，CCTV-3正式上星并面向全国播出。1996年1月1日，CCTV-3正式起名为戏曲·音乐频道。"),
            SWCCTVModel(avatarImage: "CCTV4", name: "CCTV4", nameDetail: "中央电视台中文国际频道（", content: "是以海外华人、华侨和港、澳、台为主要服务对象的专业频道，于1992年10月1日开播。1995年7月1日，CCTV-4对外正式启用“中国中央电视台国际频道”（CCTV INTERNATIONAL）呼号。"),
            SWCCTVModel(avatarImage: "CCTV5", name: "CCTV5", nameDetail: "中国中央电视台体育频道", content: "是中国中央电视台拥有的一条以普通话广播为主的体育频道，该频道是中央电视台第一条专业性频道，为全国规模最大、拥有世界众多顶级赛事中国大陆地区独家报道权的专业体育频道，于1994年10月1日试播、1995年1月1日正式开播，通过中星6B、鑫诺3号卫星覆盖全国，卫星信号加密播出。全天24小时播出，在中央电视台体育赛事频道开播以前一直是唯一一个覆盖全中国大陆的专业体育频道。")
        ]
        
        shouldShowEmptyView = !liveRoomList.isEmpty
    }
    
    

    
}
