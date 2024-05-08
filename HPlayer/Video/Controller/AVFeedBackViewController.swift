//
//  AVFeedBackViewController.swift
//  HPlayer
//
//  Created by HF on 2024/2/19.
//

import UIKit
import IQKeyboardManagerSwift

class AVFeedBackViewController: VBaseViewController {
    var titleName: String = ""
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var feedBackL: UILabel!
    @IBOutlet weak var contentV: IQTextView!
    @IBOutlet weak var emailV: IQTextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.rightBtn.isHidden = false
        self.navBar.rightBtn.setImage(UIImage(named: "nav_sure"), for: .normal)
        self.navBar.titleL.text = titleName
        
        top.constant = kNavBarHeight + 20
        contentV.layer.cornerRadius = 16
        contentV.layer.masksToBounds = true
        contentV.textContainerInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        emailV.layer.cornerRadius = 16
        emailV.layer.masksToBounds = true
        emailV.textContainerInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        contentV.placeholder = "Please input"
        contentV.textColor = UIColor.white
        contentV.placeholderTextColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        contentV.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
        
        emailV.placeholder = "Please input"
        emailV.textColor = UIColor.white
        emailV.placeholderTextColor = UIColor.hexColor("#FFFFFF", alpha: 0.5)
        emailV.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
    }

    override func clickRightAction() {
        if contentV.text.count > 0, emailV.text.count > 0 {
            toast("Feedback successful")
            self.navigationController?.popViewController(animated: true)
        } else {
            toast("Please enter your feedback or email")
        }
    }
}
