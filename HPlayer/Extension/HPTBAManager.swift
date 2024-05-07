//
//  HPTBAManager.swift
//  HPlayer
//
//  Created by HF on 2024/1/5.
//

import UIKit
import Network
import AdSupport
import CoreTelephony


enum HPTBAType: Int {
    case event
    case session
    case ads
    case install
}

class HPTBAManager: NSObject {
    
    static let shared = HPTBAManager()
    
    #if DEBUG
    var HPaHost = "https://test-archaic.plixor.net/blissful/meg/nc"
    #else
    var HPaHost = "https://archaic.plixor.net/filbert/shelley/lin"
    #endif
        
    var ip: String = UserDefaults.standard.value(forKey: HPKey.lastIp) as? String ?? "" {
        didSet {
            UserDefaults.standard.set(ip, forKey: HPKey.lastIp)
        }
    }
    
    var timer: DispatchSourceTimer?
    
    var adsParam: [String: Any] = [:]
    var eventParam: [String: Any] = [:]
    
    var HPLogs: [[String: Any]] = UserDefaults.standard.value(forKey: HPKey.HPLogs) == nil ? [] : UserDefaults.standard.value(forKey: HPKey.HPLogs) as! [[String: Any]] {
        didSet {
            UserDefaults.standard.set(HPLogs, forKey: HPKey.HPLogs)
            HPLog.log("HPPlixor.HPLogs: \(HPLogs.count) \(HPLogs)")
        }
    }
    
    var task: URLSessionDataTask?
    
