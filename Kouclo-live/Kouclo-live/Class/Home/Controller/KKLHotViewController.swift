////
////  KKLHotViewController.swift
////  Kouclo-live
////
////  Created by liwei on 16/12/24.
////  Copyright © 2016年 live. All rights reserved.
////  首页控制器
//
//import UIKit
//
//class KKLHotViewController: UITableViewController {
//    
//    private var identifier = "LiveCell"
//    ///模型数组
//    var datalist = NSArray()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.loadData()
//    }
//
//    override init(style: UITableView.Style) {
//        super.init(style: style)
//        self.tableView.register(LiveCell.self, forCellReuseIdentifier: LiveCell.className())
//        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: KKLTabbarHeight, right: 0)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func loadData(){
//        weak var wSelf = self
//        KKLHomeHandler.executeGetHotLiveTaskWithSuccess(success: { (result) in
//            wSelf?.datalist = result as! NSArray
//            wSelf?.tableView.reloadData()
//        }) { (error) in
//            print(error)
//        }
//    }
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
//        return 70 + KKLScreenWidth
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let live = self.datalist[indexPath.row] as? LiveModel
//        let playVC = KKLPlayerViewController()
//        playVC.live = live
//        self.navigationController?.pushViewController(playVC, animated: true)
//    }
//}
