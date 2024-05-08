//
//  HPADManager.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import UIKit
//import GoogleMobileAds
//import AppLovinSDK
import AVKit
import HandyJSON

enum HPADPlayType: String, HandyJSONEnum {
    case native = "native"
    case interstitial = "interstitial"
    case open = "open"
    case rewarded = "rewarded"
    case rewardedInterstitial = "rewardedInterstitial"
}

enum HPADType: String, HandyJSONEnum {
    //    case native = "native"
    case open = "open"
    case play = "play"
    case other = "landscape"
    //    case off = "off"
    //    case high = "high"
}

enum HPADSourceType: String, HandyJSONEnum {
    case admob = "admob"
    case max = "max"
}

class HPADItem: BaseModel {
    var id: String = ""
    var level: Int = 0
    var type: HPADPlayType = .interstitial
    var source: HPADSourceType = .admob
    var open_time: Int? = 0
    
    override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        // 指定字段解析
        mapper.specify(property: &source) { (rawString) -> (HPADSourceType) in
            let s = HPADSourceType(rawValue: rawString.lowercased())
            return s ?? .admob
        }
        mapper.specify(property: &type) { (rawString) -> (HPADPlayType) in
            let t = HPADPlayType(rawValue: rawString.lowercased())
            return t ?? .interstitial
        }
    }
}

/// 缓存广告
class HPADCache: BaseModel {
    var id: String = ""
    var level: Int = 0
    var type: HPADType = .open
    var source: HPADSourceType = .admob
    var id_type: HPADPlayType = .open
    var time: TimeInterval = Date().timeIntervalSince1970
    var ad: NSObject?
}

/// 广告列表
class HPADTypeModel: BaseModel {
    var HP_open: [HPADItem] = []
    var HP_play: [HPADItem] = []
    var HP_landscape: [HPADItem] = []
    var HP_highLevel: [HPADItem] = []
    var HP_sameInterval: Int = 60
    var HP_differentInterval: Int = 60
    var HP_openInterval: Int = 60
    var HP_mixOpenWait: Int = 10
    var HP_totalShowCount: Int = 100
    var HP_play_point_time: Int = 540
}

class HPADManager: NSObject {
    
    static let share = HPADManager()
    
    /// 缓存定时器
//    var timer: DispatchSourceTimer?
//    var countCache = 0 {
//        didSet {
//            DispatchQueue.main.async {
//                if self.countCache % 2 == 0 {
//                    self.refreshAdCache()
//                }
//            }
//        }
//    }
//    
//    /// 显示和点击次数
//    var adCounts: HPADCounts?
//    
    var play_time: Int = 600
//    
//    var coolSuccessLoad = false
//    var isShowingCoolAd = false
//    
//    var sameInterval: Int = 60
//    var differentInterval: Int = 60
//    var openInterval: Int = 60
//    var mixOpenWait: Int = 10
//    
//    var playTime: TimeInterval = 0
//    var openTime: TimeInterval = 0 {
//        didSet {
//            HPLog.log("open_time: \(openTime)")
//        }
//    }
//    var otherTime: TimeInterval = 0
//    
//    var dataArr: [adInfoListModel] = []
//    var cacheArr: [adCacheModel] = []
//    var adInfoModel = HPADTypeModel() {
//        didSet {
//            self.dataArr.removeAll()
//            self.setInfoData(self.adInfoModel.HP_play, .play)
//            self.setInfoData(self.adInfoModel.HP_open, .open)
//            self.setInfoData(self.adInfoModel.HP_landscape, .other)
//            self.sameInterval = self.adInfoModel.HP_sameInterval
//            self.differentInterval = self.adInfoModel.HP_differentInterval
//            self.openInterval = self.adInfoModel.HP_openInterval
//            self.mixOpenWait = self.adInfoModel.HP_mixOpenWait
//            self.play_time = self.adInfoModel.HP_play_point_time
//        }
//    }
//    
    var tempDismissComplete: (() -> Void)?
//    
//    var type: HPADType = .open
//    
    var openLoadingSuccessComplete: (() -> Void)?
//    
//    var isInstall = false
//    
//    func setInfoData(_ items: [HPADItem], _ type: HPADType) {
//        let model = adInfoListModel()
//        model.item = items
//        model.type = type
//        model.item.sort(by: {$0.level > $1.level })
//        self.dataArr.append(model)
//    }
//    func setConfig() {
//        if let jsonString = UserDefaults.standard.value(forKey: HPKey.advertiseKey) as? String {
//            let jsonData = Data(base64Encoded: jsonString) ?? Data()
//            if let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
//                if let model = HPADTypeModel.deserialize(from: json) {
//                    adInfoModel = model
//                }
//            }
//        } else {
//#if DEBUG
//            let path = Bundle.main.path(forResource: "HP_ad_debug", ofType: "json")!
//#else
//            let path = Bundle.main.path(forResource: "HP_ad_release", ofType: "json")!
//#endif
//            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                if let model = HPADTypeModel.deserialize(from: json) {
//                    adInfoModel = model
//                }
//            }
//        }
//        
//        // setup counts
//        upDateAdmobCounts()
//        
//        // refresh caches
//        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
//        timer?.setEventHandler(handler: { [weak self] in
//            self?.countCache = (self?.countCache ?? 0) + 1
//        })
//        timer?.schedule(deadline: .now() + 60, repeating: 60)
//        timer?.resume()
//    }
//    
//    /// 预加载
//    func startInit() {
//        DispatchQueue.main.async {
//            if VipManager.share.isVip { return }
//            self.hplayeraddAds(type: .open)
//            self.hplayeraddAds(type: .play)
//        }
//    }
//    
//    func addInit() {
//        guard !isInstall else { return }
//        isInstall = true
//        self.startInit()
//    }
}

