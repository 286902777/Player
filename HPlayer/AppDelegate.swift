//
//  AppDelegate.swift
//  HPlayer
//
//  Created by HF on 2024/5/6.
//

import UIKit
import CoreData
import Alamofire
import IQKeyboardManagerSwift
import AppTrackingTransparency
//import GoogleMobileAds
//import AppLovinSDK
//import FirebaseCore
//import FirebaseMessaging
//import StoreKit
import Adjust
import AdSupport
import AdServices
//import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var allow: Bool = false
    var lock: Bool = false
    
    var window: UIWindow?
    var pushApnsId: String?
    
    override init() {
        super.init()
        CapTransformer.defaultConfig()    // 注册CapTransformer
    }
    
    private var reachabilityManager: NetworkReachabilityManager? = {
        let reachbility = NetworkReachabilityManager.default
        return reachbility
    }()
    
    var netStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown {
        didSet {
            if netStatus != oldValue {
                NotificationCenter.default.post(name: HPKey.Noti_NetStatus, object: nil)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.reachabilityManager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { [weak self] (status) in
            self?.netStatus = status
        })
        addTrack()
//        addAdjust()
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if lock {
            return .landscape
        } else {
            return allow ? .all : .portrait
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HPlayer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func addTrack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
//                    Settings.shared.isAdvertiserTrackingEnabled = true
                }
            }
        }
    }
    
    // MARK: - Adjust
    func addAdjust() {
        var adjustToken = "owoielasdf"
        var environment = ADJEnvironmentSandbox
#if DEBUG
#else
        adjustToken = "sjoejlfss"
        environment = ADJEnvironmentProduction
#endif
        let adConfig = ADJConfig(appToken: adjustToken, environment: environment)
        adConfig?.deactivateSKAdNetworkHandling()
        Adjust.appDidLaunch(adConfig)
        Adjust.addSessionCallbackParameter("customer_user_id", value: HPConfig.share.getDistinctId())
    }
}

