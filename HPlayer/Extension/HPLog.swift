//
//  HPLog.swift
//  HPlayer
//
//  Created by HF on 2024/1/3.
//

import Foundation
//import FirebaseAnalytics
//import Adjust
//import FBSDKCoreKit

class HPLog: NSObject {
    /// debug 打印
    class func logMsg(_ msg: String) {
#if DEBUG
//        print(msg)
#endif
    }
}

extension HPLog {
    class func hp_ad_impression_revenue(value: Double, currency: String, adFormat: String, adSource: String, adPlatform: String, adUnitName: String, precision: String, placement: String) {
        
        HPLog.logMsg("[LOG-Message] ---- value: \(value), currency: \(currency), adFormat: \(adFormat), adSource: \(adSource), adPlatform: \(adPlatform), adUnitName: \(adUnitName), precision: \(precision), placement: \(placement)")
//        var event = ADJEvent(eventToken: "g3qup0")
//        #if DEBUG
//        #else
//        event = ADJEvent(eventToken: "tsg9xy")
//        #endif
//        event?.setRevenue(value, currency: "USD")
//        Adjust.trackEvent(event)
//        
//        AppEvents.shared.logPurchase(amount: value, currency: "USD")
//
//        HPTBAManager.shared.setAdSubParas(capstan: Int64(value * 1000000), anew: currency, bright: adSource, avocate: adPlatform, smear: adUnitName, thruway: placement, drowsy: adFormat, trefoil: precision)
//        HPTBAManager.shared.setParamlist(type: .ads)
//        /* 上报firebase */
//        HPLog.logEvent(
//            "Ad_impression_revenue",
//            parameters: [
//                AnalyticsParameterAdPlatform: adPlatform,
//                AnalyticsParameterAdSource: adSource,
//                AnalyticsParameterAdFormat: adFormat,
//                AnalyticsParameterAdUnitName: adUnitName,
//                AnalyticsParameterCurrency: currency,
//                AnalyticsParameterValue: value
//            ])
    }
}

extension HPLog {
    class func logEvent(_ name: String, parameters: [String: Any]?) {
//#if DEBUG
//        
//#else
//        Analytics.logEvent(name, parameters: parameters)
//#endif
//        
//        var eventParam: [String: Any] = ["saunders": name]
//        if let parameters = parameters {
//            for item in parameters.keys {
//                eventParam[item] = parameters[item]
//            }
//        }
//        HPTBAManager.shared.eventParam = eventParam
//        HPTBAManager.shared.setParamlist(type: .event)
    }
    
    class func tb_home_sh(loadsuccess: String, errorinfo: String, show: String = "0") {
        HPLog.logMsg("LogMessage: 电影首页展示上报 loadsuccess: \(loadsuccess), errorinfo: \(errorinfo), show: \(show)")
        HPLog.logEvent("home_sh", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo, "show": show])
    }
    
    class func tb_home_sh_result(loadsuccess: String, errorinfo: String, cache_len: String = "0") {
        HPLog.logMsg("LogMessage: 电影首页拉取结果 loadsuccess: \(loadsuccess), errorinfo: \(errorinfo), cache_len: \(cache_len)")
        HPLog.logEvent("home_sh_result", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo, "cache_len": cache_len])
    }
    
    class func tb_home_len(len: String = "0") {
        HPLog.logMsg("LogMessage: 电影首页停留时长_len: \(len)")
        HPLog.logEvent("home_len", parameters: ["len": len])
    }
    
    class func tb_home_cl(kid: String, c_id: String, c_name: String, ctype: String, secname: String, secid: String) {
        HPLog.logMsg("LogMessage: 电影首页点击 kid: \(kid), c_id: \(c_id), c_name: \(c_name), ctype: \(ctype), secname: \(secname), secid: \(secid)")
        HPLog.logEvent("home_cl", parameters: ["kid": kid, "c_id": c_id, "c_name": c_name, "ctype": ctype, "secname": secname, "secid": secid])
    }
    
    class func tb_explore_sh(loadsuccess: String) {
        HPLog.logMsg("LogMessage: 探索页展示 statuses: \(loadsuccess)")
        HPLog.logEvent("explore_sh", parameters: ["statuses": loadsuccess])
    }
    
    class func tb_explore_sh_result(loadsuccess: String, errorinfo: String, cache_len: String = "0") {
        HPLog.logMsg("LogMessage: 探索页展示结果 loadsuccess: \(loadsuccess), errorinfo: \(errorinfo), cache_len: \(cache_len)")
        HPLog.logEvent("explore_sh_result", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo, "cache_len": "\(cache_len)"])
    }
    
    class func tb_explore_cl(kid: String = "1", type: String = "all", genres: String = "all", year: String = "all", country: String = "all", c_id: String = "", c_name: String = "") {
        HPLog.logMsg("LogMessage: 探索页点击 kid: \(kid), type: \(type), genres: \(genres), year: \(year), country: \(country), c_id: \(c_id), c_name: \(c_name)")
        HPLog.logEvent("explore_cl", parameters: ["kid": kid, "type": type, "genres": genres, "year": year, "country": country, "c_id": c_id, "c_name": c_name])
    }
    
    class func tb_explore_len(len: String = "0") {
        HPLog.logMsg("LogMessage: 探索页停留时长_len: \(len)")
        HPLog.logEvent("explore_len", parameters: ["len": len])
    }
    
