//
//  WNavigationBar.swift
//  HPlayer
//
//  Created by HF on 2024/2/19.
//

import UIKit

class WNavigationBar: UIView{
    
    @IBOutlet weak var leftL: UILabel! {
        didSet {
            leftL.font = UIFont.font(weigth: .semibold, size: 28)
        }
    }
    @IBOutlet weak var navLeft: NSLayoutConstraint!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var vipBtn: UIButton!
    
    @IBOutlet weak var middleBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    var navBarBlock: ((_ tag: Int)->())?
    
    class func view() -> WNavigationBar {
        let view = Bundle.main.loadNibNamed(String(describing: WNavigationBar.self), owner: nil)?.first as! WNavigationBar
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavBarHeight)
        return view
    }

    
    @IBAction func BtnAction(_ sender: Any) {
        if let btn = sender as? UIButton {
            navBarBlock?(btn.tag)
            DispatchQueue.main.async {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.addTrack()
                }
            }
        }
    }
    
    func setBackHidden(_ hidden: Bool = false) {
        self.backBtn.isHidden = hidden
        if hidden {
            navLeft.constant = 16
        } else {
            navLeft.constant = 6
        }
    }
}

