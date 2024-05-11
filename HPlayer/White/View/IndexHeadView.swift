//
//  IndexHeadView.swift
//  HPlayer
//
//  Created by HF on 2024/5/9.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class IndexHeadView: UIView {
    lazy var dayBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Today", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    lazy var weekBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("This week", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var isToDay: Bool = true {
        didSet {
            if isToDay {
                self.dayBtn.backgroundColor = UIColor.hexColor("#5548C1", alpha: 0.5)
                self.weekBtn.backgroundColor = UIColor.clear
                self.dayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                self.weekBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                self.dayBtn.snp.updateConstraints { make in
                    make.width.equalTo(66)
                }
                self.weekBtn.snp.updateConstraints { make in
                    make.width.equalTo(58)
                }
                self.dayBtn.layer.cornerRadius = 16
                self.weekBtn.layer.cornerRadius = 0
            } else {
                self.weekBtn.backgroundColor = UIColor.hexColor("#5548C1", alpha: 0.5)
                self.dayBtn.backgroundColor = UIColor.clear
                self.weekBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                self.dayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                self.dayBtn.snp.updateConstraints { make in
                    make.width.equalTo(40)
                }
                self.weekBtn.snp.updateConstraints { make in
                    make.width.equalTo(96)
                }
                self.dayBtn.layer.cornerRadius = 0
                self.weekBtn.layer.cornerRadius = 16
            }
        }
    }
    var clickBlock:((_ isDay: Bool) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        self.isHidden = true
        self.addSubview(dayBtn)
        self.addSubview(weekBtn)
        dayBtn.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(32)
        }
        weekBtn.snp.makeConstraints { make in
            make.left.equalTo(dayBtn.snp.right).offset(16)
            make.top.equalToSuperview()
            make.width.equalTo(58)
            make.height.equalTo(32)
        }
        dayBtn.tag = 1
        weekBtn.tag = 2
        dayBtn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        weekBtn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        self.isToDay = true
    }
    
    @objc func clickAction(_ sender: UIButton) {
        self.isToDay = sender.tag == 1
        self.clickBlock?(self.isToDay)
    }
}
