//
//  AVHistoryBottomView.swift
//  TBPlixor
//
//  Created by HF on 2023/1/3.
//

import UIKit

class AVHistoryBottomView: UIView {
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var clickBlock:((_ index: Int) -> Void)?
    var clickSelectBlock:((_ select: Bool) -> Void)?

    class func view() -> AVHistoryBottomView {
        let view = Bundle.main.loadNibNamed(String(describing: AVHistoryBottomView.self), owner: nil)?.first as! AVHistoryBottomView
        view.cancelBtn.layer.cornerRadius = 18
        view.cancelBtn.layer.borderWidth = 2
        view.cancelBtn.layer.borderColor = UIColor.hexColor("#FFFFFF", alpha: 0.75).cgColor
        view.cancelBtn.layer.masksToBounds = true
        view.deleteBtn.layer.cornerRadius = 18
        view.deleteBtn.layer.masksToBounds = true
        view.backgroundColor = UIColor.hexColor("#141414", alpha: 0.7)
        return view
    }
    
    override func layoutSubviews() {
        self.setEffectView(CGSize(width: kScreenWidth, height: 98 + kBottomSafeHeight))
    }
    
    @IBAction func clickAction(_ sender: Any) {
        if let btn = sender as? UIButton {
            if btn.tag == 0 {
                self.selectBtn.isSelected = !self.selectBtn.isSelected
                self.clickSelectBlock?(self.selectBtn.isSelected)
            } else {
                self.clickBlock?(btn.tag)
            }
        }
    }
    
    func show() {
        self.selectBtn.isSelected = false
    }
}
