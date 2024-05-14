//
//  IndexBannerCell.swift
//  HPlayer
//
//  Created by HF on 2024/5/9.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit
import JXBanner

class IndexBannerCell: JXBannerBaseCell {
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "banner_mask")
        return view
    }()
    
    lazy var starImgV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cell_star")
        return view
    }()
    
    lazy var starL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#B2AAFF")
        label.textAlignment = .center
        return label
    }()
    
    lazy var likeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.backgroundColor = UIColor.hexColor("#000000", alpha: 0.15)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var stackV: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.spacing = 6
        return view
    }()
    
    lazy var favoriteL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Favorite"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    lazy var favImgV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "w_unlike")
        return view
    }()
    
    lazy var playView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "w_banner_play")
        return view
    }()

    open override func jx_addSubviews() {
        super.jx_addSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        contentView.addSubview(bgView)
        contentView.addSubview(likeView)
        contentView.addSubview(playView)
        contentView.addSubview(starImgV)
        contentView.addSubview(starL)
        contentView.addSubview(titleL)

        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-8)
            make.height.equalTo(26)
        }
        
        likeView.addSubview(stackV)
        stackV.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7))
        }
        
        stackV.addArrangedSubview(favImgV)
        stackV.addArrangedSubview(favoriteL)

        favImgV.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        playView.snp.makeConstraints { make in
            make.bottom.equalTo(-24)
            make.right.equalTo(-8)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        starImgV.snp.makeConstraints { make in
            make.bottom.equalTo(-22)
            make.left.equalTo(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        starL.snp.makeConstraints { make in
            make.left.equalTo(starImgV.snp.right).offset(4)
            make.centerY.equalTo(starImgV)
        }
        
        titleL.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.right.equalTo(playView.snp.left).offset(-12)
            make.bottom.equalTo(starImgV.snp.top).offset(-6)
        }
    }

    func setModel(_ model: IndexDataListModel) {
        let attr: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeColor: UIColor.hexColor("#141414"), NSAttributedString.Key.strokeWidth: -0.5]
        self.titleL.attributedText = NSAttributedString(string: model.title, attributes: attr)
        self.imageView.setImage(with: model.horizontal_cover)

        if let r = Float(model.rate) {
            self.starL.isHidden = false
            let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Open Sans", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .medium), .foregroundColor: UIColor.hexColor("#B2AAFF")]
            self.starL.attributedText = NSAttributedString(string: String(format: "%.1f", r), attributes: attr)
        } else {
            self.starL.isHidden = true
        }
        let arr = DBManager.share.selectWhiteData()
        if let _ = arr.first(where: {$0.id == model.id}) {
            model.isLike = true
        }
        self.favImgV.image = UIImage(named: model.isLike ? "w_like" : "w_unlike")
        self.favoriteL.text = model.isLike ? "Favorited" : "Favorite"
    }
}
