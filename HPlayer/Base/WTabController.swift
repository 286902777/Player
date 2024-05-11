//
//  WTabController.swift
//  HPlayer
//
//  Created by HF on 2024/5/9.
//  Copyright © 2024 HPlayer. All rights reserved.
//

import UIKit

class WTabController: UITabBarController {
    enum wTabBarStauts: String {
        case index = "Home"
        case favorite = "Favorite"
        case my = "My Library"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = addChildVC(controller: IndexViewController(),title: wTabBarStauts.index.rawValue, image: "w_index", selectImage: "w_index_sel")
        let fav = addChildVC(controller: FavoriteViewController(),title: wTabBarStauts.favorite.rawValue, image: "w_favorite", selectImage: "w_favorite_sel")
        let my = addChildVC(controller: MyLibraryViewController(),title: wTabBarStauts.my.rawValue, image: "w_my", selectImage: "w_my_sel")

        self.tabBar.barTintColor = UIColor.hexColor("#141414", alpha: 0.9)
        self.tabBar.backgroundColor = UIColor.hexColor("#141414", alpha: 0.9)
        self.tabBar.isTranslucent = false
        self.viewControllers = [index, fav, my]
    }
    
    func addChildVC(controller: UIViewController, title: String, image: String, selectImage: String) -> UINavigationController {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(named: image)
        controller.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor("#FFFFFF", alpha: 0.5), .font: UIFont.systemFont(ofSize: 10)], for: .normal)
        
        controller.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 10)], for: .selected)

        controller.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        return UINavigationController.init(rootViewController: controller)
    }
}
