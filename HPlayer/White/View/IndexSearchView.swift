//
//  IndexSearchView.swift
//  HPlayer
//
//  Created by HF on 2024/4/12.
//

import UIKit

class IndexSearchView: UIView {
    var clickCancelBlcok: (() -> Void)?
    var clickClearBlcok: (() -> Void)?

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    class func view() -> IndexSearchView {
        let v = Bundle.main.loadNibNamed(String(describing: IndexSearchView.self), owner: nil)?.first as! IndexSearchView
        v.searchView.layer.cornerRadius = 12
        v.searchView.layer.masksToBounds = true
        let attr = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.hexColor("#141414", alpha: 0.5), .font: UIFont.systemFont(ofSize: 12, weight: .medium)])
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
