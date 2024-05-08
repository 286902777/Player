//
//  HPRemoteManager.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import UIKit
//import FirebaseRemoteConfig

class HPRemoteManager: NSObject {
    
    static let share = HPRemoteManager()
    
    var trys = 0

//    var defaultConfig = RemoteConfig.remoteConfig()
//    
//    func Config() {
//        // ad setting
//        var admob = ""
//        if let adJson = UserDefaults.standard.value(forKey: HPKey.advertiseKey) as? String, adJson.count > 0 {
//            admob = UserDefaults.standard.value(forKey: HPKey.advertiseKey) as! String
//        } else {
//#if DEBUG
//            let filePath = Bundle.main.path(forResource: "ad_debug", ofType: "json")!
//#else
//            let filePath = Bundle.main.path(forResource: "ad_release", ofType: "json")!
//#endif
//            let fileData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
//            admob = fileData.base64EncodedString()
//        }
//        
//        defaultConfig.setDefaults(["ads_json_ios": admob as NSObject])
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0
//        defaultConfig.configSettings = settings
//        self.fetchConfigData()
//    }
//    
//    
//    private func requestFBConfig() {
//        defaultConfig.activate { success, error in
//            guard error == nil else {
//                HPLog.log("Remote activated error: \(error?.localizedDescription ?? "No error available.")")
//                return
//            }
//            HPLog.log("Remote config successfully activated!")
//            if let jsonString = self.defaultConfig["ads_json_ios"].stringValue {
//                if jsonString != UserDefaults.standard.value(forKey: HPKey.advertiseKey) as? String {
//                    UserDefaults.standard.set(jsonString, forKey: HPKey.advertiseKey)
//                    let jsonData = Data(base64Encoded: jsonString) ?? Data()
//                    if let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
//                        if let model = HPADTypeModel.deserialize(from: json) {
//                            HPADManager.share.adInfoModel = model
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func fetchConfigData() {
//        defaultConfig.fetch { status, error in
//            guard error == nil else {
//                HPLog.log("Remote config error: \(error?.localizedDescription ?? "error noData")")
//                if self.trys == 0 {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                        self.trys += 1
//                        self.fetchConfigData()
//                    }
//                }
//                return
//            }
//            HPLog.log("Remote config successed")
//            self.requestFBConfig()
//        }
//    }

}
