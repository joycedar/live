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


class ShirWindMessageViewController: UIViewController {
    var tableview = UITableView()
    
    var refreshTool = BGRefresh()
    

    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
    override func viewDidLoad() {
        title = "消息页面"
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "global_search"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "title_button_more"), style: UIBarButtonItem.Style.done, target: nil,action: nil)
        self.view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(LiveCell.self, forCellReuseIdentifier: LiveCell.className())
        tableview.register(CCTVLiveCell.self, forCellReuseIdentifier: RecommemdationCell.className())
 
        
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
        refreshTool.isAutoEnd = true;//设为自动结束刷新 YES/NO 自动/手动
        refreshTool.refreshTime = 2.0;//设置自动刷新时间(秒为单位) 手动结束刷新时不设置此项
        refreshTool.scrollview = tableview;
    }

    
}



extension ShirWindMessageViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            if let cell = self.tableview.dequeueReusableCell(withIdentifier: LiveCell.className(), for: indexPath) as? LiveCell {
//                return cell
//            }
//        case 1:
//            if let cell = self.tableview.dequeueReusableCell(withIdentifier: CCTVLiveCell.className(), for: indexPath) as? CCTVLiveCell {
//                cell.configCCTV(cctvModel: self.homeViewModel.cctvModelList[indexPath.row])
//                return cell
//            }
//        default:
//            return UITableViewCell()
//        }
        return UITableViewCell()
    }
        
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableview.cellForRow(at: indexPath) {
            if cell.isKind(of: CCTVLiveCell.self) {
                let streamUrl = RTMPLIST[indexPath.row]
                let liveModel = LiveModel()
                liveModel.stream_addr = streamUrl
                liveModel.name = CCTVNameList[indexPath.row]
                let playViewController = KKLPlayerViewController()
                playViewController.liveModel = liveModel
                self.navigationController?.pushViewController(playViewController, animated: true)
            }
        }
    }
}
