////
////  KKLFocuseViewController.swift
////  Kouclo-live
////
////  Created by liwei on 16/12/24.
////  Copyright © 2016年 live. All rights reserved.
////  首页关注控制器
//
//import UIKit
//
//class KKLFocuseViewController: UITableViewController {
//
//    //
//    private var identifier = "LiveCell"
//    ///模型数组
//    var datalist:NSMutableArray = NSMutableArray()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.setupUI()
//        self.loadData()
//    }
//    
//    //MARK:数据源和代理
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.datalist.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LiveCell
//        cell?.live = self.datalist[indexPath.row] as? LiveModel
//        return cell!
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 70 + KKLScreenWidth
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        let live = self.datalist[indexPath.row] as? LiveModel
//        let playVC = KKLPlayerViewController()
//        playVC.live = live
//        self.navigationController?.pushViewController(playVC, animated: true)
//    }
//    
//    //初始化控件
//    private func setupUI(){
//        
//        self.tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
//        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: KKLTabbarHeight, right: 0)
//    }
//    
//    //初始化数据
//    private func loadData(){
//        weak var wSelf = self
//        KKLHomeHandler.executeGetHotLiveTaskWithSuccess(success: { (result) in
//            
//            wSelf?.datalist = result as! NSMutableArray
//            wSelf?.tableView.reloadData()
//            let liveM = LiveModel()
//            liveM.online_users = NSNumber.init(value: 100);
//            liveM.stream_addr = Live_KoucloLive
//            
//            let creator = KKLCreator()
//            liveM.creator = creator
//            
//            creator.nick = "MySelf"
//            creator.portrait = "live"
//            wSelf?.datalist.insert(liveM, at: 0)
//            
//            wSelf?.tableView.reloadData()
//
//        }) { (error) in
//            print(error)
//        }
//    
//    }
//
//}
