//
//  AVTabController.swift
//  HPlayer
//
//  Created by HF on 2024/3/13.
//

import UIKit

class AVTabController: UITabBarController {
    enum TabBarStauts: String {
        case index = "Home"
        case explore = "Explore"
        case vip = "Premium"
        case set = "Setting"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = addSubVC(controller: AVHomeViewController(),title: TabBarStauts.index.rawValue, image: "index", selectImage: "index_sel")
        let explore = addSubVC(controller: AVFilterViewController(),title: TabBarStauts.explore.rawValue, image: "exp", selectImage: "exp_sel")
        let set = addSubVC(controller: AVSettingViewController(),title: TabBarStauts.set.rawValue, image: "setting", selectImage: "setting_sel")
//        let vip = setChildVC(vc: VipViewController(),title: TabBarItem.vip.rawValue, image: "vipTab", selectImage: "vipTab_select")

        self.tabBar.barTintColor = UIColor.hexColor("#141414")
        self.tabBar.backgroundColor = UIColor.hexColor("#141414")
        self.tabBar.isTranslucent = false
        self.viewControllers = [index, explore, set]
    }
    
    func addSubVC(controller: UIViewController, title: String, image: String, selectImage: String) -> UINavigationController {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: image)
        controller.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor("#FFFFFF", alpha: 0.5), .font: UIFont.systemFont(ofSize: 10)], for: .normal)
        
        controller.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 10)], for: .selected)

        controller.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        return UINavigationController.init(rootViewController: controller)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title ?? "")
        if let t = item.title {
            switch TabBarStauts.init(rawValue: t) {
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


