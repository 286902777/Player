//
//  ProgressHud.swift
//  HPlayer
//
//  Created by HF on 2023/11/15.
//

import Foundation
import ProgressHUD

class HPProgressHUD {
    static func config() {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorBackground = .white
        ProgressHUD.colorAnimation = .black
        ProgressHUD.mediaSize = 60
        ProgressHUD.marginSize = 20
        ProgressHUD.colorStatus = .black
        ProgressHUD.colorBannerTitle = .black
        ProgressHUD.fontStatus = .systemFont(ofSize: 18)
    }
    static func show() {
        HPProgressHUD.config()
        ProgressHUD.animate("loading...")
    }
    
    static func success(_ text: String) {
        HPProgressHUD.config()
        ProgressHUD.succeed("text", delay: 2)
    }
    
    static func error(_ text: String) {
        HPProgressHUD.config()
        ProgressHUD.failed("text", delay: 2)
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
