//
//  LiveCell.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/27.
//  Copyright © 2016年 live. All rights reserved.
//

import UIKit
import SnapKit

class LiveCell: UITableViewCell {
    
    lazy var avatarImage: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        return imageView
    }()

    var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 16)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
    var bigImageView = UIImageView()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 16)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(bigImageView)
        self.contentView.addSubview(descriptionLabel)
        
        
        avatarImage.snp.makeConstraints { (make) in
            make.leading.equalTo(13)
            make.top.equalTo(20)
            make.width.height.equalTo(32)
        }
        
        nameLable.snp.makeConstraints { (make) in
            make.top.leading.equalTo(25)
        }
        
        bigImageView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImage)
            make.top.equalTo(avatarImage.snp.bottom).offset(16)
            make.width.equalTo(134)
            make.height.equalTo(200)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bigImageView.snp.bottom).offset(12)
            make.leading.equalTo(bigImageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configWithModel(model: LiveModel) {
        self.avatarImage.image = UIImage(named: "avatar_placeholder")
        self.bigImageView.image = UIImage(named: "liveRoom_placeholder")
        self.nameLable.text = "未有具体用户名"
        self.descriptionLabel.text = "还没有具体的用户名字"
    }

}


class EmptyLiveRoomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        self.contentView.addSubview(emptyLiveRoomImageView)
        self.contentView.addSubview(emptyLabel)
        
        emptyLiveRoomImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(13)
            make.width.equalTo(90)
            make.height.equalTo(80)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(24)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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

}



class CCTVLiveCell: UITableViewCell {
    
    
    lazy var avatarImage: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.04).cgColor
        return imageView
    }()

    var nameLable: UILabel = {
        let label = UILabel()
        label.text = "aria"
        label.font = UIFont(name: "", size: 28)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
    var nameDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 28)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 28)
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play_bottuon"), for: .normal)
        button.setImage(UIImage(named: "play_bottuon_highlight"), for: .highlighted)
        return button
    }()
    
    
    var containerView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xC3C3C5)
        return view
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(nameDetailLabel)
        self.contentView.addSubview(playButton)
        self.contentView.addSubview(descriptionLabel)
        
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(rgb: 0xC3C3C5).cgColor
        self.clipsToBounds = true
        
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(13)
            make.width.height.equalTo(64)
        }
        
        nameLable.snp.makeConstraints { make in
            make.top.equalTo(11)
            make.leading.equalTo(avatarImage.snp.trailing).offset(13)
        }
        
        nameDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLable)
            make.top.equalTo(35)
        }
        
        playButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-23)
            make.top.equalTo(17)
            make.height.width.equalTo(32)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(93)
            make.top.equalTo(86)
            make.width.lessThanOrEqualTo(233)
        }

    }
    
    public func configCCTV(cctvModel:CCTVModel) {
        self.nameLable.text = cctvModel.name
        self.nameDetailLabel.text = cctvModel.nameDetail
        self.avatarImage.image = UIImage(named: cctvModel.avatarIamge ?? "")
        self.descriptionLabel.text = cctvModel.content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