// MARK: - fullscreen 入口
//extension HPADManager {
//    func hplayeraddAds(type: HPADType, index: Int = 0) {
//        if VipManager.share.isVip { return }
//        if !HPConfig.share.isNetWork {
//            return
//        }
//        // 是否可显示
//        if isCanShowAd() == false {
//            return
//        }
//        HPLog.log("hplayer --- 广告开始加载 type: \(type.rawValue)")
//        
//        if let item = self.dataArr.first(where: {$0.type == type}), let opens = UserDefaults.standard.value(forKey: HPKey.appOpen) as? Int {
//            if let model = item.item.indexOfSafe(index) {
//                if model.open_time ?? 0 < opens {
//                    switch model.type {
//                    case .interstitial:
//                        self.hplayerLoadInterstitialAd(type: type, index: index, item: model)
//                    case .open:
//                        self.hplayerLoadOpenAd(type: type, index: index, item: model)
//                    case .rewarded:
//                        self.hplayerLoadRewardAd(type: type, index: index, item: model)
//                    case .rewardedInterstitial:
//                        self.hplayerLoadRewardInterstitialAd(type: type, index: index, item: model)
//                    default:
//                        break
//                    }
//                } else {
//                    if let m = self.dataArr.first(where: {$0.type == type}) {
//                        HPLog.log("hplayer --- opentime 不满足 type: \(type.rawValue) app_opens: \(opens)  open_time: \(String(describing: m.item.first?.open_time))")
//                        m.adIsLoding = false
//                        self.hplayeraddAds(type: m.type, index: m.index + 1)
//                    }
//                }
//            } else {
//                return
//            }
//        }
//    }
//    
//    func hplayerShowAds(type: HPADType, complete: @escaping(Bool, GADFullScreenPresentingAd?) -> Void) {
//        if VipManager.share.isVip {
//            complete(false, nil)
//            return
//        }
//        if !HPConfig.share.isNetWork {
//            complete(false, nil)
//            return
//        }
//        // 是否可显示
//        if isCanShowAd() == false {
//            complete(false, nil)
//            return
//        }
//        let time = Date().timeIntervalSince1970
//        if let arr = self.getCache(type: type), arr.count > 0 {
//            self.type = type
//            switch type {
//            case .open:
//                if Int(ceil(time - self.openTime)) < self.sameInterval || Int(ceil(time - self.otherTime)) < self.differentInterval || Int(ceil(time - self.playTime)) < self.differentInterval {
//                    HPLog.log("hplayer --- 同场景间隔时间小于\(self.sameInterval) 或者 不同场景间隔时间小于\(self.differentInterval) 或者 开屏与插屏间隔时间小于\(self.openInterval)")
//                    complete(false, nil)
//                    return
//                }
//            case .play:
//                if Int(ceil(time - self.openTime)) < self.openInterval || Int(ceil(time - self.otherTime)) < self.differentInterval || Int(ceil(time - self.playTime)) < self.sameInterval {
//                    HPLog.log("hplayer --- 同场景间隔时间小于\(self.sameInterval) 或者 不同场景间隔时间小于\(self.differentInterval) 或者 开屏与插屏间隔时间小于\(self.openInterval)")
//                    complete(false, nil)
//                    return
//                }
//            case .other:
//                if Int(ceil(time - self.openTime)) < self.openInterval || Int(ceil(time - self.playTime)) < self.differentInterval || Int(ceil(time - self.otherTime)) < self.sameInterval {
//                    HPLog.log("hplayer --- 同场景间隔时间小于\(self.sameInterval) 或者 不同场景间隔时间小于\(self.differentInterval) 或者 开屏与插屏间隔时间小于\(self.openInterval)")
//                    complete(false, nil)
//                    return
//                }
//            }
//            if let c = arr.first {
//                print("________\(c.id)")
//                self.setTime(self.type)
//                if c.source == .admob {
//                    if let ad = c.ad as? GADInterstitialAd {
//                        ad.fullScreenContentDelegate = self
//                        complete(true, ad)
//                    } else if let ad = c.ad as? GADAppOpenAd {
//                        ad.fullScreenContentDelegate = self
//                        complete(true, ad)
//                    } else if let ad = c.ad as? GADRewardedAd {
//                        ad.fullScreenContentDelegate = self
//                        complete(true, ad)
//                    } else if let ad = c.ad as? GADRewardedInterstitialAd {
//                        ad.fullScreenContentDelegate = self
//                        complete(true, ad)
//                    } else {
//                        self.deleteFirstCache(type: type)
//                        self.hplayeraddAds(type: type)
//                        complete(false, nil)
//                    }
//                } else if c.source == .max {
//                    if (c.ad as? MAInterstitialAd)?.isReady == true {
//                        (c.ad as? MAInterstitialAd)?.show()
//                        complete(true, nil)
//                    } else if (c.ad as? MAAppOpenAd)?.isReady == true {
//                        (c.ad as? MAAppOpenAd)?.show()
//                        complete(true, nil)
//                    } else if (c.ad as? MARewardedAd)?.isReady == true {
//                        (c.ad as? MARewardedAd)?.show()
//                        complete(true, nil)
//                    } else if (c.ad as? MARewardedInterstitialAd)?.isReady == true {
//                        (c.ad as? MARewardedInterstitialAd)?.show()
//                        complete(true, nil)
//                    } else {
//                        self.deleteFirstCache(type: type)
//                        self.hplayeraddAds(type: type)
//                        self.type = .open
//                        complete(false, nil)
//                    }
//                }
//            }
//        } else {
//            self.deleteFirstCache(type: type)
//            self.hplayeraddAds(type: type)
//            complete(false, nil)
//        }
//    }
//}
//
//// MARK: - 插屏、 激励、 激励插屏
//extension HPADManager {
//    func hplayerLoadInterstitialAd(type: HPADType, index: Int, item: HPADItem) {
//        if item.source == .admob {
//            let request = GADRequest()
//            GADInterstitialAd.load(withAdUnitID: item.id, request: request) { [weak self] ad, error in
//                guard let self = self else { return }
//                if let m = self.dataArr.first(where:{$0.type == type}) {
//                    m.adIsLoding = false
//                }
//                guard error == nil else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                    return
//                }
//                
//                if let ad = ad {
//                    let cache = HPADCache()
//                    cache.id = item.id
//                    cache.level = item.level
//                    cache.type = type
//                    cache.source = item.source
//                    cache.ad = ad
//                    cache.id_type = item.type
//                    
//                    /// 加入缓存
//                    self.addCache(type: type, model: cache)
//                    HPLog.log("hplayer --- 广告加载成功 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    
//                    if type == .open {
//                        self.coolSuccessLoad = true
//                        if self.openLoadingSuccessComplete != nil {
//                            self.openLoadingSuccessComplete!()
//                        }
//                    }
//                    
//                    ad.paidEventHandler = { value in
//                        let nvalue = value.value
//                        let currencyCode = value.currencyCode
//                        HPLog.hp_ad_impression_revenue(value: nvalue.doubleValue, currency: currencyCode, adFormat: "INTERSTITIAL", adSource: ad.responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName ?? "", adPlatform: "admob", adUnitName: item.id , precision: "\(value.precision.rawValue)", placement: type.rawValue)
//                    }
//                } else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                }
//            }
//        } else if item.source == .max {
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                m.ad = MAInterstitialAd(adUnitIdentifier: item.id)
//                (m.ad as? MAInterstitialAd)?.delegate = self
//                (m.ad as? MAInterstitialAd)?.revenueDelegate = self
//                (m.ad as? MAInterstitialAd)?.load()
//            }
//        }
//    }
//    
//    func hplayerLoadRewardAd(type: HPADType, index: Int, item: HPADItem) {
//        if item.source == .admob {
//            let request = GADRequest()
//            GADRewardedAd.load(withAdUnitID: item.id, request: request) { [weak self] ad, error in
//                guard let self = self else { return }
//                if let m = self.dataArr.first(where:{$0.type == type}) {
//                    m.adIsLoding = false
//                }
//                
//                guard error == nil else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                    
//                    return
//                }
//                
//                if let ad = ad {
//                    let cache = HPADCache()
//                    cache.id = item.id
//                    cache.level = item.level
//                    cache.type = type
//                    cache.source = item.source
//                    cache.ad = ad
//                    cache.id_type = item.type
//                    /// 加入缓存
//                    self.addCache(type: type, model: cache)
//                    HPLog.log("hplayer --- 广告加载成功 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    
//                    if type == .open {
//                        self.coolSuccessLoad = true
//                        if self.openLoadingSuccessComplete != nil {
//                            self.openLoadingSuccessComplete!()
//                        }
//                    }
//                    
//                    ad.paidEventHandler = { value in
//                        let nvalue = value.value
//                        let currencyCode = value.currencyCode
//                        
//                        HPLog.hp_ad_impression_revenue(value: nvalue.doubleValue, currency: currencyCode, adFormat: "INTERSTITIAL", adSource: ad.responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName ?? "", adPlatform: "admob", adUnitName: item.id , precision: "\(value.precision.rawValue)", placement: type.rawValue)
//                    }
//                    
//                } else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                }
//            }
//        } else if item.source == .max {
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                m.ad = MARewardedAd.shared(withAdUnitIdentifier: item.id)
//                (m.ad as? MARewardedAd)?.delegate = self
//                (m.ad as? MARewardedAd)?.revenueDelegate = self
//                (m.ad as? MARewardedAd)?.load()
//            }
//        }
//    }
//    
//    func hplayerLoadRewardInterstitialAd(type: HPADType, index: Int, item: HPADItem) {
//        if item.source == .admob {
//            let request = GADRequest()
//            GADRewardedInterstitialAd.load(withAdUnitID: item.id, request: request) {[weak self] ad, error in
//                guard let self = self else { return }
//                if let m = self.dataArr.first(where: {$0.type == type}) {
//                    m.adIsLoding = false
//                }
//                guard error == nil else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                    return
//                }
//                
//                if let ad = ad {
//                    let cache = HPADCache()
//                    cache.id = item.id
//                    cache.level = item.level
//                    cache.type = type
//                    cache.source = item.source
//                    cache.ad = ad
//                    cache.id_type = item.type
//                    
//                    /// 加入缓存
//                    self.addCache(type: type, model: cache)
//                    HPLog.log("hplayer --- 广告加载成功 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    
//                    if type == .open {
//                        self.coolSuccessLoad = true
//                        if self.openLoadingSuccessComplete != nil {
//                            self.openLoadingSuccessComplete!()
//                        }
//                    }
//                    
//                    ad.paidEventHandler = { value in
//                        let nvalue = value.value
//                        let currencyCode = value.currencyCode
//                        
//                        HPLog.hp_ad_impression_revenue(value: nvalue.doubleValue, currency: currencyCode, adFormat: "INTERSTITIAL", adSource: ad.responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName ?? "", adPlatform: "admob", adUnitName: item.id , precision: "\(value.precision.rawValue)", placement: type.rawValue)
//                    }
//                    
//                } else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                }
//            }
//        } else {
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                m.ad = MARewardedInterstitialAd(adUnitIdentifier: item.id)
//                (m.ad as? MARewardedInterstitialAd)?.delegate = self
//                (m.ad as? MARewardedInterstitialAd)?.revenueDelegate = self
//                (m.ad as? MARewardedInterstitialAd)?.load()
//            }
//            //            self.hplayeraddAds(type: type, index: index + 1)
//        }
//    }
//    func hplayerLoadOpenAd(type: HPADType, index: Int, item: HPADItem) {
//        if item.source == .admob {
//            let request = GADRequest()
//            GADAppOpenAd.load(withAdUnitID: item.id, request: request, orientation: .portrait) { [weak self] ad, error in
//                guard let self = self else { return }
//                switch type {
//                case .open:
//                    if let m = self.dataArr.first(where: {$0.type == .open}) {
//                        m.adIsLoding = false
//                    }
//                default:
//                    return
//                }
//                guard error == nil else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                    return
//                }
//                
//                if let ad = ad {
//                    let cache = HPADCache()
//                    cache.id = item.id
//                    cache.level = item.level
//                    cache.source = item.source
//                    cache.type = type
//                    cache.ad = ad
//                    cache.id_type = item.type
//                    
//                    ad.paidEventHandler = { value in
//                        let nvalue = value.value
//                        let currencyCode = value.currencyCode
//                        
//                        HPLog.hp_ad_impression_revenue(value: nvalue.doubleValue, currency: currencyCode, adFormat: "OPEN", adSource: ad.responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName ?? "", adPlatform: "admob", adUnitName: item.id , precision: "\(value.precision.rawValue)", placement: type.rawValue)
//                    }
//                    
//                    /// 加入缓存
//                    self.addCache(type: type, model: cache)
//                    HPLog.log("hplayer --- 广告加载成功 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    switch type {
//                    case .open:
//                        self.coolSuccessLoad = true
//                        if self.openLoadingSuccessComplete != nil {
//                            self.openLoadingSuccessComplete!()
//                        }
//                    default:
//                        return
//                    }
//                } else {
//                    HPLog.log("hplayer --- 广告加载失败 type: \(type.rawValue) 优先级: \(index + 1), id: \(item.id)")
//                    self.hplayeraddAds(type: type, index: index + 1)
//                    return
//                }
//            }
//        } else {
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                m.ad = MAAppOpenAd(adUnitIdentifier: item.id)
//                (m.ad as? MAAppOpenAd)?.delegate = self
//                (m.ad as? MAAppOpenAd)?.revenueDelegate = self
//                (m.ad as? MAAppOpenAd)?.load()
//                /// 加入缓存
//            }
//        }
//    }
//}
//
//// MARK: - 全屏广告代理
//extension HPADManager: GADFullScreenContentDelegate {
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        HPLog.log("hplayer --- Ad did fail to present full screen content.")
//        if ad is GADAppOpenAd {
//            if self.type == .open {
//                if let m = self.dataArr.first(where: {$0.type == .open}) {
//                    m.adIsLoding = false
//                    self.deleteFirstCache(type: m.type)
//                    self.hplayeraddAds(type: m.type)
//                    if self.tempDismissComplete != nil {
//                        self.tempDismissComplete!()
//                    }
//                }
//            }
//        } else {
//            let interstitialAd = ad as? GADInterstitialAd
//            let rewardAd = ad as? GADRewardedAd
//            let rewardInterstitialAd = ad as? GADRewardedInterstitialAd
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                if let _ = m.item.first(where: {$0.id == interstitialAd?.adUnitID || $0.id == rewardAd?.adUnitID || $0.id == rewardInterstitialAd?.adUnitID}) {
//                    m.adIsLoding = false
//                    self.deleteFirstCache(type: m.type)
//                    self.hplayeraddAds(type: m.type)
//                    if self.tempDismissComplete != nil {
//                        self.tempDismissComplete!()
//                    }
//                }
//            }
//        }
//    }
//    
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        UIApplication.shared.isStatusBarHidden = true
//        if ad is GADAppOpenAd {
//            if self.type == .open {
//                self.upDateShowCount(type: .open)
//            }
//        } else {
//            let interstitialAd = ad as? GADInterstitialAd
//            let rewardAd = ad as? GADRewardedAd
//            let rewardInterstitialAd = ad as? GADRewardedInterstitialAd
//            if let m = self.dataArr.first(where: {$0.type == type}) {
//                if let _ = m.item.first(where: {$0.id == interstitialAd?.adUnitID || $0.id == rewardAd?.adUnitID || $0.id == rewardInterstitialAd?.adUnitID}) {
//                    self.upDateShowCount(type: m.type)
//                    m.adShowing = true
//                }
//            }
//        }
//        self.isShowingCoolAd = true
//    }
//    
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        UIApplication.shared.isStatusBarHidden = false
//        self.setTime(self.type)
//        self.deleteFirstCache(type: self.type)
//        self.hplayeraddAds(type: self.type)
//        
//        let interstitialAd = ad as? GADInterstitialAd
//        let rewardAd = ad as? GADRewardedAd
//        let rewardInterstitialAd = ad as? GADRewardedInterstitialAd
//        if let m = self.dataArr.first(where: {$0.type == type}) {
//            if let _ = m.item.first(where: {$0.id == interstitialAd?.adUnitID || $0.id == rewardAd?.adUnitID || $0.id == rewardInterstitialAd?.adUnitID}) {
//                m.adIsLoding = false
//                m.adShowing = false
//            }
//        }
//        if self.tempDismissComplete != nil {
//            self.tempDismissComplete!()
//        }
//    }
//    
//    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
//        
//        if ad is GADAppOpenAd {
//            if self.type == .open {
//                self.upDateClickCount(type: .open)
//            }
//        } else {
//            let interstitialAd = ad as? GADInterstitialAd
//            let rewardAd = ad as? GADRewardedAd
//            let rewardInterstitialAd = ad as? GADRewardedInterstitialAd
//            for mod in self.dataArr {
//                if let _ = mod.item.first(where: {$0.id == interstitialAd?.adUnitID || $0.id == rewardAd?.adUnitID || $0.id == rewardInterstitialAd?.adUnitID}) {
//                    self.upDateClickCount(type: self.type)
//                }
//            }
//        }
//    }
//}
//
//extension HPADManager: MAAdViewAdDelegate {
//    func didExpand(_ ad: MAAd) {
//        HPLog.log("hplayer --- didExpand")
//    }
//    
//    func didCollapse(_ ad: MAAd) {
//        HPLog.log("hplayer --- didCollapse")
//    }
//    
//    func didLoad(_ ad: MAAd) {
//        HPLog.log("hplayer --- didLoad")
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == ad.adUnitIdentifier}) {
//                HPLog.log("hplayer --- 广告加载成功 type: \(mod.type.rawValue) 优先级: \(mod.index + 1), placementid: \(ad.adUnitIdentifier)")
//                mod.adIsLoding = false
//                if mod.index >= mod.item.count {
//                    return
//                }
//                if let model = mod.item.indexOfSafe(mod.index) {
//                    let cache = HPADCache()
//                    cache.id = model.id
//                    cache.level = model.level
//                    cache.source = .max
//                    cache.type = mod.type
//                    cache.ad = mod.ad
//                    cache.id_type = model.type
//                    self.addCache(type: mod.type, model: cache)
//                }
//            }
//        }
//        self.coolSuccessLoad = true
//        if self.openLoadingSuccessComplete != nil {
//            self.openLoadingSuccessComplete!()
//        }
//    }
//    
//    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
//        HPLog.log("hplayer --- didFailToLoadAd: adUnitIdentifier: \(adUnitIdentifier), error: \(error.mediatedNetworkErrorCode) \(error.message)")
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == adUnitIdentifier}) {
//                HPLog.log("hplayer --- 广告加载失败 type: \(HPADType.play.rawValue) 优先级: \(mod.index + 1), placementid: \(adUnitIdentifier)")
//                mod.adIsLoding = false
//                self.hplayeraddAds(type: mod.type, index: mod.index + 1)
//            }
//        }
//    }
//    
//    func didDisplay(_ ad: MAAd) {
//        HPLog.log("hplayer --- didDisplay")
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == ad.adUnitIdentifier}), mod.type == self.type {
//                self.upDateShowCount(type: mod.type)
//                mod.adShowing = true
//                break
//            }
//        }
//        self.isShowingCoolAd = true
//    }
//    
//    func didHide(_ ad: MAAd) {
//        HPLog.log("hplayer --- didHide")
//        UIApplication.shared.isStatusBarHidden = false
//        self.setTime(self.type)
//        self.deleteFirstCache(type: self.type)
//        self.hplayeraddAds(type: self.type)
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == ad.adUnitIdentifier}), mod.type == self.type {
//                //                self.deleteFirstCache(type: mod.type)
//                mod.adIsLoding = false
//                mod.adShowing = false
//                //                self.hplayeraddAds(type: mod.type, placement: mod.placement)
//                break
//            }
//        }
//        if self.tempDismissComplete != nil {
//            self.tempDismissComplete!()
//        }
//    }
//    
//    func didClick(_ ad: MAAd) {
//        HPLog.log("hplayer --- didClick")
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == ad.adUnitIdentifier}), mod.type == self.type {
//                self.upDateClickCount(type: self.type)
//                break
//            }
//        }
//    }
//    
//    func didFail(toDisplay ad: MAAd, withError error: MAError) {
//        HPLog.log("hplayer --- didFailtoDisplay, error: \(error)")
//        if error.code.rawValue != -23 {
//            for mod in self.dataArr {
//                if let _ = mod.item.first(where: {$0.id == ad.adUnitIdentifier}), mod.type == self.type {
//                    mod.adIsLoding = false
//                    self.deleteFirstCache(type: mod.type)
//                    self.hplayeraddAds(type: mod.type)
//                    if self.tempDismissComplete != nil {
//                        self.tempDismissComplete!()
//                    }
//                    break
//                }
//            }
//        }
//    }
//}
//
//extension HPADManager: MARewardedAdDelegate {
//    func didRewardUser(for ad: MAAd, with reward: MAReward) {
//        //        HPMethods.rewardGeted()
//    }
//}
//
//extension HPADManager: MAAdRevenueDelegate {
//    func didPayRevenue(for ad: MAAd) {
//        HPLog.log("hplayer --- didPayRevenue")
//        let revenue = ad.revenue // In USD
//        let adUnitId = ad.adUnitIdentifier // The MAX Ad Unit ID
//        let networkName = ad.networkName // Display name of the network that showed the ad (e.g. "AdColony")
//        var format = ""
//        var placem = ""
//        for mod in self.dataArr {
//            if let _ = mod.item.first(where: {$0.id == adUnitId}) {
//                format = "INTERSTITIAL"
//                if mod.type == .other || mod.type == .play {
//                    format = "INTERSTITIAL"
//                    //                } else if mod.type == .native {
//                    //                    format = "NATIVE"
//                }
//                placem = mod.type.rawValue
//            }
//        }
//        HPLog.hp_ad_impression_revenue(value: revenue, currency: "USD", adFormat: format, adSource: networkName, adPlatform: "MAX", adUnitName: adUnitId , precision: "", placement: placem)
//    }
//}
//
//// MARK: - 缓存相关
//extension HPADManager {
//    /// 更新缓存 缓存时长3000s
//    func refreshAdCache() {
//        let date = Date().timeIntervalSince1970
//        self.cacheArr.forEach { m in
//            m.cache = m.cache.filter({
//                if $0.id_type == .open {
//                    date - $0.time < 14000
//                } else {
//                    date - $0.time < 3000
//                }
//            })
//        }
//    }
//    /// 获取缓存数组
//    func getCache(type: HPADType) -> [HPADCache]? {
//        if let m = self.cacheArr.first(where: {$0.type == type}) {
//            return m.cache
//        }
//        return nil
//    }
//    /// 加入缓存
//    func addCache(type: HPADType, model: HPADCache) {
//        if let m = self.cacheArr.first(where: {$0.type == type}) {
//            m.cache.removeAll()
//            m.cache.append(model)
//        } else {
//            let m = adCacheModel()
//            m.cache.append(model)
//            m.type = type
//            self.cacheArr.append(m)
//        }
//    }
//    /// 清除单个缓存
//    func deleteFirstCache(type: HPADType) {
//        if let m = self.cacheArr.first(where: {$0.type == type}) {
//            m.cache.removeAll()
//            if let mod = self.dataArr.first(where: {$0.type == type}) {
//                mod.index = 0
//            }
//        }
//    }
//    /// 清除全部缓存
//    func deleteAllCache() {
//        self.cacheArr.removeAll()
//    }
//}
//// MARK: - 展示及点击次数相关
//extension HPADManager {
//    /// 是否可显示广告
//    func isCanShowAd() -> Bool {
//        self.upDateAdmobCounts()
//        if adCounts!.totalShowCount >= adInfoModel.HP_totalShowCount {
//            HPLog.log("hplayer --- total 展示次数上限")
//        }
//        return adCounts!.totalShowCount < adInfoModel.HP_totalShowCount
//    }
//    /// 显示次数增加
//    func upDateShowCount(type: HPADType) {
//        upDateAdmobCounts()
//        guard var counts = adCounts else { return }
//        counts.totalShowCount += 1
//        adCounts = counts
//        do {
//            let data = try JSONEncoder().encode(counts)
//            UserDefaults.standard.setValue(data, forKey: String(describing: HPADCounts.self))
//            HPLog.log("hplayer --- 广告展示 \(counts.totalShowCount) 次")
//        } catch let e {
//            HPLog.log("hplayer --- 广告统计失败 \(e.localizedDescription)")
//        }
//    }
//    /// 点击次数增加
//    func upDateClickCount(type: HPADType?) {
//        upDateAdmobCounts()
//        guard var counts = adCounts else { return }
//        counts.totalClickCount += 1
//        adCounts = counts
//        do {
//            let data = try JSONEncoder().encode(counts)
//            UserDefaults.standard.setValue(data, forKey: String(describing: HPADCounts.self))
//            HPLog.log("hplayer --- 广告点击 \(counts.totalClickCount) 次")
//        } catch let e {
//            HPLog.log("hplayer --- 广告统计失败 \(e.localizedDescription)")
//        }
//    }
//    /// 次数更新
//    func upDateAdmobCounts() {
//        if adCounts != nil {
//            if Date().timeIntervalSince1970 - adCounts!.time > 24 * 60 * 60 {
//                UserDefaults.standard.removeObject(forKey: String(describing: HPADCounts.self))
//                adCounts = nil
//                upDateAdmobCounts()
//            }
//            return
//        }
//        if let c = UserDefaults.standard.value(forKey: String(describing: HPADCounts.self)) as? Data,
//           let counts = try? JSONDecoder().decode(HPADCounts.self, from: c) {
//            if Date().timeIntervalSince1970 - counts.time > 24 * 60 * 60 {
//                UserDefaults.standard.removeObject(forKey: String(describing: HPADCounts.self))
//                upDateAdmobCounts()
//                return
//            }
//            adCounts = counts
//        } else {
//            let adCount = HPADCounts()
//            do {
//                let data = try JSONEncoder().encode(adCount)
//                UserDefaults.standard.setValue(data, forKey: String(describing: HPADCounts.self))
//                adCounts = adCount
//            } catch let e {
//                HPLog.log("hplayer --- 加载广告统计失败 \(e.localizedDescription)")
//            }
//        }
//    }
//    
//    fileprivate func setTime(_ type: HPADType) {
//        switch type {
//        case .other:
//            self.otherTime = Date().timeIntervalSince1970
//        case .play:
//            self.playTime = Date().timeIntervalSince1970
//        default:
//            self.openTime = Date().timeIntervalSince1970
//        }
//    }
//}
//
//struct HPADCounts: Codable {
//    var time = Date().timeIntervalSince1970
//    var totalShowCount: Int = 0
//    var totalClickCount: Int = 0
//}
//class adInfoListModel: BaseModel {
//    var item: [HPADItem] = []
//    var type: HPADType = .open
//    var adIsLoding = false
//    var index = 0
//    var ad: NSObject?
//    var adShowing = false
//    var tradAd: NSObject?
//    var loader: MANativeAdLoader?
//    var canShow = true
//    var maxAd: MAAd?
//    var adView: MANativeAdView!
//}
class adItemModel: BaseModel {
    var item: HPADItem = HPADItem()
}
class adCacheModel: BaseModel {
    var cache: [HPADCache] = []
    var type: HPADType = .open
}