    func setConfig() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.setEventHandler(handler: { [weak self] in
            self?.needRequest()
        })
        timer?.schedule(deadline: .now() + 10, repeating: 10)
        timer?.resume()
    }
    
    func needRequest() {
        if self.HPLogs.count > 0 {
            self.request()
        }
    }
    
    func request() {
        if self.task != nil {
            return
        }
        let tempHPaLogs = self.HPLogs
        let urlString = "\(self.HPaHost)?kellogg=Apple&bible=\(UIDevice.current.modelName)&ibm=took&rigging=&alkali=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // bundle_id  idfa  brand
        
        var request: URLRequest = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Apple", forHTTPHeaderField: "kellogg")
        request.setValue(UUID().uuidString, forHTTPHeaderField: "brawl")

        if let data = try? JSONSerialization.data(withJSONObject: tempHPaLogs, options: []) {
            request.httpBody = data
        }
        
        request.timeoutInterval = 10
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                HPLog.log("TBA---error: \(error?.localizedDescription ?? "")")
                self.task = nil
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                HPLog.log("TBA---data: \(dataString)")
            }
            if let res = response as? HTTPURLResponse, res.statusCode == 200 {
                HPLog.log("TBA---success!")
                for item in tempHPaLogs {
                    if let index = self.HPLogs.firstIndex(where: { (($0["select"] as? [String: Any]))?["brawl"] as? String == ((item["select"] as? [String: Any]))?["brawl"] as? String }) {
                        self.HPLogs.remove(at: index)
                    }
                }
            } else {
                HPLog.log("TBA---fail!")
            }
            self.task = nil
            
        })
        self.task?.resume()
    }
    
    func getTabParameters(type: HPTBAType) -> [String: Any] {
        let coat: [String: Any] = [
            "melanism": HPConfig.app_version, // 应用的版本
//            "lace": self.getCarrierName(), // 网络供应商名称
            "suzerain": HPConfig.SafeBUNDLEID, // 当前的包名称，a.b.c
//            "sneaky": HPConfig.idfv, // ios的idfv原值
            "beijing": UIDevice.current.systemVersion, // 操作系统版本号
            "kellogg": "Apple", // 收集厂商，hauwei、opple
            "elsinore": Int(Date().timeIntervalSince1970 * 1000), // 日志发生的客户端时间，毫秒数
        ]
        
        let select: [String: Any] = [
            "snack": HPConfig.idfv, // ios的idfv原值
            "miracle": self.getCarrierName(), // 网络供应商名称
            "cern": "\(Locale.current.languageCode ?? "zh")_\(Locale.current.regionCode ?? "CN")", // String locale = Locale.getDefault(); 拼接为：zh_CN的形式，下杠
//            "itll": HPConfig.share.getDistinctId(), // 用户排重字段，统计涉及到的排重用户数就是依据该字段，对接时需要和产品确认
            "brawl": UUID().uuidString, // 日志唯一id，用于排重日志
//            "beijing": UIDevice.current.systemVersion, // 操作系统版本号
//            "kellogg": "Apple", // 收集厂商，hauwei、opple
//            "sole": Int(Date().timeIntervalSince1970 * 1000), // 日志发生的客户端时间，毫秒数
        ]
        let apostle: [String: Any] = [
            "ibm": "took", // 操作系统；映射关系：{“crampon”: “android”, “took”: “ios”, “slouch”: “web”}
            "bible": UIDevice.current.modelName, // 手机型号
//            "shebang": UIDevice.current.systemVersion, // 操作系统版本号
//            "bayonet": MTNetworkManager.standerd.currentTypeString, // 网络类型：wifi，3g等，非必须，和产品确认是否需要分析网络类型相关的信息，此参数可能需要系统权限
//            "kosher": Locale.current.regionCode ?? "ZZ", // 操作系统中的国家简写，例如 CN，US等
//            "editor": "", // 没有开启google广告服务的设备获取不到，但是必须要尝试获取，用于归因，原值，google广告id
//            "hobo": HPConfig.idfa, // idfa 原值（iOS）
//            "remorse": self.ip, // 客户端IP地址，获取的结果需要判断是否为合法的ip地址！！
//            "mongolia": "Apple", // 品牌
//            "isis": "\(kScreenWidth)*\(kScreenHeight)", // 屏幕分辨率：宽*高， 例如：380*640
            "pavlov": HPConfig.share.getDistinctId(), // 用户排重字段，统计涉及到的排重用户数就是依据该字段，对接时需要和产品确认
//            "sen": self.timeZone, // 客户端时区
        ]
        var paras: [String: Any] = [:]
        paras["coat"] = coat
        paras["select"] = select
        paras["apostle"] = apostle
        
        switch type {
        case .install:
            let dobbin: [String: Any] = [
                "fathom": "build/\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? "1")", // 系统构建版本，Build.ID， 以 build/ 开头
                "garish": "",// webview中的user_agent, 注意为webview的，android中的useragent有;wv关键字
                "rna": "meld", // 用户是否启用了限制跟踪，0：没有限制，1：限制了；映射关系：{“segment”: 0, “hang”: 1}
                "wallet": 0, // referrer_url
                "rain": 0,
                "sean": 0,
                "cherub": 0,
                "bassinet": 0,
                "ordnance": 0
            ]
            paras["dobbin"] = dobbin
        case .session:
            paras["saunders"] = "civilian"
        case .ads:
            paras["cluj"] = self.adsParam
        case .event:
            if let name = self.eventParam["saunders"] as? String {
                paras["saunders"] = name
                var eventMap: [String: Any] = [:]
                for item in self.eventParam.keys.filter({ $0 != "saunders" }) {
                    eventMap[item] = self.eventParam[item]
                }
                paras[name] = eventMap
            }
        }
        HPLog.log("REQUEST---paras: \(paras)")
        return paras
    }
    
    func setAdSubParas(capstan: Int64, anew: String, bright: String, avocate: String, smear: String, thruway: String, amnesia: String = "", penitent: String = "", drowsy: String, trefoil: String = "0") {
        self.adsParam = [
            "homesick": capstan, // 预估收益, admob取出来的值可以直接使用（x/10^6）=> 美元， Max的值为美元, 需要 * 10^6在上报
            "embitter": anew, // 预估收益的货币单位
            "hubby": bright, // 广告网络，广告真实的填充平台，例如admob的bidding，填充了Facebook的广告，此值为Facebook
            "hurrah": avocate, // 广告SDK，admob，max等
            "improve": smear, // 广告位id，例如：ca-app-pub-7068043263440714/75724612
            "hyannis": thruway, // 广告位逻辑编号，例如：page1_bottom, connect_finished
//            "squint": amnesia, // 真实广告网络返回的广告id，海外获取不到，不传递该字段
//            "gruff": penitent, // 广告场景，置空
            "joshua": drowsy, // 广告类型，插屏，原生，banner，激励视频等
//            "salem": trefoil, // google ltvpingback的预估收益类型
//            "grill": self.ip, // 广告加载时候的ip地址
//            "helmsman": self.ip // 广告显示时候的ip地址
        ]
    }
    
    func setParamlist(type: HPTBAType) {
        var has = self.HPLogs
        has.append(self.getTabParameters(type: type))
        self.HPLogs = has
        self.request()
    }

    func getCarrierName() -> String {
        var name = ""
        let info = CTTelephonyNetworkInfo()
        if let carrierArr = info.serviceSubscriberCellularProviders {
            let values = carrierArr.values
            if let firstName = values.first {
                name = firstName.carrierName ?? ""
            }
        }
        return name
    }
}


