//
//  AVHistorySearchView.swift
//  HPlayer
//
//  Created by HF on 2024/4/12.
//

import UIKit

class AVHistorySearchView: UIView {
    var clickCancelBlcok: (() -> Void)?
    var clickClearBlcok: (() -> Void)?

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    class func view() -> AVHistorySearchView {
        let v = Bundle.main.loadNibNamed(String(describing: AVHistorySearchView.self), owner: nil)?.first as! AVHistorySearchView
        v.searchView.layer.cornerRadius = 22
        v.searchView.layer.borderColor = UIColor.hexColor("#B2AAFF", alpha: 0.75).cgColor
        v.searchView.backgroundColor = UIColor.hexColor("#B2AAFF", alpha: 0.1)
        v.searchView.layer.borderWidth = 1
        v.searchView.layer.masksToBounds = true
        let attr = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.hexColor("#FFFFFF", alpha: 0.5), .font: UIFont.systemFont(ofSize: 12)])
        v.searchTF.attributedPlaceholder = attr
        return v
    }
    
    @IBAction func clickCancelAction(_ sender: Any) {
        self.clickCancelBlcok?()
    }
    
    @IBAction func clickClearAction(_ sender: Any) {
        self.clickClearBlcok?()
    }
    
}
