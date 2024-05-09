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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.BGColor
        addNavBar()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.addTrack()
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
    
    func backAction() {
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
