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
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        self.addSubview(imageV)
        self.imageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addSubview(backView)
        self.backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setEffect() {
        self.layoutIfNeeded()
        backView.setEffectView(CGSize(width: self.frame.size.width, height: self.frame.size.height))
    }
}
