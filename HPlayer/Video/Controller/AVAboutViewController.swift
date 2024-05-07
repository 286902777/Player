//
//  AVAboutViewController.swift
//  HPlayer
//
//  Created by HF on 2024/4/15.
//

import UIKit

class AVAboutViewController: VBaseViewController {

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var versonL: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.rightBtn.isHidden = true
        self.navBar.titleL.text = "About us"

        if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            self.nameL.text = appName
        }
    
        if HPConfig.app_version.isEmpty == false {
            self.versonL.text = "V\(HPConfig.app_version)"
        }
    }
}
