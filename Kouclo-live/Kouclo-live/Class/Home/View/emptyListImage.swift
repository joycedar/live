//
//  File.swift
//  Kouclo-live
//
//  Created by cedar on 2021/4/6.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit

class emptyListImage: UIView {
    var hint: UILabel = {
        let label  = UILabel()
        label.text = "现在还没有人在直播哟～默认介入CCTV频道～"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.addSubview(hint)
        hint.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
