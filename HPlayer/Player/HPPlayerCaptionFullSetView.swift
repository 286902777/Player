//
//  HPPlayerCaptionFullSetView.swift
//  HPlayer
//
//  Created by HF on 2024/2/13.
//


import UIKit

class HPPlayerCaptionFullSetView: UIView {
    @IBOutlet weak var eView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var switchBtn: UIButton!
    
    @IBOutlet weak var languageBtn: UIButton!
    
    @IBAction func clickAction(_ sender: Any) {
        if let btn = sender as? UIButton, btn.tag == 0 {
            btn.isSelected = !btn.isSelected
            PlayerManager.share.subtitleOn = btn.isSelected
        } else {
            self.langView = HPPlayerLanguageFullView.view()
            self.baseView?.addSubview(self.langView!)
            self.langView?.snp.makeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
            self.langView?.setModel(self.list)
            self.langView?.clickBlock = { [weak self] address in
                self?.clickBlock?(address)
            }
            self.langView?.backBlock = { [weak self] in
                self?.dismissSelf()
            }
        }
    }
    
    private var langView: HPPlayerLanguageFullView?
    private var baseView: UIView?
    private var list: [AVCaption] = []
    var clickBlock: ((_ address: String)->())?

    class func view() -> HPPlayerCaptionFullSetView {
        let view = Bundle.main.loadNibNamed(String(describing: HPPlayerCaptionFullSetView.self), owner: nil)?.first as! HPPlayerCaptionFullSetView
        view.switchBtn.isSelected = PlayerManager.share.subtitleOn
        view.eView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        view.eView.setEffectView(CGSize(width: 356 + 48, height: kScreenWidth))
        return view
    }
    
    @objc func dismissSelf() {
        self.langView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    func setModel(_ list: [AVCaption], view: UIView) {
        self.list = list
        self.baseView = view
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        self.addGestureRecognizer(tap)
    }
}
