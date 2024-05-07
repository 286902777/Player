//
//  AVFilterSearchView.swift
//  HPlayer
//
//  Created by HF on 2024/1/10.
//

import UIKit

class AVFilterSearchView: UIView {
    var clickBlock: (() -> Void)?

    @IBOutlet weak var searchView: UIView!
    
    class func view() -> AVFilterSearchView {
        let view = Bundle.main.loadNibNamed(String(describing: AVFilterSearchView.self), owner: nil)?.first as! AVFilterSearchView
        view.searchView.layer.cornerRadius = 22
        view.searchView.layer.borderColor = UIColor.hexColor("#B2AAFF", alpha: 0.75).cgColor
        view.searchView.backgroundColor = UIColor.hexColor("#B2AAFF", alpha: 0.1)
        view.searchView.layer.borderWidth = 1
        view.searchView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(clickSearchAction))
        view.searchView.addGestureRecognizer(tap)
        return view
    }

    @objc func clickSearchAction() {
        self.clickBlock?()
    }
}
