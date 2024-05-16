//
//  HPPlayerCaptionSetView.swift
//  HPPlixor
//
//  Created by HF on 2024/3/21.
//


import UIKit

class HPPlayerCaptionSetView: UIViewController {
    private var list: [AVCaption] = []
    var clickItemBlock: ((_ address: String)->())?
    
    var dismissBlock: (()->Void)?
    
    @IBOutlet weak var clickView: UIView!
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var subtitleView: UIView!
    
    @IBOutlet weak var languageView: UIView!
    
    /// 初始化方法
    /// - Parameters:

    init(list:[AVCaption], isCancel: Bool = false) {
        super.init(nibName: nil, bundle:nil)
        self.list = list
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func clickAction(_ sender: Any) {
        self.btn.isSelected = !self.btn.isSelected
        PlayerManager.share.subtitleOn = self.btn.isSelected
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.bgView.transform = CGAffineTransform.identity
        }
    }
    private func showAnimation() {
        bgView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    @objc func dismissAnimation() {
        self.dismissBlock?()
        self.dismiss(animated: true, completion: nil)
    }
    private func setUpUI() {
        view.setEffectView(CGSize(width: kScreenWidth, height: kScreenHeight))
        bgView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.05)
        bgView.setCorner(conrners: [.topLeft, .topRight], radius: 24)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAnimation))
        self.clickView.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        setUpUI()
        self.btn.isSelected = PlayerManager.share.subtitleOn
    }
    
    @IBAction func clickBtnAction(_ sender: Any) {
        let vc = PlayerLanguageView()
        vc.list = self.list
        vc.clickBlock = { [weak self] address in
            self?.clickItemBlock?(address)
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}
