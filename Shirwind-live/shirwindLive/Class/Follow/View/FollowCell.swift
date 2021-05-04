//
//  FollowCell.swift
//
//  Created by cedar on 2021/4/15.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
protocol RecommendDelegate:NSObject {
    func didClickFollowButton(targetModel:UserProfileModel , result:@escaping(Bool)->())
}

class EmptyFollowRoomCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        self.contentView.addSubview(emptyLiveRoomImageView)
        self.contentView.addSubview(emptyLabel)
        
        emptyLiveRoomImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(18)
            make.trailing.equalTo(-13)
            make.width.height.equalTo(137)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(emptyLiveRoomImageView.snp.leading).offset(-18)
            make.leading.equalTo(24)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var emptyLiveRoomImageView: UIImageView =  {
        let imageView = UIImageView(image: UIImage(named: "emptyFollowImage"))
        imageView.frame.size = CGSize(width: 137, height: 137)
        return imageView
    }()

    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    func configWithModel(viewModel:FollowViewModel) {
        self.emptyLabel.text = viewModel.hint
        self.emptyLiveRoomImageView.image = UIImage(named: viewModel.emptyImageName)
    }
}

class ExploreFollowCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(rgb: 0xC3C3C5).cgColor
        self.contentView.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.centerX.equalToSuperview()
        }
        
        self.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 82)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "探\n索"
        label.font = UIFont(name: "Arial", size: 20)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        label.numberOfLines = 2
        return label
    }()
}

class RecommemdationCell: UITableViewCell {
    var delegate:RecommendDelegate?
    var userModel = UserProfileModel()
    lazy var avatarImage: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.04).cgColor
        return imageView
    }()

    var nameLable: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "", size: 13)
        label.textColor = .black
        return label
    }()
    
    var introductionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "", size: 13)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        label.numberOfLines = 0
        return label
    }()
    
    var subsribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("订阅", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.init(rgb: 0x25B4E1)//0xC3C3C5
        return button
    }()
    
    @objc
    func clickButton(){
        self.delegate?.didClickFollowButton(targetModel:self.userModel) { scuess in
            if scuess {
                self.subsribeButton.backgroundColor = UIColor.init(rgb: 0xC3C3C5)
                self.subsribeButton.setTitle("已订阅", for: .normal)
            }
        }
    }
    
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(avatarImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(subsribeButton)
        self.contentView.addSubview(introductionLabel)
        
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
        
        introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(55)
            make.leading.equalTo(avatarImage.snp.trailing).offset(13)
            make.trailing.equalTo(subsribeButton.snp.trailing)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        subsribeButton.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.top.equalTo(30)
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        subsribeButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    public func configWithModel(userProfileModel: UserProfileModel) {
        self.userModel = userProfileModel
        self.nameLable.text = userProfileModel.name
        self.introductionLabel.text = userProfileModel.introduction
        if let image = UIImage(named: "placeholder_avatar") {
             self.avatarImage.image = image
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
