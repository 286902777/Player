//
//  ProgressHud.swift
//  HPlayer
//
//  Created by HF on 2023/11/15.
//

import Foundation
import SVProgressHUD

class HPProgressHUD {
    static func show() {
        SVProgressHUD.show(withStatus: "loading")
    }
    
    static func success(_ text: String) {
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    static func error(_ text: String) {
        SVProgressHUD.showError(withStatus: text)
    }
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
}
