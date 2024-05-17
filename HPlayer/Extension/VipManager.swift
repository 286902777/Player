//
//  VipManager.swift
//  HPlayer
//
//  Created by HF on 2024/3/7.
//

import UIKit
//import StoreKit
import Adjust

#if DEBUG
let vipHost = "https://apporder.powerfulclean.net"
#else
let vipHost = ""
#endif

// 内购模型枚举
enum VipID: String {
    
#if DEBUG
    case week = "iosPlixor_test_week"
    case month = "iosPlixor_test_month"
    case year = "iosPlixor_test_year"
#else
    case week = "plixor_week"
    case month = "plixor_month"
    case year = "plixor_year"
#endif
    
    static var allValueStr: Set<String>{
        return [week.rawValue, month.rawValue, year.rawValue]
    }
}

enum VipType: Int {
    case buy = 0
    case restore
    case update
    case updatePrice
    case app
}

struct VipData {
    var id: VipID = .month
    var price = ""
    var oldPrice = ""
    var title = ""
    var subTitle = ""
    var tag = ""
    var line = false
}

var premiumWeek = "$1.99"
var premiumMonth = "$4.99"
var premiumYear = "$29.99"
var premiumYearCut = "$120"


class VipManager: NSObject {
    
    static let share = VipManager()
    
    var task: URLSessionDataTask?
    
