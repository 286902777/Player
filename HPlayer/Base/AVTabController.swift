//
//  AVTabController.swift
//  HPlayer
//
//  Created by HF on 2024/3/13.
//

import UIKit

class AVTabController: UITabBarController {
    enum TabBarItem: String {
        case index = "Home"
        case explore = "Explore"
        case vip = "Premium"
        case set = "Setting"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = setChildVC(vc: AVHomeViewController(),title: TabBarItem.index.rawValue, image: "index", selectImage: "index_sel")
        let explore = setChildVC(vc: AVFilterViewController(),title: TabBarItem.explore.rawValue, image: "exp", selectImage: "exp_sel")
        let set = setChildVC(vc: AVSettingViewController(),title: TabBarItem.set.rawValue, image: "setting", selectImage: "setting_sel")
//        let vip = setChildVC(vc: VipViewController(),title: TabBarItem.vip.rawValue, image: "vipTab", selectImage: "vipTab_select")

        self.tabBar.barTintColor = UIColor.hexColor("#141414")
        self.tabBar.backgroundColor = UIColor.hexColor("#141414")
        self.tabBar.isTranslucent = false
        self.viewControllers = [index, explore, set]
    }
    
    func setChildVC(vc: UIViewController, title: String, image: String, selectImage: String) -> UINavigationController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor("#FFFFFF", alpha: 0.5), .font: UIFont.systemFont(ofSize: 10)], for: .normal)
        
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 10)], for: .selected)

        vc.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        return UINavigationController.init(rootViewController: vc)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title ?? "")
        if let t = item.title {
            switch TabBarItem.init(rawValue: t) {
            case .explore:
                HPLog.tb_home_cl(kid: "5", c_id: "", c_name: "", ctype: "", secname: "", secid: "")
            case .vip:
                HPLog.tb_vip_sh(source: "1")
                HPLog.tb_home_cl(kid: "7", c_id: "", c_name: "", ctype: "", secname: "", secid: "")
            default:
                break
            }
        }
    }
}