//    class func tb_tv_sh(loadsuccess: String, errorinfo: String) {
//        HPLog.log("LogMessage: tab_电视剧展示 loadsuccess: \(loadsuccess), errorinfo: \(errorinfo)")
//        HPLog.logEvent("tab_tv_sh", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo])
//    }
//    
//    class func tb_tv_cl(kid: String) {
//        HPLog.log("LogMessage: tab_电视剧点击 kid: \(kid)")
//        HPLog.logEvent("tab_tv_cl", parameters: ["kid": kid])
//    }
    
    class func tb_search_sh(statuses: String, source: String) {
        HPLog.logMsg("LogMessage: 搜索页展示statuses: \(statuses), source: \(source)")
        HPLog.logEvent("search_sh", parameters: ["statuses": statuses, "source": source])
    }
    
    class func tb_search_sh_result(loadsuccess: String, errorinfo: String, cache_len: String = "0") {
        HPLog.logMsg("LogMessage: 搜索页展示结果 loadsuccess: \(loadsuccess), errorinfo: \(errorinfo), cache_len: \(cache_len)")
        HPLog.logEvent("search_sh_result", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo, "cache_len": cache_len])
    }
    /// kid 1-点击搜索中间页内容 2-历史搜索记录 3-点击返回
    class func tb_search_cl(kid: String, movie_id: String, movie_name: String, type: String = "") {
        HPLog.logMsg("LogMessage: 搜索页点击kid: \(kid), movie_id: \(movie_id), movie_name: \(movie_name), type: \(type)")
        HPLog.logEvent("search_cl", parameters: ["kid": kid, "movie_id": movie_id, "movie_name": movie_name, "type": type])
    }
    
    class func tb_search_result_sh(keyword: String) {
        HPLog.logMsg("LogMessage: 搜索结果页展示 keyword: \(keyword)")
        HPLog.logEvent("search_result_sh", parameters: ["keyword": keyword])
    }
    
    class func tb_search_result_sh_result(loadsuccess: String, errorinfo: String, cache_len: String) {
        HPLog.logMsg("LogMessage: 搜索结果页展示结果 loadsuccess: \(loadsuccess), errorinf: \(errorinfo), cache_len: \(cache_len)")
        HPLog.logEvent("search_result_sh_result", parameters: ["loadsuccess": loadsuccess, "errorinfo": errorinfo, "cache_len": cache_len])
    }
    
    ///kid 1-点击搜索中间页内容 3-点击返回
    class func tb_search_result_cl(kid: String, movie_id: String, movie_name: String) {
        HPLog.logMsg("LogMessage: 搜索结果页点击kid: \(kid), movie_id: \(movie_id), movie_name: \(movie_name)")
        HPLog.logEvent("search_result_cl", parameters: ["kid": kid, "movie_id": movie_id, "movie_name": movie_name])
    }
    
    class func tb_movie_play_sh(movie_id: String, movie_name: String, eps_id: String, eps_name: String, source: String, movie_type: String) {
        HPLog.logMsg("LogMessage: 进入播放页展示 movie_id: \(movie_id), movie_name: \(movie_name), eps_id: \(eps_id), eps_name: \(eps_name), source: \(source), movie_type: \(movie_type)")
        HPLog.logEvent("movie_play_sh", parameters: ["movie_id": movie_id, "movie_name": movie_name, "eps_id": eps_id, "eps_name": eps_name, "source": source, "movie_type": movie_type])
    }
    
    class func tb_playback_status(movie_id: String, movie_name: String, eps_id: String, eps_name: String, source: String, movie_type: String, cache_len: String, if_success: String, errorinfo: String) {
        HPLog.logMsg("LogMessage: 播放状态上报 movie_id: \(movie_id), movie_name: \(movie_name), eps_id: \(eps_id), eps_name: \(eps_name), source: \(source), movie_type: \(movie_type), cache_len: \(cache_len), if_success: \(if_success), errorinfo: \(errorinfo)")
        HPLog.logEvent("playback_status", parameters: ["movie_id": movie_id, "movie_name": movie_name, "eps_id": eps_id, "eps_name": eps_name, "source": source, "movie_type": movie_type, "cache_len": cache_len, "if_success": if_success, "errorinfo": errorinfo])
    }
    
    class func tb_movie_play_cl(kid: String, movie_id: String, movie_name: String, eps_id: String, eps_name: String) {
        HPLog.logMsg("LogMessage: 播放页点击 kid: \(kid), movie_id: \(movie_id), movie_name: \(movie_name), eps_id: \(eps_id), eps_name: \(eps_name)")
        HPLog.logEvent("movie_play_cl", parameters: ["kid": kid, "movie_id": movie_id, "movie_name": movie_name, "eps_id": eps_id, "eps_name": eps_name])
    }
    
    class func tb_movie_play_len(movie_id: String, movie_name: String, eps_id: String, eps_name: String, movie_type: String, watch_len: String) {
        HPLog.logMsg("LogMessage: 播放页停留时长 movie_id: \(movie_id), movie_name: \(movie_name), eps_id: \(eps_id), eps_name: \(eps_name), movie_type: \(movie_type), watch_len: \(watch_len)")
        HPLog.logEvent("movie_play_len", parameters: ["movie_id": movie_id, "movie_name": movie_name, "eps_id": eps_id, "eps_name": eps_name, "movie_type": movie_type, "watch_len": watch_len])
    }
    
    class func tb_vip_sh(source: String) {
        HPLog.logMsg("LogMessage: 订阅页展示 source: \(source)")
        HPLog.logEvent("vip_sh", parameters: ["source": source])
    }
    
    class func tb_vip_cl(kid: String, type: String, source: String) {
        HPLog.logMsg("LogMessage: 订阅页点击 kid: \(kid), tb_type: \(type), source: \(source)")
        HPLog.logEvent("vip_cl", parameters: ["kid": kid, "tb_type": type, "source": source])
    }
    
    class func tb_subscribe_status(status: String, source: String) {
        HPLog.logMsg("LogMessage: 订阅状态 status: \(status), source: \(source)")
        HPLog.logEvent("subscribe_status", parameters: ["status": status, "source": source])
    }
    
    class func tb_payment_sesult(if_success: String, type: String, price: String, pay_time: String) {
        HPLog.logMsg("LogMessage: 付款结果 if_success: \(if_success), type: \(type), price: \(price), pay_time: \(pay_time)")
        HPLog.logEvent("payment_sesult", parameters: ["if_success": if_success, "type": type, "price": price, "pay_time": pay_time])
    }
    
    class func tb_payment_renewal(status: String, type: String, price: String) {
        HPLog.logMsg("LogMessage: 续费监听 status: \(status), type: \(type), price: \(price)")
        HPLog.logEvent("payment_renewal", parameters: ["status": status, "type": type, "price": price])
    }
}
