//
//  AVSettingViewController.swift
//  HPlayer
//
//  Created by HF on 2024/3/13.
//


import UIKit
//import AppLovinSDK
//import GoogleMobileAds

class AVSettingViewController: VBaseViewController {
    var list: [AVSettingModel] = []
    let cellIdentifier = "AVSettingCellIdentifier"

    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(AVSettingCell.self, forCellReuseIdentifier: cellIdentifier)
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.list = [AVSettingModel(type: .About), AVSettingModel(type: .Feedback), AVSettingModel(type: .Share), AVSettingModel(type: .Evaluate), AVSettingModel(type: .Privacy), AVSettingModel(type: .Terms)]
//        if HPUMPManager.shared.isPrivacyOptionsRequired {
//            self.list.append(AVSettingModel(type: .PrivacySetting))
//        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        view.addSubview(tableView)
        self.navBar.backBtn.isHidden = true
        self.navBar.rightBtn.isHidden = true
        self.navBar.titleL.text = "Setting"
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension AVSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AVSettingCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AVSettingCell
        let t = self.list[indexPath.row].type.rawValue
        cell.titleL.textColor = .white
        cell.titleL.text = t
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch list[indexPath.row].type {
        case .About:
            let vc = AVAboutViewController()
            vc.isVideo = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .Privacy:
            let vc = AVWebViewController()
            if let model = self.list.indexOfSafe(indexPath.row) {
                vc.name = model.type.rawValue
            }
            vc.link = HPKey.privacy
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .Terms:
            let vc = AVWebViewController()
            if let model = self.list.indexOfSafe(indexPath.row) {
                vc.name = model.type.rawValue
            }
            vc.link = HPKey.terms
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
//        case .PrivacySetting:
//            if HPUMPManager.shared.isPrivacyOptionsRequired {
//                HPUMPManager.shared.getPrivacyOptionsForm(from: self) { _ in
//                }
//            }
        case .Feedback:
            let vc = AVFeedBackViewController()
            if let model = self.list.indexOfSafe(indexPath.row) {
                vc.titleName = model.type.rawValue
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .Share:
            let url: String = "https://apps.apple.com/us/app/id\(HPKey.APPID)"
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        case .Evaluate:
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(HPKey.APPID)?action=write-review") {
                UIApplication.shared.open(url)
            }
        default:
//            #if DEBUG
//               self.setAdTestTool()
//            #endif
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
//    func setAdTestTool() {
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["9044820215e8f16b96eeff39b89d060c", "0ee00fe9a35b653f5b1a3c86d0036e6b"]
//        let alertController = UIAlertController(title: "AD Tools", message: "select AD Tool", preferredStyle: .actionSheet)
//        let action1 = UIAlertAction(title: "admob", style: .default) { (action) in
//            GADMobileAds.sharedInstance().presentAdInspector(from: self) { error in
//                
//            }
//        }
//        let action2 = UIAlertAction(title: "Max", style: .default) { (action) in
//            ALSdk.shared()!.showMediationDebugger()
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            // Cancel code
//        }
//        
//        alertController.addAction(action1)
//        alertController.addAction(action2)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
}

class AVSettingModel: BaseModel {
    enum SettingType: String {
        case About = "About"
        case Feedback = "Feedback"
        case Share = "Share"
        case Evaluate = "Evaluate"
        case Privacy = "Privacy Policy"
        case Terms = "Terms of Service"
        case PrivacySetting = "Privacy Setting"
    }
    var type: SettingType = .About
    
    init(type: SettingType) {
        self.type = type
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
