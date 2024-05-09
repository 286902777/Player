//
//  HPCommon.swift
//  HPPlixor
//
//  Created by HF on 2023/11/2.
//

import Foundation
import UIKit

let kScreenBounds = UIScreen.main.bounds

//屏幕大小
let kScreenSize                           = kScreenBounds.size
//屏幕高度
let kScreenHeight: CGFloat                = kScreenSize.height
//屏幕宽度
let kScreenWidth: CGFloat                 = kScreenSize.width


//导航栏默认高度
var kNavBarHeight:CGFloat {
    get {
        return (kStatusBarHeight + 44)
    }
}

//状态栏默认高度
var kStatusBarHeight:CGFloat {
    get {
        let scene = UIApplication.shared.connectedScenes.first
        guard let window = scene as? UIWindowScene else { return 0 }
        guard let status = window.statusBarManager else { return 0 }
        return status.statusBarFrame.height
    }
}

var isScreenFull = false

/// 顶部安全区高度
var kTopSafeHeight:CGFloat {
    get {
        let scene = UIApplication.shared.connectedScenes.first
        if let window = scene as? UIWindowScene, let key = window.windows.first  {
            return key.safeAreaInsets.top
        } else {
            return 0
        }
    }
}

/// 底部安全区高度
var kBottomSafeHeight:CGFloat {
    get {
        let scene = UIApplication.shared.connectedScenes.first
        if let window = scene as? UIWindowScene, let key = window.windows.first  {
            return key.safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}

//Tabbar默认高度
var kTabBarHeight: CGFloat {
    get {
        return kBottomSafeHeight + 49
    }
}

var ScreenFull = false

extension UIFont {
    static func font(weigth: UIFont.Weight = .regular ,size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weigth)
    }
}

extension UIDevice {
    var modelName: String {
        var info = utsname()
        uname(&info)
        let mirror = Mirror(reflecting: info.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
