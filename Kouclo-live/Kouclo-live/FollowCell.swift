//
//  FollowCell.swift
//  Kouclo-live
//
//  Created by cedar on 2021/4/15.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class EmptyFollowRoomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        self.contentView.addSubview(emptyLiveRoomImageView)
        self.contentView.addSubview(emptyLabel)
        
        emptyLiveRoomImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-13)
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
        let imageView = UIImageView(image: UIImage(named: "emptyFollowImage"))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "你当前还没有关注任主播\n快快去找一个有趣的主播吧～"
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = UIColor.init(rgb: 0xC3C3C5)
        label.numberOfLines = 3
        return label
    }()

}

class ExploreFollowCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        self.contentView.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "探\n索"
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor.init(rgb: 0xC3C3C5)
        label.numberOfLines = 2
        return label
    }()

}




class RecommemdationCell: UITableViewCell {
    
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
        label.text = "CCTV"
        label.font = UIFont(name: "", size: 13)
        label.textColor = .black
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "想综合？看他就对了"
        label.font = UIFont(name: "", size: 13)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
    var subsribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("订阅", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.init(rgb: 0xC3C3C5)
        return button
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(subsribeButton)
        self.contentView.addSubview(detailLabel)
        
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(rgb: 0xC3C3C5).cgColor
        self.clipsToBounds = true
        
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(18)
            make.width.height.equalTo(64)
        }
        
        nameLable.snp.makeConstraints { make in
            make.top.equalTo(11)
            make.leading.equalTo(avatarImage.snp.trailing).offset(13)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-13)
            make.leading.equalTo(avatarImage.snp.trailing).offset(13)
        }
        
        subsribeButton.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.top.equalTo(30)
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
    }
    
    public func configCCTV(userProfileModel: UserProfileModel) {
        self.nameLable.text = userProfileModel.name
        self.detailLabel.text = userProfileModel.introduction
        self.avatarImage.image = UIImage(named: "avatar_placeholder")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}

