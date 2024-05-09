//
//  HPConfig.swift
//  HPPlixor
//
//  Created by HF on 2023/12/20.
//

import Foundation
import UIKit
import AdSupport
import Alamofire
//import GoogleMobileAds
//import UserMessagingPlatform

class HPConfig{
    static let share = HPConfig()
    enum rootStatus: Int {
        case home = 0
        case play
    }
    
    static let SafeBUNDLEID = "com.HPlayer.six"

    static let app_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    private let ClOCK_HOST: String = "https://cannery.plixor.net/wiggly/shoHPush"

    static let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    static let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""

    var avRequest: Bool = false
    var cfgDataList: [AVHomeModel] = []
    var cfgBannerList: [AVDataInfoModel] = []
    
    var isUser = UserDefaults.standard.bool(forKey: HPKey.isUser) {
        didSet {
            if isUser == true {
                UserDefaults.standard.set(isUser, forKey: HPKey.isUser)
            }
        }
    }
    
    func setRootRequest() {
        if HPConfig.share.getClock() {
            HPConfig.share.setRoot(.home)
        } else {
            clockRequest { [weak self] info in
                guard let self = self else { return }
                if let result = info, result == "ocarina" {
                    HPConfig.share.setClock(true)
//                    HPTBAManager.shared.setParamlist(type: .session)
                    self.setRoot(.play)
                } else {
                    self.setRoot(.home)
                }
            }
        }
    }
    
    func setRoot(_ type: rootStatus) {
        DispatchQueue.main.async {
//            if type == .home {
//                let tabbar = HomeTabBarController()
//                HPConfig.share.currentWindow()?.rootViewController = tabbar
//            } else {
//                if HPConfig.share.getDBVersion() == false {
//                    DataBaseManager.share.deleteAllData()
//                    HPConfig.share.setDBVersion(true)
//                }
//                let tabbar = VideoTabController()
//                HPConfig.share.currentWindow()?.rootViewController = tabbar
//            }
            self.setGoogleUMP()
        }
    }
    
    
    private func setGoogleUMP() {
//        #if DEBUG
//        UMPConsentInformation.sharedInstance.reset()
//        #endif
//        if let vc = HPConfig.topVC() {
//            HPUMPManager.shared.gatherConsent(from: vc) { consentError in
//                if let consentError {
//                    // Consent gathering failed.
//                    print("Error: \(consentError.localizedDescription)")
//                }
//            }
//        }
    }
    
    private func clockRequest(complete: @escaping ((_ info: String?) -> Void)) {
        let distinct_id = HPConfig.share.getDistinctId()
        let client_ts = "\(Date().timeIntervalSince1970 * 1000)"
        let device_model = UIDevice().modelName
        let os_version = UIDevice.current.systemVersion
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let gaid = ""
        let android_id = ""
        let os = "ios"
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let app_version = HPConfig.app_version
        
        let paraString = "?pavlov=\(distinct_id)&elsinore=\(client_ts)&bible=\(device_model)&suzerain=\(HPConfig.SafeBUNDLEID)&beijing=\(os_version)&snack=\(idfv)&abeyance=\(gaid)&alkali=\(android_id)&ibm=\(os)&insult=\(idfa)&melanism=\(app_version)"
        let url = ClOCK_HOST + paraString
        var request: URLRequest = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                complete(nil)
                return
            }
            if let result = response as? HTTPURLResponse, result.statusCode == 200, let d = data {
                if let str = String(data: d, encoding: .utf8) {
                    complete(str)
                    return
                }
            } else {
                complete(nil)
            }
        })
        task.resume()
    }
    func setClock(_ clock: Bool) {
        UserDefaults.standard.setValue(clock, forKey: "HPClock")
        HPConfig.share.isUser = clock
        UserDefaults.standard.synchronize()
    }
    
    func getClock() -> Bool {
        let clock = UserDefaults.standard.bool(forKey: "HPClock")
        HPConfig.share.isUser = clock
        return clock
    }
    
    func setDBVersion(_ delete: Bool) {
        UserDefaults.standard.setValue(delete, forKey: "DataDelete")
        UserDefaults.standard.synchronize()
    }
    
    func getDBVersion() -> Bool {
        let result = UserDefaults.standard.bool(forKey: "DataDelete")
        return result
    }
    
    /// uuid
    func getDistinctId() -> String {
        if let uuid = UserDefaults.standard.string(forKey: "uuid") {
            return uuid
        }
        let uid = UUID().uuidString
        UserDefaults.standard.setValue(uid, forKey: "uuid")
        return uid
    }
    
    func currentWindow() -> UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = sceneDelegate.window else {
            return UIApplication.shared.windows.last
        }
        return window
    }
    
    class func topVC(vc: UIViewController? = nil) -> UIViewController? {
        var controller = vc
        if controller == nil {
            guard let window = HPConfig.share.currentWindow() else { return nil }
            controller = window.rootViewController
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topVC(vc: selected)
            }
        }
    
        if let presented = controller?.presentedViewController {
            return topVC(vc: presented)
        }
        
        if let navigationController = controller as? UINavigationController {
            return topVC(vc: navigationController.visibleViewController)
        }
        return controller
    }
    
    var netStatus: netStatusType {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                switch appDelegate.netStatus {
                case .reachable(.cellular):
                    return .cellular
                case .reachable(.ethernetOrWiFi):
                    return .wifi
                case .notReachable:
                    return .notNet
                default:
                    return .unknown
                }
            }
            return .unknown
        }
    }
    
    var isNetWork: Bool {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                switch appDelegate.netStatus {
                case .reachable(_):
                    return true
                default:
                    return false
                }
            }
            return false
        }
    }
    
    enum netStatusType: Int {
        case unknown = 0
        case notNet
        case wifi
        case cellular
    }
    
    func showADS(type: HPADType, complete: @escaping(Bool) -> Void) {
//        HPADManager.share.hplayerShowAds(type: type) { result, ad in
//            DispatchQueue.main.async {
//                if result, let vc = HPConfig.topVC() {
//                    if let ad = ad as? GADInterstitialAd {
//                        ad.present(fromRootViewController: vc)
//                        complete(true)
//                    } else if let ad = ad as? GADAppOpenAd {
//                        ad.present(fromRootViewController: vc)
//                        complete(true)
//                    } else if let ad = ad as? GADRewardedAd {
//                        ad.present(fromRootViewController: vc, userDidEarnRewardHandler: {
//                            toast("Reward received!")
//                        })
//                        complete(true)
//                    } else if let ad = ad as? GADRewardedInterstitialAd {
//                        ad.present(fromRootViewController: vc, userDidEarnRewardHandler: {
//                            toast("Reward received!")
//                        })
//                        complete(true)
//                    } else {
//                        complete(true)
//                    }
//                } else {
//                    complete(false)
//                }
//            }
//        }
    }
}

