//
//  BaseViewController.swift
//  HPlayer
//
//  Created by HF on 2024/1/2.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    lazy var navBar: WNavigationBar = {
        let view = WNavigationBar.view()
        return view
    }()
    
    var backView = UIImageView()
    var emptyView: AVNoNetView = AVNoNetView.view()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.F141414
        addBackView()
        addNavBar()
        setUI()
        emptyView.isHidden = true
        emptyView.clickBlock = { [weak self] in
            guard let self = self else { return }
            self.reSetRequest()
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.addTrack()
        }
    }
    
    func reSetRequest() {
        
    }
    
    func addBackView() {
        view.addSubview(backView)
        backView.contentMode = .scaleToFill
        backView.image = UIImage.init(named: "home_bg")
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addNavBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        view.addSubview(self.navBar)
        navBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavBarHeight)
        }
        navBar.navBarBlock = { [weak self] tag in
            guard let self = self else { return }
            switch tag {
            case 0:
                self.backAction()
            case 1:
                self.rightAction()
            case 2:
                self.middleAction()
            default:
                self.vipAction()
            }
        }
    }
    
    func setUI() {
        
    }
    
    func backAction() {
        HPProgressHUD.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightAction() {
        
    }
    
    func middleAction() {
        
    }
    
    func vipAction() {
        
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.interactivePopGestureRecognizer == gestureRecognizer {
            if let nav = self.navigationController {
                if nav.viewControllers.count < 2 {
                   return false
                }
            }
        }
        return true
    }
}
