//
//  PlayerManager.swift
//  HPlayer
//
//  Created by HF on 2023/12/21.
//


import UIKit

enum PlayerShowCase: Int {
    case always         = 0 /// 始终显示
    case horizantal     = 1 /// 只在横屏界面显示
    case none           = 2 /// 不显示
}

enum PlayFrom: Int {
    case index = 1
    case search
    case history
    case banner
    case list
    case play
    case explore
    case nextTV
    case historyList
    case searchList
    case selectTV
    case push
}

class PlayerManager {
    static let share = PlayerManager()
        
    var language: String = ""
    
    var defaultLanguage: String = "en"

    var isLock: Bool = false
    /// auto play
    var autoPlay = true
    
    var topBarInCase = PlayerBarCase.always
    
    var animateDelayInterval = TimeInterval(3)
    
    var subtitleOn = true
    /// should show log
    var allowLog  = false
    
    /// use gestures to set brightness, volume and play position
    var enableBrightnessGestures = true
    var enableVolumeGestures = true
    var enablePlaytimeGestures = true
    var enableChooseDefinition = false
    var enablePlayControlGestures = true
    
    func openPlayer(vc: UIViewController, id: String, from: PlayFrom, animation: Bool = true) {
        if HPConfig.share.isNetWork == false {
            HPProgressHUD.error("No network!")
            return
        }
        if let model = DBManager.share.selectAVData(id: id) {
            let controller = AVPlayViewController(model: model, from: from)
            controller.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func getLanguage() -> String {
        if self.language.isEmpty {
            if let lang = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first {
                return lang
            } else {
                return "en"
            }
        } else {
            return self.language
        }
    }
}
