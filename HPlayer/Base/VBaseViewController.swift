//
//  VBaseViewController.swift
//  HPlayer
//
//  Created by HF on 2023/12/29.
//

import UIKit
import AppTrackingTransparency

class VBaseViewController: UIViewController {
    lazy var navBar: BaseNavigationBar = {
        let view = BaseNavigationBar.view()
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.barTintColor = UIColor.hexColor("#141414")
        self.tabBarController?.tabBar.backgroundColor = UIColor.hexColor("#141414")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    var backImageView = UIImageView()

    var emptyView: AVNoNetView = AVNoNetView.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        HPTBAManager.shared.setParamlist(type: .session)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.addTrack()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(netStatusChange), name: Notification.Name("netStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushPlayVC), name: HPKey.Noti_PushAPNS, object: nil)
        view.backgroundColor = UIColor.hexColor("#141414")
        setBackgroudView()
        setNavBar()
        emptyView.isHidden = true
        emptyView.clickBlock = { [weak self] in
            guard let self = self else { return }
            self.reSetRequest()
        }
    }
    
    deinit {
        HPProgressHUD.dismiss()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func netStatusChange() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            switch appDelegate.netStatus {
            case .reachable(_):
                reSetRequest()
            default:
                break
            }
        }
    }
    
    @objc func pushPlayVC(_ info: Notification) {
        if HPConfig.topVC()?.isKind(of: VBaseViewController.self) == true {
            if let u = info.userInfo as? [String: Any], let model = apnsModel.deserialize(from: u) {
                let mod = AVModel()
                mod.id = model._id
                mod.type = model.type
                DBManager.share.updateData(mod)
                PlayerManager.share.openPlayer(vc: self, id: mod.id, from: .push, animation:  false)
            }
        }
    }
    
    func reSetRequest() {
        
    }

    func setBackgroudView() {
        view.addSubview(backImageView)
        backImageView.contentMode = .scaleToFill
        backImageView.image = UIImage.init(named: "video_home_bg")
        view.insertSubview(backImageView, at: 0)
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setNavBar() {
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
                self.clickBackAction()
            case 1:
                self.clickRightAction()
            default:
                self.clickMiddleAction()
            }
        }
    }
    
    func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func clickRightAction() {
        
    }
    
    func clickMiddleAction() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
}

extension VBaseViewController {
    // 是否支持自动转屏
    override var shouldAutorotate: Bool {
        return false
    }

    // 支持哪些屏幕方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // 默认的屏幕方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

extension VBaseViewController: UIGestureRecognizerDelegate {
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
