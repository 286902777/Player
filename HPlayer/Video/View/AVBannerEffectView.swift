//
//  AVBannerEffectView.swift
//  HPlayer
//
//  Created by HF on 2024/4/10.
//

import UIKit

class AVBannerEffectView: UIView {
    lazy var imageV: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    func configUI() {
        self.addSubview(imageV)
        self.addSubview(backView)
        self.imageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setEffect() {
        self.layoutIfNeeded()
        backView.setEffectView(CGSize(width: self.frame.size.width, height: self.frame.size.height))
    }
}
