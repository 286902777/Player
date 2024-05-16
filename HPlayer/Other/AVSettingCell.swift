//
//  AVSettingCell.swift
//  HPlayer
//
//  Created by HF on 2024/2/21.
//

import UIKit

class AVSettingCell: UITableViewCell {
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.F141414
        label.font = UIFont.font(weigth: .medium, size: 14)
        return label
    }()
    
    lazy var subTitleL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#FFFFFF", alpha: 0.7)
        label.font = UIFont.font(size: 14)
        label.isHidden = true
        return label
    }()
    
    lazy var arrowV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "set_arrow")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUI() {
        self.addSubview(titleL)
        self.addSubview(arrowV)
        self.addSubview(subTitleL)
        
        titleL.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.bottom.equalToSuperview()
        }
        
        arrowV.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        subTitleL.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
