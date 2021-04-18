//
//  KKLHomeViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/20.
//  Copyright © 2016年 live. All rights reserved.

import UIKit
import SnapKit





class HomeViewController: UIViewController {
    var tableview = UITableView()
    var avatarList = [String]()
    var refreshTool = BGRefresh()
    var homeViewModel = HomeViewModel()

    
    var emptyLiveRoomView: UIView = {
        let view = UIView()
        
        var emptyLiveRoomImageView: UIImageView =  {
            let imageView = UIImageView(image: UIImage(named: "emptyLiveRoomImage"))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = false
            return imageView
        }()
        
        var emptyLabel: UILabel = {
            let label = UILabel()
            label.text = "当前没有直播房间哦～\n可以看看下面的推荐直播"
            label.font = UIFont(name: "", size: 28)
            label.textColor = UIColor.black
            label.numberOfLines = 2
            return label
        }()
        
        view.addSubview(emptyLiveRoomImageView)
        view.addSubview(emptyLabel)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        
        emptyLiveRoomImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.top.equalTo(13)
        }
        
        return view
    }()
    
    var searchBar:UITextView = {
         var textView: UITextView = {
            let textView = UITextView()
            textView.font = UIFont(name: "Arial", size: 16)
            textView.layer.cornerRadius = 10
            textView.backgroundColor = UIColor.init(rgb: 0xD8D8D8)
            
            textView.returnKeyType = .done
            textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.minimumLineHeight = 20
            paragraphStyle.maximumLineHeight = 20
            textView.typingAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Arial", size: 16),
                .paragraphStyle: paragraphStyle
            ]
            return textView
        }()
        let icon = UIImageView(image: UIImage(named: "icon_search"))
        textView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.leading.top.equalTo(5)
            make.width.height.equalTo(21)
        }
        return textView
    }()
    override func viewWillAppear(_ animated: Bool) {
        self.emptyLiveRoomView.isHidden = homeViewModel.shouldShowEmptyView
        
        if self.emptyLiveRoomView.isHidden {
            emptyLiveRoomView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }

    }
    
    
    override func viewDidLoad() {
        title = "首页"
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "global_search"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "title_button_more"), style: UIBarButtonItem.Style.done, target: nil,action: nil)
        self.view.addSubview(searchBar)
        self.view.addSubview(emptyLiveRoomView)
        self.view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(LiveCell.self, forCellReuseIdentifier: LiveCell.className())
        tableview.register(CCTVLiveCell.self, forCellReuseIdentifier: CCTVLiveCell.className())
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(60 + 44)
            make.leading.equalTo(10)
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.equalTo(40)
        }
    
        
        emptyLiveRoomView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(105)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(emptyLiveRoomView.snp.bottom).offset(12)
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



extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return avatarList.count
        case 1:
            return homeViewModel.cctvModelList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = self.tableview.dequeueReusableCell(withIdentifier: LiveCell.className(), for: indexPath) as? LiveCell {
                return cell
            }
        case 1:
            if let cell = self.tableview.dequeueReusableCell(withIdentifier: CCTVLiveCell.className(), for: indexPath) as? CCTVLiveCell {
                cell.configCCTV(cctvModel: self.homeViewModel.cctvModelList[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
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
