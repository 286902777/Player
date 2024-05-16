//
//  AVBannerCell.swift
//  HPlayer
//
//  Created by HF on 2024/4/9.
//

import UIKit
import JXBanner

class AVBannerCell: JXBannerBaseCell {
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
        label.font = UIFont(name: "Bebas Neue", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    lazy var qualityL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.hexColor("#9B90FF", alpha: 0.25)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var newL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "New"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.hexColor("#F15009")
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var playView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "banner_play")
        return view
    }()
    
    lazy var topMengView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor("#141414", alpha: 0.35)
        return view
    }()

    open override func jx_addSubviews() {
        super.jx_addSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        contentView.addSubview(bgView)
        contentView.addSubview(newL)
        contentView.addSubview(playView)
        contentView.addSubview(starImgV)
        contentView.addSubview(starL)
        contentView.addSubview(qualityL)
        contentView.addSubview(titleL)
        contentView.addSubview(topMengView)

        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newL.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-6)
            make.size.equalTo(CGSize(width: 46, height: 22))
        }
        
        playView.snp.makeConstraints { make in
            make.bottom.equalTo(-18)
            make.right.equalTo(-6)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        starImgV.snp.makeConstraints { make in
            make.bottom.equalTo(-5)
            make.left.equalTo(12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        starL.snp.makeConstraints { make in
            make.left.equalTo(starImgV.snp.right).offset(4)
            make.centerY.equalTo(starImgV)
        }
        
        qualityL.snp.makeConstraints { make in
            make.left.equalTo(starL.snp.right).offset(12)
            make.centerY.equalTo(starImgV)
            make.size.equalTo(CGSize(width: 36, height: 20))
        }
        
        titleL.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(playView.snp.left).offset(-12)
            make.bottom.equalTo(starImgV.snp.top).offset(-5)
        }
        
        topMengView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setModel(_ model: AVDataInfoModel) {
        let attr: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeColor: UIColor.hexColor("#141414"), NSAttributedString.Key.strokeWidth: -0.5]
        self.titleL.attributedText = NSAttributedString(string: model.title, attributes: attr)
        
        self.imageView.setImage(with: model.horizontal_cover)
        if let r = Float(model.rate) {
            self.starL.isHidden = false
            self.starL.text = String(format: "%.1f", r)
        } else {
            self.starL.isHidden = true
        }
        self.newL.isHidden = Date.IsWeekData(tp: model.storage_timestamp)
        self.qualityL.isHidden = model.quality.count > 0 ? false : true
        self.qualityL.text = model.quality
        self.playView.isHidden = true
        self.topMengView.isHidden = false
    }
}
