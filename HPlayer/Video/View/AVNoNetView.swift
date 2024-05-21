//
//  AVNoNetView.swift
//  HPlayer
//
//  Created by HF on 2024/5/7.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class AVNoNetView: UIView {
    enum EmptyType: Int {
        case net = 1
        case content
        case favorite
    }
    
    @IBOutlet weak var tryBtn: UIButton!
    
    @IBOutlet weak var desL: UILabel!
    
    @IBOutlet weak var iconV: UIImageView!
    
    var clickBlock:(() -> Void)?

    class func view() -> AVNoNetView {
        let view = Bundle.main.loadNibNamed(String(describing: AVNoNetView.self), owner: nil)?.first as! AVNoNetView
        view.tryBtn.layer.cornerRadius = 18
        view.tryBtn.layer.masksToBounds = true
        return view
    }
    
    func setType(_ type: EmptyType = .net) {
        switch type {
        case .net:
            self.desL.text = "No network, please retry."
            self.iconV.image = UIImage(named: "no_network")
        case .content:
            self.desL.text = "No more content."
            self.iconV.image = UIImage(named: "no_content")
        default:
            self.desL.text = "No favorite content, please go to the homepage to view your favorite movies."
            self.iconV.image = UIImage(named: "no_content")
            self.tryBtn.isHidden = true
        }
    }
    
    @IBAction func clickAction(_ sender: Any) {
        self.clickBlock?()
    }
}
