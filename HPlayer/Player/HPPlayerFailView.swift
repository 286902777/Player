//
//  HPPlayerFailView.swift
//  HPPlixor
//
//  Created by HF on 2023/12/21.
//


import UIKit

class HPPlayerFailView: UIView {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tryBtn: UIButton!
    
    var clickBlock: (()->())?
    class func view() -> HPPlayerFailView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerFailView.self), owner: nil)?.first as! HPPlayerFailView
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 120)
        view.tryBtn.layer.cornerRadius = 18
        view.tryBtn.layer.masksToBounds = true
        return view
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        self.clickBlock?()
    }
    
}
