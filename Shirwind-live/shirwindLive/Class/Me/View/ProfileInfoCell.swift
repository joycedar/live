
import Foundation
import UIKit
import SnapKit



class ProfileCell:UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(fansCountLabel)
        self.contentView.addSubview(followCountLabel)
        self.contentView.addSubview(fansLabel)
        self.contentView.addSubview(followLabel)

        avatarImageView.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.height.width.equalTo(80)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(6)
        }
        followLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview()
        }
        followCountLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(43)
        }
        fansLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(followLabel.snp.trailing).offset(50)
            make.bottom.equalToSuperview()
        }
        fansCountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(followLabel.snp.trailing).offset(50)
            make.top.equalTo(nameLabel.snp.bottom).offset(43)
        }
    }
    
    public func configWithModel(userModel: UserProfileModel) {
        self.avatarImageView.image = UIImage(named: "me_photo")
        self.nameLabel.text = userModel.name
        self.fansCountLabel.text = String(userModel.fansCount)
        self.followCountLabel.text = String(userModel.followsCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(rgb: 0xC3C3C5)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 32)
        label.text = "JoyCedar"
        label.textColor = .black
        return label
    }()
    
    private lazy var followCountLabel:UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Arial", size: 24)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var fansCountLabel:UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Arial", size: 24)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var fansLabel:UILabel = {
        let label = UILabel()
        label.text = "粉丝"
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
    private lazy var followLabel:UILabel = {
        let label = UILabel()
        label.text = "关注"
        label.font = UIFont(name: "Arial", size: 12)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
}

class MeSettingCell: UITableViewCell{

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        self.contentView.addSubview(iconIamge)
        self.contentView.addSubview(iconLabel)
        self.contentView.addSubview(seperatorView)
        
        iconIamge.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.top.equalTo(8)
            make.width.height.equalTo(24)
        }
        
        iconLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconIamge.snp.trailing).offset(20)
            make.top.equalTo(8)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.leading.equalTo(iconIamge.snp.trailing).offset(5)
            make.top.equalTo(iconIamge.snp.bottom).offset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var seperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xC3C3C5)
        return view
    }()
    
    private lazy var iconIamge = UIImageView()

    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = UIColor(rgb: 0xC3C3C5)
        return label
    }()
    
    public func configWithIconNameAndIconImageName(name:String, imageName:String) {
        self.iconIamge.image = UIImage(named: name)
        self.iconLabel.text = imageName
    }
}


