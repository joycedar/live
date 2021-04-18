//
//  FollowViewModel.swift
//  Kouclo-live
//
//  Created by cedar on 2021/4/15.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation


class FollowViewModel {
    public var liveRoomList: [LiveModel] = [LiveModel]()

    public var followModelList: [UserProfileModel] = [UserProfileModel]()
    
    public var shouldShowEmptyView: Bool
    
    init() {
        followModelList = [
            UserProfileModel(name: "cedar", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "aria", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "petty", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "garnet", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "penny", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "shirwind", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍"),
            UserProfileModel(name: "sunnyshell", fansCount: 0, followCount: 10, fanList: nil, followList: nil, avaterUrL: "avatar_placeholder", introduction: "只是一个没有感情的自我介绍")
        ]
        
        shouldShowEmptyView = liveRoomList.isEmpty
    }
    
    func fetchRoomList() {
        
    }
    

    
    
    
    
}