    var isVip = UserDefaults.standard.bool(forKey: HPKey.isVip) {
        didSet {
            UserDefaults.standard.set(isVip, forKey: HPKey.isVip)
            NotificationCenter.default.post(name: HPKey.Noti_VipStatusChange, object: nil)
        }
    }
    
//    var week = VipData(id: .week, price: premiumWeek, oldPrice: "", title: "Weekly", subTitle: "For the per week", tag: "", line: false)
//    var month = VipData(id: .month, price: premiumMonth, oldPrice: "",  title: "Monthly", subTitle: "For the per month", tag: "", line: false)
//    var year = VipData(id: .year, price: premiumYear, oldPrice: "",  title: "Annually", subTitle: premiumYearCut, tag: "-70%", line: true)
//    
//    var premiumList: [String] = [] {
//        didSet {
//            var list: [VipData] = []
//            for item in premiumList {
//                if item == month.id.rawValue {
//                    list.append(month)
//                }
//                if item == year.id.rawValue {
//                    list.append(year)
//                }
//                if item == week.id.rawValue {
//                    list.append(week)
//                }
//            }
//        }
//    }
//        
//    var dataList: [VipData] = [] {
//        didSet {
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: HPKey.Noti_VipStatusChange, object: nil)
//            }
//        }
//    }
//    var request = SKReceiptRefreshRequest()
//    var productsData: [SKProduct] = []
//    var productId: String = ""
//    var from: VipType = .update
//    var isfirst: Bool = false
//#if DEBUG
//    let vipBundleID = "com.player.live"
//#else
//    let vipBundleID = "com.plixorios.box"
//#endif
//    
//    override init() {
//        super.init()
//        self.addTask()
//        
//        self.premiumList = [VipID.month.rawValue, VipID.year.rawValue, VipID.week.rawValue]
//        
//        var list: [VipData] = []
//        for item in self.premiumList {
//            if item == month.id.rawValue {
//                list.append(month)
//            }
//            if item == year.id.rawValue {
//                list.append(year)
//            }
//            if item == week.id.rawValue {
//                list.append(week)
//            }
//        }
//        self.dataList = list
//        self.upDateReceipt(from: .app)
//    }
//    
//    deinit {
//        self.destroyTask()
//    }
//    
//    func reSetLists(arr: [SKProduct]) {
//        let form = NumberFormatter.init()
//        form.numberStyle = .currencyAccounting
//        if let one = arr.first {
//            form.locale = one.priceLocale
//        }
//        form.usesGroupingSeparator = true
//        for (_, model) in arr.enumerated() {
//            var price: String = ""
//            var oldPrice: String = ""
//            if let p = model.introductoryPrice?.price, let np = form.string(from: p) {
//                price = np
//                if let op = form.string(from: model.price) {
//                    oldPrice = op
//                }
//            } else {
//                if let p = form.string(from: model.price) {
//                    price = p
//                }
//            }
//            
//            switch VipID(rawValue: model.productIdentifier) {
//            case .week:
//                premiumWeek = price
//                self.week = VipData(id: .week, price: premiumWeek, oldPrice: oldPrice, title: "Weekly", subTitle: "For the per week", tag: "", line: false)
//            case .month:
//                premiumMonth = price
//                self.month = VipData(id: .month, price: premiumMonth, oldPrice: oldPrice, title: "Monthly", subTitle: "For the per month", tag: "", line: false)
//            case .year:
//                premiumYear = price
//                premiumYearCut = form.string(from: (model.price.doubleValue / 0.3) as NSNumber) ?? "$120"
//                self.year = VipData(id: .year, price: premiumYear, oldPrice: oldPrice, title: "Annually", subTitle: premiumYearCut, tag: "-70%", line: true)
//            case .none:
//                break
//            }
//        }
//        self.dataList = [self.month, self.year, self.week]
//    }
//    
//    // 加入Queue
//    func addTask() {
//        SKPaymentQueue.default().add(self)
//    }
//    
//    // 销毁
//    func destroyTask() {
//        SKPaymentQueue.default().remove(self)
//    }
//    
//    func clickRestoreAction() {
//        if !self.isVip {
//            self.from = .restore
//            HPProgressHUD.show()
//            self.upDateReceipt(from: .restore)
//        } else {
//            toast("You already subscribed!")
//        }
//    }
//    
//    func upDateReceipt(from: VipType) {
//        task?.cancel()
//        request.cancel()
//        request = SKReceiptRefreshRequest()
//        request.delegate = self
//        request.start()
//        self.refreshPurchaseData(from: from)
//    }
//    
//    // 是否允许购买
//    func isCanMakePay() -> Bool {
//        return SKPaymentQueue.canMakePayments()
//    }
//    
//    // 完成购买流程
//    func finishTransaction(transaction: SKPaymentTransaction) {
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }
//    
//    // 获取reciptData
//    func getReceiptData(product: Any?, from: VipType, transaction: SKPaymentTransaction? = nil) {
//        if let reciptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: reciptURL.path) {
//            do {
//                let reciptData = try Data(contentsOf: reciptURL, options: .alwaysMapped)
//                if reciptData.count > 0 {
//                    self.checkWithCompareServerData(data: reciptData.base64EncodedString(options: []), from: from, transaction: transaction)
//                }
//            } catch {
//                HPProgressHUD.dismiss()
//                if from == .buy || from == .restore {
//                    HPProgressHUD.error("Failed to get ticket!")
//                }
//                self.showMsgError(error: "Failed to get ticket!")
//            }
//        } else {
//            HPProgressHUD.dismiss()
//            if from == .buy || from == .restore {
//                HPProgressHUD.error("Failed to get ticket!")
//            }
//            self.showMsgError(error: "Failed to get ticket!")
//        }
//    }
//    
//    // MARK: - apple内购价格配置
//    func refreshPurchaseData(from: VipType = .update) {
//        self.from = from
//        if isCanMakePay() {
//            HPLog.log("app 订阅 --- 允许内购")
//            let request = SKProductsRequest(productIdentifiers: VipID.allValueStr)
//            request.delegate = self
//            request.start()
//        } else {
//            HPLog.log("app 订阅 --- 不允许内购")
//        }
//    }
//    /*MARK: - 准备拉起内购
//     // - Parameter proId: apple内购productID
//     // - Parameter from: 购买/恢复购买/验证
//     // - Parameter source: 调起内购来源页面，用于日志标识
//     */
//    func startBuyProduct(_ productId: String, from: VipType) {
//        HPProgressHUD.show()
//        self.productId = productId
//        self.from = from
//        if let product = self.productsData.first(where: { $0.productIdentifier == productId }) {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(payment)
//        } else {
//            let payment = SKMutablePayment()
//            payment.productIdentifier = productId
//            payment.quantity = 1
//            SKPaymentQueue.default().add(payment)
//        }
//    }
//    
//    /// admin 内购校验
//    /// - Parameter from: 购买/恢复购买/验证
//    /// - Parameter source: 调起内购来源页面，用于日志标识
//    func checkWithCompareServerData(data: String, from: VipType, transaction: SKPaymentTransaction?) {
//        guard self.task == nil else {
//            return
//        }
//        let bodyStr = String(format: "{\"device_id\":\"%@\",\"receipt_base64_data\":\"%@\",\"product_id\":\"%@\",\"package_name\":\"%@\"}", HPConfig.idfv, data, self.productId, self.vipBundleID)
//        HPLog.log("订阅 --- bodyString: \(bodyStr)")
//        let url = "\(vipHost)/v1/ios/receipt-verifier"
//        var request: URLRequest = URLRequest(url: URL(string: url)!)
//        request.httpMethod = "POST"
//        let data = bodyStr.data(using: .utf8)
//        request.httpBody = data
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.timeoutInterval = 15
//        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
//        let session: URLSession = URLSession(configuration: configuration)
//        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
//            self.task = nil
//            HPProgressHUD.dismiss()
//            if let transaction = transaction {
//                self.finishTransaction(transaction: transaction)
//            }
//            guard error == nil else {
//                print("-----\(error?.localizedDescription ?? "")")
//                switch from {
//                case .buy:
//                    self.setBuyFailed(.buy)
//                    self.showMsgError(error: error?.localizedDescription)
//                case .restore:
//                    self.setBuyFailed(.restore)
//                default:
//                    break
//                }
//                if let info = self.getPayInfo() {
//                    HPLog.tb_payment_sesult(if_success: "2", type: info.0, price: info.1, pay_time: "\(Date().timeIntervalSince1970)")
//                }
//                return
//            }
//            if let res = response as? HTTPURLResponse {
//                if res.statusCode == 200, let data = data {
//                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        var type: String?
//                        let time = "\(Date().timeIntervalSince1970)"
//                        if let model = PremiuModel.deserialize(from: json) {
//                            var status: String = "1"
//                            switch Int(model.auto_renew_status) {
//                            case 0:
//                                status = "3"
//                            case 1:
//                                status = "1"
//                            default:
//                                status = "2"
//                            }
//                            if model.entity.ok == true {
//                                switch from {
//                                case .buy:
//                                    self.setBuySuccess(.buy)
//                                    type = "3"
//                                case .restore:
//                                    self.setBuySuccess(.restore)
//                                    type = "2"
//                                default:
//                                    type = "1"
//                                }
//                                if let t = type {
//                                    HPLog.tb_subscribe_status(status: status, source: t)
//                                }
//                                if let info = self.getPayInfo() {
//                                    HPLog.tb_payment_sesult(if_success: "1", type: info.0, price: info.1, pay_time: "\(Date().timeIntervalSince1970)")
//                                    HPLog.tb_payment_renewal(status: self.isfirst ? "1" : "2", type: info.0, price: info.1)
//                                }
//
//                                UserDefaults.standard.set(model.product_id, forKey: HPKey.product_id)
//                                UserDefaults.standard.set(model.expires_date_ms, forKey: HPKey.expires_date_ms)
//                                UserDefaults.standard.set(model.auto_renew_status, forKey: HPKey.auto_renew_status)
//                                VipManager.share.isVip = true
//                            } else {
//                                VipManager.share.isVip = false
//                                switch from {
//                                case .buy:
//                                    self.setBuyFailed(.buy)
//                                    self.showMsgError(error: "severs error")
//                                    type = "3"
//                                case .restore:
//                                    self.setBuyFailed(.restore)
//                                    type = "2"
//                                default:
//                                    type = "1"
//                                }
//                                if let t = type {
//                                    HPLog.tb_subscribe_status(status: status, source: t)
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    switch from {
//                    case .buy:
//                        self.setBuyFailed(.buy)
//                        self.showMsgError(error: "ErrorCode: \(res.statusCode)")
//                    case .restore:
//                        self.setBuyFailed(.restore)
//                    default:
//                        break
//                    }
//                    if let info = self.getPayInfo() {
//                        HPLog.tb_payment_sesult(if_success: "2", type: info.0, price: info.1, pay_time: "\(Date().timeIntervalSince1970)")
//                    }
//                }
//            }
//        })
//        self.task?.resume()
//    }
//    
//    func showMsgError(error: String?) {
//        switch from {
//        case .buy, .restore:
//            break
//        default:
//            HPLog.log("订阅 --- 获取票据失败: \(error ?? "unKnown")")
//        }
//        self.refreshPurchaseData(from: .updatePrice)
//    }
//}
//
//extension VipManager {
//    func setBuySuccess(_ type: VipType) {
//        let text: String = type == .buy ? "Subscription Success!" : "Restore Success!"
//        DispatchQueue.main.async {
//            let event = ADJEvent(eventToken: "wrq1mg")
//            Adjust.trackEvent(event)
////            let view = VipSuccessView.viewText(text)
////            HPConfig.currentVC()?.view.addSubview(view)
////            view.snp.makeConstraints { make in
////                make.edges.equalToSuperview()
////            }
//        }
//    }
//    
//    func setBuyFailed(_ type: VipType) {
//        let text: String = type == .buy ? "Subscription Failed Please Retry!" : "Restore Failed Please Retry!"
//        DispatchQueue.main.async {
////            let view = TBVipFailedView.viewText(text)
////            HPConfig.currentVC()?.view.addSubview(view)
////            view.snp.makeConstraints { make in
////                make.edges.equalToSuperview()
////            }
//        }
//    }
//}
//
//extension VipManager: SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
//    // 请求产品信息成功
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        let products = response.products
//        HPLog.log("订阅 --- 无效的产品ID: \(response.invalidProductIdentifiers)")
//        guard products.count > 0 else {
//            HPLog.log("订阅 --- 没有有效地产品")
//            return
//        }
//        self.productsData = products
//        HPProgressHUD.dismiss()
//        self.reSetLists(arr: self.productsData)
//    }
//    
//    // 请求产品信息失败
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        if self.from == .restore {
//            HPLog.log("订阅 --- 恢复购买失败: \(error.localizedDescription)")
//            HPProgressHUD.dismiss()
//            HPProgressHUD.error("Restore purchase failed!")
//        } else {
//            HPLog.log("订阅 --- 产品请求失败: \(error.localizedDescription)")
//        }
//    }
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchasing:
//                HPLog.log("订阅 --- 商品添加进列表")
//            case .deferred:
//                HPLog.log("订阅 --- 交易延期")
//            case .purchased:
//                HPLog.log("订阅 --- 交易完成")
//                if let _ = transaction.original {
//                    self.isfirst = false
//                } else {
//                    self.isfirst = true
//                }
//                self.getReceiptData(product: self.productId, from: self.from, transaction: transaction)
//                self.refreshPurchaseData(from: .updatePrice)
//            case .failed:
//                HPLog.log("订阅 --- 交易失败")
//                if let info = self.getPayInfo() {
//                    HPLog.tb_payment_sesult(if_success: "2", type: info.0, price: info.1, pay_time: "\(Date().timeIntervalSince1970)")
//                }
//                self.finishTransaction(transaction: transaction)
//                self.showMsgError(error: transaction.error?.localizedDescription)
//            case .restored:
//                HPLog.log("订阅 --- 已经购买过")
//                self.getReceiptData(product: self.productId, from: self.from, transaction: transaction)
//                self.refreshPurchaseData(from: .updatePrice)
//            default:
//                HPLog.log("订阅 --- 未知错误")
//                self.finishTransaction(transaction: transaction)
//                self.showMsgError(error: transaction.error?.localizedDescription)
//            }
//        }
//    }
//    
//    func requestDidFinish(_ request: SKRequest) {
//        if self.from == .restore || self.from == .update || self.from == .app {
//            self.getReceiptData(product: nil, from: from)
//        }
//    }
//    
//    func getPayInfo() -> (String, String)? {
//        if let info = self.dataList.first(where: {$0.id.rawValue == self.productId}) {
//            var type: String = "1"
//            switch info.id {
//            case .week:
//                type = "3"
//            case .month:
//                type = "1"
//            default:
//                type = "2"
//            }
//            return (type, "\(info.price)")
//        }
//        return nil
//    }
}

