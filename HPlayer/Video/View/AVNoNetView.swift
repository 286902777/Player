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
        if type == .net {
            self.desL.text = "Oops! Looks like you're offline. Please reconnect."
            self.iconV.image = UIImage(named: "no_network")
        } else {
            self.desL.text = "Oops!Failed to load data."
            self.iconV.image = UIImage(named: "no_content")
        }
    }
    
    @IBAction func clickAction(_ sender: Any) {
        self.clickBlock?()
    }
}
