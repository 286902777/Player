//
//  AVHomeHeadView.swift
//  HPlayer
//
//  Created by HF on 2024/1/10.
//

import UIKit

class AVHomeHeadView: UIView {
    var clickBlock: ((_ type: ButtonType) -> Void)?
    enum ButtonType: Int {
        case vip = 0
        case search
    }
    @IBOutlet weak var searchView: UIView!
    
    class func view() -> AVHomeHeadView {
        let view = Bundle.main.loadNibNamed(String(describing: AVHomeHeadView.self), owner: nil)?.first as! AVHomeHeadView
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 44)
        view.searchView.layer.cornerRadius = 22
        view.searchView.layer.borderColor = UIColor.hexColor("#B2AAFF", alpha: 0.75).cgColor
        view.searchView.backgroundColor = UIColor.hexColor("#B2AAFF", alpha: 0.1)
        view.searchView.layer.borderWidth = 1
        view.searchView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(clickSearchAction))
        view.searchView.addGestureRecognizer(tap)
        return view
    }
    
    @IBAction func clickVipAction(_ sender: Any) {
        self.clickBlock?(.vip)
    }
    
    @objc func clickSearchAction() {
        self.clickBlock?(.search)
    }
}
