//
//  ShirWindMessageViewController.swift
//  Kouclo-live
//
//  Created by cedar on 2021/4/5.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum FollowSectionType: Int {
    case emptyFollowSection = 0
    case exploreSection = 1
    case liveRoomSection = 2
    case recommemdSection = 3
}

class ShirWindFollowViewController: UIViewController {
    var tableview : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    var followViewModel = FollowViewModel()
    
    var refreshTool = BGRefresh()
    

    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
    override func viewDidLoad() {
        title = "关注页面"
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "global_search"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "title_button_more"), style: UIBarButtonItem.Style.done, target: nil,action: nil)
        self.view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(EmptyFollowRoomCell.self, forCellReuseIdentifier: EmptyFollowRoomCell.className())
        tableview.register(ExploreFollowCell.self, forCellReuseIdentifier: ExploreFollowCell.className())
        tableview.register(LiveCell.self, forCellReuseIdentifier: LiveCell.className())
        tableview.register(RecommemdationCell.self, forCellReuseIdentifier: RecommemdationCell.className())
 
        
        tableview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalToSuperview()
        }
        
        refreshTool.scrollview = tableview
        refreshTool.startBlock = {
            print("开始刷新....")
            
        };
        refreshTool.endBlock = {
            print("结束刷新....")
        };
        refreshTool.isAutoEnd = true;
        refreshTool.refreshTime = 2.0;
        refreshTool.scrollview = tableview;
    }
}



extension ShirWindFollowViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case FollowSectionType.emptyFollowSection.rawValue:
            return followViewModel.shouldShowEmptyView ? 1 : 0
        case FollowSectionType.exploreSection.rawValue:
            return followViewModel.shouldShowEmptyView ? 1 : 0
        case FollowSectionType.liveRoomSection.rawValue:
            return followViewModel.liveRoomList.count
        case FollowSectionType.recommemdSection.rawValue:
            return followViewModel.followModelList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case FollowSectionType.emptyFollowSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: EmptyFollowRoomCell.className(), for: indexPath)
            if let cell = cell as? EmptyFollowRoomCell {
                return cell
            }
        case FollowSectionType.exploreSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: ExploreFollowCell.className(), for: indexPath)
            if let cell = cell as? ExploreFollowCell {
                return cell
            }
        case FollowSectionType.liveRoomSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: LiveCell.className(), for: indexPath)
            if let cell = cell as? LiveCell {
                return cell
            }
        case FollowSectionType.recommemdSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: RecommemdationCell.className(), for: indexPath)
            if let cell = cell as? RecommemdationCell {
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case FollowSectionType.emptyFollowSection.rawValue:
            return 147
        case FollowSectionType.exploreSection.rawValue:
            return 82
        case FollowSectionType.liveRoomSection.rawValue:
            return 312
        case FollowSectionType.recommemdSection.rawValue:
            return 86
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
}
