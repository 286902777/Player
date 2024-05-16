//
//  AVAlertController.swift
//  HPlayer
//
//  Created by HF on 2024/4/3.
//

import UIKit

class AVAlertController: UIViewController {
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var contentL: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var comfirmBtn: UIButton!
    @IBAction func clickCancelAction(_ sender: Any) {
        self.dismissAnimate()
    }
    @IBAction func clickSureAction(_ sender: Any) {
        self.clickBlock?()
        self.dismissAnimate()
    }
    
    var clickBlock:(() -> Void)?
    
    private var titleText: String?
    private var contentText: String?
    init(_ title: String?, _ content: String?) {
        super.init(nibName: nil, bundle:nil)
        self.modalPresentationStyle = .overFullScreen
        self.titleText = title
        self.contentText = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alertView.transform = CGAffineTransform.identity
        }
    }
    private func showAnimate() {
        alertView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    private func dismissAnimate() {
        self.dismiss(animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.setEffectView(CGSize(width: kScreenWidth, height: kScreenHeight))
        alertView.layer.cornerRadius = 12
        alertView.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.1)
        alertView.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 20
        comfirmBtn.layer.cornerRadius = 20
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor.hexColor("#FFFFFF", alpha: 0.75).cgColor
        cancelBtn.layer.masksToBounds = true
        comfirmBtn.layer.masksToBounds = true
        showAnimate()
        showView()
    }
    
    private func showView() {
        self.titleL.text = self.titleText
        self.contentL.text = self.contentText
    }
}
