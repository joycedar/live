//
//  LHomeViewController.swift
//

import UIKit
import SnapKit





class HomeViewController: UIViewController {
    var tableview = UITableView()
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
        
        return textView
    }()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //请求房间接口
        self.getAllRoomList()
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
        tableview.separatorStyle = .none
        tableview.dataSource = self
        tableview.register(RoomCell.self, forCellReuseIdentifier: RoomCell.className())
        tableview.register(CCTVRoomCell.self, forCellReuseIdentifier: CCTVRoomCell.className())
        
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
            self.getAllRoomList()
        };
        refreshTool.endBlock = {
            print("结束刷新....")
        };
        refreshTool.isAutoEnd = true;//设为自动结束刷新 YES/NO 自动/手动
        refreshTool.refreshTime = 2.0;//设置自动刷新时间(秒为单位) 手动结束刷新时不设置此项
        refreshTool.scrollview = tableview;
    }
}

extension HomeViewController {
    func getAllRoomList() {
        HttpTool.getWithPath(path: API_getAllRoomList, params: nil, success: { (data) in
            if let jsonData = data as? [String:Any] {
               if let roomList = jsonData["data"] as? [Any]{
                var roomModelList = [SWRoomModel]()
                 for room in roomList {
                     if let room = room as? [String:Any],
                         let name = room["name"] as? String,
                         let roomDescription =  room["roomName"] as? String,
                         let roomUrl = room["roomUrl"] as? String ,
                         let roomUid = room["uid"] as? Int{
                         let roomModel = SWRoomModel()
                           roomModel.uid = roomUid
                           roomModel.name = name
                           roomModel.roomDescription = roomDescription
                           roomModel.roomUrl = roomUrl
                       roomModelList.append(roomModel)
                       }
                   }
                self.homeViewModel.liveRoomList = roomModelList
                self.tableview.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }

}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return homeViewModel.liveRoomList.count
        case 1:
            return homeViewModel.SWCCTVModelList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = self.tableview.dequeueReusableCell(withIdentifier: RoomCell.className(), for: indexPath) as? RoomCell {
                cell.configWithModel(model: self.homeViewModel.liveRoomList[indexPath.row])
                return cell
            }
        case 1:
            if let cell = self.tableview.dequeueReusableCell(withIdentifier: CCTVRoomCell.className(), for: indexPath) as? CCTVRoomCell {
                cell.configCCTV(SWCCTVModel: self.homeViewModel.SWCCTVModelList[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            if let cell = tableview.cellForRow(at: indexPath) {
//                 if cell.isKind(of: RoomCell.self) {
//                    let streamUrl = homeViewModel.liveRoomList[indexPath.row].roomUrl
//                    let liveModel = LiveModel()
//
//                    let playViewController = KKLPlayerViewController()
//                    playViewController.liveModel = liveModel
//                    self.navigationController?.pushViewController(playViewController, animated: true)
//                 }
//             }
//        case 1:
//            if let cell = tableview.cellForRow(at: indexPath) {
//                if cell.isKind(of: CCTVRoomCell.self) {
//                    let streamUrl = RTMPLIST[indexPath.row]
//                    let liveModel = LiveModel()
//                    liveModel.stream_addr = streamUrl
//                    liveModel.name = CCTVNameList[indexPath.row]
//                    let playViewController = KKLPlayerViewController()
//                    playViewController.liveModel = liveModel
//                    self.navigationController?.pushViewController(playViewController, animated: true)
//                }
//            }
//
//
//        default:
//            return
//        }
//
//    }
//}
}

extension HomeViewController:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
